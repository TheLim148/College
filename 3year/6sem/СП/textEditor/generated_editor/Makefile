CXX := clang++
CXXFLAGS := -std=c++17 -Wall -Wextra -O2

SRC := src/main.cpp src/text_buffer.cpp src/file_manager.cpp
TARGET := build/editor

.PHONY: all run clean

all: $(TARGET)

$(TARGET): $(SRC)
	mkdir -p .target
	$(CXX) $(CXXFLAGS) $(SRC) -o $(TARGET)

run: $(TARGET)
	./$(TARGET)

clean:
	rm -rf .target
