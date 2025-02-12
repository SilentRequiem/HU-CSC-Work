/*
Name: Michael Amoo
Instructor: Dr B.
Program: Basic Arrays
Date: 2/12/25 3:26 PM
I, Michael Amoo, pledge to follow with class header and main method header.
*/
import java.util.Scanner;

public class AmooM_Lab5 {
   public static void main(String[] args) {
   
   Scanner keyboard = new Scanner(System.in); //keyboard set for scanner
   
//Part A - Define Integer Arrays and Read Input from user
   final int size = 5;
   
   int[] numbers = new int[size]; //an array made with the "size" of size being 5. The syntax is almost the same as other java initalizations.
   
   
   
   for (int i = 0; i < numbers.length; i++)
   {
   System.out.print("Enter " + (size - i) + " number(s) into the array: ");
   
   numbers[i] = keyboard.nextInt();

   }
   
   
   //Printing for a regular loop
    System.out.println("\n\nRegular loop");
   
   
   for (int i = 0; i < numbers.length; i++) 
   {
   
    System.out.print(numbers[i] + ", ");
   
   }
   
   System.out.println("\n\nEnhanced loop");
   
   
   //Printing enhanced loop
   
   for (int tmp : numbers) //Remember to add the data type
   {
      
   System.out.print(tmp + ", "); //Remember that numbers[i] = tmp, so you don't need to do numbers[tmp] (it will i++ till it goes beyond the length
   
   }
 
//Part B - Calculate values from Array
int sum = 0; //Make it start at 0
int min = numbers[0]; //Start at the first number in the array
int max = numbers[0]; //Same for this
double average;


   for (int i = 0; i < numbers.length; i++)
   {
      sum += numbers[i]; //add current number to the sum
      
      if (numbers[i] < min) //if current number is less than the current minimum, make it that
         min = numbers[i];
         
      if (numbers[i] > max) //if current number is greater than the current maximum, make it that
         max = numbers[i]; 
   }
   
   average = (double) sum / size; //Make sure it's casted to be a double since they are both ints
   
   System.out.println("");
   System.out.println("\nResults using regular for loop");
   //Results using regular for loop
   System.out.println("Stats: sum = " + sum 
                                      + "\n\t\t average = " + average 
                                      + "\n\t\t min = " + min
                                      + "\n\t\t max = " + max);
   

   sum = 0; min = numbers[0]; max = numbers[0];  //Another way to do statements!
                                      
   for (int tmp : numbers)
   {
      sum += tmp; //add current number to the sum
      
      if (tmp < min) //if current number is less than the current minimum, make it that
         min = tmp;
         
      if (tmp > max) //if current number is greater than the current maximum, make it that
         max = tmp; 
   }
   
   //Results using enhanced for loop
   System.out.println("\nResults using enhanced for loop");
   System.out.println("Stats: sum = " + sum 
                                      + "\n\t\t average = " + average 
                                      + "\n\t\t min = " + min
                                      + "\n\t\t max = " + max);
   
   

//Part C - Find Odd and Even numbers array

   int cntOdd = 0, cntEven = 0, cnt25Higher = 0; //Another way to initalize!
   
   
   for (int i = 0; i < numbers.length; i++)
   {
      if (numbers[i] % 2 == 1)  //Even is 0 while Odd is 1;
         cntOdd++;
         
      else
         cntEven++;
         
      if (numbers[i] >= 25)
         cnt25Higher++;
      
   }
   System.out.println("\nResults using regular for loop");
   System.out.println("My array has " + numbers.length + " integers: "
                        + "\n\t" + cntOdd + " integers are odd "
                        + "\n\t" + cntEven + " integers are even "
                        + "\n\t" + cnt25Higher + " have at least 25 or higher ");
   
   
   cntOdd = 0; cntEven = 0; cnt25Higher = 0;
  
  for (int tmp : numbers)
  {
     if (tmp % 2 == 1)  //Even is 0 while Odd is 1;
         cntOdd++;
         
      else
         cntEven++;
         
      if (tmp >= 25)
         cnt25Higher++;
  } //Enhanced is faster and simpler but also it's more limited
  
  System.out.println("\nResults using enhanced for loop");
   System.out.println("My array has " + numbers.length + " integers: "
                        + "\n\t" + cntOdd + " integers are odd "
                        + "\n\t" + cntEven + " integers are even "
                        + "\n\t" + cnt25Higher + " have at least 25 or higher ");
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   }
   
   
 }