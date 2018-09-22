#ifndef BOGGLEPLAYER_H
#define BOGGLEPLAYER_H
#include "baseboggleplayer.h"
#include "boggleutil.h"
#include <stack>
#include <set>
#include <string>


class BogglePlayer : public BaseBogglePlayer {
  public:
  void buildLexicon(const set<string>& word_list);

  void setBoard(unsigned int rows, unsigned int cols, string** diceArray);

  bool getAllValidWords(unsigned int minimum_word_length, set<string>* words);

  bool isInLexicon(const string& word_to_check);

  vector<int> isOnBoard(const string& word);

  void getCustomBoard(string** &new_board, unsigned int *rows, unsigned int *cols);

  void findPath(int R, int C, vector<int>  &subPath, string word, string
          toAppend);

  vector<Node*> addNeighbor(int i, int j);

  void clearTheBoard();

  bool isPrefix(string &s);

  bool BoundCheck(int i, int j);

  void findMatch(string toAppend, int R, int C, int minimum_word_length,
          set<string> * words);


  BogglePlayer() : setBoardCalled(false) {
      dataStrc = new Trie();
  }

  ~BogglePlayer() {

      for (unsigned int i = 0; i < row; i++)
          delete [] board[i];
      delete [] board;
  }

  Trie * dataStrc;
  private:
  unsigned int row;
  unsigned int column;
  bool setBoardCalled;
  bool isBuilt;
  Node*** board;
  bool found;
};

#endif
