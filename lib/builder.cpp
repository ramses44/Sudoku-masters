#include <ctime>
#include <random>
#include "builder.h"

std::vector<std::vector<Cell>> SudokuBuilder::GetBaseField(size_t size) {
    if (!Sudoku::IsValidSize(size)) {
        throw std::invalid_argument("Invalid size!");
    }

    size_t n = sqrt(size);

    std::vector res(size, std::vector<Cell>(size));

    for (size_t i = 0; i < size; ++i) {
        for (size_t j = 0; j < size; ++j) {
            res[i][j] = Cell((i * n + i / n + j) % (n * n) + 1);
        }
    }

    return std::move(res);
}

Sudoku SudokuBuilder::Build(SudokuBuilder::Difficulty difficulty) {
    GenerateField();

    size_t minimumThrow = 0;
    size_t maximumThrow = 0;

    switch (difficulty) {
        case Difficulty::easy:
            minimumThrow = simpleFilledPercentHighBorder * _sudoku.CellsCount();
            maximumThrow = mediumFilledPercentHighBorder * _sudoku.CellsCount();
            break;
        case Difficulty::medium:
            minimumThrow = mediumFilledPercentHighBorder * _sudoku.CellsCount();
            maximumThrow = hardFilledPercentHighBorder * _sudoku.CellsCount();
            break;
        case Difficulty::hard:
            minimumThrow = hardFilledPercentHighBorder * _sudoku.CellsCount();
            maximumThrow = hardFilledPercentLowBorder * _sudoku.CellsCount();
            break;
    }

    maximumThrow -= minimumThrow;

    while (minimumThrow > 0) {
        int tries = 5;

        while (tries > 0) {
            if (TryThrowCell(difficulty)) {
                break;
            } else {
                --tries;
            }
        }

        if (tries == 0) {
            return Build(difficulty);
        }

        --minimumThrow;
    }

    while (maximumThrow > 0) {
        if (!TryThrowCell(difficulty)) {
            break;
        }

        --maximumThrow;
    }

    for (size_t i = 0; i < _sudoku.size(); ++i) {
        for (size_t j = 0; j < _sudoku.size(); ++j) {
            _sudoku[i][j].initial = _sudoku[i][j].number != 0;
        }
    }

    return _sudoku;
}

void SudokuBuilder::GenerateField() {
    _sudoku = Sudoku(GetBaseField(_sudoku.size()));
    std::random_device rand;

    for (size_t i = 0; i < shuffleStepsInGenerating; ++i) {
        switch (rand() % 5) {
            case 0:
                Transpose();
                break;
            case 1:
                Reverse(rand() % 2 ? Dimension::horizontal : Dimension::vertical);
                break;
            case 2: {
                size_t section = rand() % _sudoku.SubSize();
                SwapLines(
                        rand() % 2 ? Dimension::horizontal : Dimension::vertical,
                        section * _sudoku.SubSize() + rand() % _sudoku.SubSize(),
                        section * _sudoku.SubSize() + rand() % _sudoku.SubSize());
                break;
            }
            case 3:
                SwapSections(
                        rand() % 2 ? Dimension::horizontal : Dimension::vertical,
                        rand() % _sudoku.SubSize(),
                        rand() % _sudoku.SubSize());
                break;
            case 4:
                SwapNumbers(
                        rand() % _sudoku.size() + 1, rand() % _sudoku.size() + 1);
        }
    }
}

bool SudokuBuilder::TryThrowCell(SudokuBuilder::Difficulty difficulty) {
    std::random_device rand;
    size_t x, y;

    do {
        x = rand() % _sudoku.size();
        y = rand() % _sudoku.size();
    } while (_sudoku[x][y].number == 0);

    _sudoku[x][y].number = 0;
    auto solver = SudokuSolver(_sudoku);
    std::optional<Sudoku> res;

    switch (difficulty) {
        case Difficulty::easy:
            res = solver.EasySolve();
            break;
        case Difficulty::medium:
            res = solver.MediumSolve();
            break;
        case Difficulty::hard:
            res = solver.HardSolve();
            break;
    }

    if (!res.has_value()) {
        _sudoku[x][y].number = _sudoku[x][y].expected_number;
    }

    return res.has_value();
}

void SudokuBuilder::Transpose() {
    for (size_t i = 0; i < _sudoku.size(); ++i) {
        for (size_t j = 0; j < i; ++j) {
            _sudoku[i][j].SwapNumbers(_sudoku[j][i]);
        }
    }
}

void SudokuBuilder::Reverse(SudokuBuilder::Dimension dim) {
    for (size_t i = 0; i < _sudoku.size(); ++i) {
        for (size_t j = 0; j < _sudoku.size() / 2; ++j) {
            if (dim == Dimension::vertical) {
                _sudoku[i][j].SwapNumbers(_sudoku[_sudoku.size() - i - 1][j]);
            } else {
                _sudoku[j][i].SwapNumbers(_sudoku[_sudoku.size() - j - 1][i]);
            }
        }
    }
}

void SudokuBuilder::SwapLines(SudokuBuilder::Dimension dim, size_t first, size_t second) {
    for (size_t i = 0; i < _sudoku.size(); ++i) {
        if (dim == Dimension::vertical) {
            _sudoku[i][first].SwapNumbers(_sudoku[i][second]);
        } else {
            _sudoku[first][i].SwapNumbers(_sudoku[second][i]);
        }
    }
}

void SudokuBuilder::SwapSections(SudokuBuilder::Dimension dim, size_t first, size_t second) {
    for (size_t i = 0; i < _sudoku.SubSize(); ++i) {
        SwapLines(dim, first * _sudoku.SubSize() + i, second * _sudoku.SubSize() + i);
    }
}

void SudokuBuilder::SwapNumbers(size_t first, size_t second) {
    for (size_t i = 0; i < _sudoku.size(); ++i) {
        for (size_t j = 0; j < _sudoku.size(); ++j) {
            if (_sudoku[i][j].number == first) {
                _sudoku[i][j].number = second;
                _sudoku[i][j].expected_number = second;
            } else if (_sudoku[i][j].number == second) {
                _sudoku[i][j].number = first;
                _sudoku[i][j].expected_number = first;
            }
        }
    }
}

