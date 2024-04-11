/* 
Name: Michael Amoo
Section: 152 S1
Date: 4/11/24
Program: Review Exception - add try-catch block invididually
 “I, Michael Amoo, pledge to follow the Honor Code in taking my Lab 12.”
*/
import java.util.*;

public class AmooM_Lab12
{
   public static void main(String [] args) 
   {
         int num1 = 0;
         int num2 = 0;
         // ** Given source code -- you will add try-catch block for each section that could potentially cause exception**// 
         Scanner  keyboard = new Scanner ( System.in );
         try {
         System.out.print("Please enter 2 numbers: "); 
         num1 = keyboard.nextInt( );
         num2 = keyboard.nextInt( );
         }
         
         catch (InputMismatchException e)
         {
         System.out.println("value should be numbers");
         }
         
         try {
         System.out.println("Result is " + num1 / num2);
         }
         
         catch (ArithmeticException e)
         {
         System.out.println("Num2 zero error");
         }
         keyboard.nextLine( ); // clear buffer
         
         try {
         System.out.print("Enter a code: ");
         String code = keyboard.nextLine( );
         char   zone = code.charAt(5);
         for (int i = 0 ; i <  code.length( ) ;  i++)
            System.out.println(code.charAt(i) );
         }
            
         catch (StringIndexOutOfBoundsException e)
         {
         System.out.println("the code was not long enough to get character at index 5");
         System.out.println(e.getMessage());
         } 
         
         System.out.print("Enter a double num variable : " );
         try {
         double num3 = keyboard.nextDouble();
         }
         
         catch (InputMismatchException e)
         {
         System.out.println("value should be numbers");
         }
           
         // Array 
         int[] myScores = {12,15,20,13,9};
         
         for(int i : myScores){
            System.out.print(i + ", ");
         }
         // Read input and print out information    
        
        
        System.out.print("\nEnter an index that you want to know the score: ");
        
        try {
        int index = keyboard.nextInt();
        System.out.println("The score at index " + index + " is " + myScores[index]);
        }
        
        catch (InputMismatchException e)
        {
        System.out.println("value should be numbers");
        }
         
        catch (ArrayIndexOutOfBoundsException e)
        {
        System.out.println("index should be within range");
        System.out.println(e.getMessage());
        }  
        
       
   } // end main
} // end program
// ** update by Michael Amoo