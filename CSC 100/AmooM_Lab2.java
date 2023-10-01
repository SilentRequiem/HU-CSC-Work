// comment
/* _   _                       _                _   _       _                    _ _         
  | | | |                     | |              | | | |     (_)                  (_) |        
  | |_| | __ _ _ __ ___  _ __ | |_ ___  _ __   | | | |_ __  ___   _____ _ __ ___ _| |_ _   _ 
  | | | | (_| | | | | | | |_) | || (_) | | | | | |_| | | | | |\ V /  __/ |  \__ \ | |_| |_| |
  \_| |_/\__,_|_| |_| |_| .__/ \__\___/|_| |_|  \___/|_| |_|_| \_/ \___|_|  |___/_|\__|\__, |
                      | |                                                               __/ |
                      |_|                                                              |___/ */

/* -- Multi-line comment
   Author: Michael Amoo
   Instuctor: Dr. B & Dr. M
   Program Name: AmooM_Lab2
   Description: Reading Input from Keyboard
                String Manipulation
   Date: 6/27/23

*/       //Ending of multi-line comment

// import Scanner class
import java.util.Scanner;

// class header
public class AmooM_Lab2
{ // starting of program
  // maid method header
  public static void main(String args[])
  { // start main method
   
   //Create a Scanner object
   Scanner keyboard = new Scanner(System.in);
   
   // read names
   System.out.print("What is your first name? ");
   String firstname = keyboard.nextLine();
   
   System.out.print("What is your last name? ");
   String lastname = keyboard.nextLine();
   
   System.out.println("My name is " + firstname + " " + lastname + ".");
   
   // read intergers and basic caluction
   System.out.print("Enter first integer: ");
   int num1 = keyboard.nextInt();
   System.out.print("Enter second integer: ");
   int num2 = keyboard.nextInt();
   
   // calculation - sum, sub, mult, div, rem
   int sum = num1 + num2;
   int sub = num1 - num2;
   int mult = num1 * num2;
   int div = num1 / num2;
   int rem = num1 % num2;
   
   // print
   System.out.println("You entered " + num1 + " and " + num2 + "\n\tThe sum is "
    + sum + "\n\tThe difference is " + sub + "\n\tThe product is " + mult
    + "\n\tThe quotient is " + div + "\n\tThe remainder is " + rem);
    
   //basic String maniputation
   //count character in firstname
   int countFN = firstname.length(); 
   String upper = firstname.toUpperCase();
   char fChar = firstname.charAt(0);
   
   //print
   System.out.println("count first name: "
      + countFN + " characters"
      + "\nUpper case: " + upper
      + "\nfirst char: " + fChar);
   
   //  Addtion on 6/28/23
   System.out.print("What is your hourly rate? ");
   double hourRate = keyboard.nextDouble();
   System.out.print("How many hours you work? ");
   double hours = keyboard.nextDouble();
   double wages = hourRate * hours; // money we make
   System.out.println("You work " + hours + " hours" +
                     " at a rate of " + hourRate + " $/hour" +
                     " \n\t You make " + wages + " dollars.");
   
   // Math class - Math.pow and Math.sqrt
   double cubeOf7 = Math.pow(7, 3);
   double NinePowerTen = Math.pow(9, 10);
   double result1 = Math.pow(num1, num2);
   double result2 = Math.pow(num2, 5);
   double result3 = Math.pow(2, num1);
   double result4 = Math.sqrt(144);
   double result5 = Math.sqrt(num1);
   double result6 = Math.sqrt(Math.pow(num2, 2) + num1);
   
   System.out.println("result1: " + result1);
   System.out.println("result2: " + result2);
   System.out.println("result3: " + result3);
   System.out.println("result4: " + result4);
   System.out.println("result5: " + result5);
   System.out.println("result6: " + result6);
   
  } // end main method
} //ending of program