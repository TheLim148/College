#include "text_buffer.hpp"

#include <cstring>
#include <sstream>
#include <stdexcept>

TextBuffer::TextBuffer() {
    clear();
}

void TextBuffer::clear() {
    lineCount = 0;
    for (int i = 0; i < MAX_LINES; ++i) {
        lines[i][0] = '\0';
    }
}

bool TextBuffer::isEmpty() const {
    return lineCount == 0;
}

int TextBuffer::size() const {
    return lineCount;
}

void TextBuffer::validateLineLength(const std::string& text) const {
    if (text.size() >= static_cast<std::size_t>(MAX_COLS)) {
        throw std::runtime_error(
            "Line is too long. Maximum length is " + std::to_string(MAX_COLS - 1) + " characters."
        );
    }
}

void TextBuffer::validateIndex(int index) const {
    if (index < 0 || index >= lineCount) {
        throw std::runtime_error("Line number is out of range.");
    }
}

void TextBuffer::copyStringToRow(int index, const std::string& text) {
    validateLineLength(text);

    std::size_t length = text.size();
    std::memcpy(lines[index], text.c_str(), length);
    lines[index][length] = '\0';
}

void TextBuffer::setLine(int index, const std::string& text) {
    validateIndex(index);
    copyStringToRow(index, text);
}

void TextBuffer::appendLine(const std::string& text) {
    if (lineCount >= MAX_LINES) {
        throw std::runtime_error(
            "Buffer is full. Maximum number of lines is " + std::to_string(MAX_LINES) + "."
        );
    }

    copyStringToRow(lineCount, text);
    ++lineCount;
}

void TextBuffer::insertLineAfter(int index, const std::string& text) {
    if (lineCount >= MAX_LINES) {
        throw std::runtime_error(
            "Buffer is full. Maximum number of lines is " + std::to_string(MAX_LINES) + "."
        );
    }

    if (lineCount == 0) {
        appendLine(text);
        return;
    }

    validateIndex(index);
    for (int i = lineCount; i > index + 1; --i) {
        std::strcpy(lines[i], lines[i - 1]);
    }

    copyStringToRow(index + 1, text);
    ++lineCount;
}

void TextBuffer::deleteLine(int index) {
    validateIndex(index);

    for (int i = index; i < lineCount - 1; ++i) {
        std::strcpy(lines[i], lines[i + 1]);
    }

    --lineCount;
    if (lineCount >= 0) {
        lines[lineCount][0] = '\0';
    }
}

std::string TextBuffer::getLine(int index) const {
    validateIndex(index);
    return std::string(lines[index]);
}

std::string TextBuffer::toText() const {
    std::ostringstream out;

    for (int i = 0; i < lineCount; ++i) {
        out << lines[i];
        if (i + 1 < lineCount) {
            out << '\n';
        }
    }

    return out.str();
}

void TextBuffer::loadFromText(const std::string& text) {
    clear();

    if (text.empty()) {
        return;
    }

    std::stringstream input(text);
    std::string line;
    while (std::getline(input, line)) {
        appendLine(line);
    }

    if (!text.empty() && text.back() == '\n') {
        appendLine("");
    }
}

void TextBuffer::print(std::ostream& out) const {
    if (isEmpty()) {
        out << "[Buffer is empty]\n";
        return;
    }

    out << "------------------------------\n";
    for (int i = 0; i < lineCount; ++i) {
        out << (i + 1) << ": " << lines[i] << '\n';
    }
    out << "------------------------------\n";
}
