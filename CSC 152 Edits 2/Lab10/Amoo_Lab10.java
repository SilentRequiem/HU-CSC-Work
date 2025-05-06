/*
Name: Michael Amoo
Instructor: Dr B.
Program: Lab 10 
Date: 4/9/25
Description: Review Stack
File: Driver
Class: CSC 152 02 / Lab Section 3
I, Michael Amoo, pledge to follow the Honor Code in completing my Lab 10.
*/

import java.util.*;

public class Amoo_Lab10
{
   public static void main(String [] args) 
   {
   
//Part A - Stack of Integers
      System.out.println("Part A - Stack of Integers");
      Stack<Integer> myScoresStack = new Stack<Integer>();
      Scanner keyboard = new Scanner(System.in);

      System.out.print("Enter a score (-1 to stop): "); //-1 isn't counted

      int score = keyboard.nextInt();
      
      int max = score;
      int min = score;
      int sum = score;
      int cnt = 1; //total
      double average = sum / cnt;
      
      int posOdd = 0; //How many are postive odd
      int posEven = 0; //How many are postive even
      
      int posOddSum = 0; //sum of odds
      int posEvenSum = 0; //sum of evens
      
      if (score % 2 == 0 && score > 0) {
       posEven++;
       posEvenSum += score;
      }
      
      if (score % 2 != 0 && score > 0) {
       posOdd++;
       posOddSum += score;
      }
      
      
      while (score != -1) //As long as the score isn't -1, keep going
      {
         myScoresStack.push(score);
         System.out.print("Enter a score (-1 to stop): ");
         int x = keyboard.nextInt();
         
            if (x == -1) //if the score is -1, break
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
            
            if (score % 2 == 0 && score > 0) {
             posEven++;
             posEvenSum += score;
            }
      
      if (score % 2 != 0 && score > 0) {
             posOdd++;
             posOddSum += score;
            }
            
          
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
      
      
      System.out.println("# of Positive Odd: " + posOdd);
      System.out.println("# of Positive Even: " + posEven);
      System.out.println("Sum of Positive Odd: " + posOddSum);
      System.out.println("Sum of Positive Even: " + posEvenSum);
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
      //Printing entire name in uppercase, last character in Uppercase, and total number of characters in name
      //Ex: MICHAEL - L 7

      while (!myNameStack.isEmpty()) //As long as the stack isn't empty keep going
      {
         String currentName = myNameStack.pop();
         System.out.print(currentName.toUpperCase() 
         + " - " + currentName.toUpperCase().charAt(currentName.length() - 1)
         + " " + currentName.length());
         
         System.out.println("");
      }
      
      System.out.println("\n\nNames");
      System.out.println("There were "+ cnt2 + " names entered.");
      System.out.println("Total Characters: " + totalChars);
      System.out.println("Longest: " + longest);
      System.out.println("Shortest: " + shortest);
      
      
    
      




      
      
   }
} 