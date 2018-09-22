// CSE 101 Winter 2016, PA 3
//
// Name: Yuming Qiao, Zhouhang Shao 
// PID: A99011577 A99086018
// Sources of Help: 
// Due: February 19th, 2016 at 11:59 PM

#ifndef __STR_RECON_CPP__
#define __STR_RECON_CPP__

#include "StrRecon.hpp"
using namespace std;
std::string str_recon(std::string in, std::map<std::string, double> dict){
        bool valid[in.length()+1];
        int pos[in.length()+1];
        double prob[in.length()+1];
        valid[0] = true;
        prob[0] = 1;
        pos[0] = 0;

        int k = 0;
        int j = 0;  

        for(k = 1; k < in.length()+1; k++){
            valid[k] = false;
            double curr = 0;
            for(j = 1; j <= k; j++){
                if(valid[j-1] && dict.find(in.substr(j-1,k-j+1)) != dict.end()){
                    valid[k] = true;
                    double temp = prob[j-1] * dict.find(in.substr(j-1,k-j+1))->second;
                    if(temp > curr){
                        curr = temp;
                        pos[k] = j;
                    }
                }
            }
            prob[k] = curr;             
        }       
    if(valid[in.length()] == false){
        return "";
    }

    //writing to the return string -> best
    string best;
    int len = in.length();
    while(len > 0){
        if(len != in.length()){
            best = in.substr(pos[len] - 1,len - pos[len] + 1) + " " + best;
        }
        else{
            best = in.substr(pos[len] - 1,len - pos[len] + 1);
        }
        len -= len - pos[len] + 1;
    }
    return best;
}
#endif

