// CSE 101 Winter 2016, PA 3
//
// DO NOT MODIFY

#ifndef __STAMPS_HPP__
#define __STAMPS_HPP__

#include <vector>

int find_stamps_naive(int postage, std::vector<int>& stamps);

int find_stamps_memoized(int postage, std::vector<int>& stamps);

int find_stamps_dp(int postage, std::vector<int>& stamps);

#endif
