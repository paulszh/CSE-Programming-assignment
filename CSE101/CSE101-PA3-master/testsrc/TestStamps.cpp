// Tester for PA3 Stamps
//
// DO NOT MODIFY

#ifndef __TEST_STAMPS_CPP__
#define __TEST_STAMPS_CPP__

#include <iostream>
#include <fstream>
#include <fstream>
#include <sstream>
#include <vector>

#include "Stamps.hpp"

int main(int argc, char * argv[]) {
    if (argc != 3) {
        std::cerr << "Invalid number of arguments; expecting 2 for file name and index for stamp method" << std::endl;
        exit(1);
    }

    std::ifstream input (argv[1], std::ios::in);

    // grab the postage amount
    int postage;
    std::string strPostage;
    if (getline(input, strPostage)) {
        std::stringstream stream(strPostage);
        stream >> postage;
    }
    else {
        std::cerr << "Unable to open file '" << argv[1] << "'" << std::endl;
        exit(1);
    }

    std::vector<int> stamps;
    std::string stamps_string;

    if (getline(input, stamps_string)) {
        std::stringstream stream(stamps_string);
        while (!stream.eof()) {
            int stamp;
            stream >> stamp;
            stamps.push_back(stamp);
        }
    }
    else {
        std::cerr << "Input file was missing the line for stamps" << std::endl;
        exit(1);
    }

    if (*argv[2] == '1') {
        std::cout << "Result of find_stamps_naive: " << find_stamps_naive(postage, stamps) << std::endl;
    }
    else if (*argv[2] == '2') {
        int i = 1;
        std::cout << "Result of find_stamps_memoized: " << find_stamps_memoized(postage, stamps) << std::endl;
    }
    else if (*argv[2] == '3') {
        std::cout << "Result of find_stamps_dp: " << find_stamps_dp(postage, stamps) << std::endl;
    }


    return 0;
}

#endif
