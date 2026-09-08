//Name: Michael Amoo
//Instructor: Dr. Muhammad and Dr. Boonthum-Denecke
//Class: CSC-100-33
//Date: 7/7/23 
//Description: Test1 
///////////////////////////////////////////////////

import java.util.Scanner;

public class Test1_MA
  { // start class
   public static void main(String[] args)
    { // start main method
    
    Scanner keyboard = new Scanner(System.in);   
   
   System.out.println("Enter a double: ");
   double myDouble = keyboard.nextDouble();
   keyboard.nextLine();
   System.out.println("Enter a interger: ");
   int myInteger = keyboard.nextInt();
   keyboard.nextLine();
   System.out.println("Enter your name: ");
   String myName = keyboard.nextLine();
   keyboard.nextLine();
   System.out.println("My name is " + myName);
                  
  System.out.println("My double is " + myDouble
                   + "." + "\nMy interger is " + myDouble + ".");
  
  String upper = myName.toUpperCase();
  System.out.println("My name in UPPERCASE is " + upper + ".");
  
  char fchar = myName.charAt(0);
  System.out.println("My forth character is " + fchar + ".");
  
  int result = -7 + 4 * 3 % 5 - 6 / 2 + 7;
  //         1 5   2   3   6   4   7
  
  System.out.println(result);  
  
  int num1 = 2;
  int num2 = 4;
  int num3 = 6;
  
  double result0 = (int) (Math.pow(3,2) + 3 * num2) / (Math.sqrt(Math.pow(num1,3)) - 5) + (Math.sqrt(Math.pow(num2,4)) + 10);
  //                          1         7   6       10      4       2              8    11   5         3               9               
  
  System.out.println(result0); 
  
  double result1 = (int) (Math.pow(1,2)) + (4 * Math.pow(2,3)) - (2 * Math.pow(num3,7));
  System.out.println(result1); 
  
  double result2 = (int) (((Math.pow(num3,10) + 3) * num2)) / (Math.sqrt(Math.pow(num1,4)));
  System.out.println(result2);
  
  double result3 = (double) (num3 - num2) / (8 * num1) + (double) (4 * num1) - (num3) / (num2);  
  System.out.println(result3);
   
  double result4 = (Math.sqrt(3 * (Math.pow(num2,4) + 3) - (num1)) / (7 * Math.pow(num2,2))); 
  System.out.println(result4); 
   
   
   
   
   
   
   
   
   
   } // end main method 
  } //ending of program