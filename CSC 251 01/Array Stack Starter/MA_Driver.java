/* 
Author: Michael Amoo
Instructor:  Dr. Jean Muhammad || Mr. Higgs
Class:  CSC 251 Data Structures
Description:  Manual String Stack (Driver)
Date: 9/29/26
*/

import java.util.Scanner;

public class MA_Driver
{
    public static void main(String[] args) {

        MA_ArrayStack objectMA = new MA_ArrayStack();
        Scanner keyboard = new Scanner(System.in);

        //store stack
        objectMA.storeStack(keyboard);

        //print stack
        objectMA.printStack();

        //search stack
        System.out.print("Enter a string to search: ");
        String sSearch = keyboard.nextLine();
        System.out.println("Found? " + objectMA.searchStack(sSearch));

        //num occurrences
        System.out.print("Enter a string to count: ");
        String sCount = keyboard.nextLine();
        System.out.println("Occurrences: " + objectMA.numOccur(sCount));

        //build string
        System.out.println("Build string: " + objectMA.buildString());

        //print all char
        System.out.print("Enter char for 5th position: ");
        char c = keyboard.nextLine().charAt(0);
        objectMA.printAllChar(c);

        //add 5 strings
        objectMA.add5Strings(keyboard);

        //delete one
        System.out.print("Delete one occurrence of: ");
        String d1 = keyboard.nextLine();
        objectMA.deleteStackOne(d1);

        //delete all
        System.out.print("Delete all occurrences of: ");
        String dAll = keyboard.nextLine();
        objectMA.deleteStackAll(dAll);

        //add after
        System.out.print("Search string: ");
        String s1 = keyboard.nextLine();
        System.out.print("Add string after: ");
        String s2 = keyboard.nextLine();
        objectMA.addOneElementAfter(s1, s2);

        //check full/empty
        System.out.println("Stack full? " + objectMA.origStackFull());
        System.out.println("Stack empty? " + objectMA.origStackEmpty());

        //final print
        objectMA.printStack();

        keyboard.close();
    }
}
