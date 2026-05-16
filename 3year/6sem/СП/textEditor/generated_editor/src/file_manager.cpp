#include "file_manager.hpp"
#include "exceptions.hpp"

#include <fstream>
#include <stdexcept>
#include <vector>

namespace {

const char BTXT_MAGIC[4] = {'B', 'T', 'X', 'T'};
const std::uint8_t BTXT_VERSION = 1;

void writeUint32(std::ofstream& out, std::uint32_t value) {
    out.write(reinterpret_cast<const char*>(&value), sizeof(value));
}

std::uint32_t readUint32(std::ifstream& in) {
    std::uint32_t value = 0;
    in.read(reinterpret_cast<char*>(&value), sizeof(value));
    if (!in) {
        throw InvalidBtxtFormatException("BTXT header is damaged.");
    }
    return value;
}

void requireNonEmptyKey(const std::string& key) {
    if (key.empty()) {
        throw std::runtime_error("Encryption key must not be empty.");
    }
}

}  // namespace

namespace FileManager {

bool hasExtension(const std::string& fileName, const std::string& extension) {
    if (fileName.size() < extension.size()) {
        return false;
    }

    return fileName.compare(fileName.size() - extension.size(), extension.size(), extension) == 0;
}

std::uint32_t calculateChecksum(const std::string& text) {
    std::uint32_t hash = 2166136261u;
    for (unsigned char ch : text) {
        hash ^= ch;
        hash *= 16777619u;
    }
    return hash;
}

std::string xorTransform(const std::string& data, const std::string& key) {
    requireNonEmptyKey(key);

    std::string result = data;
    for (std::size_t i = 0; i < result.size(); ++i) {
        result[i] = static_cast<char>(result[i] ^ key[i % key.size()]);
    }
    return result;
}

void loadTxt(const std::string& fileName, TextBuffer& buffer) {
    if (hasExtension(fileName, ".btxt")) {
        throw WrongFileTypeException(
            "You are trying to open a .btxt file as plain text. Use the 'open .btxt' command."
        );
    }

    if (!hasExtension(fileName, ".txt")) {
        throw WrongFileTypeException("Plain text files must have the .txt extension.");
    }

    std::ifstream in(fileName.c_str());
    if (!in.is_open()) {
        throw FileOpenException("Cannot open file: " + fileName);
    }

    std::string text;
    std::string line;
    bool firstLine = true;

    while (std::getline(in, line)) {
        if (!firstLine) {
            text += '\n';
        }
        text += line;
        firstLine = false;
    }

    if (!in.eof() && in.fail()) {
        throw FileOpenException("Error while reading file: " + fileName);
    }

    buffer.loadFromText(text);
}

void saveTxt(const std::string& fileName, const TextBuffer& buffer) {
    if (hasExtension(fileName, ".btxt")) {
        throw WrongFileTypeException(
            "You are trying to save encrypted data as plain text. Use a .txt extension for plain text."
        );
    }

    if (!hasExtension(fileName, ".txt")) {
        throw WrongFileTypeException("Plain text files must have the .txt extension.");
    }

    std::ofstream out(fileName.c_str());
    if (!out.is_open()) {
        throw FileOpenException("Cannot open file for writing: " + fileName);
    }

    out << buffer.toText();
    if (!out) {
        throw FileOpenException("Error while writing file: " + fileName);
    }
}

void saveBtxt(const std::string& fileName, const std::string& key, const TextBuffer& buffer) {
    if (!hasExtension(fileName, ".btxt")) {
        throw WrongFileTypeException("Encrypted files must have the .btxt extension.");
    }

    requireNonEmptyKey(key);

    std::string plainText = buffer.toText();
    std::string encryptedText = xorTransform(plainText, key);
    std::uint32_t checksum = calculateChecksum(plainText);
    std::uint32_t dataSize = static_cast<std::uint32_t>(encryptedText.size());

    std::ofstream out(fileName.c_str(), std::ios::binary);
    if (!out.is_open()) {
        throw FileOpenException("Cannot open file for writing: " + fileName);
    }

    out.write(BTXT_MAGIC, sizeof(BTXT_MAGIC));
    out.put(static_cast<char>(BTXT_VERSION));
    writeUint32(out, dataSize);
    writeUint32(out, checksum);
    out.write(encryptedText.data(), static_cast<std::streamsize>(encryptedText.size()));

    if (!out) {
        throw FileOpenException("Error while writing BTXT file: " + fileName);
    }
}

void loadBtxt(const std::string& fileName, const std::string& key, TextBuffer& buffer) {
    if (!hasExtension(fileName, ".btxt")) {
        throw WrongFileTypeException("Encrypted files must have the .btxt extension.");
    }

    requireNonEmptyKey(key);

    std::ifstream in(fileName.c_str(), std::ios::binary);
    if (!in.is_open()) {
        throw FileOpenException("Cannot open file: " + fileName);
    }

    char magic[4] = {};
    in.read(magic, sizeof(magic));
    if (!in) {
        throw InvalidBtxtFormatException("File is too short to be a valid BTXT file.");
    }

    for (int i = 0; i < 4; ++i) {
        if (magic[i] != BTXT_MAGIC[i]) {
            throw InvalidBtxtFormatException("Invalid BTXT signature.");
        }
    }

    int version = in.get();
    if (version == EOF) {
        throw InvalidBtxtFormatException("BTXT version is missing.");
    }

    if (static_cast<std::uint8_t>(version) != BTXT_VERSION) {
        throw InvalidBtxtFormatException("Unsupported BTXT version.");
    }

    std::uint32_t dataSize = readUint32(in);
    std::uint32_t expectedChecksum = readUint32(in);

    std::string encryptedText(dataSize, '\0');
    in.read(&encryptedText[0], static_cast<std::streamsize>(dataSize));
    if (!in) {
        throw InvalidBtxtFormatException("BTXT data section is damaged or incomplete.");
    }

    std::string plainText = xorTransform(encryptedText, key);
    std::uint32_t actualChecksum = calculateChecksum(plainText);

    if (actualChecksum != expectedChecksum) {
        throw WrongKeyException("Wrong key. BTXT file cannot be decrypted.");
    }

    buffer.loadFromText(plainText);
}

}  // namespace FileManager
