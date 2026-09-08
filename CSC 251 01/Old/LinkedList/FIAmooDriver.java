/* 
Author: Michael Amoo
Instructor:  Dr. Jean Muhammad || Dr. Paudel
Class:  CSC-251-01 Data Structures
Description:  StarterLinkedList
Date: 11/11/25
File: Driver
*/

public class FIAmooDriver {
    public static void main(String[] args) {

        FIAmooLL cityList = new FIAmooLL();

        //add5nodes
        System.out.println("Using add5nodes() to make a list of 5 cities:\n");
        cityList.add5nodes();
        cityList.printAllNodes();
        System.out.println();

        //addToFront
        System.out.println("Adding Emporia to the front of the list:\n");
        cityList.addToFront("Emporia");
        cityList.printAllNodes();
        System.out.println();

        //addRear
        System.out.println("Adding Charlottesville to the rear of the list:\n");
        cityList.addRear("Charlottesville");
        cityList.printAllNodes();
        System.out.println();

        //removeFromFront
        System.out.println("Removing from the front of the list:\n");
        String frontRemoved = cityList.removeFromFront();
        System.out.println("Removed from front: " + frontRemoved);
        cityList.printAllNodes();
        System.out.println();

        //removeFromRear
        System.out.println("Removing from the rear of the list:\n");
        String rearRemoved = cityList.removeFromRear();
        System.out.println("Removed from rear: " + rearRemoved);
        cityList.printAllNodes();
        System.out.println();

        //search
        System.out.println("Searching for Richmond...it is " + cityList.search("Richmond"));
        System.out.println("Searching for New York...it is " + cityList.search("York"));
        System.out.println();

        //addAfter
        System.out.println("Adding Fairfax after Norfolk:\n");
        boolean addedAfter = cityList.addAfter("Norfolk", "Fairfax");
        System.out.println("Can we add addAfter?: " + addedAfter);
        cityList.printAllNodes();
        System.out.println();

        //removeNode
        System.out.println("Removing Norfolk from the list:\n");
        boolean removedNorfolk = cityList.removeNode("Norfolk");
        System.out.println("removeNode result: " + removedNorfolk);
        cityList.printAllNodes();
        System.out.println();

        System.out.println("Removing Hawaii from the list:\n");
        boolean removedHawaii = cityList.removeNode("Hawaii");
        System.out.println("removeNode result: " + removedHawaii);
        cityList.printAllNodes();
    }
}
