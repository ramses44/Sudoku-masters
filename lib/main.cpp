#include <iostream>
#include "builder.h"
#include <iostream>
#include <ctime>
#include <random>

int main() {
    std::setlocale(LC_ALL, "en_US.UTF-8");
    clock_t start = clock();

    auto s = SudokuBuilder(16).Build(SudokuBuilder::medium);
    std::cout << s.ToString() << "\n";
    clock_t end = clock();

    auto solved = SudokuSolver(s).MediumSolve();

    if (solved.has_value())
        std::cout << solved.value().ToString() << "\n";
    else
        std::cout << "Solution not found!\n";

    std::cout << (end - start) / CLOCKS_PER_SEC << std::endl;

    return 0;
}

