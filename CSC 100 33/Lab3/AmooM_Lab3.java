/* 
   Author: Michael Amoo
   Instuctor: Dr. B & Dr. M
   Program Name: AmooM_Lab3
   Description: User Input from Keyboard;
                String Manipulation
   Date: 6/28/23

*/

//Part A - Read Input from Keyboard using Scanner (REVIEW)
 
//Import Scanner
import java.util.Scanner;

//class header
public class AmooM_Lab3

{ //start of Program
   //main method header
   public static void main(String args[])
   { //start of main method
   
   Scanner keyboard = new Scanner(System.in);
   
  //Input prompts
  System.out.print("What is your full name? ");
   String name = keyboard.nextLine();
  
  System.out.print("What is your age? ");
   int age = keyboard.nextInt();
  
  System.out.print("What is your gpa? ");
   double gpa = keyboard.nextDouble();
  
  keyboard.nextLine();
  
  System.out.print("What is your major? ");
   String major = keyboard.nextLine();
   
   System.out.print("What is your hometown? (City, State) ");
   String hometown = keyboard.nextLine();
   
   //Printing Inputs
   System.out.println("Name is " + name + ".");
   System.out.println("Age is " + age + ".");
   System.out.println("Gpa is " + gpa + ".");
   System.out.println("Major is " + major + ".");
   System.out.println("Hometown is " + hometown + ".");
   
   //Part B - Basic String Manipulation
   int size;
   char firstLetter;
   size = name.length();
   String upper = name.toUpperCase();
   String lower = name.toLowerCase();
   firstLetter = name.charAt(0);
   
   //Printing String Manipulation
   System.out.print("Name is " + name + ", has " + size + " characters."
                    + "\nUPPERCASE of name is " + upper + "."
                    + "\nlowercase of name is " + lower + "."
                    + "\nThe first character of name is " + firstLetter + ".");
  
  keyboard.nextLine();
  
  
  //Part C - Math Class - Math.pow and Math.sqrt methods
  System.out.print("Enter first integer: ");
   int num1 = keyboard.nextInt();
   
  System.out.print("Enter second integer: ");
   int num2 = keyboard.nextInt();
  
  double myAnswer1 = Math.pow(num1, 8);
  double myAnswer2 = Math.sqrt(num2);
  double myAnswer3;
  myAnswer3 = (Math.sqrt(2 * Math.pow(num1, 5) + num2)/5); // <-- Precendence can be seen here
  
   System.out.println("myAnswer1 is " + myAnswer1 + ".");
   System.out.println("myAnswer2 is " + myAnswer2 + ".");
   System.out.println("myAnswer3 is " + myAnswer3 + ".");
  
  
  
  
  
  
  
  
  
    } // end main method
} //ending of program