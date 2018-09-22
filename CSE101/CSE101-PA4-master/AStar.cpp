// CSE 101 Winter 2016, PA 4
//
// Name: ZhouHang Shao & Tianqi Hu 
// PID: A99086018 & A99077299
// Sources of Help: Andew Wang, Youtube
// Due: March 4th, 2016 at 11:59 PM

#ifndef __A_STAR_CPP__
#define __A_STAR_CPP__

#include "AStar.hpp"
#include <iostream>
#include <queue>
#include <vector>
#include <cmath>

using namespace std;


bool hasUp(int row){ return row != 0;}
bool hasDown(int row, int grid_row){return row + 1 != grid_row;}
bool hasLeft(int col) {return col != 0;}
bool hasRight(int col, int grid_col){return col + 1 != grid_col;}
bool isDestination(Coordinate current, Coordinate d){return current.r == d.r && current.c == d.c;}



void relaxUp(TwoDArray<Coordinate>& g, Coordinate &current, Coordinate& c_up, float h, Coordinate d, priority_queue<Coordinate , vector<Coordinate>> &pq){

    //if the coordinate is open to be relaxed 
    if(!c_up.obstacle && !c_up.closed_set && c_up.open_set){
        //just compare g value, if true relax and update the f_score
        if(current.g_score + 1 < c_up.g_score){
            //cout << "Enter 1" << endl;
            float node_h = (abs(c_up.r - d.r) + abs(c_up.c - d.c)) * h;
            c_up.g_score = current.g_score + 1;
            c_up.f_score = c_up.g_score + node_h;
            pq.push(c_up);
        }
    }

    //if the coordinate has never been touched 
    if(!c_up.obstacle && !c_up.closed_set && !c_up.open_set){
        float node_h = (abs(c_up.r - d.r) + abs(c_up.c - d.c)) * h;
        c_up.g_score = current.g_score + 1;
        c_up.f_score = c_up.g_score + node_h;
        c_up.open_set = true;
        pq.push(c_up);
    }   
}


void relaxDown(TwoDArray<Coordinate>& g, Coordinate &current, Coordinate& c_down, float h, Coordinate d, priority_queue<Coordinate , vector<Coordinate>> &pq){

    //if the coordinate is open to be relaxed 
    if(!c_down.obstacle && !c_down.closed_set && c_down.open_set){
        //just compare g value, if true relax and update the f_score
        if(current.g_score + 1 < c_down.g_score){
            //cout << "Enter 2" << endl;

            float node_h = (abs(c_down.r - d.r) + abs(c_down.c - d.c)) * h;
            c_down.g_score = current.g_score + 1;
            c_down.f_score = c_down.g_score + node_h;
            pq.push(c_down);
        }
    }   


    //if the coordinate has never been touched 
    if(!c_down.obstacle && !c_down.closed_set && !c_down.open_set){
        float node_h = (abs(c_down.r - d.r) + abs(c_down.c - d.c)) * h;
        c_down.g_score = current.g_score + 1;
        c_down.f_score = c_down.g_score + node_h;
        c_down.open_set = true;
        pq.push(c_down);
    }   
}


void relaxLeft(TwoDArray<Coordinate>& g, Coordinate &current, Coordinate& c_left, float h, Coordinate d, priority_queue<Coordinate , vector<Coordinate>> &pq){

    //if the coordinate is open to be relaxed 
    if(!c_left.obstacle && !c_left.closed_set && c_left.open_set){
        //just compare g value, if true relax and update the f_score
        if(current.g_score + 1 < c_left.g_score){
            //cout << "Enter 3" << endl;

            float node_h = (abs(c_left.r - d.r) + abs(c_left.c - d.c)) * h;
            c_left.g_score = current.g_score + 1;
            c_left.f_score = c_left.g_score + node_h;
            pq.push(c_left);
        }
    }   


    //if the coordinate has never been touched 
    if(!c_left.obstacle && !c_left.closed_set && !c_left.open_set){
        float node_h = (abs(c_left.r - d.r) + abs(c_left.c - d.c)) * h;
        c_left.g_score = current.g_score + 1;
        c_left.f_score = c_left.g_score + node_h;
        c_left.open_set = true;
        pq.push(c_left);
    }   
}

void relaxRight(TwoDArray<Coordinate>& g, Coordinate &current, Coordinate& c_right, float h, Coordinate d, priority_queue<Coordinate , vector<Coordinate>> &pq){

    //if the coordinate is open to be relaxed 
    if(!c_right.obstacle && !c_right.closed_set && c_right.open_set){
        //just compare g value, if true relax and update the f_score
        if(current.g_score + 1 < c_right.g_score){
            //cout << "Enter 4" << endl;

            float node_h = (abs(c_right.r - d.r) + abs(c_right.c - d.c)) * h;
            c_right.g_score = current.g_score + 1;
            c_right.f_score = c_right.g_score + node_h;
            pq.push(c_right);
        }
    }   


    //if the coordinate has never been touched 
    if(!c_right.obstacle && !c_right.closed_set && !c_right.open_set){
        float node_h = (abs(c_right.r - d.r) + abs(c_right.c - d.c)) * h;
        c_right.g_score = current.g_score + 1;
        c_right.f_score = c_right.g_score + node_h;
        c_right.open_set = true;
        pq.push(c_right);
    }   
}


std::pair<int, float> a_star(TwoDArray<Coordinate>& g, Coordinate s, Coordinate d, float heuristic_weight) {
    // tbr indicates (number of vertices, length of best path found)
    std::pair<int, float> tbr;

    int number_explore = 0;
    float path_length = 0;

    int grid_row = g.getNumRows();
    int grid_col = g.getNumCols();

    //get coordinates for source 
    Coordinate &source = g.at(s);
    //Coordinate source_toAdd = g.at(s);
    source.g_score = 0;

    float source_h_score = (abs(source.r - d.r) + abs(source.c - d.c)) * heuristic_weight;
    source.f_score = source_h_score + source.g_score;    

    //overload operator in coordinate class, just declare pq
    priority_queue<Coordinate> pq;

    //insert source to pq
    pq.push(source);

    bool isDestinationFound = false;

    
    //begin the A* algorithm
    
    while(!pq.empty()){
        
        //cout << "hello" << endl;
        Coordinate current = pq.top();
        Coordinate & current_Ref = g.at(current.r,current.c);
        pq.pop();


        if(current_Ref.closed_set) {
            //cout << "hello" << endl;
            continue;
        }

        number_explore++;
        current_Ref.open_set = false;
        current_Ref.closed_set = true;


        //relax up
        if(hasUp(current.r)){
            //check if it is the destination 
            Coordinate &c_up = g.at(current.r - 1, current.c);
            if(isDestination(c_up,d)){
                //h_score should be zero
                c_up.f_score = current_Ref.g_score + 1;
                isDestinationFound = true;
                path_length = c_up.f_score;
                break;
            }
            relaxUp(g, current_Ref, c_up, heuristic_weight, d, pq);
        }

        //relax down
        if(hasDown(current.r, grid_row)){
            //check if it is the destination 
            Coordinate &c_down = g.at(current.r + 1, current.c);
            if(isDestination(c_down,d)){
                //h_score should be zero
                c_down.f_score = current_Ref.g_score + 1;
                isDestinationFound = true;
                path_length = c_down.f_score;
                break;
            }
            relaxDown(g, current_Ref, c_down, heuristic_weight, d, pq);
        }


        //relax left
        if(hasLeft(current.c)){
            //check if it is the destination 
            Coordinate &c_left = g.at(current.r, current.c - 1);
            if(isDestination(c_left,d)){
                //h_score should be zero
                c_left.f_score = current_Ref.g_score + 1;
                isDestinationFound = true;
                path_length = c_left.f_score;
                break;
            }
            relaxLeft(g, current_Ref, c_left, heuristic_weight, d, pq);
        }

        //relax right
        if(hasRight(current.c, grid_col)){
            //check if it is the destination 
            Coordinate &c_right = g.at(current_Ref.r, current.c + 1);
            if(isDestination(c_right,d)){
                //h_score should be zero
                c_right.f_score = current.g_score + 1;
                isDestinationFound = true;
                path_length = c_right.f_score;
                break;
            }
            relaxRight(g, current_Ref, c_right, heuristic_weight, d, pq);
        }
    }
    
    if(isDestinationFound) {
        tbr.first = number_explore;
        tbr.second = path_length;
    }


    else{
        tbr.first = -1;
        tbr.second = -1.0;
    }

    return tbr;
}


#endif
