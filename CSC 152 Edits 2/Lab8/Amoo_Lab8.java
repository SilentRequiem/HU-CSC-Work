/*
Name: Michael Amoo
Instructor: Dr B.
Program: Lab 8 Exception
Date: 3/26/25
Description: Exception Handling
File: Driver
Class: CSC 152 02 / Lab Section 3
I, Michael Amoo, pledge to follow the Honor Code in completing my Lab 8.
*/

import java.util.Scanner;
import java.util.*;

public class Amoo_Lab8
{
   public static void main(String [] args) 
   {
   
//Part A
   try {
   
      // ** Given source code **// 
      // ** make sure to put comments in additional section / update **
      Scanner  keyboard = new Scanner ( System.in );
      System.out.print("Please enter 2 numbers: ");
      int num1 = keyboard.nextInt( );
      int num2 = keyboard.nextInt( );
      System.out.println("Result is " + num1 / num2);
      keyboard.nextLine( ); // clear buffer
   
      System.out.print("Enter a code: ");
      String code = keyboard.nextLine( );
      char   zone = code.charAt(5);
      for (int i = 0 ; i <  code.length( ) ;  i++) //fixed to be < code.length not <=
         System.out.println(code.charAt(i) );
     
   //Part B        
     System.out.println("Enter a double: ");
     double num3 = keyboard.nextDouble();
     int myScores[] = {12, 15, 20, 13, 9};
     
     for (int tmp : myScores) {
     
     System.out.print(tmp + ", ");
     
     }  
     
     System.out.println("\nWhat slot do you want to show from the array?");
     int slot = keyboard.nextInt();
     keyboard.nextLine();
     slot = myScores[slot];
     System.out.println(slot);
     
     System.out.println("Give me a word longer than 4 charcters");
     
     String word = keyboard.nextLine();
     int check = word.charAt(3);
     
    System.out.println("Divide 2 numbers - don't divide by zero");
    int top = keyboard.nextInt();
    int bottom = keyboard.nextInt();
    
    int answer = top / bottom;
     
     
     
     
     
     
   } //end of try
   
   
   //Catches
    catch (InputMismatchException e)
    {
      System.out.println("value should be numbers.");
      System.out.println("Message: " + e.getMessage());
    }
    
    catch (StringIndexOutOfBoundsException e)
    {
      System.out.println("the code was not long enough to get character at index 5.");
      System.out.println("Message: " + e.getMessage());
    }
    
    catch (ArrayIndexOutOfBoundsException e) 
    {
      System.out.println("index should be within range.");
      System.out.println("Message: " + e.getMessage());   
    }
    
    catch (ArithmeticException e) 
    {
      System.out.println("Not mathmatical, check it out.");
      System.out.println("Message: " + e.getMessage());   
    }
    
    
    


     
     
     
  
   
   } // end main
} // end program
// ** 3/26/25 : update by Michael Amoo