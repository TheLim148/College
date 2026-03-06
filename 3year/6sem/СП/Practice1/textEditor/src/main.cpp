#include <CLI/CLI.hpp>
#include <iostream>
#include <fstream>
#include <string>

void openFile(std::string fileName, std::string inputData) {
    std::ofstream out;
    out.open(fileName, std::ios::app);
    
    if (out.is_open()) {
        out << inputData << std::endl;
    }

    out.close();
}

void readFile(std::string fileName) {
    std::string line;
    std::ifstream in(fileName);
    
    if (in.is_open()) {
        while(std::getline(in, line)) {
            std::cout << line << "\n";
        }
    }

    in.close();
}

int main(int argc, char* argv[]) {

    CLI::App app{"Terminal Text Editor"};

    std::string file;
    std::string input = "Data";

    app.add_option("filename", file, "File name")
        ->required()
        ->check(CLI::ExistingFile);
    
    app.add_option("input", input, "Input string");
    
    
    
    CLI11_PARSE(app, argc, argv);

    // system("uname -a");
    // system("lscpu");
    
    openFile(file, input);
    readFile(file);
    
    return 0;
}