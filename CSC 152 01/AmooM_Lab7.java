//Name: Michael Amoo
//Phone: (757)-776-2017
//Section: 152 S1 / 2/27/24, 10:58 AM
//Instructor: Dr. B
//Description: char, String Arrays, and Searching Algorithms
//“I, Michael Kwabena Amoo, pledge to follow the Honor Code in completing my Lab 7.”


import java.util.Scanner;
public class AmooM_Lab7
{
public static void main(String args[])
   {
   Scanner keyboard = new Scanner(System.in);
   
//Part A - Array of characters
   System.out.print("Enter a sentence: ");
   String sentence_MKA = keyboard.nextLine();
   // create an array of characters
   int size = sentence_MKA.length();
   char[] myChars_MKA = new char[size];
   
   //assign character to array
   for (int i=0; i<myChars_MKA.length; i++)
   {  //char array with index
      myChars_MKA[i] = sentence_MKA.charAt(i);
   
   }
   //print in reverse
   System.out.println("\nReverse: ");
   for (int i=myChars_MKA.length - 1; i>=0; i--)
   {
   System.out.print(myChars_MKA[i]);
   }
   System.out.println(" ");
   
//Part B –String Arrays and String Manipulation
   
   String[] myFriends_MKA = new String[5];
   
   //input
   for(int i=0; i<myFriends_MKA.length; i++)
   {
      System.out.print("\nEnter a name: ");
      myFriends_MKA[i] = keyboard.nextLine();
   
   }
   
   //print using enhanced for loop
   for (String name : myFriends_MKA) //you can replace "tmp" with anything
   {
   
      System.out.println(
      name + " has " + name.length() + " characters - " +
      name.toUpperCase().charAt(0) +
      name.toUpperCase().charAt(name.length() -1));   
   
   }
   
//Part C – Partially Filled Array   
   
   int[] myScores_MKA = new int[100];
   int count = 0;
   
  System.out.print("\nEnter a number for array or -1 to quit: ");
  int stop = keyboard.nextInt();
  while (stop != -1 && count <= 99)
  {
    myScores_MKA[count] = stop; //assign
    count++;
    System.out.print("Enter a number or -1 to quit: ");
    stop = keyboard.nextInt();
  }
   System.out.println(); //separator
   
   //print
   int count_print = 0;
   for (int num : myScores_MKA)
   {
      System.out.print(num + "\t");
      count_print++; //increment what has printed so far
      if ( count_print % 10 == 0 )
         System.out.println();
   }
   // print only what user entered
   System.out.println("\nPrint only what user entered");
   for (int i = 0; i < count; i++)
   {
      System.out.print(myScores_MKA[i] + "\t"); 
      if ( (i + 1) % 10 == 0);
         System.out.println();
      
   }
   
   //stats
   int sum = 0;
   int highest = myScores_MKA[0];
   int lowest = myScores_MKA[0];
   
   for (int i = 0; i < count; i++)
   { sum = myScores_MKA[i];
     
     if (myScores_MKA[i] > highest)
         highest = myScores_MKA[i];
     
     if (myScores_MKA[i] < lowest)
         lowest = myScores_MKA[i];
   }
   double average = (double) sum / count;
   
   //Printout
    System.out.println("\n\nPrint out for stats " +
            "\n\tsum is " + sum +
            "\n\thighest is " + highest +
            "\n\tlowest is " + lowest +
            "\n\taverage is " + average + "\n");
   
   
   
   }
}