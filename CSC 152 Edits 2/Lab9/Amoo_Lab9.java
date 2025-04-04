/*
Name: Michael Amoo
Instructor: Dr B.
Program: Lab 9 
Date: 4/2/25
Description: Learning how to use API for Stack
File: Driver
Class: CSC 152 02 / Lab Section 3
I, Michael Amoo, pledge to follow the Honor Code in completing my Lab 9.
*/

import java.util.*;

public class Amoo_Lab9
{
   public static void main(String [] args) 
   {
   
//Part A - Stack of Integers
      System.out.println("Part A - Stack of Integers");
      Stack<Integer> myScoresStack = new Stack<Integer>();
      Scanner keyboard = new Scanner(System.in);

      System.out.print("Enter a score (-99 to stop): "); //-99 isn't counted

      int score = keyboard.nextInt();
      
      int max = score;
      int min = score;
      int sum = score;
      int cnt = 1; //total
      double average = sum / cnt;
      
      
      while (score != -99) //As long as the score isn't -99, keep going
      {
         myScoresStack.push(score);
         System.out.print("Enter a score (-99 to stop): ");
         int x = keyboard.nextInt();
         
            if (x == -99) //if the score is -99, break
            {
               break;
            }
            score = x; //otherwise, set the score to x
         
         cnt++;
         sum += score;
         
            if (score > max)
            {max = score;}
            
            if (score < min)
            {min = score;}
            
          
      average = sum / cnt;
      
      }
             
      
      //Printing the stack 5 per line
      System.out.println("\nThe scores in the stack are:");
      int count = 0;
      while (!myScoresStack.isEmpty()) //As long as the stack isn't empty, keep going
      {
         System.out.print(myScoresStack.pop() + " ");
         count++;
         if (count % 5 == 0) //reset each line after 5
         {
            System.out.println();
         }
      }
      System.out.println("\n\nStats");
      System.out.println("There were "+ cnt + " scores entered.");
      System.out.println("Max: " + max);
      System.out.println("Min: " + min);
      System.out.println("Sum: " + sum);
      System.out.println("Average: " + average);
      
      keyboard.nextLine();
   

//Part B - Stack of Strings
      System.out.println("\nPart B - Stack of Strings");

      Stack<String> myNameStack = new Stack<String>();

      
      

      System.out.print("Enter a name (DONE to stop): ");
      String name = keyboard.nextLine();
      
      int cnt2 = 0; //total
      int totalChars = 0; //total number of chars in all names together
      String longest = ""; //longest name (in char)
      String shortest = ""; //shortest name (in char)
      


      while (!name.equalsIgnoreCase("DONE")) //As long as the name isn't DONE, keep going
      {
         if (!name.equalsIgnoreCase("DONE")) {
            myNameStack.push(name);
            cnt2++;
            totalChars += name.length();

            if (longest.isEmpty() || name.length() > longest.length()) {
               longest = name;
            }

            if (shortest.isEmpty() || name.length() < shortest.length()) {
               shortest = name;
            }
         }
         System.out.print("Enter a name (DONE to stop): ");
         name = keyboard.nextLine();

      }
      System.out.println("");
      //Printing entire name in uppercase, last character in lowercase, and total number of characters in name
      //Ex: MICHAEL - l 7

      while (!myNameStack.isEmpty()) //As long as the stack isn't empty keep going
      {
         String currentName = myNameStack.pop();
         System.out.print(currentName.toUpperCase() 
         + " - " + currentName.toLowerCase().charAt(currentName.length() - 1)
         + " " + currentName.length());
         
         System.out.println("");
      }



      
      
   }
} 