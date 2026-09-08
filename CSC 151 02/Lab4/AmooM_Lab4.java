//Name: Michael Amoo
//Date: 9/26/23
//Phone: (757)-776-2017
//Section: 151 63
//Instructor: Dr. B
//Description: Lab 4 - Conditioning Statement if, if-else, if-else-if, and nested-if-else

import java.util.Scanner;

public class AmooM_Lab4
{
public static void main(String[] args)
   {
   Scanner keyboard = new Scanner(System.in);
   
   //Part A - Guessing Game with Basic If-Statement and If-Else
   final int myNUMBER = 7;
   int guessNumber;
   
   System.out.print("Guess my favorite number: ");
   guessNumber = keyboard.nextInt();
   
   if (guessNumber == myNUMBER)
      System.out.println("Good Guess, " + guessNumber + " is my favorite number.");
  
   else
      System.out.println("Sorry, " + myNUMBER + " is the correct answer.");
      
  //Part B -  Two numbers: Am I higher or lower? If-else-if statement
  int num1;
  int num2;
  
  System.out.print("\nEnter a number for num1: ");
     num1 = keyboard.nextInt();
  System.out.print("Enter a number for num2: ");
     num2 = keyboard.nextInt();

   if (num1 > num2)
      System.out.print("- Based on the user input " + num1 + " and " + num2 + ", num1 is higher than num2");
   
   else if (num1 < num2)
      System.out.print("- Based on the user input " + num1 + " and " + num2 + ", num1 is lower than num2");
   
   else 
       System.out.print("- Based on the user input " + num1 + " and " + num2 + ", num1 is equal to num2");    
   
   //Part C - Read Scores, Get Average, and Print Message with if-else-if for a letter grade
   int num3;
   int num4;
   int num5;
   
  System.out.println("\nEnter 5 intergers (0 - 100): ");
     num1 = keyboard.nextInt();
     num2 = keyboard.nextInt(); 
     num3 = keyboard.nextInt(); 
     num4 = keyboard.nextInt();
     num5 = keyboard.nextInt();
   
   double average = num1 + num2 + num3 + num4 + num5 / 5;
   char letterGrade;
   
   if (average >= 90)
      letterGrade = 'A';   
   
   else if (average >= 80)
      letterGrade = 'B';
   
   else if (average >= 70)
      letterGrade = 'C';      
   
   else if (average >= 60)
      letterGrade = 'D';      
   
   else
      letterGrade = 'F';   
      
      System.out.println("Your average score is " + average + " and you earn " + letterGrade + ".");
      
    //Part D - Read 3 intergers and find highest using nested-if-else
    if (num1 > num2)
    {
     if (num2 > num3)
      {
      System.out.println("\nYou enter " + num1 + ", " + num2 + ", " + num3 + ", and the highest number is " + num2 + ".");
      }
     else if (num3 > num1)
      System.out.println("\nYou enter " + num1 + ", " + num2 + ", " + num3 + ", and the highest number is " + num3 + ".");      
      }
    else
    
    {
      if (num2 > num3)
         System.out.println("\nYou enter " + num1 + ", " + num2 + ", " + num3 + ", and the highest number is " + num2 + ".");
      else if (num3 > num2)
         System.out.println("\nYou enter " + num1 + ", " + num2 + ", " + num3 + ", and the highest number is " + num3 + ".");
    }
    
    
    //Part E - REVIEW Chapter 2: calculation, order of predcedence and data conversion
    int a;
    int b;
    double r;
    
   System.out.println("\nEnter a, b and r: ");
   a = keyboard.nextInt();
   b = keyboard.nextInt();
   r = keyboard.nextDouble();
   
   int result1 = (int) (Math.pow(a,9) + 7 * 9 - Math.sqrt(a));
   double result2 = ( ( (3 * a + 7) / 5 ) + ( (2 * b - 9) / 7) );
   double result3 = ( (4 * Math.pow(r,9) + 3 * a - 2 * b) / 7);
   
   System.out.println("\nYou entered: a = " + a + ", b = " + b + ", and r = " + r + ".");
   System.out.println("result1 is " + result1 + ".");
   System.out.println("result2 is " + result2 + ".");
   System.out.println("result3 is " + result3 + ".");

   }
}