// CSE 101 Winter 2016, PA 2
//
// Name: TODO put both partners' info if applicable
// PID: TODO
// Sources of Help: TODO
// Due: February 5th, 2016 at 11:59 PM

#ifndef __PRIM_CPP__
#define __PRIM_CPP__

#include "Graph.hpp"
#include <queue>
#include <vector>
#include <cfloat>
using namespace std;

// include more libraries as needed

template <class T>
struct compare
{
	//dist[v]
	bool operator () ( const pair<T,float> u, const pair<T,float> v){
		return u.second > v.second;
	}
};

template <class T>
float prim(Graph<T>& g, T src) {
    float cost = 0.0;

    unordered_map<T, Vertex<T> *> vertices = g.vertices;
	map<Edge<T>, float> weight = g.weights;

	priority_queue< pair<T,float> , vector<pair<T,float>>, compare<T>> pq;

	for(auto it = vertices.begin();
	it != vertices.end(); it++){
		it -> second -> visited = false;
		it -> second -> prev = 0;
		if(it->first == src){
			it -> second -> distance = 0;
		}
		else{
			it -> second -> distance = FLT_MAX;
		}

		 // pair<T,float> v(it->first, it->second->distance);
		 // pq.push(v);
		
	}

	  pair<T,float> v(src, vertices[src]->distance);
	  pq.push(v);


	//Loop for |V| - 1 times
	while(!pq.empty()){

		pair<T,float> pair = pq.top();

		pq.pop();
		T u = pair.first;

		if(vertices[u]->visited) continue;

		cout<< "v:" << u << " cost:"<< vertices[u]->distance << endl;

		cost+= g.get_weight(vertices[u]->prev,u);

		vertices[u]->visited = true;

		for(auto it = vertices[u]->edges.begin();
		it != vertices[u]->edges.end(); it++){

			T v = vertices[*it]->id;
			float alt = g.get_weight(u,v);

			if(g.vertices[v]->visited){
                continue;
            }
			//relax the edges for all the vertices
			if(alt < vertices[v]->distance){
				vertices[v]->distance = alt;
				vertices[v]->prev = u;
				pq.push(make_pair(v,alt));
			}
		}
	}

    // TODO: Problem 3

    return cost;
}

#endif