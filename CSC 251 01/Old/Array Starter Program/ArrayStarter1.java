/* 
Author: Michael Amoo
Instructor:  Dr. Jean Muhammad || Dr. Paudel
Class:  CSC-251-01 Data Structures
Description:  Array Program - practicing writing array methods
Date: 9/9/25
*/

import java.util.Scanner;
public class ArrayStarter1

{

//  attributes

    //Define arraySize of 15, final

    final static int arraySize = 15;

    //Define arrayMA of type integer and of size: arraySize

    int arrayMA[] = new int [arraySize];

    //Count
    int count = 0;

//  methods 

    //public void arrayStore()  - as we did in the class  - 8 elements  integer

    public void arrayStore() {
        Scanner keyboard = new Scanner(System.in);

        System.out.println("Enter 8 integers to store in the array:");

        for (int i = 0; i < 8; i++) {

            if (count >= arrayMA.length) {
                System.out.println("Array is full. Cannot add more elements.");
                break;
            }
            System.out.print("#" + (i + 1) + ":");
            arrayMA[count] = keyboard.nextInt();
            count++;
            System.out.println("");
        }
    }


    //public void arrayPrint()   - print all elements in the array ( do not print out empty cells )

    public void arrayPrint() { 
        System.out.println("Items in currently in array ");

        for (int i = 0; i < count; i++) {
            System.out.print(arrayMA[i] + ", ");  
        }
        System.out.println();
    }

    //public boolean arrayFull() -  check to see if the array is full

    public boolean arrayFull() {
    return count >= arrayMA.length;
    }

    //public boolean arrayEmpty() - check to see if the array is empty

    public boolean arrayEmpty() {
    return count == 0;
    
    }


    //public boolean addOneElement (int x) - add 1 element into the array - make sure you can add - as discussed in class
     public boolean addOneElement(int x) {
        if (arrayFull())
        return false; 
        
        arrayMA[count] = x;
        count++;
        
        return true;
    }

    //public boolean searchArray(int x)  - search the array for element x that was passed in as a parameter

    public boolean searchArray(int x) {
    for (int i = 0; i < count; i++) {
            if (arrayMA[i] == x) 
            return true;
        }
        return false;
    }

    //public void printMultiple8() - print all elements that are multiples of 8
    
    public void printMultiple8() {
        System.out.print("Multiples of 8: ");
        boolean MultiOf8 = false;
        for (int i = 0; i < count; i++) {
            if (arrayMA[i] % 8 == 0) {
                System.out.print(arrayMA[i] + " ");
                MultiOf8 = true;
            }
        }
        if (!MultiOf8) 
        System.out.print("No multiples of 8 found.");
        
        System.out.println();
    }

    //public int findAllRange()  -  find all elements over 15 - return the number of elements over 15
    public int findAllRange() {
        
        int r15 = 0; //count of range


        for (int i = 0; i < count; i++) {
            if (arrayMA[i] > 15) 
            r15++;
        }
        return r15;
    }
    

    //public int averageArray() - calculate and return the average of all elements in the array 

    public int averageArray() {
        int sum = 0;
        for (int i = 0; i < count; i++) sum += arrayMA[i];
        return sum / count;
    }


    //public int smallestEleArray - find and return the smallest element in the array  
    public int smallestEleArray() {
        int min = arrayMA[0];
        for (int i = 1; i < count; i++) {
            if (arrayMA[i] < min) min = arrayMA[i];
        }
        return min;
    }

 //end class array

}

