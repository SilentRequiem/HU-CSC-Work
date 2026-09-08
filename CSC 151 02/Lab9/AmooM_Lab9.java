/**
Name: Michael Amoo
Phone: 757-776-2017
Instructor: Dr.B
Section: CSC 151 63 F23
Date: 11/7/23
Desc: Ch.5 While Loops, Sentinel Value and Running Total, and Nested-Loop
*/
import java.util.Scanner;
import java.util.Random;
public class AmooM_Lab9
{  public static void main(String[] args)
   {
   Scanner keyboard = new Scanner(System.in);
   Random Random = new Random();

//Part A - While Loop - Integer Sentinel value and Running Total
   int num = 0;   
   int countOdd = 0;
   int countEven = 0;
   int sumOdd = 0;
   int sumEven = 0;
   int runs = 0;
   System.out.print("Please enter an integer [-1 to exit]: ");
   num = keyboard.nextInt();
   keyboard.nextLine();
   
   while (num != -1)
      {
         if (num % 2 == 0)
         {
         
            System.out.println(num + " is even");
            sumEven = num + sumEven;
            countEven += 1;
            
         }
         
         else
         {   
            System.out.println(num + " is odd");
            sumOdd = num + sumOdd;
            countOdd += 1;
         }
         System.out.print("Please enter an integer [-1 to exit]: ");
         num = keyboard.nextInt();
         keyboard.nextLine(); 
         runs += 1; 
      }   
      
      System.out.println("\nYou enter " + runs + " numbers: ");
      System.out.println(countOdd + " odd intergers; a total of " + sumOdd);
      System.out.println(countEven + " even intergers; a total of " + sumEven);
      
//Part B - While Loop - String Sentinel value
   
   String message;
   String stopper = "STOP";      
   int count = 0;
   runs = 0;
   System.out.print("\nType anything besides stop [to stop just enter stop in any case]: ");
   message = keyboard.nextLine();   
      
   while (!(message.equalsIgnoreCase(stopper)))
   //Self Note: Above means while following message doesn't equal stop in any form, proceed with the following statements
      {   
         if (message.length() > 10)
            System.out.println("Long message");
         
         else
            System.out.println("Short message");
         
         runs += 1;
         System.out.print("\nType anything besides stop [to stop just enter stop in any case]: ");
         message = keyboard.nextLine(); 
      }
      
      System.out.println("\nYou entered " + runs + " messages");
      
//Part C - For-Loops and Input Validation     
       
      System.out.print("\nWhat do you want to use for pattern? ");
      char pattern = keyboard.nextLine().charAt(0);
      
      System.out.print("How many rows to print? ");
      int rows = keyboard.nextInt();
      
      System.out.print("How many columns? ");
      int columns = keyboard.nextInt();
      
      System.out.println("\nPrinting " + pattern + " for " + rows + " rows and " + columns + " columns: ");
      System.out.println("\n");
      
      for (int r = 0; r < rows; r++)
    {
      for (int c = 0; c < columns; c++)
      {
       System.out.print(pattern);
      }
       System.out.println();
    }

//Part D - For-Loops and Input Validation      
      System.out.println("\n***  Enter Limit ***");
      System.out.print("Please enter an integer number for limit (5-10): ");
      int limit = keyboard.nextInt();
      
      while (limit < 5 || limit > 10)
      {
      System.out.println("Value is outside of range");
      System.out.print("Please enter an integer number for limit (5-10): ");
      limit = keyboard.nextInt();
      }
      
      
       System.out.println("\n*** Enter Power ***");
      System.out.print("Please enter an power greater than 2: ");
      int power = keyboard.nextInt();
      
      while (power < 2)
      {
      System.out.println("Reenter Power");
      System.out.print("Please enter an power greater than 2: ");
      power = keyboard.nextInt();
      }
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
   }
}