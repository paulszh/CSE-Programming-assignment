#include <iostream>
#include <string>
#include "boggleutil.cpp"
#include "boggleutil.h"
using namespace std;
int main(int argc, char** argv){

    Trie *myTrie = new Trie();
    string home = "home";
    string homework = "homework";
    string homemade = "homemade";
    string dog = "dog";
    string cat = "cat";
    string car = "car";
    myTrie->addWord(home,myTrie->root);
    myTrie->addWord(homework,myTrie->root);
    myTrie->addWord(homemade,myTrie->root);
    myTrie->addWord(cat,myTrie->root);
    myTrie->addWord(car,myTrie->root);
    myTrie->addWord(dog,myTrie->root);
    if(myTrie->root->word[7])
        cout << "h is there" << endl;
    if(myTrie->root->word[7]->word[14])
        cout << "o is there" << endl;
    if(myTrie->root->word[7]->word[14]->word[12])
        cout << "m is there" << endl;
    if(myTrie->root->word[7]->word[14]->word[12]->word[4])
        cout << "e is there" << endl;
    if(myTrie->root->word[7]->word[14]->word[12]->word[4]->end_marker)
        cout << "end_marker is true" << endl;
    if(myTrie->root->word[3])
        cout << "d is there" << endl;
    if(myTrie->root->word[3]->word[14])
        cout << "o is there" << endl;
    if(myTrie->root->word[3]->word[14]->word[6])
        cout << "g is there" << endl;
    if(myTrie->root->word[3]->word[14]->word[6]->end_marker)
        cout << "end_marker is true" << endl;
    if(myTrie->searchWord(home))
        cout << "find home" << endl;
    if(myTrie->searchWord(homework))
        cout << "find homework" << endl;
    if(myTrie->searchWord(homemade))
        cout << "find homework" << endl;
    if(myTrie->searchWord(cat))
        cout << "find cat" << endl;
    if(myTrie->searchWord(dog))
        cout << "find dog" << endl;
    if(myTrie->searchWord(car))
        cout << "find car" << endl;

    /*cout << " " << endl;
    myTrie->addWord(homework, myTrie->root);
    cout << " " << endl;
    myTrie->addWord(homemade, myTrie->root);
    cout << " " << endl;
    myTrie->addWord(cat, myTrie->root);
    //cout << "enter 3" << endl;
    myTrie->addWord(word, myTrie->root);
    if(myTrie->searchWord(home, myTrie->root) == true)
        cout << "FIND CAT" << endl;
    */
}
