
#include "baseboggleplayer.h"
#include "boggleplayer.cpp"
#include "boggleutil.h"
#include "boggleutil.cpp"
#include <iostream>
#include <string>
using namespace std;

int main(int argc, char** argv){
    BaseBogglePlayer *boggle_player = new BogglePlayer();
    vector<int> result;
    int iter;
    string ** a;
    string ** cannibal;

    a = new string*[3];
    for(int i=0; i<3; i++) {
        a[i] = new string[4];
    }
    cannibal = new string*[4];
    for(int i=0; i<4; i++) {
        cannibal[i] = new string[4];
    }
    string b [3][4] = {
        {"d", "a", "t", "t"} ,
        {"v", "c", "f", "a"} ,
        {"a", "c", "a", "b"}
    };
    string c [4][4] = {
        {"A","A","A","K"},
        {"A","A","A","Z"},
        {"A","A","A","X"},
        {"A","A","A","P"}
    };

    for(int j=0; j<3; j++){
        for(int k=0; k<4; k++){
            a[j][k] = b[j][k];
        }
    }
    for(int j=0; j<4; j++){
        for(int k=0; k<4; k++){
            cannibal[j][k] = c[j][k];
        }
    }

    boggle_player->setBoard(4,4,cannibal);
    string s = "catt";
    string lol = "AA";
    //string lol = "pca";

    string &Str = lol;
    result = boggle_player->isOnBoard(Str);
    for (vector<int>::const_iterator iter = result.begin();iter != result.end(); ++iter){
        cout << "The path "<<*iter << endl;
    }
    //string test = "hello";
    //cout << test.at(0)  - 'a' << endl;
    //cout << test[0]  - 'a' << endl;

}
