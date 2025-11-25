//Circular Linked Lists and Ordered Linked Lists

class Node { //What each node will be able to use to store data and point to the next node
    int data;
    Node next;
    Node prev;
    }


public class CircularLinkedListNOrdered {
      
//Ordered Linked List - Can be circular, ordered, and doubled. In this case it will be made to be a queue.


//What is the difference between a circular linked list and a doubled linked list?

//A circular linked list is a linked list where the last node points back to the first node, creating a loop.
//A double linked list is a linked list where each node has two pointers, basically a list that can go both ways.
//An ordered linked list is a linked list where the elements are stored in a specific order, usually in ascending or descending order.

//Example: 12, 3, 9, 4, 7, 6, 8 will be stored in an ordered linked list as 3, 4, 6, 7, 8, 9, 12.

/*
Properties of Data Structures - Make sure to use the full word not just the abbreviation when describing the properties of data structures.
--------------|-------------------------------------|----------------|------------------------
Array         |              Stack                  |  Linked List   | Queue
--------------|-------------------------------------|----------------|------------------------
Fixed         | Not fixed depends on implementation |     Dynamic    | Same as stack
--------------|-------------------------------------|----------------|------------------------
Contiguous    |              Depends                | Non-contiguous | Depends
--------------|-------------------------------------|----------------|------------------------
Homogenous    |              Homogenous             |   Homogenous   | Homogenous
--------------|-------------------------------------|----------------|------------------------
Random Access |              LIFO/FIFO              |   Traversal    | FIFO/LIFO
--------------|-------------------------------------|----------------|------------------------
*/

//A Single Linked List has these Methods:
/*
add() - Adds a new node to the end of the list.
Traverse() - Goes through the list and prints out the data of each node.
Remove() - Removes a node from the list based on the data value.
Search(int x) - Searches for a node with a specific data value and returns true if found, false otherwise.
*/

//Example of SSL methods in code:
//Rules of a SLL: FIFO, You can Access only the first element, and no info on length of the list.

// Head --> Blue --> Red --> Green --> Yellow --> Null
public int add() { //rear
   return null; //placeholder for later code
}

public int traverse() { //print all nodes, search for a node.
   return null; //placeholder for later code
}

public int remove() { //front
   return null; //placeholder for later code
}

public int search(int x) { //search a specific node
   return null; //placeholder for later code
}





























public static void main(String[] args) { //Main method
   System.out.println("11/20/25");
   
   }

}
