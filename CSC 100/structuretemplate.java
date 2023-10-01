/*
Author: [name]
Instructor: Dr. B & Dr. Muhammad
Date": 
Program Name:
Description:
*/ 


//class header
public class //title
{ //Start of program
   // main method header
   public static void main(String args[])
   { //start main method 

      
   } // end main method 

} //ending of program


//Scanner input template 
import java.util.Scanner; 
Scanner keyboard = new Scanner(System.in); //Create scanner object

String firstName = keyboard.nextLine();
// String variable = keyboard.nextVar();
keyboard.nextLine(); //clear buffer, needed everytime you go from an int or double to a string, should always be nexLine, DONT FORGEET PARENTHESES

//String manipulation 
For # of characters: int string.length();
For Upper Case: String upper = string.toUpperCase();
For lower case: string lower = string.toLowerCase();
For the xth character: char firstLetter = string.charAt(0); //where 0 is the first character 
For last letter : char lastLetter = sport.charAt(sport.length()-1);

//math commands 
Math.pow(x, y)
Math.sqrt(x)

      /* 
      OOP Order
      Negatives first - Right to left 
       * , /, and % - Left to right 
       + and -, Left  to right
       Math.pow and Math.sqrt last 
       In a division problem, take care of the numerator, then denominator , and then the division
      */

// conditioning statements
'if'statement: decides whether a section of code executes or not; uses a boolean to decide whether the next statement or block of statements executes
In most cases the boolean expression uses expressions like:
    < less than
    > Greater than
    == equal to (note the two equal signs)
    >= greater than or equal to 
    <= less than or equal to 
    != not equal to
    && range (Example: (average >= 80 && average <= 89 ))

    
'if-else' statements- adds the ability to conditionally execute code when the if statement is false 

if (expression)
System.out.println(statement);

else 
System.out.print(statement);

'if-else-if' statements- basically lets you put multuple if/else statements into one 
Example:

           
          // if-else-if 
          //check equals first, and then which one ever one is larger 
          System.out.println("\nif-else-if");
          if (num1 == num2)
            System.out.println(num1 + " is equal to " + num2);
            
          else if (num1 > num2) //second if statement
            System.out.println(num1 + " is larger than " + num2);
            
          else //if neither of the above statements are true it goes to this one  
            System.out.println(num2 + " is larger than " + num1);
          
          //calculation - based on num1 and num2 that we have 
          //only do this if num1 and num2 are not the same
            if (num1 != num2)
            {            
            //if num1 is larger then do the following 
               if (num1 > num2)
               { //these brackets contain the 'if' statement
            //      create a int diff variable, use num1 - num2 
            int diff = num1 - num2;                  
            //      create a double result 1, diff / num2
            double result1 = (double) diff / num2;            
            //      then print the result both diff and result1
               System.out.println("Diff is " + diff + "\n result1 is " + result1);
               }
            
          
          //if num2 is larger...
               else 
               {
          //      create an int diff variable , use num2 - num1 
             int diff = num2 - num1;
          //      create a double result2, diff / num1 
            double result2 = diff / num1;
          //      then print the result both diff and result2
            System.out.println("Diff is " + diff + "\nresult2 is " + result2);
               }   
            
            }   
