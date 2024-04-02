/* 
Name:  Michael Amoo
Section:   S1 / April 2, 2024
Program: Exception
 “I, Michael Amoo, pledge to follow the Honor Code in taking my Lab 11.”
*/
import java.util.Scanner;
import java.util.*;
public class AmooM_Lab11
{
   public static void main(String [] args) 
   {  
      
      // ** Given source code **// 
      // ** make sure to put comments in additional section / update **
      Scanner keyboard = new Scanner ( System.in );
      try {
      
      System.out.print("Please enter 2 numbers: ");
      int num1 = keyboard.nextInt( );
      int num2 = keyboard.nextInt( );
      System.out.println("Result is " + num1 / num2);
      keyboard.nextLine( ); // clear buffer
   
      System.out.print("Enter a code: ");
      String code = keyboard.nextLine( );
      char   zone = code.charAt(5);
      for (int i = 0 ; i < code.length( ) ;  i++)
         System.out.println(code.charAt(i) );
   
   //Part B - Write Additional Code and Handle Exception
      
      System.out.print("\nEnter an input: ");
      double num3 = keyboard.nextDouble();

      
      
      int[] myScores = {12,15,20,13,9};
      
      for (int tmp : myScores) {
      
      System.out.print(tmp + ", ");
      
      }
      
      }
            
      catch (InputMismatchException e)
      {
      System.out.println("value should be numbers");
      }
      
      catch (NumberFormatException e)
      {
      System.out.println("value should be numbers");
      }
      
      catch (StringIndexOutOfBoundsException e)
      {
      System.out.println("the code was not long enough to get character at index 5");
      System.out.println(e.getMessage());
      }
      
     
      
      catch (ArrayIndexOutOfBoundsException e)
      {
      System.out.println("index should be within range");
      System.out.println(e.getMessage());
      }
      
      
   } // end main
} // end program
// ** update by Michael Amoo