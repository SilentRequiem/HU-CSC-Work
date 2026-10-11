/*
Program Name:  MA_ArrayStack.java
Author: Michael Amoo
Instructor:  Dr. Jean Muhammad || Mr. Higgs
Class:  CSC251-01-Fall 2026
Description:  Stack Array - using Strings
Due Date:  October 8, 2026
Date: September 29, 2026
*/

import java.util.Scanner;


/*
TODO:
1) Class: MA_ArrayStack - Strings
Stacks: origStack, tempStack
- stackSize = 20
- define top, ttop
- create a storeStack() method: store 10 strings entered by the user; each string must be at least 6 characters
- create a printOStack() method: print all elements in the order they were added
- create a printRStack() method: print all elements in reverse order
- create a searchStack(char myChar) method: search for myChar as the 4th character and return how many were found
- create a numOccur(String str) method: return the number of occurrences of str
- create a buildString() method: return one string containing all stack strings whose 2nd character is 'h'
- create a printAllChar(char c) method: print all elements whose 5th character is c
- create an add5Strings() method: add 5 more strings using a loop and check available space
- create a deleteStackOne(String str) method: delete only 1 occurrence of str
- create a deleteStackAll(String str) method: delete every occurrence of str
- create an addOneElementAfter(String search, String addString) method: add 1 element after search
- create a stackFull() method: return whether the stack is full
- create a stackEmpty() method: return whether the stack is empty
2) Create an MA_Driver
- create your object: MA_ArrayStack MA_object = new MA_ArrayStack()
- call all the methods
Due Date: Final Stack Program Return Oct. 8th   before Midnight 11:59  - deduction 10 points per day. 

*/

/*
Things to do:
- Check if element can be added before adding
- call object FILI_Object
- Muhammad will input her strings so make sure she can do so via driver or class
- try to call via method (ex: myChar.obj.searchStack("string"))
*/

public class MA_ArrayStack{
    public int size;
    public int top;
    public int ttop;
    private String[] origStack;
    private String[] tempStack;

    // The assignment searches for strings whose second character is 'h'.
    private final char secondChar = 'h';

    // constructor
    public MA_ArrayStack() {
        
        size = 20;
        top = -1;
        ttop = -1;
        origStack = new String[size];
        tempStack = new String[size];

    }

    Scanner keyboard = new Scanner(System.in);

    // Store the required strings in the stack.
    public void storeStack() {
        // TODO: store 10 elements into the stack ( ask the user for a string  (must be at least 6 characters) inside of the method

        for(int i = 0; i < 10; i++) {
            
            if (top < size - 1) {

                String word = "";

                System.out.println("Enter a String that is at least 6 characters: ");

                word = keyboard.nextLine();

                    while (word.length() < 6) {
                        System.out.println("Please enter a String that is AT LEAST 6 characters: ");
                        word = keyboard.nextLine();
                    }
                
                top++;
                origStack[top] = word;

            }

        }

    }

    // Print elements in the order they were added.
    public void printOStack() {
        // TODO: print origStack from the bottom toward the top.

        for (int i = 0; i <= top; i++) {

            tempStack[i] = origStack[i];
            ttop++;

        }

        for (int ii = 0; ii <= ttop; ii++) {

            System.out.print(tempStack[ii] + ", ");

        }

        ttop = -1; //Empty the ttop pointer for safety
    }

    // Print elements in reverse order.
    public void printRStack() {
        // TODO: print origStack from the top toward the bottom.

        ttop = -1;

        for (int i = 0; i <= top; i++) {
            tempStack[i] = origStack[i];
            ttop++;
        }

        for (int ii = ttop; ii >= 0; ii--) {

            System.out.print(tempStack[ii] + ", ");

        }

        ttop = -1;

    }

    // Count strings whose fourth character matches myChar.
    public int searchStack(char myChar) {
        // search all strings in the Stack that have myChar as the 4th character - return how many you found

        ttop = -1;
        int count = 0;

        for (int i = 0; i <= top; i++) {
            tempStack[i] = origStack[i];
            ttop++;
        }

        for (int ii = ttop; ii >= 0; ii--) {

            if (tempStack[ii].charAt(3) == myChar) {
                
                count++;

            }
        }

        ttop = -1;
        return count;
    }

    // Count occurrences of a string.
    public int numOccur(String str) {
        // TODO: count matching strings in origStack.

        ttop = -1;
        int count = 0;

        for (int i = 0; i <= top; i++) {
            tempStack[i] = origStack[i];
            ttop++;
        }

    
        for (int ii = ttop; ii >= 0; ii--) {

            if (tempStack[ii].equals(str)) {
                
                count++;
            
            }
        }

        ttop = -1;
        return count;
    }

    // Build a string from elements whose second character is secondChar.
    public String buildString() {
       //create a string with all strings in the stack  with the 2nd character: 'h'  - return string

        String mergeStr = "";
        ttop = -1;

        for (int i = 0; i <= top; i++) {
            tempStack[i] = origStack[i];
            ttop++;
        }

        for (int ii = ttop; ii >= 0; ii--) {

            if (tempStack[ii].charAt(1) == secondChar) {
                mergeStr += tempStack[ii] + "-";
            }
        }

        ttop = -1;

        return mergeStr;
    }

    // Print elements whose fifth character matches c.
    public void printAllChar(char c) {
        // TODO: search for c at index 4 and print matching elements.

        ttop = -1;

        for (int i = 0; i <= top; i++) {
            tempStack[i] = origStack[i];
            ttop++;
        }

        for (int ii = ttop; ii >= 0; ii--) {

            if (tempStack[ii].charAt(4) == c) {
                System.out.print(tempStack[ii] + ", ");
            }
        }

        ttop = -1;

    }

    // Add five additional strings.
    public void add5Strings() {
        // add 5 more strings to the stack // test to see if you have the space ( must use a loop)

        for (int i = 0; i < 5; i++) {

            if (top < size - 1) {

                System.out.println("Enter a String: ");
                String word = keyboard.nextLine();

                top++;
                origStack[top] = word;
            }

            else {
                System.out.println("Stack is full.");
                break;
            }
        }
    }

    // Delete one occurrence of str.
    public void deleteStackOne(String str) {
        //  this method will delete 1 occurrence of str only

        boolean deleted = false;
        ttop = -1;

        for (int i = top; i >= 0; i--) {

            if (!deleted && origStack[i].equals(str)) {
                deleted = true;
            }

            else {
                ttop++;
                tempStack[ttop] = origStack[i];
            }
        }

        top = -1;

        for (int i = ttop; i >= 0; i--) {
            top++;
            origStack[top] = tempStack[i];
        }

        ttop = -1;

        if (!deleted) {
            System.out.println(str + " was not found");
        }

    }

    // Delete every occurrence of str.
    public void deleteStackAll(String str) {
        // this method will delete all occurrence of str 

        ttop = -1;

        for (int i = top; i >= 0; i--) {

            if (!origStack[i].equals(str)) {
                ttop++;
                tempStack[ttop] = origStack[i];
            }
        }

        top = -1;

        for (int i = ttop; i >= 0; i--) {
            top++;
            origStack[top] = tempStack[i];
        }

        ttop = -1;
    }

    // Add addString immediately after search.
    public void addOneElementAfter(String search, String addString) {
        // this method adds 1 element to the stack

        if (top >= size - 1) {
        
            System.out.println("Stack is full.");
            return;

        }

        boolean added = false;
        ttop = -1;

        for (int i = top; i >= 0; i--) {

            if (!added && origStack[i].equals(search)) {
                
                ttop++;
                tempStack[ttop] = addString;
                added = true;

            }

            ttop++;
            tempStack[ttop] = origStack[i];
        }

        top = -1;

        for (int i = ttop; i >= 0; i--) {
            top++;
            origStack[top] = tempStack[i];
        }

        ttop = -1;

        if (!added) {
            System.out.println(search + " was not found");
        }

    }

    // Check whether the original stack is full.
    public boolean stackFull() {

        if (top == size - 1) {
            return true;
        }

    return false;
    }

    // Check whether the original stack is empty.
    public boolean stackEmpty() {

        if (top == -1) {
            return true;
        }

    return false;
}

}