#include <set>
#include <string>

struct Cell {
    constexpr static std::string_view symbols = " 123456789abcdefghijklmnopqrstuvwxyz#";
    size_t number = 0; // Number on the field in the process of solving
    size_t expected_number = 0; // The number that must be in the correct solution
    bool initial = true; // Is the number in this cell was set by computer
    std::set<size_t> noted; // Just a list of user notes in this cell

    explicit Cell(size_t numb = 0) : number(numb), expected_number(numb) {}

    Cell(const Cell& rhs) noexcept
            : number(rhs.number),
              expected_number(rhs.expected_number),
              initial(rhs.initial),
              noted(std::set<size_t>(rhs.noted)) {}

    void SwapNumbers(Cell& rhs);

    const std::string ToString() const;

    bool operator==(const Cell& rhs) const;
};

