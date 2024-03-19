//Name: Michael Amoo
//Phone: (757)-776-2017
//Section: 152 S1 / 3/19/24, 11:02 AM (Tuesday)
//Instructor: Dr. B
//Description: Review Arrays and Searching Algorithm
//“I, Michael Kwabena Amoo, pledge to follow the Honor Code in completing my Lab 9.”

import java.util.Scanner;
import java.util.Arrays;
public class AmooM_Lab9
{
   public static void main(String args[])
   {
   Scanner keyboard = new Scanner(System.in);
   
//Part A - Filled String Array

   String[] friendsListMKA = new String[5];
   
   for (int i=0; i < 5; i++)
   {
   System.out.println("Enter your friend's name: ");
   friendsListMKA[i] = keyboard.nextLine();
   }
   
   //collecting data for reverse

for (int i = friendsListMKA.length - 1; i >= 0; i--) 
   {
   
   String name = friendsListMKA[i];
   int nameLength = name.length();
   char lastCharUpperCase = Character.toUpperCase(name.charAt(nameLength - 1));   
   char middleCharUpperCase = Character.toUpperCase(name.charAt(nameLength / 2 )); 
   
   //Count of characters
   int totalCharacters = 0;
   
   //Total of characters
   totalCharacters += nameLength;
   
   
   System.out.println(name + " has " + nameLength + " charcters, " + lastCharUpperCase + " " + middleCharUpperCase);
   
   }
   
//Part B - Partially Filled Array Interger

   int[] scoresMKA = new int[40];

   //Count of how many numbers in array
   int count = 0;

   //Reading input for array
   System.out.println("Enter up to 40 numbers (stop with [-1]:");
   while (count < 50) 
   {
      int number = keyboard.nextInt();
      if (number == -1 || count == 40)
      {break;}
      
      scoresMKA[count++] = number;
   }   
   //Print
   System.out.println("Scores entered...");
   for (int i = 0; i < count; i++)
   {
   System.out.print(scoresMKA[i] + "\t");
   if ((i + 1) % 10 == 0) {
      System.out.println();
      }
   }
   System.out.println();
   
   
   //Calc for stats
   int sum = 0;
   int min = Integer.MIN_VALUE;
   int max = Integer.MAX_VALUE;
   
   for(int i = 0; i <count; i++)
   {
   sum += scoresMKA[i];
   if (scoresMKA[i] < min) {
   min = scoresMKA[i];
   }
   }
   
   double average = count > 0 ? (double) sum / count : 0;
   
   //Print
   System.out.println("Statistics: ");
   System.out.println("Sum: " + sum);
   System.out.println("Average: " + average);
   System.out.println("Min: " + min);
   System.out.println("Max: " + max);

//Part C – Duplicate Array Integer
  
   int[] sortedMKA = new int[scoresMKA.length];
     for ( int i=0; i<scoresMKA.length; i++)
         sortedMKA[i] = scoresMKA[i];
     Arrays.sort(sortedMKA); // sort number in the array
     
     System.out.println("Sorted scores: ");
     int numbersPerLine = 0;
     for (int score : sortedMKA) {
         System.out.print(score + "\t");
         numbersPerLine++;
         if (numbersPerLine % 5 == 0) {
            System.out.println(); // Every 5 numbers it moves
     }
     }
      
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   }
}