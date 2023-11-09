#include "cell.h"

void Cell::SwapNumbers(Cell& rhs) {
    size_t num = number;
    size_t exp_num = expected_number;
    number = rhs.number;
    expected_number = rhs.expected_number;
    rhs.number = num;
    rhs.expected_number = exp_num;
}

const std::string Cell::ToString() const {
    return std::string{symbols[number]};
}

bool Cell::operator==(const Cell& rhs) const {
    return number == rhs.number &&
           expected_number == rhs.expected_number &&
           noted == rhs.noted &&
           initial == rhs.initial;
}


