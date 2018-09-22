// CSE 101 Winter 2016, PA 3
//
// Name: ZHOUHANG SHAO YUMING QIAO
// PID: A99086018 A99011577
// Sources of Help: 
// Due: February 19th, 2016 at 11:59 PM

#ifndef __STAMPS_CPP__
#define __STAMPS_CPP__

#include <map>
#include "Stamps.hpp"
#include "TwoD_Array.hpp"
using namespace std;

// Naive solution is provided below
int find_stamps_naive(int postage, std::vector<int>& stamps) {
    int min = -1;
    for (auto it = stamps.begin(); it != stamps.end(); ++it) {
        if (postage == *it) {   // 1 is the minimum number of possible stamps
            return 1;
        }
        else if (postage > *it) {
            //cout << "The stamp left" << postage - *it << endl;
            int stamps_used = find_stamps_naive(postage - *it, stamps) + 1;
            //cout << "The stamp used" << stamps_used << endl;
            if (min == -1 || stamps_used < min) {
                min = stamps_used;
            }
        }
        // do nothing if stamp value is larger than the postage
    }
    return min;
}

std::map<int, int> memoize;
int find_stamps_memoized(int postage, std::vector<int>& stamps) {
    //cout << "numCall: " << numCall << endl;
    //numCall++;
    if(memoize[postage] != 0){
        return memoize[postage];
    }
    int min = -1;
    for (auto it = stamps.begin(); it != stamps.end(); ++it) {
        if (postage == *it) {   // 1 is the minimum number of possible stamps
            return 1;
        }
        else if (postage > *it) {
            int stamps_used = find_stamps_memoized(postage - *it, stamps) + 1;
            if (min == -1 || stamps_used < min) {
                min = stamps_used;
            }
        }
    }
    memoize[postage] = min;
    return min;
}

int find_stamps_dp(int postage, std::vector<int>& stamps) {

    //construct a array
    TwoD_Array<int> *stamps_dp = new TwoD_Array<int>(1, postage+1);


    for(int i = 0; i<= postage;i++){
        stamps_dp->at(0,i) = INT_MAX;
    }
    int minCoin;
    stamps_dp->at(0,0) = 0;
    for(int i = 1; i <= postage; i++){
        for(int j = 0; j < stamps.size(); j++){
            if(i - stamps[j] >= 0){
                minCoin = stamps_dp->at(0,i-stamps[j])+1;
                if( minCoin < stamps_dp->at(0,i)){
                    stamps_dp->at(0,i) = minCoin;
                }
            }

        }
    }
    return stamps_dp->at(0,postage);
}

#endif
