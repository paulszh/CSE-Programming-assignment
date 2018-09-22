// Tester for PA3 StrRecon
//
// DO NOT MODIFY

#ifndef __TEST_STR_RECON_CPP__
#define __TEST_STR_RECON_CPP__

#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <sstream>
#include <list>
#include <map>
#include <math.h>

#include "StrRecon.hpp"

int main(int argc, char * argv[]){
    if(argc != 2){
        std::cerr << "Invalid number of arguments; expecting 1 for file name" << std::endl;
        exit(1);
    }

    std::ifstream input(argv[1], std::ios::in);

    std::string str;
    std::map<std::string, double> dict;  

    if(getline(input, str)){
        std::stringstream stream(str);
    } else {
        std::cerr << "Unable to open file '" << argv[1] << "'" << std::endl;
    }

    if (input.is_open()) {
        std::string line;

        while (getline(input, line)) {
            std::stringstream in(line);
            std::string word;
            in >> word;
            double freq;
            in >> freq;
            dict[word] = freq;
        }
        input.close();
    } else {
        std::cerr << "Unable to read input, please check word/dict format." << std::endl;
        exit(1);
    }

    std::cout << "Most likely sentence: '" << str_recon(str, dict) << "'" << std::endl;

    return 0;
}

#endif
