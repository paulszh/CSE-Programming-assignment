#ifndef BST_HPP
#define BST_HPP
#include "BSTNode.hpp"
#include "BSTIterator.hpp"
#include <iostream>
using namespace std;

template<typename Data>
class BST {

    protected:

    /** Pointer to the root of this BST, or 0 if the BST is empty */
    BSTNode<Data>* root;

    /** Number of Data items stored in this BST. */
    unsigned int isize;

    public:

    /** define iterator as an aliased typename for BSTIterator<Data>. */
    typedef BSTIterator<Data> iterator;

    /** Default constructor.
      Initialize an empty BST.
     */
    BST() : root(0), isize(0) {  }


    /** Default destructor.
      Delete every node in this BST.
     */ // TODO
    virtual ~BST() {
        clear();
    }

    /** Given a reference to a Data item, insert a copy of it in this BST.
     *  Return  true if the item was added to this BST
     *  as a result of this call to insert,
     *  false if an item equal to this one was already in this BST.
     *  Note: This function should use only the '<' operator when comparing
     *  Data items. (should not use >, <=, >=)
     */ // TODO
    virtual bool insert(const Data& item) {

        BSTNode<Data>* newNode = new BSTNode<Data>(item);
        if(isize == 0 && root == 0){
            root = newNode;
            isize++;
            return 1;
        }
        return insertHelper(newNode,root);
    }


    /** Find a Data item in the BST.
     *  Return an iterator pointing to the item, or pointing past
     *  the last node in the BST if not found.
     *  Note: This function should use only the '<' operator when comparing
     *  Data items. (should not use >, <=, >=)
     */ // TODO
    iterator find(const Data& item) const {
        if(root == 0 && isize == 0){
            return end();
        }
        return findhelper(item,root);
    }

    /** Return the number of items currently in the BST.
     */ // TODO
    unsigned int size() const {
        return isize;
    }

    /** Return true if the BST is empty, else false.
     */ // TODO
    bool empty() const {
        if(isize == 0)
            return true;
        else
            return false;
    }

    /** Empties the Tree
     */ // TODO
    bool clear(){

        this->deleteAll(root);
        isize = 0;
        root = 0;
        return true;
    }

    /** Return an iterator pointing to the first item in the BST (not the root).
     */ // TODO
    iterator begin() const {
        BSTNode<Data>* last = first(root);
        return typename BST<Data>::iterator(last);
    }

    /** Return an iterator pointing past the last item in the BST.
     */
    iterator end() const {
        return typename BST<Data>::iterator(0);
    }


    /** Perform an inorder traversal of this BST.
     */
    void inorder() const {
        inorder(root);
    }


    private:
    bool insertHelper(BSTNode<Data> *toInsert, BSTNode<Data> *toCompare){
        if(toInsert->data == toCompare->data){
            delete toInsert;
            return 0;
        }
        if(toInsert->data < toCompare->data){
            if(toCompare->left == 0){
                toCompare->left = toInsert;
                toInsert ->parent = toCompare;
                isize++;
                return 1;
            }
            else{
                return insertHelper(toInsert,toCompare->left);
            }
        }
        else{    
            if(toCompare->right == 0){
                toCompare->right = toInsert;
                toInsert->parent = toCompare;
                isize++;
                return 1;
            }
            else{
                return insertHelper(toInsert,toCompare->right);
            }
        }
    }

    iterator findhelper(const Data& item,BSTNode<Data>* toCompare) const{
        if(item == toCompare-> data){
            return leaf(toCompare);
        }
        else if(toCompare->data < item){
            if(toCompare->right == 0){
                return end();
            }
            else{
                return findhelper(item,toCompare->right);
            }
        }
        else{
            if(toCompare->left == 0){
                return end();
            }
            else{
                return findhelper(item,toCompare->left);
            }
        }

    }

    iterator leaf(BSTNode<Data> *current) const{
        return typename BST<Data>::iterator(current);
    }

    /** Recursive inorder traversal 'helper' function */
    /** Inorder traverse BST, print out the data of each node in ascending order.
      Implementing inorder and deleteAll base on the pseudo code is an easy way to get started.
     */ // TODO
    void inorder(BSTNode<Data>* n) const {

        if(!n){
            return;
        }
        inorder(n->left);
        cout << n->data <<endl;
        inorder(n->right);
        /* Pseudo Code:
           if current node is null: return;
           recursively traverse left sub-tree
           print current node data
           recursively traverse right sub-tree
         */
    }
    /** Find the first element of the BST
     */
    static BSTNode<Data>* first(BSTNode<Data>* root) {
        if(root == 0) return 0;
        while(root->left != 0) root = root->left;
        return root;
    }

    /** do a postorder traversal, deleting nodes
     */ // TODO
    static void deleteAll(BSTNode<Data>* n) {
        /* Pseudo Code:
           if current node is null: return;
           recursively delete left sub-tree
           recursively delete right sub-tree
           delete current node
         */
        if(!n){return;}
        else{
            if(n->left != 0)
                deleteAll(n->left);
            if(n->right !=0)
                deleteAll(n->right);
            delete n;
        }

    }
};


#endif //BST_HPP
