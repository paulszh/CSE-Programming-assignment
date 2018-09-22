// Tester for PA4 A Star
//
// DO NOT MODIFY

#ifndef __TEST_A_STAR_CPP__
#define __TEST_A_STAR_CPP__

#include <iostream>
#include <fstream>
#include <sstream>
#include <limits>
#include <string.h>

#include "AStar.hpp"

int main(int argc, char * argv[]) {
	int arg_pos = 1;

    if (strncmp(argv[arg_pos], "-P", 2) == 0) {
        arg_pos++;
    }

    int n, m, s_r, s_c, d_r, d_c;
    float h_weight;


    std::ifstream input (argv[arg_pos], std::ios::in);

    std::string nm, s, d, h_wt;
    getline(input, nm);
    std::stringstream nm_ss(nm);
    nm_ss >> n;
    nm_ss >> m;

    getline(input, s);
    std::stringstream s_ss(s);
    s_ss >> s_r;
    s_ss >> s_c;

    getline(input, d);
    std::stringstream d_ss(d);
    d_ss >> d_r;
    d_ss >> d_c;

    getline(input, h_wt);
    std::stringstream h_wt_ss(h_wt);
    h_wt_ss >> h_weight;


    TwoDArray<Coordinate> grid(n, m);
    for(int i = 0; i < n; i++){
    	for(int j = 0; j < m; j++){
    		grid.at(i, j) = Coordinate(i, j);
    	}
    }

    std::string line;
    while(getline(input, line)){
    	std::stringstream in(line);
    	int o_r, o_c;
    	in >> o_r;
    	in >> o_c;
    	if(o_r < n && o_c < m && o_r >= 0 && o_c >= 0){
    		grid.at(o_r, o_c).obstacle = true;
    	}
    }

    std::pair<int, float> result = a_star(grid, Coordinate(s_r, s_c), Coordinate(d_r, d_c), h_weight);

    std::cout << "Number of vertices explored: " << result.first << 
    	" with path length " << result.second << std::endl;
    
    if(arg_pos > 1)
    	grid.printOut();
    
    return 0;
}

#endif
