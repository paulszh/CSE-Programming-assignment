#include "boggleplayer.h"
#include "boggleutil.h"
#include "algorithm"
#include <iostream>
#include <set>
#include <vector>
#include <string>


#define Alphabet 26
#define Char_a 97


using namespace std;


void BogglePlayer::clearTheBoard(){
    for (int i = 0; i < row; i++){
        for (int j = 0; j < column; j++){
            board[i][j]->setVisited(false);
        }
    }
}

void BogglePlayer::buildLexicon(const set<string>& word_list){

    isBuilt = 1;
    //range base for loop
    for(set<string>::iterator it = word_list.begin(); it!=word_list.end(); ++it){
        string s = *it;
        dataStrc->addWord(s,dataStrc->root);
    }
}
bool BogglePlayer:: isPrefix(string &s){
    return dataStrc->isPrefix(s);
}

void BogglePlayer::setBoard(unsigned int rows, unsigned int cols, string** diceArray) {

    this->row = rows;
    this->column = cols;
    board = new Node**[rows];

    for (unsigned int i = 0; i < rows; i++){
        board[i] = new Node*[cols];
    }

    string s;

    for(unsigned int r = 0; r < rows ; r++){
        for(unsigned int c = 0; c < cols; c++){
            s = diceArray[r][c];
            transform(s.begin(), s.end(), s.begin(),::tolower);
            board[r][c] = new Node(s,r,c);
        }
    }
    setBoardCalled = 1;
}

bool BogglePlayer::getAllValidWords(unsigned int minimum_word_length, set<string>* words) {
    if(!setBoardCalled || !isBuilt){
        return 0;
    }
    for( int i = 0; i < row ; i++){
        for(int j = 0; j < column; j++){

            board[i][j]->setVisited(false);
            board[i][j]->setRevisited(false);

        }
    }
    //start from the board, do dfs for each cell
    Node * current;
    string temp;
    for(int i = 0; i < row ; i++){
        for( int j = 0; j < column; j++){

            findMatch("", i,j,minimum_word_length,words);

        }
    }
    return 1;
}
bool BogglePlayer:: BoundCheck(int i, int j){
    return (j+1 > column || i+1 > row || i<0 || j<0 ||
            board[i][j]->visit == true);
}

void BogglePlayer:: findMatch(string toAppend, int R, int C, int
        minimum_word_length, set<string>* words){

    string temp = toAppend;
    if(BoundCheck(R,C)){
        return;
    }
    
    temp.append(board[R][C]->Chr);

    if(!isPrefix(temp)){
        return;
    }
    toAppend.append(board[R][C]->Chr);
    board[R][C]->setVisited(true);
    
    if(isInLexicon(toAppend) && toAppend.size() >= minimum_word_length){
        words->insert(toAppend);
    }

    for(int h = -1; h < 2 ; h++){      // goto the surrounding neighbors
        for (int v = -1; v < 2; v++){

            findMatch(toAppend, (R+h), (C+v), minimum_word_length, words);

        }

    }
    board[R][C]->setVisited(false);

}

bool BogglePlayer::isInLexicon(const string& word_to_check) {

    if(!isBuilt){
        return false;
    }
    string s = word_to_check;
    return dataStrc->searchWord(s);
}

vector<int> BogglePlayer::isOnBoard(const string& word) {
    vector<int> path;
    found = false;
    if(!setBoardCalled){
        return path;
    }
    clearTheBoard();
    for(int i = 0; i < row; i++){
        for(int j = 0; j < column; j++){
            int pos = word.find(board[i][j]->Chr); 
            if(pos == 0 ){
                //cout << "pos equals to 0" << endl;
                findPath(i,j,path,word,"");
                if(found){
                    break;
                }
            }
        }
    }
    return path;
}

void BogglePlayer:: findPath(int R, int C, vector<int> &subPath, string word, string
        toAppend){
    if(toAppend.size() == word.size()){
        return;
    }
    if(BoundCheck(R,C)){
        return;
    }
    if(word.find(toAppend) != 0){

        return;
    }
    toAppend.append(board[R][C]->Chr);
    if(word.compare(toAppend) == 0){
        found = true;
    }
    subPath.push_back(R*column + C);

    board[R][C]->setVisited(true);

    for(int h = -1; h < 2 ; h++){      // goto the surrounding neighbors
        for (int v = -1; v < 2; v++){
            if(found){
                break;
            }
            findPath((R+h), (C+v), subPath, word, toAppend);

        }

    }
    if(!found){
        subPath.pop_back();
        board[R][C]->setVisited(false);
    }
}


void BogglePlayer::getCustomBoard(string** &new_board, unsigned int *rows, unsigned int *cols) {
}
