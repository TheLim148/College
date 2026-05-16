#ifndef TEXT_BUFFER_HPP
#define TEXT_BUFFER_HPP

#include <iostream>
#include <string>

struct TextBuffer {
    static const int MAX_LINES = 200;
    static const int MAX_COLS = 256;

    char lines[MAX_LINES][MAX_COLS];
    int lineCount;

    TextBuffer();

    void clear();
    bool isEmpty() const;
    int size() const;

    void setLine(int index, const std::string& text);
    void appendLine(const std::string& text);
    void insertLineAfter(int index, const std::string& text);
    void deleteLine(int index);

    std::string getLine(int index) const;
    std::string toText() const;
    void loadFromText(const std::string& text);

    void print(std::ostream& out) const;

private:
    void copyStringToRow(int index, const std::string& text);
    void validateLineLength(const std::string& text) const;
    void validateIndex(int index) const;
};

#endif
