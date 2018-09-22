#ifndef BOGGLEUTIL_H
#define BOGGLEUTIL_H
#include <string>
#define Alphabet 26

using namespace std;

//Data structures for lexicon and board should reside in this file.
//All of the operations your data structures support should be declared within your data structures.
class Node{
public:
    bool visit;
    bool revisit;
    int x;
    int y;
    string Chr;
    void setVisited(bool t);
    void setRevisited(bool t);
    Node();
    ~Node();
    Node(string toSet, int x, int y): visit(0),revisit(0){
        Chr = toSet;
        this->x = x;
        this->y = y;
    }
private:
};
class TrieNode{
public:
    TrieNode(){
        end_marker = 0;
        isLeaf = 1;
        for (int i = 0; i < Alphabet; i++){
            //0?
            word[i] = NULL;
        }
    }
    //~TrieNode();
    TrieNode * childAt(int index); //get the child at specific index;
    void setMark();
    bool reachEnd();
    void setChild(int idx, TrieNode * node);
    bool end_marker;
    bool isLeaf;
    //Syntax for declaring an array of pointer in c++
    //array of pointer 
    //change the only pointer??????
    TrieNode* word[Alphabet];
private:
};


class Trie{
public:
    Trie(){
        root = new TrieNode();
    }
    ~Trie(){
        clear(root);
    }
    void addWord(string & toAdd, TrieNode * r);
    bool searchWord(string & toSearch);
    void clear(TrieNode *r);
    bool isPrefix(string &toSearch);
    TrieNode * root;
private:

};
#endif
