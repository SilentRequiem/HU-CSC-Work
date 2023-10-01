//Name: Michael Amoo
//Instructor: Dr. Muhammad and Dr. Boonthum-Denecke
//Class: CSC-100-33
//Date:  
//Description: 
///////////////////////////////////////////////////

import java.util.Scanner;

public class AmooM_Lab6
  { // class header
   public static void main(String[] args)
    { // main method header
    
    Scanner keyboard = new Scanner(System.in);   
  
   
   //Part A - Guessing Game with Basic If-Statment
    System.out.print("Enter your favorite number 0-9: ");
    int myNumber = keyboard.nextInt();
  
    System.out.print("Guess a number 0-9: ");
   int guessNumber = keyboard.nextInt();
  
   if (myNumber == guessNumber)
         System.out.println("Good guess, " + guessNumber + " is my favorite number.");
  
      
  //Part B - Two numbers: Am I higher or lower? If-statement
  {
  
   System.out.print("Enter a number: ");
   int num1 = keyboard.nextInt();
  
   System.out.print("Enter another number: ");
    int num2 = keyboard.nextInt(); 
   
    if (num1 > num2)
      System.out.println("Based on the user input (" + num1 + ") and (" + num2 
                                                      + "), num1 is higher than num2");
   
    if (num1 < num2)
       System.out.println("Based on the user input (" + num1 + ") and (" + num2 
                                                     + "), num1 is lower than num2");   
      if (num1 == num2)
       System.out.println("Based on the user input (" + num1 + ") and (" + num2 
                                                      + "), num1 is equal to num2");
  }
   
   //Part C - Read Scores, Get Average, and Print Message with if-else-if
   {
      System.out.print("Enter a number 1: ");
   int num1 = keyboard.nextInt();
   
      System.out.print("Enter a number 2: ");
   int num2 = keyboard.nextInt();
   
      System.out.print("Enter a number 3: ");
   int num3 = keyboard.nextInt();
   
      System.out.print("Enter a number 4: ");
   int num4 = keyboard.nextInt();
   
      System.out.print("Enter a number 5: ");
   int num5 = keyboard.nextInt();
   
   double average = (num1 + num2 + num3 + num4 + num5) / 5;
   
   if (average < 60)
      System.out.println("Your score of " + average + " is Needs to improve more.");

   else if (average >= 60 && average <= 69)
       System.out.println("Your score of " + average + " is Poor, with room to improve.");
   
  else if (average >= 70 && average <= 79)
       System.out.println("Your score of " + average + " is Just enough, but you can do more.");
  
  else if (average >= 80 && average <= 89)
       System.out.println("Your score of " + average + " is Good job!");
  
  else if (average >= 90 && average <= 99)
       System.out.println("Your score of " + average + " is Excellence!!");
  
  else 
       System.out.println("Your score of " + average + " is Outstanding!!!");
  
  
  
  
  
  
   }
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   } // end main method 
  } //ending of program