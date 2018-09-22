// CSE 101 Winter 2016, PA 3
//
// Name: Yuming Qiao, Zhouhang Shao 
// PID: A99011577 A99086018
// Due: February 19th, 2016 at 11:59 PM

#ifndef __GRID_SUM_CPP__
#define __GRID_SUM_CPP__

#include "TwoD_Array.hpp"
#include "GridSum.hpp"
using namespace std;

// Perform the precomputation step here
GridSum::GridSum (TwoD_Array<int>& grid) {
    // TODO
    int left;
    int top;
    int topLeft;
    //TwoD_Array<int> grid(size, size);
    pg = new TwoD_Array<int>(grid.getNumRows(),grid.getNumCols());
    pg->at(0,0) = grid.at(0,0);    //initialize (0,0) to the grid(0,0)

    for(int i = 0; i < grid.getNumRows(); i++){
        for(int j = 0; j < grid.getNumCols(); j++){
            if(i == 0 && j ==0){    //special case, already handled
                continue;
            }
            else if(j == 0){
                left = 0;            //LEFT IS EMPTY
                top = pg->at(i-1,j);
                topLeft = 0;
            }
            else if(i == 0){
                top = 0;            //TOP IS EMPTY
                left = pg->at(i,j-1);   
                topLeft = 0;
            }
            else{
                left = pg->at(i,j-1);  
                top = pg->at(i-1,j);
                topLeft = pg->at(i-1,j-1);
            }
            pg->at(i,j) = grid.at(i,j) + left + top - topLeft;
        }
    }
}

// Perform the query step here
int GridSum::query (int x1, int y1, int x2, int y2) {
    // TODO
    if(x1 > 0 && y1 > 0){
        return pg->at(x2,y2) - pg->at(x1-1,y2) - pg->at(x2,y1-1) + pg->at(x1-1, y1
                -1);
    }
    else if(x1 == 0 && y1 > 0 ){
        return pg->at(x2,y2) - pg->at(x2,y1-1);
    }
    else if(y1 == 0 && x1 >0){
        return pg->at(x2,y2) - pg->at(x1-1,y2);
    }
    else{
        return pg->at(x2,y2);
    }

}

#endif
