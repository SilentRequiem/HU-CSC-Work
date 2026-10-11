/*
Program Name:  MA_Driver.java
Author: Michael Amoo
Instructor: Dr. Jean Muhammad || Mr. Higgs
Class: CSC 251 Data Structures
Description: Stack Array - using Strings
Due Date: October 8, 2026
Date: September 29, 2026
*/

import java.util.Scanner;

public class MA_Driver {

    public static void main(String[] args) {

        MA_ArrayStack MA_Object = new MA_ArrayStack();

        // Reuse the Scanner from MA_ArrayStack
        Scanner keyboard = MA_Object.keyboard;


        // Store 10 Strings
        MA_Object.storeStack();

        System.out.println();


        // Print in original order
        System.out.println("Original Stack:");
        MA_Object.printOStack();

        System.out.println();


        // Print in reverse order
        System.out.println("Reverse Stack:");
        MA_Object.printRStack();

        System.out.println();


        // Search for a character in the 4th position
        System.out.println("Enter a character to search for as the 4th character:");
        char myChar = keyboard.nextLine().charAt(0);

        int charCount = MA_Object.searchStack(myChar);

        System.out.println("Number of Strings with " + myChar + " as the 4th character: " + charCount);


        // Count occurrences of a String
        System.out.println("Enter a String to count:");
        String str = keyboard.nextLine();

        int occurrences = MA_Object.numOccur(str);

        System.out.println(
            str + " occurs " + occurrences + " time(s)."
        );


        // Build String using Strings whose 2nd character is h
        String builtString = MA_Object.buildString();

        System.out.println("Strings with 'h' as the 2nd character: " + builtString);


        // Print Strings whose 5th character matches c
        System.out.println("Enter a character to search for as the 5th character:");

        char c = keyboard.nextLine().charAt(0);

        System.out.println("Matching Strings:");
        MA_Object.printAllChar(c);

        System.out.println();


        // Add 5 more Strings
        System.out.println("Add 5 more Strings:");
        MA_Object.add5Strings();

        System.out.println();

        System.out.println("Stack after adding:");
        MA_Object.printOStack();

        System.out.println();


        // Delete one occurrence
        System.out.println(
            "Enter a String to delete ONE occurrence of:"
        );

        String deleteOne = keyboard.nextLine();

        MA_Object.deleteStackOne(deleteOne);

        System.out.println("Stack after deleting one occurrence:");
        MA_Object.printOStack();

        System.out.println();


        // Delete all occurrences
        System.out.println(
            "Enter a String to delete ALL occurrences of:"
        );

        String deleteAll = keyboard.nextLine();

        MA_Object.deleteStackAll(deleteAll);

        System.out.println("Stack after deleting all occurrences:");
        MA_Object.printOStack();

        System.out.println();


        // Add one element after a searched element
        System.out.println(
            "Enter the String you want to search for:"
        );

        String search = keyboard.nextLine();

        System.out.println(
            "Enter the new String you want to add after it:"
        );

        String addString = keyboard.nextLine();

        MA_Object.addOneElementAfter(search, addString);

        System.out.println("Stack after insertion:");
        MA_Object.printOStack();

        System.out.println();


        // Check full
        System.out.println(
            "Stack is full: " + MA_Object.stackFull()
        );


        // Check empty
        System.out.println(
            "Stack is empty: " + MA_Object.stackEmpty()
        );
    }
}