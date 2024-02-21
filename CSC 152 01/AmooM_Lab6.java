//Name: Michael Amoo
//Phone: (757)-776-2017
//Section: 152 S1 / 2/20/24, 11:03 AM
//Instructor: Dr. B
//Description: Basic Arrays
//“I, Michael Kwabena Amoo, pledge to follow the Honor Code in completing my Lab 6.”
import java.util.Scanner;
public class AmooM_Lab6
{
public static void main(String args[])
   {
   Scanner keyboard = new Scanner(System.in);
   
   
  //Part A - interger array
  int[] numbersMKA = new int[7];
  
  // regular for-loop to read input
  for (int  i=0; i < numbersMKA.length; i++)
  {
      System.out.print("Enter an integer: ");
      numbersMKA[i] = keyboard.nextInt();
  
  }
  
  System.out.println("\nPrinting Array Part A:");
  
  // use enhanced-for loop to print (doesn't matter what you intizlize it to)
  for (int tmp : numbersMKA)
      System.out.print( tmp + ", ");
     System.out.println(" ");    
         
   System.out.println("\nPrinting Array Part B:");
  
       //call printArray
       printArray(numbersMKA);
       
     //Part C -- calculation
     //Version 1 - using a regular for loop
     int sum = 0;
     int highest = numbersMKA[0];//take first element
     int lowest = numbersMKA[0];//take first element
     
     for (int i = 0; i < numbersMKA.length; i++)
     {    
         sum += numbersMKA[i]; // add current value to sum
         if (numbersMKA[i] > highest) //check highest
            highest = numbersMKA[i];
         if (numbersMKA[i] < lowest) //check lowest
            lowest = numbersMKA[i];
      } //end of loop
      double average = (double) sum / numbersMKA.length;
      //printout 
         System.out.println("\n\nUsing regular for loop " +
            "\n\tsum is " + sum +
            "\n\thighest is " + highest +
            "\n\tlowest is " + lowest +
            "\n\taverage is " + average + "\n");
           
      //Version 2
      sum = 0; //re 0 initialize 
      highest = numbersMKA[0]; //re - initialize
      lowest = numbersMKA[0]; //re - initialize
      for (int tmp : numbersMKA)
      {
         sum += tmp; //running total
         
         if (tmp > highest) //check highest
            highest = tmp;
         if (tmp < lowest) //check lowest
            lowest = tmp;
       } // end of enhanced-for-loop
       average = (double) sum / numbersMKA.length;
       // printout
       System.out.println("\n\nUsing enhanced for loop " +
            "\n\tsum is " + sum +
            "\n\thighest is " + highest +
            "\n\tlowest is " + lowest +
            "\n\taverage is " + average + "\n");
         
       //Part D - Find odd and even  
         int cntOdd = 0;
         int cntEven = 0;
         int cnt25Higher = 0;
         
         
        for (int tmp : numbersMKA)
      {
         sum += tmp; //running total
         
         if (tmp % 2 == 0) //even
            cntOdd++;
         if (tmp % 2 == 0) //odd
            cntEven++;
         if (tmp >= 25)
         cnt25Higher++;
            
       } // end of enhanced-for-loop
       
       System.out.println("\n\nMy array has " + numbersMKA.length + " intergers: " +
            "\n\t " + cntOdd + " integers are odd " +
            "\n\t " + cntEven + " integers are even " +
            "\n\t " + cnt25Higher + " have are least 25 higher");
            
         
         
      } // End main method
      //printArray method
      
      public static void printArray(int[] values)
      { //regular for loop
         for (int i = 0; i < values.length; i++)
            System.out.print( values[i] + "\t");
           
      
      }
     
}