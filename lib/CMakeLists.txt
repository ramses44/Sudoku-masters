# cmake_minimum_required(VERSION <specify CMake version here>)
project(sudokuMasters)

set(CMAKE_CXX_STANDARD 20)

add_executable(sudokuMasters main.cpp cell.cpp cell.h sudoku.cpp sudoku.h solver.cpp solver.h builder.cpp builder.h)
