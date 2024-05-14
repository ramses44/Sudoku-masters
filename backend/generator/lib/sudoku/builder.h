#include "solver.h"
#include <cmath>


class SudokuBuilder {
public:
  enum Dimension { horizontal, vertical };

  constexpr static size_t shuffleStepsInGenerating = 20;
  constexpr static float simpleFilledPercentHighBorder = 0.57;
  constexpr static float mediumFilledPercentHighBorder = 0.63;
  constexpr static float hardFilledPercentHighBorder = 0.70;
  constexpr static float hardFilledPercentLowBorder = 0.79;

  static std::vector<std::vector<Cell>> GetBaseField(size_t size);

  explicit SudokuBuilder(size_t size) : _sudoku(size) {}

  Sudoku Build(Difficulty difficulty);

protected:
  Sudoku _sudoku;

protected:
  void GenerateField();
  bool TryThrowCell(Difficulty difficulty);

  void Transpose();
  void Reverse(Dimension dim);
  void SwapLines(Dimension dim, size_t first, size_t second);
  void SwapSections(Dimension dim, size_t first, size_t second);
  void SwapNumbers(size_t first, size_t second);
};
