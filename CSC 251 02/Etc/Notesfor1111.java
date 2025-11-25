import java.util.*;

public class Notesfor1111 {
    public static void main(String[] args) {

/*There are 4 types of linked lists: Single LinkedLIst (8 operations), Circular, Double, Ordered */

/* 
Single Linked List:
  1. Add to the front - Ex: If the list is empty, add to the front. If the list is not empty, add to the front and point to the old head.  
  2. Remove from the front - Ex: If the list is empty, do nothing. If the list is not empty, remove the head and point to the next node.
  3. Add Rear - Ex: If the list is empty, add to the rear. If the list is not empty, add to the rear and point to the old rear.
  4. Remove Rear - Ex: If the list is empty, do nothing. If the list is not empty, remove the rear and point to the previous node.
  5. Traverse - Ex: If list is empty, do nothing. If list is not empty, start at the head & print each node till you reach the end of list.
  6. Search - Ex: If list is empty, do nothing. If list is not empty, start at the head & check each node till you find the search item or reach the end of the list.
  7. Add before/after -  Ex: If list is empty, do nothing. If list is not empty, start at the head & check each node till you find the search item or reach the end of the list. If you find the search item, add before/after it.
  8. Remove if it exists - Ex: If list is empty, do nothing. If list is not empty, start at the head & check each node till you find the search item or reach the end of the list. If you find the search item, remove it.
*/

/*
 Circular Linked List:
 Cars (Head) --> Belly --> Scream --> Avengers --> Cars (Head)
 For Example: if Head is 100 and it points to belly (222) then it will point to 97 (scream), and so on till it repeats

The class for the Circular Linked List will look like this: 

class CLL {
        Node head;
}

class Node {
        String data; //Depending on the data change the data type to int, double, etc
        Node NN; //Next Node
}
 */

 /* Searching in a linked list
    
    //CN is currently head
    

    if (head == search) {

        while (CN != head.NN) {
            
            if (CN.data == search) {
                found = true;
                break;
                }
            CN = CN.NN;
            }
    }

    OR YOU CAN DO THIS...Do while

    do {
        if (CN.data == search) {
            found = true;
            break;
        }
        CN = CN.NN;
    } while (CN != head);

    Why? Because if the search is at the head, then the while loop will never execute and it will not find it. 
    The do while loop will execute at least once and check the head first before moving on to the next node.

    For example if it was looking for scream, it would check the head first, then move on to belly, then scream and find it.
    If it was looking for cars, it would check the head first and find it immediately.

    
    //CN.NN means the next node of current node. Read from right to to left like manga.


  */

/*Removing from the rear of a Circular Linked list

cars (head) --> belly --> scream --> avengers

//Connect scream back to the head (cars) and make scream the new rear.
//Assuming you don't know the length of the list, you can use a while loop to find the rear and the node before it.

//before the loop, you need to set the previous node and current node to the head and the next node respectively.

PN = head; //Previous Node
CN = PN.NN; //Current Node


do {
   
   PN = PN.NN; //Move previous node to the next node
   CN = CN.NN; //Move current node to the next node 
   
   } while (CN.NN != head) // Keep moving until you find the rear (the node whose next node is the head)

PN.NN = CN.NN; //Connect the previous node to the next node of the current node (which is the rear)

*/

/* Adding to the front of a Circular linked list
   cars (head) --> belly --> scream --> avengers

   For this example we will be adding nemo to the front of the list.
   
   1. Avengers needs to point to the new node (nemo) 
   2. Nemo (new node) needs to point to the existing head (cars) 
   3. Head needs to become New Node (nemo)

   The current node will be avengers and the new node will be nemo.

   do {
     CN = CN.NN; //Move current node to the next node
    } while (CN.NN != head) // Keep moving until you find the rear (the node whose next node is the head)

    CN.NN = newNode; //Connect the rear to the new node
    newNode.NN = head; //Connect the new node to the existing head
    head = newNode; //Make the new node the new head
 */

//--------------------Study Session---------------------------------------------------------


// Test will be on Arrays, Stacks, and Linked Lists.
// It will cover the following topics: 8 operations, Addresses, Traversal, Search, and Circular Linked Lists.

/*
Question: Check and see if there a second node to remove 

Baseball (head) --> Basketball --> Kickball --> null

if (head != null) { //if head is not null
    
    if (head.NN != null) { // if also the next node is not null

        head = head.NN.NN; 
        //Move the head to the next node's next node (which is the third node), skipping the second node (basketball) and removing it

    }
}


Question: Stack
a = 20
b = a++
System.out.println(b); //Answer is 20 because the value of a is assigned to b before it is incremented.
Assign then increment

(it's only changing the value of a, not b. So b will still be 20, while a will be 21 after the operation.)

x = 30
y = ++x
System.out.println(y); //Answer is 31 because the value of x is incremented before it is assigned to y.
Increment then assign
(it's changing the value of x before it is assigned to y. So x will be 31, and y will also be 31 after the operation.)


Question: Stack

We add 22, 34, 55, 66, 12 to the stack in that order and our top is 12 at this moment. We want to make a temporary stack
Ttop (temporary top) will start at the bottom of the the stack. We are making an array that acts like a stack.

int array[] = new int[5];
array = {22, 34, 55, 66, 12} //This is the stack with 22 at the bottom and 12 at the top.

top = 12;

You can only use arr[top] because you can only access the top of the stack. You cannot access any other element in the stack directly.

If I was going to print the elements in the stack, I would have to pop each element off the stack and print it. What would be the loop?

while (top > -1) {
    System.out.println(arr[top]); //Print the top element
    top--; //Move the top down to the next element
}

//Adding to temp stack
while (top > = 0) {
    int value = arr[top--];
    System.out.println(value);
    ttop++; //We use ttop++ because we want to move the temp top up before adding the value to the temp stack.
    
    tarr[ttop] = value; //Add the value to the temp stack

    ++ttop; //We use ++ttop because we want to move the temp top up before adding the value to the temp stack. 
    //If we used ttop++ it would add the value to the temp stack before moving the temp top up, which would cause an error.
}

//Search in stack array
while (top > = 0) {
    int value = arr[top--];
    
        if (value == search) {
            System.out.println("Found " + search);
            found = true;
            break;
        }
        tarr [++ttop] = value; //Add the value to the temp stack because we are popping it off the original stack and we want to keep it in the temp stack. We use ++ttop because we want to move the temp top up before adding the value to the temp stack.
    }








*/

































    }
}
    