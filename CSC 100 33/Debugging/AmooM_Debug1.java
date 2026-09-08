/////////////////////////////////////////////////////////////
// Comments at the beginining
//Author: Michael Amoo
//Instructor: Dr. Muhammad and Dr. Boonthum-Denecke
//Class: CSC-100-33
//Date: June 27, 2023
//Description: Debugging Assignment 1
//             You will compile and modify this code to make it work
//             Please make sure to replace your information 
////////////////////////////////////////////////////////////

//**************************************************************
// Instruction:  For everything that you fix, you will need 
//               to put in a comment ABOVE or END of the line that you fixed
//**************************************************************

//================================ NO ERROR ABOVE THIS LINE =============================

// class header

public class AmooM_Debug1   // please make sure that you replace LASTNAME with your own (Did It)
{
   // main method header
   /*
   static and void must be switched
   change "Main (String[] args)" to main(String[] args)
   add 2 "}" at the end to close the code
   */
   public static void main(String[] args)    
   {
   
      //Basic Print Statements
      /*
       Capitalize the "S" in system.out.println("YOUR FAVORITE MOVIE")
       Replace the "1" to a "l" in System.out.print1n("YOUR NAME"); // replace information 
       Delete one "s" at Syystem inSysstem.out.println("YOUR MAJOR"); // replace information
       Add "//" before "replace information" in System.out.println("YOUR FAVORITE MOVIE")  replace information
       Add ";" after the ")" at System.out.println("YOUR FAVORITE MOVIE")
      */
            
      System.out.println("Michael Amoo"); // replace information 
      System.out.println("Computer Science"); // replace information
      System.out.println("One Piece: Red"); // replace information
      
      // Define String Variables
      /*
      Change "STRING" and "string" to "String"
      */
      String firstName; 
      String lastName;
      String major;

      // Assign value to String and print
      /*
      Change ('') to (")
      Add ; at the end of "YOUR MAJOR"
      Change FirstName, lastname  and Major to firstName. lastName and major
      */      
      firstName = "Michael"; // replace information 
      lastName = "Amoo"; // replace information 
      major = "Computer Science";  // replace information

      // print out, please make sure that everything look nice and spacing for readability
      /*
      Before: System.out.println("Hello, my name is" + firstName + LastName + ", and my major is" + major + ".");
      After:  System.out.println("Hello, my name is " + firstName + " " + lastName + " , and my major is" + " " + major + ".");
      */
      System.out.println("Hello, my name is " + firstName + " " + lastName + " , and my major is" + " " + major + ".");
      
      // Define Integers
      //Make 7.0 to 7
      int num1;
      int num2;
      int sum;

      num1 = 25;
      num2 = 7;
      
      // Calculations
      /*
      Add a ; at the end of "int sum = num1 + num2"
      Take out int
      */
      sum = num1 + num2;
      
      // print out each number and then the sum result
      //Remove the extra spaces
      System.out.println("The sum of num1 and " + num2 +" is " + sum);
      
      // Define Doubles
      double d1, d2, d3, d4, d5;
      
      // Assign values
      /*
      Add a ; at the end of "d3 = 2.4"
      */

      d1 = 1.2;
      d2 = 6;
      d3 = 2.4;
      d4 = 9.8;
      d5 = 6.1;
      
      // Calculation
      //Add d3 in equation
      double dsum = d1 + d2 + d3 + d4 + d5;   // add all number together
      double average = dsum/5;
      
      // Print out - make sure that the spacing between information for readability
      /*
      Add a "t" after the "ou" in "System.ou.println"
      Add space between d2 and +
      Add a (") after (", )
      Add + before d3
      Add space between d4 and both the +'s
      Add space between + and d5
     */
     
     /*
     Add a space separating + and dsum to make "+ dsum"
     Add a ";" at the end of System.out.print1n("Sum of these values is" +dsum)
     Add a space separating + and average to make "+ average"
     Change dl to d1
     Change the 1n System.out.print1n("Sum of these values is" + dsum); to a "ln"
     Change the "s" in system.out.println("Average of these values is" + average); to an Uppercase "s"
     Add a space after "is" in ("Average of these values is" + average);
     Add a space after "is" in ("Sum of these values is " + dsum);
     Add a space to separtate +d5 to make (+ d5) 


     */
      System.out.println("Values are " + d1 + ", " + d2 + ", " + d3 + ", " + d4 + ", and " + d5);
      System.out.println("Sum of these values is " + dsum);
      System.out.println("Average of these values is " + average);
      
      //Define and Initialize character and boolean variables
      /*
      Change myflag to myFlag at System.out.println("myFlag is " + myflag)
      Add a ";" at the end of System.out.println("myFlag is " + myflag)
      Change "K" to 'K'
      Change Boolean to boolean
      Change FALSE to false
      */
      char myChar = 'K'; 
      boolean myFlag = false;
      System.out.println("myChar is mychar");
      System.out.println("myFlag is " + myFlag);
      
      
   } // end of main method
 }// end of class