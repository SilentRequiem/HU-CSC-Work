/* 
Author: Michael Amoo
Instructor:  Dr. Jean Muhammad || Dr. Paudel
Class:  CSC-251-01 Data Structures
Description:  StarterLinkedList
Date: 11/11/25
File: Class
*/

class Node {
    String city; //data
    Node NN; //next node

    public Node(String c) { //constructor
        city = c;
        NN = null; //next node is null to start with
    }
}

public class FIAmooLL {

    // attributes
    Node head;

    // constructors
    public FIAmooLL() {
        head = null;
    }

    public void add5nodes() { //method to start with 5 nodes to the list
        addRear("Suffolk");
        addRear("Norfolk");
        addRear("Richmond");
        addRear("Virginia Beach");
        addRear("Washington D.C");
    }

    public void printAllNodes() { //Traversing the list and printing all nodes
        if (head == null) { //checking if the list is empty so that we don't get a null pointer exception
            System.out.println("List is empty.");
            return;
        }

        Node CN = head; // current node
        System.out.println("Cities listed:");
        while (CN != null) {
            System.out.println(" ---> " + CN.city); // remember to read city then CN
            CN = CN.NN; //Makes the current node the next node in the list, so that we can traverse through the list until we reach a null
        }
    }

    public void addToFront(String city) { 
        /*
        Adds a city to the front of the list by creating a new node and making it the new head
        while the old head becomes the next node of the new head
        */
        Node newNode = new Node(city);
        newNode.NN = head;
        head = newNode;
    }

    public void addRear(String city) { //Goes to the end of the list and adds a new node with the city name to the rear of the list
        Node newNode = new Node(city);

        if (head == null) {
            head = newNode; //if the list is empty, the new node becomes the head
        } else {
            Node CN = head; //current node starts at head
            while (CN.NN != null) {
                CN = CN.NN; //traverse to the end of the list
            }
            CN.NN = newNode; //when we reach the end of the list, we set the next node of the last node to be the new node
        }
    }

    public String removeFromFront() {
        if (head == null) {
            System.out.println("No head exists.");
            return null; //returning null just for the driver
        }

        String removed = head.city;
        head = head.NN; //moves the head to be the next node
        return removed; //shows removed
    }

    public String removeFromRear() {
        if (head == null) { //if the list is empty, there is nothing to remove
            System.out.println("No rear exists.");
            return null;
        }

        if (head.NN == null) { //if there is only one node, we remove it and set head to null
            String removed = head.city;
            head = null;
            return removed;
        }

        Node PN = head;      //previous node starts at head
        Node CN = head.NN;   //current node starts at second node

        while (CN.NN != null) { //traverse until we reach the last node
            PN = PN.NN; //move previous node to current node
            CN = CN.NN; //move current node to next node
        } //this loop basically moves PN and CN together until CN is the last node (CN.NN == null)
        //Example: if the list is A -> B -> C -> null, then after the loop, PN will be B and CN will be C so the list will be A -> B -> null

        String removed = CN.city;
        PN.NN = null;  // cut off the last node
        return removed;
    }

    public boolean search(String city) {
        Node CN = head; //Makes current node the head
        while (CN != null) {
            if (CN.city.equalsIgnoreCase(city)) { //if the current node's city matches the search city, returns true
                return true;
            }
            CN = CN.NN;
        }
        return false;
    }

    public boolean removeNode(String city) { //removes a node with the given city name if it exists in the list
        if (head == null) {
            System.out.println("List is empty.");
            return false;
        }

        if (head.city.equalsIgnoreCase(city)) { //if the head node is the one to remove, we just make the head the next node
            head = head.NN;
            return true;
        }

        Node PN = head; //previous node starts at head
        Node CN = head.NN; //current node starts at second node

        while (CN != null && !CN.city.equalsIgnoreCase(city)) { //while CN is not null and the current node doesn't match the city to remove, we keep going
            PN = PN.NN;
            CN = CN.NN;
        }

        if (CN == null) {
            System.out.println(city + " is not in the list.");
            return false;
        }

        PN.NN = CN.NN; //once we find the node, set the NN of the PN to be the NN of the CN, effectively removing the CN from the list
        return true;
    }

    public boolean addAfter(String targetCity, String newCity) {//search for targetCity. if found, insert newCity after it.
        if (head == null) {
            System.out.println("List is empty. Cannot add after.");
            return false;
        }

        Node CN = head;

        while (CN != null && !CN.city.equalsIgnoreCase(targetCity)) { //while cn is not null and the cn city doesn't match the target city, we keep going
            CN = CN.NN;
        }

        if (CN == null) {
            System.out.println(targetCity + " not found. Cannot add after it.");
            return false;
        }

        Node newNode = new Node(newCity); //create a new node with the new city name
        newNode.NN = CN.NN; //set the next node of the new node to be the next node of the current node
        CN.NN = newNode; //set the next node of the current node to be the new node, effectively inserting it after the current node
        return true;
    }
}
