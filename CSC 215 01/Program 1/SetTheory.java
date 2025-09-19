/* 
Author: Michael Amoo
Instructor:  Dr. Aneke
Class:  CSC-215-01 Discrete Structures
Description: SetTheory
Date: 9/13/25
*/

public class SetTheory {
    public static void main(String[] args) {
        
    int[] a = {1, 2, 3, 4, 5};
    int[] b = {4, 5, 6, 7, 8};

//Print arrays
    System.out.print("a = {");

    for (int i = 0; i < a.length; i++) {
        
        System.out.print(a[i]);
        
        if (i < a.length - 1) { //to prevent the extra comma
            System.out.print(", ");
        }

    }
    System.out.println("}");


    System.out.print("b = {");
    for (int i = 0; i < b.length; i++) {
        
        System.out.print(b[i]);

        if (i < b.length - 1) { //to prevent the extra comma
            System.out.print(", ");
        }

    }
    System.out.println("}");


//Union - all unique elements in both sets

    //Merge arrays
    int[] union = new int[a.length + b.length];
    int size = 0;

    // A --> union
    for (int i = 0; i < a.length; i++) {
        union[size] = a[i];
        size++;
    }

    //Compare and add only unique elements from b

    for (int i = 0; i < b.length; i++) {
        boolean found = false;

        for (int ii = 0; ii < size; ii++) {
           
            if (b[i] == union[ii]) {
                found = true;
                break;
            }

        }

        //if not found, add
        if (!found) {
            union[size] = b[i];
            size++;
        }
    }

    //Print
    System.out.print("a Union b = {");

    for (int i = 0; i < size; i++) {
        
        System.out.print(union[i]);

        if (i < size - 1) { //to prevent the extra comma
            System.out.print(", ");
        }

    }
    System.out.println("}");

//Intersect - items in both sets
    int[] intersect = new int[Math.min(a.length, b.length)];
    int size4intersect = 0;

    //For each a, is it in b?
    for (int i = 0; i < a.length; i++) {
        
        for (int ii = 0; ii < b.length; ii++) {
            if (a[i] == b[ii]) {
                intersect[size4intersect] = a[i];
                size4intersect++;
                break;
            }

        }
    }

    //Print
    System.out.print("a Intersect b = {");
    for (int i = 0; i < size4intersect; i++) {
        
        System.out.print(intersect[i]);

        if (i < size4intersect - 1) { //to prevent the extra comma
            System.out.print(", "); 
        }
    }
    System.out.println("}");

//Difference A - B (items in A not in B)

    int[] differenceAB = new int[a.length];
    int size4differenceAB = 0;

    for (int i = 0; i < a.length; i++) {
        boolean found = false;

        for (int ii = 0; ii < b.length; ii++) {
            if (a[i] == b[ii]) {
                found = true;
                break;
            }

        }

        //if not found, add item 
        if (!found) {
            differenceAB[size4differenceAB] = a[i];
            size4differenceAB++;
        }
    }
    //Print
    System.out.print("a - b = {");
    for (int i = 0; i < size4differenceAB; i++) {
        
        System.out.print(differenceAB[i]);

        if (i < size4differenceAB - 1) { //to prevent the extra comma
            System.out.print(", ");
        }
    }
    System.out.println("}");




//Difference B - A (items in B not in A)

    int[] differenceBA = new int[b.length];
    int size4differenceBA = 0;

    for (int i = 0; i < b.length; i++) {
        boolean found = false;

        for (int ii = 0; ii < a.length; ii++) {
            if (b[i] == a[ii]) {
                found = true;
                break;
            }

        }

        //if not found, add item 
        if (!found) {
            differenceBA[size4differenceBA] = b[i];
            size4differenceBA++;
        }
    }

    //Print
    System.out.print("b - a = {");
    for (int i = 0; i < size4differenceBA; i++) {
        System.out.print(differenceBA[i]);

        if (i < size4differenceBA - 1) { //to prevent the extra comma
            System.out.print(", ");
        }
    }
    System.out.println("}");

    }

}
