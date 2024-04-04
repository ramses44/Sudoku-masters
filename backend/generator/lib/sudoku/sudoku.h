#include "cell.h"
#include <vector>


class Sudoku {
public:
  static bool IsValidSize(size_t size);

  explicit Sudoku(size_t size);

  explicit Sudoku(const std::vector<std::vector<Cell>> &matrix);

  Sudoku(const Sudoku &rhs);

  Sudoku &operator=(Sudoku &&rhs) noexcept;

  bool operator==(const Sudoku &rhs) const;

  std::vector<Cell> &operator[](size_t ind);

  const std::vector<Cell> &operator[](size_t ind) const;

  size_t size() const;

  size_t SubSize() const;

  size_t CellsCount() const;

  bool IsValid() const;

  bool IsFilled() const;

  bool IsSolved() const;

  bool SetNumber(int number, int row, int col);

  std::string ToStringPretty() const;

  std::string ToString(bool solved = false) const;

protected:
  size_t _size;
  std::vector<std::vector<Cell>> _field;
};
