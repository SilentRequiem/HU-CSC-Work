//Name: Michael Amoo
//Phone: (757)-776-2017
//Section: 152 S1 / 3/5/24, 10:56 AM
//Instructor: Dr. B
//Description: Arrays and Searching Algorithm
//“I, Michael Kwabena Amoo, pledge to follow the Honor Code in completing my Lab 8.”

import java.util.Scanner;
import java.util.Arrays;
public class AmooM_Lab8
{
   public static void main(String args[])
   {
   Scanner keyboard = new Scanner(System.in);
   
//Part A – Define Integer Arrays and Read Input from user (20 pts)
   
   int[] scoresMKA = new int[10];
   
   System.out.println("Enter 10 intergers: ");
   for (int i=0; i<scoresMKA.length; i++)
   scoresMKA[i] = keyboard.nextInt();
   
   //Last 3 digits of 00549396
   scoresMKA[5] = 396;
   
   System.out.println("\n");
   
   //Print 10 times
   for (int tmp : scoresMKA)
   {
      System.out.println(tmp + "\t");
   
   }
   
   
//Part C – Test Your Search Methods (25 pts)   
   
   for (int i = 0; i < scoresMKA.length; i++)
   {
      System.out.print(scoresMKA[i] + "\t");
      if ( ( i+i ) % 5 == 0 ) //checks 5 numbers
       System.out.println();
   }   
      
      System.out.print("\nEnter a target to search: ");
      int target = keyboard.nextInt();
      // call a search
      int positionFound = linearSearch_MKA(scoresMKA, target);
      
        if (positionFound > -1) //found
      System.out.println("Found at " + (positionFound + 1));
   else
      System.out.print("Target not found");
      
     //copies array
     int[] sortedMKA = new int[scoresMKA.length];
     for ( int i=0; i<scoresMKA.length; i++)
         sortedMKA[i] = scoresMKA[i];
     Arrays.sort(sortedMKA); // sort number in the array
     System.out.println("\nSorted Number:\n");
     for (int i=0; i < sortedMKA.length; i++)
     {
        System.out.print(sortedMKA[i] + "\t");
      if ( ( i+i ) % 5 == 0 ) //checks 5 numbers
      System.out.println();
     }
   
   //Find a target using binary search
   positionFound = binarySearch_MKA( sortedMKA, target);
   if (positionFound > -1) //found
      System.out.println("Found at " + (positionFound + 1));
   else
      System.out.print("Target not found");
      
      
   
   }

  
  
//Part B – Create methods for Linear Search and Binary Search (40 points)   
   
   
   public static int linearSearch_MKA(int[] values, int target)
   {
   
   int pos = -1; //not found
   boolean foundFlag = false;
   int index = 0; //index
   
   while (!foundFlag && index < values.length)
   {
      if (values[index] == target) //found
      { pos = index; foundFlag = true; }
      index++;
   }
   return pos; //if found, then it is position found. -1 not found
   }
   
   public static int binarySearch_MKA(int[] values, int target) 
   {
      int pos = -1;
      boolean foundFlag = false;
      int start = 0, end = values.length - 1;
      while (!foundFlag && start <= end)
      {
         int mid = (start + end) / 2; //Midpoint
         
         if (values[mid] == target) //found target
            { pos = mid; foundFlag = true; }
            else if  (values[mid] > target) //front half/left half
               end = mid - 1; //update end index
               else //back half or right half
               end = mid + 1;
               
          }
   return pos; //if found, then it is position found. -1 not found
   }        
 }