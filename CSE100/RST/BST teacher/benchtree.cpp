#include "RST.hpp"
#include "countint.hpp"
#include <vector>
#include <set>
#include <math.h>

using namespace std;

int main(int argc, char* argv[]) {
    int N = 32768;
    int numRun = 5;
    double comps = 0;
    double totalcomps = 0;
    double totalstd = 0;
    double avgcomps = 0;
    bool rst = false;
    double stdev;
    srand ( unsigned ( 149 ) );
    int expo, val;   // the expo of the
    cout << "# Benchmarking average number of comparisons for successful find" << endl;
    cout << "# Data structure: ";
    cout << "# rst" << endl;
    cout << "# N is the power of 2, minus 1, from 1 to ";
    cout << N << endl;
    cout << "# Averaging "<< numRun << " runs for each N" <<endl;
    cout << "#" << endl;
    cout << "# N 	 avgcomps 	 stdev" << endl;
    RST<countint> r = RST<countint>();   //ceate a rst which contains countint
    //BST<countint> b = BST<countint>();
    std::vector<countint> v;             //
    countint::clearcount();
    v.clear();
    for(expo = 1; exp2(expo)<= N; ++expo){
        val = exp2(expo)-1;
        for(int i=0; i<val; ++i) {    //Add 0 to N to the vector
            v.push_back(i);
        }
        std::random_shuffle ( v.begin(), v.end());
        std::vector<countint>::iterator vit = v.begin();
        std::vector<countint>::iterator ven = v.end();
        for(int i = 0; i < numRun; i++){  //the outer loop runs for numRun times
            if(rst){
                for(vit = v.begin(); vit != ven; ++vit){
                    r.insert(*vit);
                }
            }
            else{
                for(vit = v.begin(); vit != ven; ++vit){
                    r.BSTinsert(*vit);
                }
            }
            countint::clearcount();
            for(vit = v.begin(); vit != ven; ++vit) {
                r.find(*vit);
            }
            comps = countint::getcount()/(double)val;
            totalcomps = totalcomps + comps;
            totalstd =  totalstd + pow(comps,2);
        }

        avgcomps = totalcomps/(double)numRun;  //the overall average comparison;
        stdev = sqrt((totalstd/(double)numRun) - pow(avgcomps,2));
        cout << val << "   "<< avgcomps <<"   " <<stdev <<endl;
        totalcomps = 0;
        totalstd = 0;
        v.clear();
    }
    cout << exp2(3) << endl;

}
