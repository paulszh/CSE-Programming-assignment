// CSE 101 Winter 2016, PA 4
//
// DO NOT MODIFY

#ifndef __COORDINATE_HPP__
#define __COORDINATE_HPP__

#include <iostream>

struct Coordinate {
    int r;
    int c;
    float g_score;
    float f_score;
    bool closed_set;    // If this coordinate has already been evaluated
    bool open_set;      // If this coordinate is enqueued for evaluation
    bool obstacle;

    Coordinate(){};
    Coordinate(int r_in, int c_in, float f_in = std::numeric_limits<float>::infinity(),
               float g_in = std::numeric_limits<float>::infinity(), bool os_in = false,
               bool obs = false, bool v_in = false): 
        r(r_in), c(c_in), f_score(f_in), g_score(g_in), open_set(os_in), obstacle(obs), closed_set(v_in) {};

    friend std::ostream& operator<< (std::ostream& os, const Coordinate& cc)
    {
        if(cc.obstacle){
            os << "obs";
        } else {
            os << cc.f_score;
        }
        return os;
    }

    bool operator<(const Coordinate& rhs) const 
    {
        return f_score > rhs.f_score;
    }
};


struct CoordinateCompare {
    bool operator()(const Coordinate lhs, const Coordinate rhs) const
    {
        return lhs.f_score > rhs.f_score;
    }
};

#endif
