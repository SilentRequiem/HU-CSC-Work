/*
Name: Michael Amoo
Instructor: Dr B.
Program:Review Writing a Java Program with User Input from Keyboard, basic calculation, basic String manipulation, and basic conditioning statements
Date: 1/15/25
*/


import java.util.Scanner;
public class AmooM_Lab1
{
   public static void main(String args[])
   {
   //Part A
   Scanner keyboard = new Scanner(System.in);
   System.out.println("CSC 152 Lab Spring 2025 - 1/15/25\n"); 
   
   //Part B
   System.out.println("Please enter firstname: ");
   String firstName = keyboard.nextLine();
   System.out.println("Please enter lastname: ");
   String lastName = keyboard.nextLine();
   System.out.println("Please enter age: ");
   int age = keyboard.nextInt();
   System.out.println("Please enter major: ");
   keyboard.nextLine();
   String major = keyboard.nextLine();
   String fullName = firstName + " " + lastName;
  
  //Other variables
    int totalChars = firstName.length() + lastName.length();
    String Ufull = fullName.toUpperCase();
    String lastUpper = lastName.toUpperCase();
    char Lastchar = lastUpper.charAt(lastUpper.length() - 1);
    
   //Print
   System.out.println("Hello, my name is " + firstName + " " + lastName + ". I am " + age + " years old and my major is " + major + ".");
   System.out.println("My full name contain " + totalChars + " number of characters.");
   System.out.println("My full name contain in uppercase is " + Ufull + ".");
   System.out.println("The last character of my last name in upper case is " + lastUpper + ".");
   
   //Part C
   System.out.println("\nPlease enter 2 intergers: ");
   int num1 = keyboard.nextInt();
   int num2 = keyboard.nextInt();
   int sum = num1 + num2;
   int average = sum / 2;
   
   System.out.println("\nThe sum of " + num1 + " and " + num2 + " is " + sum + ".");
   System.out.println("The average of " + num1 + " and " + num2 + " is " + average + ".");
   
   //Part D
   System.out.println("\nPlease enter 5 numbers: ");
   double d1 = keyboard.nextDouble();
   double d2 = keyboard.nextDouble();   
   double d3 = keyboard.nextDouble();   
   double d4 = keyboard.nextDouble();   
   double d5 = keyboard.nextDouble();
   double sumDouble = d1 + d2 + d3 + d4 + d5;
   double averageDouble = sumDouble / 5;
   keyboard.nextLine();
   
   System.out.println("\nValues are " + d1 + ", " + d2 + ", " + d3 + ", " + d4 + ", and " + d5 + ".");
   System.out.println("Sum of these values is " + sumDouble + ".");
   System.out.println("Average of these values is " + averageDouble + ".");
   
 //Part E
   
   if (num1 == num2)
      {
       System.out.println("\nBased on user input " + num1 + " and " + num2 + ", num1 is equal to num2.");
      }
   
   else if (num1 > num2)   
      {
       System.out.println("\nBased on user input " + num1 + " and " + num2 + ", num1 is greater than num2.");
      }
    
   else
      {
       System.out.println("\nBased on user input " + num1 + " and " + num2 + ", num1 is less than num2.");
      }
       
 //Part F
 
   System.out.println("\nEnter the first character of your lastname: ");
   char myChar = keyboard.nextLine().charAt(0);      
   
   switch(myChar) {
  case 'a':
    System.out.println("\nAlligator");
    break;
  case 'b':
    System.out.println("\nBird");
    break;
  case 'c':
    System.out.println("\nCamal");
    break;
  case 'd':
    System.out.println("\nDog");
    break;
  default:
    System.out.println("\nYour last name doesn't match any in the animal list");
    }   
      
 //Bonus    
      System.out.println("\nPlease enter 2 names: ");
      String name1 = keyboard.nextLine();
      String name2 = keyboard.nextLine();
      
         if (name1.equalsIgnoreCase(name2))
         {
         System.out.println("\n" + name1 + " and "+ name2 + " are the same.");
         }
         
         else if (name1.compareTo(name2) < 0) //name1 is "less than" name2 (alphabetical)
         {
         System.out.println("\n" + name1);
         System.out.println(name2);
         }
         
         else //name2 is "less than" name1 (alphabetical)
         {
         System.out.println("\n" + name2);
         System.out.println(name1);
         }
     
      
      
      
      
         
   
   }
}