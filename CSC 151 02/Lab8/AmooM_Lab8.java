/**
Name: Michael Amoo
Phone: 757-776-2017
Instructor: Dr.B
Section: CSC 151 63 F23
Date: 10/31/23
Desc: Ch.5 While Loops, Do-While, and For-Loops
*/
import java.util.Scanner;
import java.util.Random;
public class AmooM_Lab8
{  public static void main(String[] args)
   {
   Scanner keyboard = new Scanner(System.in);
   Random Random = new Random();

//Part A While-Loop: Data Validation
   System.out.println("While-Loop: Data Validation");
   
   int limit;
   
   System.out.print("Please enter an interger for limit (5 - 10): ");
   limit = keyboard.nextInt();
   
   while (limit < 5 || limit > 10)
   {
   System.out.print("Invalid, speed should be between 5 and 10, please reenter: ");
   limit = keyboard.nextInt();
   }
   System.out.println("\n\t You enter " + limit + " for limit.");
   
//Part B For-Loop: Calculation and Print   
  System.out.println("\nFor-Loop - square, cude, square root - limit from part A"); 
  int number;
  System.out.println("Number Square  Cube  Square Root"); 
  for (number = 1; number <= limit; number++)
  System.out.println(number + "\t\t" + Math.pow(number,2) 
                            + "\t\t" + Math.pow(number,3)
                            + "\t\t" + Math.sqrt(number));
   
//Part C Do-While-Loop Statement: Rolling 2 dices to get the sum of 10   
   System.out.println("\nDo-While-Loop - Rolling Dices"); 
   
   int dice1;
   int dice2;
   int sum;
   
      
   do 
    {
   dice1 = Random.nextInt(1,6);   
   dice2 = Random.nextInt(1,6);
   sum = dice1 + dice2;
   
   System.out.println("Dice are " + dice1 + " " + dice2 + " (sum = " + sum + ")");
   
    } while (sum != 10);
    System.out.println("\n\t Ten Rolled");  
   
   
   
   
//Part D Basic Loops to print  
   System.out.println("\nBasic Loops to print");    
   
   /*
   Write each in 3 ways, (i) while, (ii) using do-while, and (iii) using for-loop
   1. All intergers from 0 to 20
   2. All evevn intergers from 0 to 20
   3. All intergets divisible by 7, from 100 down to 0
   Update: Just do one do to Dr.B's agreement
   */
   
   {
   sum = 0;
   for (int ii = 1; ii <=20; ii++)
      
      { 
         sum = sum +1;
         if (ii % 2 == 0)
         System.out.println(sum);
      }      
         
   } 
   
   
//Part E Basic Nested for Loops - Printing Time  
   System.out.println("\nFor-Loop: Calculation and Print");    
   
   // Simulate the clock.
    for (int hours = 1; hours <= 12; hours++)
    {
      for (int minutes = 0; minutes <= 59; minutes++)
      {
       for (int seconds = 0; seconds <= 59; seconds++)
       {
         System.out.printf("%02d:%02d:%02d\n", hours, minutes, seconds);
       }
      }
    }
   
   
   
   
   
   
   
   
   
   
   }
}