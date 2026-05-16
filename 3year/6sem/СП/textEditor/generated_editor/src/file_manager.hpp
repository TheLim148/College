#ifndef FILE_MANAGER_HPP
#define FILE_MANAGER_HPP

#include "text_buffer.hpp"

#include <cstdint>
#include <string>

namespace FileManager {

bool hasExtension(const std::string& fileName, const std::string& extension);
void loadTxt(const std::string& fileName, TextBuffer& buffer);
void saveTxt(const std::string& fileName, const TextBuffer& buffer);

void loadBtxt(const std::string& fileName, const std::string& key, TextBuffer& buffer);
void saveBtxt(const std::string& fileName, const std::string& key, const TextBuffer& buffer);

std::uint32_t calculateChecksum(const std::string& text);
std::string xorTransform(const std::string& data, const std::string& key);

}  // namespace FileManager

#endif
