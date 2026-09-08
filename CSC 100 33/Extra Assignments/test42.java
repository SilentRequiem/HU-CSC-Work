//Name: Michael Amoo
//Instructor: Dr. Muhammad and Dr. Boonthum-Denecke
//Class: CSC-100-33
//Date:  
//Description: 
///////////////////////////////////////////////////

import java.util.Scanner;

public class test42
  { // class header
   public static void main(String[] args)
    { // main method header
    
    Scanner keyboard = new Scanner(System.in);   
   
   
   // enter 4 numbers and determine the largest number
   
    System.out.print("Enter number 1: ");
   int num1 = keyboard.nextInt();
  
    System.out.print("Enter number 2: ");
   int num2 = keyboard.nextInt(); 
   
    System.out.print("Enter number 3: ");
   int num3 = keyboard.nextInt(); 
   
    System.out.print("Enter number 4: ");
   int num4 = keyboard.nextInt(); 
   
   // if statements
   if (num1 > num2 && num1 > num3 && num1 > num4)
      System.out.println("num1 is the highest.");
      
   else if (num2 > num1 && num2 > num3 && num2 > num4)
      System.out.println("num2 is the highest.");

   else if (num3 > num1 && num3 > num2 && num3 > num4)
      System.out.println("num3 is the highest."); 
   
   else if (num4 > num1 && num4 > num2 && num4 > num3)
      System.out.println("num4 is the highest.");
   
   
   
   
   
   
   
   
   
   
   } // end main method 
  } //ending of program