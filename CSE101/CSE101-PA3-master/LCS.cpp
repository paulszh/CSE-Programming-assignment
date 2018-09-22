// CSE 101 Winter 2016, PA 3
//
// Name: Yuming Qiao, Zhouhang Shao 
// PID: A99011577 A99086018
// Sources of Help
// Due: February 19th, 2016 at 11:59 PM

#ifndef __LCS_CPP__
#define __LCS_CPP__

#include "LCS.hpp"
#include "TwoD_Array.hpp"

using namespace std;
std::string lcs(std::string s1, std::string s2){
    
    TwoD_Array<int> * table = new TwoD_Array<int>(s1.length()+1, s2.length()+1);
    for(int i = 0; i < s1.length()+1; i++){
        for(int j = 0; j < s2.length()+1; j++){
            if(i == 0 || j == 0){
                table->at(i,j) = 0;
            }
            else if(s1[i-1] == s2[j-1]){
                table->at(i,j) = table->at(i-1,j-1)+1;
            }
            else{
                table->at(i,j) = max(table->at(i-1,j), table->at(i,j-1));
            }
        }
    }
         
    //reverse the table and get the string
    int m = s1.length();
    int n = s2.length();
    int len = table->at(s1.length(),s2.length());
    string word;

    while(len != 0){
        if(s1[m-1] == s2[n-1]){
            word = s1[m-1] + word;
            n--;
            m--;
            len--;
        }
        else if(table->at(m-1,n) > table->at(m,n-1)){
            m--;
        }
        else{
            n--;
        }
    }
    return word;

}

#endif
