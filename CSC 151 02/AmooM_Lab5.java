//Name: Michael Amoo
//Date: 10/3/23
//Phone: (757)-776-2017
//Section: 151 63
//Instructor: Dr. B
//Description: Lab 5 - Chapter 4 Continue Conditioning Statements
import java.util.Scanner;
public class AmooM_Lab5
{
public static void main(String args[])
   {
   Scanner keyboard = new Scanner(System.in);
//Part A - Read a String and Print Information using switch statement
   System.out.print("Enter a major: ");
   String myMajor = keyboard.nextLine();
   
   switch (myMajor)
   {
   case "csc" :
      System.out.println("My major is Computer Science");
      break;
   case "cis" :
      System.out.println("My major is Computer Infromation Systems");
      break;
   case "cys" :
      System.out.println("My major is Cyber Security - Computer Science track");
      break;
   case "ce" :
      System.out.println("My major is Computer Engineering");
      break;
   default: System.out.println("Major code not listed");
   }
   
//Part B - High/Low with Conditional Operator
   System.out.print("\nEnter a score: ");
   int score = keyboard.nextInt();
   
   //if else
   if (score > 150)
      System.out.println("Your score of " + score + " is higher than 150.");
   else
      System.out.println("Your score of " + score + " is lower than 150.");

   //Coditional Statement
   //x > y ? true : false
      
   System.out.println("Your score of " + score + " is " + (score > 150 ? "higher than 150." : "lower than 150.") );

//Part C - Nested if-else?
   System.out.print("\nEnter an annual pay: ");
   double salary = keyboard.nextDouble();
   System.out.print("Enter number of years that have been working: ");
   int years = keyboard.nextInt(); 
   System.out.print("'Y' or 'N' for recently graduate from college: ");
   char recentGrad = keyboard.next().charAt(0);
   
   if (salary >= 60000)
   { if (years >= 3)
     System.out.println("You receive 25% discount");
      else if (recentGrad == 'Y')
      System.out.println("You receive 20% discount");
   else
      System.out.println("You receive 15% discount");
     
   }
   else 
      System.out.println("You receive 5% discount");

//Part D - Read 3 intergers and find highest using logical operators
   System.out.print("\nEnter first integer: ");
   int num1 = keyboard.nextInt();
     
   System.out.print("Enter second integer: ");
   int num2 = keyboard.nextInt();   
   
   System.out.print("Enter third integer: ");
   int num3 = keyboard.nextInt();   
   
   if (num1 > num2 && num1 > num3)
   System.out.println("You enter " + num1 + ", " + num2 + ", " + num3 + " and the highest number is " + num1 + ".");
   
   else if (num2 > num1 && num2 > num3)
   System.out.println("You enter " + num1 + ", " + num2 + ", " + num3 + " and the highest number is " + num2 + ".");
   
   else
   System.out.println("You enter " + num1 + ", " + num2 + ", " + num3 + " and the highest number is " + num3 + ".");
   keyboard.nextLine(); 
//Part E - String Comparison
   System.out.print("\nEnter name #1: ");
   String name1 = keyboard.nextLine(); 
   System.out.print("Enter name #2: ");
   String name2 = keyboard.nextLine(); 
   
   if ( name1.compareTo(name2) == 0 )
     System.out.println("Both " + name1 + " and " + name2 + " are identical."); 
     
   else if (name1.compareTo(name2) < 0 )
      System.out.println("Both names are different, and here is the order " + name1 + ", " + name2);
      
   else
    System.out.println("Both names are different, and here is the order " + name2 + ", " + name1); 
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   }
}