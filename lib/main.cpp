#include <ctime>
#include <iostream>
#include <random>
#include "builder.h"

int main(int argc, char** argv) {
    std::setlocale(LC_ALL, "en_US.UTF-8");

    size_t size = 9;
    Difficulty difficulty = Difficulty::medium;

    for (int i = 2; i < argc; i += 2) {
        std::string arg_name(argv[i - 1]);
        std::string arg_value(argv[i]);

        if (arg_name == "--size") {
            try {
                size = strtoull(arg_value.c_str(), nullptr, 10);
            } catch(...) {
                throw std::invalid_argument("Invalid size param");
            }
        } else if (arg_name == "--difficulty") {
            if (arg_value == "easy") {
                difficulty = Difficulty::easy;
            } else if (arg_value == "medium") {
                difficulty = Difficulty::medium;
            } else if (arg_value == "hard") {
                difficulty = Difficulty::hard;
            } else {
                throw std::invalid_argument("Invalid difficulty param");
            }
        } else {
            throw std::invalid_argument("Unknown argument " + arg_name);
        }
    }

    auto s = SudokuBuilder(size).Build(difficulty);

    std::cout << s.ToString(false) << "\n" << s.ToString(true);

    return 0;
}

