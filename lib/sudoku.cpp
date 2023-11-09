#include <cmath>
#include <stdexcept>
#include "sudoku.h"

bool Sudoku::IsValidSize(size_t size) {
    return sqrt(size) * sqrt(size) == size;
}

Sudoku::Sudoku(size_t size) : _size(size) {
    if (!IsValidSize(_size)) {
        throw std::invalid_argument("Invalid size!");
    }

    _field = std::vector(_size, std::vector(_size, Cell()));
}

Sudoku::Sudoku(const std::vector<std::vector<Cell>>& matrix) : _size(matrix.size()) {
    if (!IsValidSize(_size)) {
        throw std::invalid_argument("Invalid size!");
    }

    _field = std::vector(_size, std::vector<Cell>(_size));

    for (size_t i = 0; i < _size; ++i) {
        for (size_t j = 0; j < _size; ++j) {
            _field[i][j] = Cell(matrix[i][j]);
        }
    }
}

Sudoku::Sudoku(const Sudoku& rhs) : _size(rhs._size), _field(_size, std::vector<Cell>(_size)) {
    for (size_t i = 0; i < _size; ++i) {
        for (size_t j = 0; j < _size; ++j) {
            _field[i][j] = Cell(rhs._field[i][j]);
        }
    }
}

Sudoku& Sudoku::operator=(Sudoku&& rhs) noexcept {
    _size = rhs._size;
    _field = std::move(rhs._field);

    return *this;
}

bool Sudoku::operator==(const Sudoku& rhs) const {
    if (_size != rhs._size) {
        return false;
    }

    for (int i = 0; i < _size; ++i) {
        for (int j = 0; j < _size; ++j) {
            if (_field[i][j] != rhs._field[i][j]) {
                return false;
            }
        }
    }

    return true;
}

std::vector<Cell>& Sudoku::operator[](size_t ind) {
    return _field[ind];
}

const std::vector<Cell>& Sudoku::operator[](size_t ind) const {
    return _field.at(ind);
}

size_t Sudoku::size() const {
    return _size;
}

size_t Sudoku::SubSize() const {
    return sqrt(_size);
}

size_t Sudoku::CellsCount() const {
    return _size * _size;
}

bool Sudoku::IsValid() const {
    std::vector<size_t> counter(_size + 1);

    // Checking lines
    for (int i = 0; i < _size; ++i) {
        std::fill(counter.begin(), counter.end(), 0);

        for (int j = 0; j < _size; ++j) {
            if (_field[i][j].number != 0 && ++counter[_field[i][j].number] > 1) {
                return false;
            }
        }
    }

    // Checking columns
    for (int i = 0; i < _size; ++i) {
        std::fill(counter.begin(), counter.end(), 0);

        for (int j = 0; j < _size; ++j) {
            if (_field[j][i].number != 0 && ++counter[_field[j][i].number] > 1) {
                return false;
            }
        }
    }

    // Checking squares
    size_t sub_size = SubSize();

    for (int i = 0; i < sub_size; ++i) {
        for (int j = 0; j < sub_size; ++j) {
            std::fill(counter.begin(), counter.end(), 0);

            for (int ii = 0; ii < sub_size; ++ii) {
                for (int jj = 0; jj < sub_size; ++jj) {
                    if (_field[i * sub_size + ii][j * sub_size + jj].number != 0 &&
                        ++counter[_field[i * sub_size + ii][j * sub_size + jj].number] > 1) {
                        return false;
                    }
                }
            }
        }
    }

    return true;
}

bool Sudoku::IsFilled() const {
    for (const auto& row : _field) {
        for (const auto& cell : row) {
            if (cell.number == 0) {
                return false;
            }
        }
    }
    return true;
}

bool Sudoku::IsSolved() const {
    for (const auto& row : _field) {
        for (const auto& cell : row) {
            if (cell.number != cell.expected_number) {
                return false;
            }
        }
    }
    return true;
}

bool Sudoku::SetNumber(int number, int row, int col) {
    _field[row][col].noted.clear();
    _field[row][col].number = number;

    size_t sec_row = row / SubSize();
    size_t sec_col = col / SubSize();

    for (int i = 0; i < _size; ++i) {
        _field[row][i].noted.erase(number);
    }
    for (int i = 0; i < _size; ++i) {
        _field[i][col].noted.erase(number);
    }

    size_t sub_size = SubSize();
    for (int i = 0; i < sub_size; ++i) {
        for (int j = 0; j < sub_size; ++j) {
            _field[sec_row * sub_size + i][sec_col * sub_size + j].noted.erase(number);
        }
    }

    return number == _field[row][col].expected_number;
}

std::string Sudoku::ToString() const {
    std::string res = "┌";
    for (int i = 0; i < _size - 1; ++i) {
        res += "─┬";
    }
    res += "─┐";

    res += "\n";

    for (int i = 0; i < _size - 1; ++i) {
        res += "│";
        for (int j = 0; j < _size; ++j) {
            res += _field[i][j].ToString() + "│";
        }
        res += "\n";

        res += "├";
        for (int j = 0; j < _size - 1; ++j) {
            res += "─┼";
        }
        res += "─┤";
        res += "\n";
    }

    res += "│";
    for (int j = 0; j < _size; ++j) {
        res += _field[_size - 1][j].ToString() + "│";
    }
    res += "\n";

    res += "└";
    for (int j = 0; j < _size - 1; ++j) {
        res += "─┴";
    }
    res += "─┘";
    res += "\n";

    return std::move(res);
}




