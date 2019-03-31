#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/InstIterator.h"
#include "231DFA.h"
#include <set>


using namespace llvm;
using namespace std;


class ReachingInfo : public Info{
  public:

    ReachingInfo() {}

    ReachingInfo(std::set<unsigned> i){
      Information = i;
    }

    std::set<unsigned> Information;


    /*
     * Print out the information
     *
     */

    void print(){
      for (auto iter = Information.begin(); iter != Information.end(); ++iter){
      errs() << *iter << '|';
    }
      errs() << '\n';
    }

    /*
     * Compare two pieces of information
     *
     */
    static bool equals(ReachingInfo * info1, ReachingInfo * info2){
      return info1->Information == info2->Information;
    }
    /*
     * Join two pieces of information.
     * The third parameter points to the result.
     *
     */
    static void join(ReachingInfo * info1, ReachingInfo * info2, ReachingInfo * result){
      std::set<unsigned> i1 = info1->Information;
      std::set<unsigned> i2 = info2->Information;
      for (auto iter = i1.begin(); iter != i1.end(); ++iter){
        i2.insert(*iter);    
      }
      result->Information = i2;
    }
};






class ReachingDefinitionAnalysis : public DataFlowAnalysis <ReachingInfo, true>{
  private:
    typedef std::pair<unsigned, unsigned> Edge;

  public: 
    ReachingDefinitionAnalysis(ReachingInfo & bottom, ReachingInfo & initialState) : DataFlowAnalysis (bottom, initialState) {}
    
    void flowfunction(Instruction * I, std::vector<unsigned> & IncomingEdges, std::vector<unsigned> & OutgoingEdges, std::vector<ReachingInfo *> & Infos) {
      
      string instr = I -> getOpcodeName();

      //errs() << instr << ' ';
      //errs() << '\n';
      
      unsigned index = getInstrToIndex()[I];

      ReachingInfo *newInfo = new ReachingInfo();
      
      // second category: join 
      for (unsigned i = 0; i < IncomingEdges.size(); ++i){
        Edge edge = std::make_pair(IncomingEdges[i], index);
        ReachingInfo::join(getEdgeToInfo()[edge], newInfo, newInfo);
      }
      

      // first category: join
      if (I -> isBinaryOp() || instr == "alloca" || instr == "load" || instr == "getelementptr" || instr == "icmp" || instr == "fcmp" || instr == "select" ){
        set<unsigned> i;
        i.insert(index);

        ReachingInfo *tmp = new ReachingInfo(i);
        ReachingInfo::join(tmp, newInfo, newInfo);
      }
      

      // third category: join
      else if (instr == "phi" ){
        set <unsigned> indices;

        Instruction * nonphi = I->getParent()->getFirstNonPHI();
        unsigned nonphiindex = getInstrToIndex()[nonphi];

        for (unsigned i = index; i< nonphiindex; ++i){
           indices.insert(i); 
        }

        ReachingInfo *tmp = new ReachingInfo(indices);
        ReachingInfo::join(tmp, newInfo, newInfo);
      }

      
     
      // outgoing
       for (unsigned i = 0; i < OutgoingEdges.size(); ++i){
        Infos.push_back(newInfo);
      }

    }
 

};





namespace {
struct ReachingDefinitionAnalysisPass : public FunctionPass {
  static char ID;
  ReachingDefinitionAnalysisPass() : FunctionPass(ID) {}

  bool runOnFunction(Function &F) override {
    ReachingInfo bottom;
    ReachingInfo initialState;
    ReachingDefinitionAnalysis  MyAnalysis(bottom, initialState);
    MyAnalysis.runWorklistAlgorithm(&F);
    MyAnalysis.print();

    return false;
  }
}; // end of struct ReachingDefinitionAnalysisPass
}  // end of anonymous namespace

char ReachingDefinitionAnalysisPass::ID = 0;
static RegisterPass<ReachingDefinitionAnalysisPass> X("cse231-reaching", "Reaching Definition Analysis",
                             false /* Only looks at CFG */,
                             false /* Analysis Pass */);
