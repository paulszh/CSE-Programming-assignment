#include"boggleutil.h"

//In this file, implement all of the operations your data structures support (you have declared these operations in boggleutil.h).
using namespace std;
#define Alphabet 26
#define Char_a 97

void Node::setVisited(bool t){
    this->visit = t;
}

void Node::setRevisited(bool t){
    this->revisit = t;
}
void TrieNode::setMark(){
    end_marker = true;
}
bool TrieNode::reachEnd(){
    return this->end_marker;
}


void Trie::addWord(string & toAdd, TrieNode * r){
    if(toAdd.size() == 0){
        r->setMark();
        return;
    }
    int idx = toAdd[0] - Char_a;  //calculate the index of each char
//    cout << "toAdd " << toAdd[0] << endl;
//cout << "INDEX:" << idx << endl;
    if(!(r->childAt(idx))){
        r->setChild(idx, new TrieNode());
        r->isLeaf = 0;
    }
    string lol = toAdd.substr(1);
//    cout << "substring "<<lol << endl;
    addWord(lol, r->childAt(idx));
}

bool Trie::searchWord(string & toSearch){
    TrieNode* current = root;
    int idx;
    TrieNode* tmp;
    while (current)
    {
        for (unsigned int i = 0; i < toSearch.length(); i++ )
        {
            idx = toSearch[i] - Char_a;
            tmp = current->childAt(idx);
            if (!tmp){
                return false;
            }
            current = tmp;
        }

        if ( current->reachEnd() ){
            return true;
        }

        else{
            return false;
        }

    }
    return false;
}

bool Trie:: isPrefix(string & toSearch){
    TrieNode* current = root;
    int idx;
    TrieNode* tmp;
    while (current)
    {
        for (unsigned int i = 0; i < toSearch.length(); i++ )
        {
            idx = toSearch[i] - Char_a;
            tmp = current->childAt(idx);
            if (!tmp){
                return false;
            }
            current = tmp;
        }
            return true;
    }
    return false;

}

TrieNode * TrieNode ::childAt(int i){
    return this->word[i];
}

void TrieNode::setChild(int idx, TrieNode * node){
    this->word[idx] = node;
}

void Trie::clear(TrieNode *r){
    if(r){
        for(int i = 0; i < Alphabet; ++i){
            clear(r -> childAt(i));
        }
        delete r;
    }
}
