//Michael Amoo
//Dr. B & Dr. M
//CSC 100
//06.26.23
//CSC 100 In Class Lab Exercise 1 - Java Program, Outline, Print, Variables and Arithmetic Operators

//Amoo_M_ICLab1.java

public class Amoo_M_ICLab1
{
   public static void main(String args[])
   {
   
   //here is where your code/statment will go
 
 
  // Part A - Variables and String Literals
  
  // Variables
  String firstName; 
  String lastName;
  String major;
  String hometown;
  String state;
  
  firstName = "Michael";
  lastName = "Amoo";
  major = "Computer Science (B.S)";
  hometown = "Suffolk";
  state = "Virginia";
  
   System.out.println("CSC 100 CSC Pre-College Summer 2023");
   System.out.println("Hello, my is " + firstName + " " + lastName + ".");
   System.out.println("I am from " + hometown + ", " + state + ".");
   System.out.println("I am attending Hampton University and majoring in " + major + ".");
   
   // Part B - Interger and Literals
   
   int num1 = 396;
   int num2 = 6;
   int num3 = 30;
   int sum;
   int average; 
   sum = num1 + num2 + num3;
   average = sum/3;
   
   System.out.println("Integers are " + num1 + ", " + num2 + ", and" + " " + num3 + ".");
   System.out.println("         Sum of these integers is " + sum + ".");
   System.out.println("         Average of these integers is " + average + ".");
   
   //Part C - Primitive Data Types
   char myChar;
   char myLetter;
   boolean flag;
   flag = false;
   myChar = 'M';
   myLetter = 65;
   
   System.out.println("This flag is " + flag + ".");
   System.out.println("The first character of my first name is " + myChar + ".");
   System.out.println("The first letter of my last name is " + myLetter + ".");
   
   //Part D - Arithmetic Operators 1
   double SALE_TAX_RATE;
   double total;
   double cost;
   double tax;
   SALE_TAX_RATE = 7.5;
   cost = 400.00;
   tax = cost * SALE_TAX_RATE;
   total = cost + tax;
   
   System.out.println("Basic Tax Calculation:");
   System.out.println("       The sales tax on " + cost + ", with " + SALE_TAX_RATE + "% is " + tax + ".");
   System.out.println("       That make the overall total cost to " + total + ".");
   
   //Part E - Arithmetic Operators 2
   int dividend;   
   int divisor;
   int quotient;
   int remainder;
   
   dividend = 15;
   divisor = 4;
   quotient = dividend/divisor;
   remainder = dividend%divisor;
   
   System.out.println("When "+ dividend + " is divided by " + divisor + ",");
   System.out.println("     the quotient is " + quotient + " and");
   System.out.println("     the remainder is " + remainder + ".");
   


   
   
   

   }  // end main method
   }  // end java program
   
 