#ifndef BSTNODE_HPP
#define BSTNODE_HPP
#include <iostream>
#include <iomanip>
using namespace std;


template<typename Data>
class BSTNode {

    public:

    /** Constructor.  Initialize a BSTNode with the given Data item,
     *  no parent, and no children.
     */
    BSTNode(const Data & d) : data(d) {
        left = right = parent = 0;
    }

    BSTNode<Data>* left;
    BSTNode<Data>* right;
    BSTNode<Data>* parent;
    Data const data;   // the const Data in this node.

    /** Return the successor of this BSTNode in a BST, or 0 if none.
     ** PRECONDITION: this BSTNode is a node in a BST.
     ** POSTCONDITION:  the BST is unchanged.
     ** RETURNS: the BSTNode that is the successor of this BSTNode,
     ** or 0 if there is none.
     */ // TODO
    BSTNode<Data>* successor() {
        BSTNode<Data> *successor = this;
        //The case that the current node has right child
        if(successor->right){
            successor = successor->right;
            //go to the leftmost leaf
            while(successor->left){
                successor = successor->left;
            }
        }
        //The case the current node does not have right child  
        else{
            // subcase: the current node is a left child
            if(!successor -> parent){
                return 0;
            }
            else if((successor->parent)->data > successor->data){
                successor = successor->parent;
            }
            // subcase: the current node is a right child;
            else{
                while((successor->parent)->data < successor->data){
                    successor = successor->parent;
                    // The case the current node is at right-most position
                    // It does not have any successor
                    if(!successor->parent){
                        return 0;
                    }
                }
                successor = successor->parent;

            }

        } 
        return successor; 
    }


}; 

/** Overload operator<< to print a BSTNode's fields to an ostream. */
template <typename Data>
std::ostream & operator<<(std::ostream& stm, const BSTNode<Data> & n) {
    stm << '[';
    stm << std::setw(10) << &n;                 // address of the BSTNode
    stm << "; p:" << std::setw(10) << n.parent; // address of its parent
    stm << "; l:" << std::setw(10) << n.left;   // address of its left child
    stm << "; r:" << std::setw(10) << n.right;  // address of its right child
    stm << "; d:" << n.data;                    // its data field
    stm << ']';
    return stm;
}

#endif // BSTNODE_HPP
