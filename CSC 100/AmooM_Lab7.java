//Name: Michael Amoo
//Instructor: Dr. Muhammad and Dr. Boonthum-Denecke
//Class: CSC-100-33
//Date: 7/12/23  
//Description: Loops 
///////////////////////////////////////////////////

import java.util.Scanner;

public class AmooM_Lab7
  { // class header
   public static void main(String[] args)
    { // main method header
    
    Scanner keyboard = new Scanner(System.in);   
   
   
   //Part A While - Loop - thid is a pretest
   int num1 = 1; //starting value to test
   while(num1 <= 10)
      {
        System.out.println("Hello world");
        num1 = num1 +1; // add - when num1 = 11 will stop the loop
        
      }
   
   
   int num2 = 15;
   while (num2 > 7)
   {
      System.out.println(num2);
    num2 = num2 -1;
      
   }
   
   // ask the user for in a loop
   System.out.println("Enter a number from 1 to 10");
   System.out.println("Enter a number out of range of 1 to 10 to quit");
   int num3 = keyboard.nextInt(); //first read
   int sum = 0;
   while (num3 <= 10)
   { //this black of code repeats untill user enters num3 is greater than 10
     sum = sum + num3; //running total
      System.out.println("Enter a number from 1 to 10");
       System.out.println("Enter a number out of range of 1 to 10 to quit");
       num3 = keyboard.nextInt(); //read another number
    
   } //end of loop
    System.out.println("Sum: " + sum);
    
    
    
    
    
    // validation loop - while loop
    System.out.println("Enter a positive number grearter than 0");
    int posNum = keyboard.nextInt();
    while (posNum <= 0) //bad input - Validation checker
    {
     System.out.println("You entered an invalid number, try again");
     System.out.println("Enter a positive number grearter than 0");
     posNum = keyboard.nextInt();
    
    }
    System.out.println("Great Job - You entered a vaild number");
    
    
    
    //Part B for...loop
    //start i = 1, Test 1 <= 10, everytime I loop it will increament i by 1
    //Test: i <= 10 if true it goes into the loop
    //adds 1 to i
    int sum1 = 0;
    for (int i = 1; i <= 10; i++)
    {
         System.out.println("i: " + i);
         sum1 = sum1 + i;
    } 
    
   } // end main method 
  } //ending of program