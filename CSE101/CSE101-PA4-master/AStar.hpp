// CSE 101 Winter 2016, PA 4
//
// DO NOT MODIFY

#ifndef __A_STAR_HPP__
#define __A_STAR_HPP__

#include <limits>

#include "Coordinate.hpp"
#include "TwoDArray.hpp"

#define DIST_UNIT 1

std::pair<int, float> a_star(TwoDArray<Coordinate>& g, Coordinate s, 
                             Coordinate d, float heuristic_weight);

#endif
