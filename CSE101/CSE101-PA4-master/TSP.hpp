// CSE 101 Winter 2016, PA 4
//
// DO NOT MODIFY

#ifndef __TSP_HPP__
#define __TSP_HPP__

#include <vector>
#include <utility>
#include <cmath>
#include <stdlib.h>

inline double dist(const std::pair<int, int>& p1, const std::pair<int, int>& p2) {
    return hypot(abs(p1.first - p2.first), abs(p1.second - p2.second));
}

// Note: The MST must be rooted at 0, so the first index should store value -1
std::vector<int> MST(const std::vector<std::pair<int, int>>& points);

std::vector<int> TwoOPT(const std::vector<std::pair<int, int>>& points);

#endif
