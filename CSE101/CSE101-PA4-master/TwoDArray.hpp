// CSE 101 Winter 2016, PA 4
//
// DO NOT MODIFY

#ifndef __TWODARRAY_HPP__
#define __TWODARRAY_HPP__

#include <iostream>
#include "Coordinate.hpp"

// This class will create an N * M array of type T for you since 
// multi dimensional arrays are slow in C++
template <typename T>
class TwoDArray {
public:
    // n represents number of rows,
    // m represents number of columns
    TwoDArray (int n, int m): n(n), m(m) {
        linear_array = new T[n * m];
    }

    // you can use 'at' to both set and retrieve values in the 2D_Array
    T& at (int x, int y) {
        return linear_array[(x*m) + y];
    }

    T& at (Coordinate cc){
        return linear_array[(cc.r*m) + cc.c];
    }

    // returns number of rows
    int getNumRows() {
        return n;
    }

    // returns number of columns
    int getNumCols() {
        return m;
    }

    // prints out the TwoD_Array -- useful for debugging purposes
    void printOut() {
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                std::cout << at(i,j) << " ";
            }
            std::cout << std::endl;
        }
        std::cout << std::endl;
    }

private:
    T * linear_array;
    int n;
    int m;
};

#endif
