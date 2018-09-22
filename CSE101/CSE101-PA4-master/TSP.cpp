// CSE 101 Winter 2016, PA 4
//
// Name: ZHOUHANG SHAO & Tianqi Hu
// PID:  A99086018     & A99077299
// Sources of Help: StackOverFlow 
// Due: March 4th, 2016 at 11:59 PM

#include "TSP.hpp"
#include <queue>
#include <vector>
#include <iostream>
#include <cfloat>
#include <stack>
using namespace std;

// TODO: Write a comparator struct for your MST priority queue
struct compare
{
	bool operator () ( const pair<int,double> u, const pair<int,double> v){
		return u.second > v.second;
	}
};

// MST should be rooted at point id 0
std::vector<int> MST(const std::vector<std::pair<int,int>>& points) {
	// TODO: Perform MST calculations
	int size = points.size();
	//pair<int,int> here stores the ids of two points, which are the index of
	//those two points inside vector points
	priority_queue<pair<int,double> ,vector<pair<int, double>>, compare> pq;
	// initialize all prev fields in the mst to -1 to indicate unvisited
	std::vector<int> mst (size, -1);
	std::vector<int> visited(size, false);
	std::vector<double> min(size, DBL_MAX);
	min[0] = 0;
	//put and set the source of MST to 0

	//initialize the pq
	pq.push(make_pair(0,0));
	for(int i = 1; i < size; i++){
		pq.push(make_pair(1,DBL_MAX));
	}

	double distance;
	while(!pq.empty()){

		int id = pq.top().first;
		double currDist = pq.top().second;
		pq.pop();
		if(visited[id]){continue;}
		visited[id] = true;

		for(int j = 0; j < size; j++){
			if(j != id && !visited[j] ){
				distance = dist(points[id],points[j]);
				//relaxation
				if(distance < min[j]){
					pq.push(make_pair(j,distance));
					mst[j] = id;
					min[j] = distance;
				}
			}
		}

	}
	/*for(auto iter = points.begin(); iter != points.end(); iter++){
		cout << "("<<iter->first<< "," <<iter->second << ") ";
	}
	cout << "" << endl;
	for(auto it = mst.begin(); it != mst.end(); it++){
		cout << *it << " "<< endl;
		//cout << "Point: (" << points[*it].first << "," << points[*it].second << " prev is "
	}*/

	return mst;
}

std::vector<int> TwoOPT(const std::vector<std::pair<int, int>>& points) {

	// TODO: Perform 2-OPT calculations
	std::vector<int> visit_order;
	stack<int> stk;

	vector<int> SPT = MST(points);
	//push the root into the stack
	stk.push(0);
	//Add the neighbor of the root to the stack


	while(!stk.empty()){
		int top = stk.top();
		stk.pop();
		visit_order.push_back(top);
		for(int j = 1; j < SPT.size(); j++){
			if(SPT[j] == top){
				stk.push(j);
			}
		}

	}


	return visit_order;
}
