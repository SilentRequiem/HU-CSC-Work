/*
Author: Michael Kwabena Amoo
Instructor: Dr.B
Program: AmooM_Prog1
Date: June 29, 2023
Description: Problem Solving Program Assignment
Location: ST 126
TAs: Gabby, Miles.
*/

import java.util.Scanner;

public class AmooM_Prog1
{ //start class
   public static void main(String[] args)
   { // start main method
   Scanner keyboard = new Scanner(System.in);
   
   //Honor Code 
   System.out.println("Summer 2023 - Program 1 by Michael Amoo, Major Computer Science");
   System.out.println("\n \n I, Michael Kwabena Amoo, did not receive any assistant\n from another person except CSC 100 instructors\n and assigned TAs.\n\n");
   
   //Questions
   System.out.print("Enter an integer for a ");
   int a = keyboard.nextInt();
   System.out.print("Enter an integer for b ");
   int b = keyboard.nextInt();
   System.out.print("Enter a decimal for r ");
   double r = keyboard.nextDouble();
   keyboard.nextLine();
   System.out.print("Enter your name ");
   String name = keyboard.nextLine();
   
   //Calulating inputs
   System.out.println("\n" + name + ", your values inputs were: "
                           + "\n   a = " + a
                           + "\n   b = " + b
                           + "\n   r = " + r);
  int result1 = (int) Math.pow(a, 7) + 5 * 9;
  int result2 = (int) Math.pow(a, 4) - 8 * (a * b) + (int) Math.pow(b,5);
  double result3 = (((2 * (double) a) - 5 )/18) + ((3 * (double) b ) - 7 )/13;
  double result4 = ( (5 * Math.pow(r,10) + 3) / 7 );
  
  //Result of Calulation
   System.out.println("\n" + "Calculated results were: "
                           + "\n   result 1 = " + result1
                           + "\n   result 2 = " + result2
                           + "\n   result 3 = " + result3
                           + "\n   result 4 = " + result4);
   //String Manipulation
   System.out.print("\n\nPlease enter your hometown (City and State): "); //In my case it's Suffolk, Virginia
   String hometown = keyboard.nextLine();
   
   System.out.println("\n" + name + ", your hometown is " + hometown); 
   String upper = hometown.toUpperCase();
   String lower = hometown.toLowerCase();
   
   //String API1 - char upper.length/lower.length
   System.out.println("   " + upper);
   System.out.println("   " + lower);
   char UHome = upper.charAt(upper.length()-1);
   System.out.println("   Last character of your hometown is " + UHome);
   
   //String API2 - Substring
   String substring = "Dunkin Donuts".substring(0,6);
   System.out.println("\n\nMy substring of [Dunkin Donuts] is " + substring);
   
   
   //String API3 - byte to string
   byte[] byteArray = { 'K', 'U', 'P', 'P', 'O', '!' };
		System.out.println("\n\nNow changing the word KUPPO! from byte to string! "); 
      byte[] byteArray1 = { 75, 85, 80, 80, 79, 33 };

		
		String str1 = new String(byteArray1);
		System.out.println("The bytes are 75,85,80,80,79,33");
      System.out.println(str1);
   
   
   
   
   //Assignment End
   System.out.println("\nProgram 1 is completed by " + name);
   
   
   
   
   
   
   
    } // end main method
} //ending of program