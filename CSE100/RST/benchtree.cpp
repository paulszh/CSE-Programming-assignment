#include "RST.hpp"
#include "countint.hpp"
#include <vector>
#include <set>
#include <string>
#include <math.h>
#include <cmath>
#include <algorithm>
using namespace std;

int main(int argc, char* argv[]) {

    if(argc != 5){
        cout << "The number of arguments is invalid, please check" << endl;
        return 0;
    }

    int range = atoi(argv[3]);

    if(range < 1){  //FIXME must also check if this number is the power of 2
        cout << "The range is invalid, please check" << endl;
        return 0;
    }

    int numRun = atoi(argv[4]);

    string bststr ("bst");
    string rststr ("rst");
    string setstr ("set");
    string sortstr("sorted");
    string shufflestr("shuffled");
    string current = argv[1];
    string datatype = argv[2];

    double stdev,acpr,cpr,total,totalstd,avgstd,difference;
    int expo, val;   // the expo of the

    cout << "# Benchmarking average number of comparisons for successful find" << endl;
    cout << "# Data structure: " << current << endl;
    cout << "# Data structure: " << datatype << endl;
    cout << "# N is the power of 2, minus 1, from 1 to " << range << endl;
    cout << "# Averaging "<< numRun << " runs for each N" <<endl;
    cout << "#" << endl;
    cout << "# N" <<setw(15) <<"avgcomps"<< setw(12) <<"stdev" << endl;

    if(current.compare(bststr) == 0){

        std::vector<countint> v;             //
        for(expo = 1; exp2(expo)<= range; expo++){
            val = exp2(expo)-1;
            v.clear();
            for(int i=0; i<val; ++i) {    //Add 0 to N to the vector
                v.push_back(i);
            }
            std::vector<countint>::iterator vit = v.begin();
            std::vector<countint>::iterator ven = v.end();
            for(int i = 0; i < numRun; i++){  //the outer loop runs for numRun times
                BST<countint> b = BST<countint>();   //ceate a bst which contains countint
                if(datatype.compare(shufflestr) == 0){
                    random_shuffle ( v.begin(), v.end());
                }
                for(vit = v.begin(); vit != ven; ++vit){
                    b.insert(*vit);
                }
                countint::clearcount();
                for(vit = v.begin(); vit != ven; ++vit) {
                    b.find(*vit);
                }
                cpr = countint::getcount()/(double)val;
                total +=cpr;
                totalstd += cpr * cpr;
            }
            acpr = total/(double)numRun;  // average comparison per run
            //cout << "total " << total << endl;
            //cout << "totalstd: " << totalstd << endl;
            avgstd = totalstd/(double)numRun;
            difference = abs(avgstd-acpr * acpr);
            stdev = sqrt(difference);
            cout << setw(1) << val << setw(10) << acpr << setw(13)<<stdev <<endl;
            total = 0;
            totalstd = 0;
            //cout << "" << endl;
        }
    }
    if(current.compare(rststr) == 0){
        std::vector<countint> v;
        for(expo = 1; exp2(expo)<= range; expo++){
            val = exp2(expo)-1;
            v.clear();
            for(int i=0; i<val; ++i) {    //Add 0 to N to the vector
                v.push_back(i);
            }
            if(datatype.compare(shufflestr) == 0){
                random_shuffle ( v.begin(), v.end());
            }
            std::vector<countint>::iterator vit = v.begin();
            std::vector<countint>::iterator ven = v.end();

            for(int i = 0; i < numRun; i++){  //the outer loop runs for numRun times

                RST<countint> r = RST<countint>();   //ceate a rst which contains countint
                for(vit = v.begin(); vit != ven; ++vit){
                    r.insert(*vit);
                }

                countint::clearcount();
                for(vit = v.begin(); vit != ven; ++vit) {
                    r.find(*vit);
                }

                cpr = countint::getcount()/(double)val;
                total = total + cpr;
                totalstd += cpr * cpr;
            }
            acpr = total/(double)numRun;  // average comparison per run
            avgstd = totalstd/(double)numRun;
            difference = abs(avgstd-acpr * acpr);
            stdev = sqrt(difference);
            cout << setw(1) << val << setw(10) << acpr << setw(13)<<stdev <<endl;
            total = 0;
            totalstd = 0;
        }
    }



    if(current.compare(setstr) == 0){
        std::vector<countint> v;             //
        //countint::clearcount();
        for(expo = 1; exp2(expo)<= range; expo++){
            val = exp2(expo)-1;
            v.clear();
            for(int i=0; i<val; ++i) {    //Add 0 to N to the vector
                v.push_back(i);
            }

            std::vector<countint>::iterator vit = v.begin();
            std::vector<countint>::iterator ven = v.end();

            for(int i = 0; i < numRun; i++){  //the outer loop runs for numRun times
                set<countint> s = set<countint>();   //ceate a rst which contains countint
                if(datatype.compare(shufflestr) == 0){
                    random_shuffle ( v.begin(), v.end());
                }
                for(vit = v.begin(); vit != ven; ++vit){
                    s.insert(*vit);
                }
                countint::clearcount();
                for(vit = v.begin(); vit != ven; ++vit) {
                    s.find(*vit);
                }
                cpr = countint::getcount()/(double)val;
                total = total + cpr;
                totalstd += cpr * cpr;
            }
            acpr = total/(double)numRun;  // average comparison per run
            avgstd = totalstd/(double)numRun;
            difference = abs(avgstd-acpr * acpr);
            stdev = sqrt(difference);
            cout << setw(1) << val << setw(10) << acpr << setw(13)<<stdev <<endl;
            total = 0;
            totalstd = 0;
        }
    }
}
