//Name: Michael Amoo
//Instructor: Dr. Muhammad and Dr. Boonthum-Denecke
//Class: CSC-100-33
//Date:  
//Description: 
///////////////////////////////////////////////////

import java.util.Scanner;

public class Amoo_Lab8a
  { 
  
    public static void main(String[] args)
    {
    
    //Create a Scanner object
    Scanner keyboard = new Scanner(System.in);   
   
   //for loop
   int total =0;
   for(int a=0; a < 6; a=a+1  ) //starting value;test condition;increment, a++ is the same as +1
   {
      //repeated body of a loop
      total = total + a;
      System.out.println("a: " + a);
   
   } //end for loop a
      System.out.println("total: " + total);
   
   //Even numbers
   int total1 = 0;
   for (int b = 0; b <=10; b = b + 2  ) // print out even numbers
   {
      System.out.println("b even numbers: " + b);
      total1 = total1 + b;
  
   } //end of loop b
  System.out.println("total1: " + total1); 
   
   
   // Threes
   int total2 = 0;
   for (int c = 0; c <=15; c = c + 3  ) // print out even numbers
   {
      System.out.println("c by threes: " + c);
      total2 = total2 + c;
  
   } //end of loop c
  System.out.println("total2: " + total2); 
   
   
   //Fives
   int total3 = 0;
   for (int d = 0; d <=25; d = d + 5 ) // print out even numbers
   {
      System.out.println("d by fives: " + d);
      total3 = total3 + d;
  
   } //end of loop d
  System.out.println("total3: " + total3); 
   
   //ask the user for their 5 grades - print out grades and the average
   double average;
   double grade;
   double sum =0;
   for ( int x= 1; x <= 5; x=x+1 ) //Activates the code 5 times // (starting value); (test condition); (increment)
   {
     System.out.println("Enter your grade");
     grade = keyboard.nextDouble();
     sum = sum + grade;
   }
   average = sum/5.0;
   System.out.println("Average grade: " + average);
  
  //Part A While - Loop - this is a pretest
  int num1 = 50; //starting value to test
  while(num1 >= 20) // test to see if enter the loop 
  {
  
      //create the code to print only the odd numbers
      // a number % 2 == 0 ---------- even number
      // a number % 2 == 1 ---------- odd number
      if (num1 % 2 == 1)
      
      {
            System.out.println("num1: " + num1);
      
      }
      num1 = num1 - 1; // increment num by num1
   } //end of part a
   
   //ask the user for their 5 grades - print out grades and the average
   double average1;
   double grade1;
   double sum2 = 0;
   int count = 0;
   
   System.out.println("Enter your first grade: ");
   grade1 = keyboard.nextDouble();
   
   while (count < 5) //we will loop 5 times to get the grades
    {
      sum2 = sum2 + grade1;
      count  = count + 1;
      System.out.println("grade: " + grade1);
      System.out.println("Enter another grade: ");
      grade1 = keyboard.nextDouble();
    }
    average1 = sum2/count;
    System.out.println("average: " + average1);
    
      
   } // end main method 
  } //ending of program