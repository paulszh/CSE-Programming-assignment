#ifndef RST_HPP
#define RST_HPP
#include "BST.hpp"
#include <iostream>

using namespace std;

template <typename Data>
class RST : public BST<Data> {

public:

    /* Insert new data into the RST if it is not already present.
    * Input
    *    item - the data to insert.
    *    return - true if the item was inserted. If the item was already contained in
    *       the tree then return false.
    */

    virtual bool insert(const Data& item) {

        // TODO: Implement this function!
        if (BST<Data>:: empty()) {
            BST<Data>::root = new BSTNode<Data>(item);
            //cout << BST<Data>::root << endl;
            return true;
        }
        else {
            BSTNode<Data>* current = BST<Data>::root;
            BSTNode<Data>* last = 0;
            while ( current != 0 ) {
                if ( item < current->data ) {
                    last = current;
                    current = current->left;
                }
                else if ( current->data < item ) {
                    last = current;
                    current = current->right;
                }
                else {  // already in the tree
                    return false;
                }
            }
            BSTNode<Data>* newNode = new BSTNode<Data>(item);
            if ( item < last->data ) {
                last->left = newNode;
                newNode->parent = last;
            }
            else {
                last->right = newNode;
                newNode->parent = last;
            }
            //cout << newNode->priority << endl;
            //bubbleUp(newNode);
            return true;

        }
    }


private:

    /* Perform a 'right rotation' that changes the structure of the tree without
    * interfering with the size, data content, and left->right order of nodes in the RST.
    * This rotation is done by changing the 'left', 'right', and/or 'parent' pointers
    * of a subset of nodes without changing their 'priority' values.
    *
    * Input
    *    par - a parent node in the RST with a left child
    *    child - the left child of 'par'
    *
    * Output
    *   The resulting tree will have 'par' and 'child' in the same order but switched
    *   in level, meaning 'par' will effectively become the right-child of 'child'.
    *
    */
    void bubbleUp(){
        return;

    }
    void rotateRight( BSTNode<Data>* par, BSTNode<Data>* child ) {

        child->parent = par->parent;  //assign the par's parent to child
        if(child->parent){
            if(child->parent->left == par){  //the case when par is a left child
                child->parent->left = child;
            }
            else{
                child->parent->right = child; //the case when par is a right child
            }
        }
        par->left = child->right;
        //the case when child-left before is not empty
        if(par->left){
            par->left->parent = par;
        }
        child->right = par;
        par->parent = child;
        if(BST<Data>::root == par){ //the case when par is a root
            BST<Data>::root = child;           //then assign child to root
            BST<Data>::root->parent = 0;
        }
        // TODO: Implement this function!

    }


    /* Perform a 'left rotation' that changes the structure of the tree without
    * interfering with the size, data content, and left->right order of nodes in the RST.
    * This rotation is done by changing the 'left', 'right', and/or 'parent' pointers
    * of a subset of nodes without changing their 'priority' values.
    *
    * Input
    *    par - a parent node in the RST with a right child
    *    child - the right child of 'par'
    *
    * Output
    *   The resulting tree will have 'par' and 'child' in the same order but switched
    *   in level, meaning 'par' will effectively become the left-child of 'child'.
    *
    */
    void rotateLeft( BSTNode<Data>* par, BSTNode<Data>* child )
    {
        child->parent = par->parent;  //assign the par's parent to child
        if(child->parent){
            if(child->parent->left == par){  //the case when par is a left child
                child->parent->left = child;
            }
            else{
                child->parent->right = child; //the case when par is a right child
            }
        }
        par->right = child->left;
        //the case when child-left before is not empty
        if(par->right){
            par->right->parent = par;
        }
        child->left = par;
        par->parent = child;
        if(BST<Data>::root == par){ //the case when par is a root
            BST<Data>::root = child;           //then assign child to root
            BST<Data>::root->parent = 0;
        }
        // TODO: Implement this function!

    }

public:

    /* THIS FUNCTION IS USED FOR TESTING, DO NOT MODIFY
    *
    * Calls BST::insert so we can add data to test rotateRight and rotateLeft before
    * implementing the fully correct version of RST::insert.
    *
    */
    bool BSTinsert(const Data& item) {

        return BST<Data>::insert(item);
        //return BSTinsert(item);

    }

    /* THIS FUNCTION IS USED FOR TESTING, DO NOT MODIFY
    *
    * Locates the node for an item and rotates it left or right without changing the
    * left->right order of nodes in the RST
    * Input
    *    item - the Data item to rotate.
    *    leftOrRight - if true then rotateLeft, otherwise rotateRight
    *    output - 0 if item could be found and had a child to rotate with, 1 if not. -1 if
    *         rotation failed for other reasons
    */
    int findAndRotate(const Data& item, bool leftOrRight) {

        BSTNode<Data>* current = RST<Data>::root;
        while ( current != 0 ) {
            if ( item < current->data ) {
                current = current->left;
            }
            else if ( current->data < item ) {
                current = current->right;
            }
            else {  // already in the tree
                break;
            }
        }

        if (current == 0 or current->data != item) {
            return 1;
        }

        if (leftOrRight) {
            if (current->right == 0) {
                return 1;
            }
            BSTNode<Data>* right = current->right;
            rotateLeft(current, current->right);

            // make sure we actually do a rotation
            if (current->right == right) {
                return -1;
            }

        } else {
            if (current->left == 0) {
                return 1;
            }
            BSTNode<Data>* left = current->left;
            rotateRight(current, current->left);

            // make sure we actually do a rotation
            if (current->left == left) {
                return -1;
            }
        }
        return 0;
    }
};
#endif // RST_HPP
