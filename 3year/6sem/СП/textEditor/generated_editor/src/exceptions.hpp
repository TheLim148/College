#ifndef EXCEPTIONS_HPP
#define EXCEPTIONS_HPP

#include <exception>
#include <string>

class EditorException : public std::exception {
protected:
    std::string message;

public:
    explicit EditorException(const std::string& msg) : message(msg) {}

    const char* what() const noexcept override {
        return message.c_str();
    }
};

class WrongFileTypeException : public EditorException {
public:
    explicit WrongFileTypeException(const std::string& msg) : EditorException(msg) {}
};

class InvalidBtxtFormatException : public EditorException {
public:
    explicit InvalidBtxtFormatException(const std::string& msg) : EditorException(msg) {}
};

class WrongKeyException : public EditorException {
public:
    explicit WrongKeyException(const std::string& msg) : EditorException(msg) {}
};

class FileOpenException : public EditorException {
public:
    explicit FileOpenException(const std::string& msg) : EditorException(msg) {}
};

#endif
