// Tester for PA4 TSP
//
// DO NOT MODIFY

#ifndef __TEST_TSP_CPP__
#define __TEST_TSP_CPP__

#include <iostream>
#include <fstream>
#include <fstream>
#include <sstream>
#include <utility>

#include "TSP.hpp"

int main(int argc, char * argv[]) {
    if (argc != 2 && argc != 3) {
        std::cerr << "Invalid number of arguments; expecting 1 for file name" << std::endl;
        exit(1);
    }

    std::ifstream input (argv[1], std::ios::in);

    std::vector<std::pair<int, int>> points;
    std::string line;
    int x, y;

    if (input.good()) {
        while (getline(input, line)) {
            std::istringstream stream(line);
            stream >> x;
            stream >> y;
            points.push_back(std::make_pair(x, y));
        }
    }
    else {
        std::cerr << "Problem attempting to read input file" << std::endl;
        exit(1);
    }

    // Find 2-OPT cost
    std::vector<int> two_opt_visit_order = TwoOPT(points);
    int size = two_opt_visit_order.size();
    std::vector<bool> visited (size, false);

    double two_opt_cost = 0.0;
    for (int i = 0; i < size - 1; ++i) {
        if (visited[two_opt_visit_order[i]]) {
            std::cerr << "2-OPT ERROR: point id " << two_opt_visit_order[i] << " appears multiple times in your 2-OPT tour" << std::endl;
            exit(1);
        }
        visited[two_opt_visit_order[i]] = true;
        two_opt_cost += dist(points[two_opt_visit_order[i]],
                             points[two_opt_visit_order[i + 1]]);
    }
    if (size > 1) {
        // stitch back the last edge to complete the cycle
        two_opt_cost += dist(points[two_opt_visit_order[size-1]],
                             points[two_opt_visit_order[0]]);
        visited[two_opt_visit_order[size-1]] = true;
    }

    for (int i = 0; i < size; ++i) {
        if (!visited[i]) {
            std::cerr << "2-OPT ERROR: point id " << i << " was not visited in your 2-OPT tour" << std::endl;
            exit(1);
        }
    }

    std::cout << "\nThe cost of the 2-OPT TSP tour found is: " << two_opt_cost << std::endl;

    if (argc == 3 && *(argv[2]) == 'D') {
        // Find MST cost
        std::vector<int> mst = MST(points);

        double mst_cost = 0.0;
        int size = mst.size();
        for (int i = 1; i < size; i++) {
            mst_cost += dist(points[mst[i]], points[i]);
        }

        std::cout << "\nThe cost of the MST is: " << mst_cost << std::endl;
        std::cout << "\nThe ratio found between 2-OPT and MST is: " << two_opt_cost / mst_cost << std::endl;
    }

    std::cout << std::endl;
    return 0;
}

#endif
