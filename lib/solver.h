#include <memory>
#include <optional>
#include "sudoku.h"

class SudokuSolver {
public:
    const size_t normal_rec_depth;
    const size_t enough_rec_depth;

    explicit SudokuSolver(const Sudoku& sudoku)
            : _sudoku(sudoku),
              normal_rec_depth(sudoku.SubSize()),
              enough_rec_depth(sudoku.CellsCount()) {}

    std::optional<Sudoku> EasySolve(bool save = true);

    std::optional<Sudoku> MediumSolve();

    std::optional<Sudoku> HardSolve();

protected:
    std::set<size_t> GetAvailableNumbersForCell(size_t i, size_t j) const;

    void TrySolve(size_t max_rec_depth, bool reverse = false);

    Sudoku _sudoku;
    std::optional<Sudoku> _solved;
};

