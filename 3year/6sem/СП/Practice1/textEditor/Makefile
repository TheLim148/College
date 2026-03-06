CXX := clang++
CXXFLAGS := -std=c++17 -Wall -Wextra -O2

NCURSESFLAGS := -lncursesw

SRC := src/main1.cpp
TARGET := .target/main

.PHONY: all run clean

all: $(TARGET)

$(TARGET): $(SRC)
	mkdir -p .target
	$(CXX) $(CXXFLAGS) $(SRC) $(NCURSESFLAGS) -o $(TARGET)

run: $(TARGET)
	./$(TARGET)

clean:
	rm -rf .target
