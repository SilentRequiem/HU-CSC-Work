/*
Author: Michael Amoo
Instructor: Dr.B
Program: AmooM_Lab4
Date: June 29, 2023
Description: Clear Buffer and Data Conversion
*/

//Import Statement
import java.util.Scanner;

public class AmooM_Lab4
{ //start class
   public static void main(String[] args)
   { // start main method
      
      // create Scanner object
      Scanner keyboard = new Scanner(System.in);
      //read 1 integer and 1 String
      System.out.print("Enter your fav # ");
      int favNum = keyboard.nextInt();
      keyboard.nextLine(); //clear buffer
      System.out.print("Enter your fav song: ");
      String favSong = keyboard.nextLine();
      System.out.println("\nYour fav # is " + favNum
                        + " \n and your fav song is "
                        + favSong);
      
      double half = (double) favNum/2;
      System.out.print("\nHalf is " + half);
      
      // power of two of favNum
      int powerOfTwo = (int) Math.pow(favNum, 2);
      System.out.println("\nPower of Two is " + powerOfTwo);
      
   } // end main method
  } // end class