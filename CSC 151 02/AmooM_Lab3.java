//Name: Michael Amoo
//Date: 9/19/23
//Phone: (757)-776-2017
//Section: 151 63
//Instructor: Dr. B
//Description: Lab 3 - Review User Input, Calculation, Basic String Manipulation

import java.util.Scanner;
public class AmooM_Lab3
{
   public static void main(String[] args)
   {
   
   //Part A - Read Input from Keyboard Using Scanner correctly
   double d1;
   double d2;
   double d3;
   double sum;
   double average;
   
   Scanner keyboard = new Scanner(System.in);
   
   System.out.print("Enter decimal #1: ");
   d1 = keyboard.nextDouble();
   System.out.print("Enter decimal #2: ");
   d2 = keyboard.nextDouble();
   System.out.print("Enter decimal #3: ");
   d3 = keyboard.nextDouble();
   
   sum = d1 + d2 + d3;
   average = sum / 3;
   
   System.out.println("You entered these 3 numbers: " + d1 + ", " + d2 + ", and " + d3 + "."
                     + "\n\tSum of these values is " + sum + "."
                     + "\n\tAverage of these values is " + average + ".");
  
  //Part B - Finding quotient and remainder based on user input                 
   int dividend;
   int divisor;
   int quotient;
   int remainder;
   
   System.out.print("\nEnter your dividend: ");
   dividend = keyboard.nextInt();
   System.out.print("Enter your divisor: ");
   divisor = keyboard.nextInt();
   
   quotient = dividend / divisor;
   remainder = dividend % divisor;
   
   System.out.println("\nWhen " + dividend + " is divided by " + divisor + ",\n\t"
                     + "the quotient is " + quotient + " and\n\t"
                     + "the remainder is " + remainder + ".");
   
   //Part C - Finding a missing side of a right triangle and a mystery value
   double a;
   double b;
   double c;
   double mystery;
   
   System.out.print("\nEnter side a: ");
   a = keyboard.nextDouble();
   System.out.print("Enter side b: ");
   b = keyboard.nextDouble();
   
   c = Math.sqrt( (Math.pow(a,2) + Math.pow(b,2)) );
   System.out.println("\nIf this right triangle has one " + a + " and another side " + b + ",\n\t"
                    + "the side opposite the right angle will be " + c + ".");
   
   mystery = ( ( (Math.sqrt( (2 * a) + 13) / 5 ) + ( ((5 * Math.pow(b,5) - 9) / 12) ) ) );
   
   System.out.println("\nMystery value is " + mystery + ".");
   
   //Part D - String and String manipulation
   String myQuote;
   String mqUpper;
   int size;
   char firstChar;
   
   System.out.print("\nType your favorite quote: ");
   keyboard.nextLine(); 
   myQuote = keyboard.nextLine();
   mqUpper = myQuote.toUpperCase();
   size = myQuote.length();
   firstChar = myQuote.charAt(0);
   
   
   System.out.println("\nMy favorite quote in all uppercase: " + mqUpper
                     + "\n\tThis quote contains " + size + " characters in it\n"
                     + "\tand the first character is " + firstChar + ".");
   /*---------------------------------------------------------------------------------------------------------------
                                                                             ##        #                                              
                                    ##    #  ####     #####   ####  #    # #    #  ####  
                                    # #   # #    #    #    # #    # ##   # #    # #      
                                    #  #  # #    #    #####  #    # # #  # #    #  ####  
                                    #   # # #    #    #    # #    # #  # # #    #      # 
                                    #    ## #    #    #    # #    # #   ## #    # #    # 
                                    #     #  ####     #####   ####  #    #  ####   ####  
   
   ----------------------------------------------------------------------------------------------------------------*/
   }
}