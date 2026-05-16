#include "exceptions.hpp"
#include "file_manager.hpp"
#include "text_buffer.hpp"

#include <iostream>
#include <limits>
#include <string>

namespace {

struct AppState {
    TextBuffer buffer;
    bool modified = false;
    std::string currentFileName;
};

void printMenu(const AppState& app) {
    system("hostnamectl");

    std::cout << "\n=== Console Text Editor ===\n";
    if (app.currentFileName.empty()) {
        std::cout << "Current file: [none]\n";
    } else {
        std::cout << "Current file: " << app.currentFileName << '\n';
    }

    std::cout << "Modified: " << (app.modified ? "yes" : "no") << "\n\n";
    std::cout << "1. Create new file\n";
    std::cout << "2. Open .txt file\n";
    std::cout << "3. Open .btxt file\n";
    std::cout << "4. Show text\n";
    std::cout << "5. Edit line\n";
    std::cout << "6. Add line to end\n";
    std::cout << "7. Insert line after number\n";
    std::cout << "8. Delete line\n";
    std::cout << "9. Save as .txt\n";
    std::cout << "10. Save as .btxt\n";
    std::cout << "0. Exit\n";
}

std::string promptLine(const std::string& prompt) {
    std::cout << prompt;
    std::string input;
    std::getline(std::cin, input);
    return input;
}

int promptInt(const std::string& prompt) {
    while (true) {
        std::cout << prompt;
        std::string input;
        std::getline(std::cin, input);

        try {
            std::size_t pos = 0;
            int value = std::stoi(input, &pos);
            if (pos != input.size()) {
                throw std::invalid_argument("extra characters");
            }
            return value;
        } catch (...) {
            std::cout << "Please enter a valid number.\n";
        }
    }
}

bool confirmDiscardChanges(const AppState& app) {
    if (!app.modified) {
        return true;
    }

    std::string answer = promptLine("Unsaved changes will be lost. Continue? (y/n): ");
    return answer == "y" || answer == "Y";
}

void createNewFile(AppState& app) {
    if (!confirmDiscardChanges(app)) {
        return;
    }

    app.buffer.clear();
    app.currentFileName.clear();
    app.modified = false;
    std::cout << "New empty document created.\n";
}

void openTxtFile(AppState& app) {
    if (!confirmDiscardChanges(app)) {
        return;
    }

    std::string fileName = promptLine("Enter .txt file name: ");
    FileManager::loadTxt(fileName, app.buffer);
    app.currentFileName = fileName;
    app.modified = false;
    std::cout << "TXT file opened successfully.\n";
}

void openBtxtFile(AppState& app) {
    if (!confirmDiscardChanges(app)) {
        return;
    }

    std::string fileName = promptLine("Enter .btxt file name: ");
    std::string key = promptLine("Enter decryption key: ");
    FileManager::loadBtxt(fileName, key, app.buffer);
    app.currentFileName = fileName;
    app.modified = false;
    std::cout << "BTXT file opened successfully.\n";
}

void showText(const AppState& app) {
    app.buffer.print(std::cout);
}

void editLine(AppState& app) {
    if (app.buffer.isEmpty()) {
        std::cout << "Buffer is empty. Add a line first.\n";
        return;
    }

    int lineNumber = promptInt("Enter line number to edit: ");
    std::string newText = promptLine("Enter new text: ");
    app.buffer.setLine(lineNumber - 1, newText);
    app.modified = true;
    std::cout << "Line updated.\n";
}

void addLine(AppState& app) {
    std::string text = promptLine("Enter text for new line: ");
    app.buffer.appendLine(text);
    app.modified = true;
    std::cout << "Line added.\n";
}

void insertLine(AppState& app) {
    if (app.buffer.isEmpty()) {
        std::cout << "Buffer is empty. The line will be added as the first line.\n";
        addLine(app);
        return;
    }

    int lineNumber = promptInt("Insert after line number: ");
    std::string text = promptLine("Enter text for new line: ");
    app.buffer.insertLineAfter(lineNumber - 1, text);
    app.modified = true;
    std::cout << "Line inserted.\n";
}

void deleteLine(AppState& app) {
    if (app.buffer.isEmpty()) {
        std::cout << "Buffer is empty. Nothing to delete.\n";
        return;
    }

    int lineNumber = promptInt("Enter line number to delete: ");
    app.buffer.deleteLine(lineNumber - 1);
    app.modified = true;
    std::cout << "Line deleted.\n";
}

void saveTxtFile(AppState& app) {
    std::string fileName = promptLine("Enter .txt file name: ");
    FileManager::saveTxt(fileName, app.buffer);
    app.currentFileName = fileName;
    app.modified = false;
    std::cout << "TXT file saved successfully.\n";
}

void saveBtxtFile(AppState& app) {
    std::string fileName = promptLine("Enter .btxt file name: ");
    std::string key = promptLine("Enter encryption key: ");
    FileManager::saveBtxt(fileName, key, app.buffer);
    app.currentFileName = fileName;
    app.modified = false;
    std::cout << "BTXT file saved successfully.\n";
}

}  // namespace

int main() {
    AppState app;

    while (true) {
        try {
            printMenu(app);
            int choice = promptInt("Choose command: ");

            switch (choice) {
                case 1:
                    createNewFile(app);
                    break;
                case 2:
                    openTxtFile(app);
                    break;
                case 3:
                    openBtxtFile(app);
                    break;
                case 4:
                    showText(app);
                    break;
                case 5:
                    editLine(app);
                    break;
                case 6:
                    addLine(app);
                    break;
                case 7:
                    insertLine(app);
                    break;
                case 8:
                    deleteLine(app);
                    break;
                case 9:
                    saveTxtFile(app);
                    break;
                case 10:
                    saveBtxtFile(app);
                    break;
                case 0:
                    if (confirmDiscardChanges(app)) {
                        std::cout << "Exiting program.\n";
                        return 0;
                    }
                    break;
                default:
                    std::cout << "Unknown command. Try again.\n";
                    break;
            }
        } catch (const EditorException& ex) {
            std::cout << "Custom error: " << ex.what() << "\n";
        } catch (const std::exception& ex) {
            std::cout << "Error: " << ex.what() << "\n";
        }
    }
}
