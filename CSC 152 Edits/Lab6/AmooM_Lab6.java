/*
Name: Michael Amoo
Section: 152 S1 
Instructor: Dr. B
Description: char and String Array
Date: 10/9/24
“I, Michael Kwabena Amoo, pledge to follow the Honor Code in completing my Lab 6.”
*/
import java.util.Scanner;
public class AmooM_Lab6 {
   public static void main(String[] args)
{
  Scanner keyboard = new Scanner(System.in);

//Part A - Array of characters

  System.out.println("Enter a sentence: ");
  String sentence_MKA = keyboard.nextLine();
   
  char[] myChars_MKA = new char[sentence_MKA.length()];
   
     //Take chars
     for (int i = 0; i < myChars_MKA.length; i++)
      {
       myChars_MKA[i] = sentence_MKA.charAt(i);
      }
     
     //Print in Reverse
     for (int i = myChars_MKA.length - 1; i >= 0; i--)
      {
       System.out.print(myChars_MKA[i]);
      }
 

//Part B - String Arrays and String Manipulation
   
   String[] myFriends_MKA = new String[5];
   System.out.println("\n\nEnter 5 names: ");
      for (int i = 0; i < myFriends_MKA.length; i++)
         {
          myFriends_MKA[i] = keyboard.nextLine();
         }
         System.out.println(" ");         
   
   //Print
   for (int i = 0; i < myFriends_MKA.length; i++)
      {
       System.out.println(myFriends_MKA[i] + " has " + myFriends_MKA[i].length() + " characters - " 
            + myFriends_MKA[i].toUpperCase().charAt(0) + " " + myFriends_MKA[i].toUpperCase().charAt(myFriends_MKA[i].length() - 1));
      }




//Part C - Partially Filled Array

   int[] myScores_MKA = new int[100];
   
   int count = 0;
   
      System.out.println("\nEnter a number (-1 to stop): ");
      while (count < myScores_MKA.length)
      { 
         int num = keyboard.nextInt();
         
            if (num == -1)
            {break;}
         
         myScores_MKA[count] = num;
         count++;
      }
     
  //Print
  
  int counter = 0;
  for (int tmp : myScores_MKA)
  {
  
  System.out.print(tmp + "\t"); 
  counter++;
  
  if (counter % 10 == 0) 
  {
    System.out.println("\n");
  }
  
  
  System.out.println("\nEntered numbers (up to " + count + " numbers:");
  for (int i = 0; i < count; i++)
  {
   System.out.print(myScores_MKA[i] + "\t");
   
   if ((i + 1) % 10 == 0)
     {
     System.out.println();
     }
   }
   System.out.println();  
   
   
  
     
  
  
  int sum = 0;
  int lowest = myScores_MKA[0];
  int highest = myScores_MKA[0];
  
  
  //Enhanced
  for (int tmp2 : myScores_MKA)
  {
   sum += tmp2;
   if (tmp2 > highest)
   highest = tmp2;
   
   if (tmp2 < lowest)
   lowest = tmp2;
  }
  
  {
  double average = (double) sum / myScores_MKA.length;
  System.out.println("\n\nPrint:\n"
                       + "\tSum: " + sum + "\n"
                       + "\tlowest: " + lowest + "\n"
                       + "\thighest: " + highest + "\n"
                       + "\tAverage: " + average + "\n"
                       + "\tCount: " + count + "\n");}}}
   }
  

  
  
  
  
  
  
  
  
  

