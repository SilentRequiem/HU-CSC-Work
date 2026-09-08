//Name: Michael Amoo
//Instructor: Dr. B
//Date: 10/17/23
//I, Michael Amoo, pledge to follow the Honor Code in taking my Lab Midterm Exam.
//No Part C, not on sheet
import java.util.Scanner;
import java.util.Random;
public class AmooM_Lab63Midterm
{  public static void main(String[] args)
   {
   Scanner keyboard = new Scanner(System.in);
   Random Random = new Random();
   
//Part A
   System.out.print("Enter an interger for a: ");
   int a = keyboard.nextInt();
   
   System.out.print("Enter an interger for b: ");
   int b = keyboard.nextInt();
   
   System.out.print("Enter an double for m: ");
   double m = keyboard.nextDouble();
   keyboard.nextLine();
   
   final double RATE = 5.75;
   
   int result1 = (int) (Math.pow(a,6) + 5 * RATE - Math.sqrt(a * b * m));
   double result2 = (((5 * a + 4 * b + 7)/8) + ((2 * b % a + 5)/9));
   
   System.out.println("Your entered: a = " + a + ", b = " + b + ", m = " + m + ", and RATE = " + RATE + ".");
   System.out.println("result1 is " + result1 + ".");
   System.out.println("result2 is " + result2 + ".");
   
//Part B
   
   System.out.print("\nEnter your full name: ");
   String fullName = keyboard.nextLine();
   
   System.out.print("Enter your major: ");
   String major = keyboard.nextLine();
   
   System.out.print("Enter your sport: ");
   String sport = keyboard.nextLine();
 
   System.out.print("Enter your count: ");
   int count = keyboard.nextInt();
   keyboard.nextLine();
   
   System.out.print("Enter your animal: ");
   String animal = keyboard.nextLine();
 
   int totalChars = fullName.length() + major.length() + sport.length();
   String upper = sport.toUpperCase();
   char firstLetter = animal.charAt(0);
   char lastLetter = sport.charAt(sport.length() - 1);

   System.out.println("\nHello my name is " + fullName + ". At Hampton University, my major is " + major + ".");
   System.out.println("\tI love " + upper + ", and I have " + count + " " + animal + "s at home.");
   System.out.println("\tThere is a total of " + totalChars + " characters in our Strings.");
   System.out.println("\t\tThe first character of " + animal + " is " + firstLetter + ".");
   System.out.println("\t\tThe last character of " + sport + " is " + lastLetter + ".");
 
//Part D
   int ran1 = Random.nextInt(1,10);
   int ran2 = Random.nextInt(1,6);
 
   if (ran1 >= 5)
       {
         if (ran2 > 3)
            { System.out.println("high end");
             ran2 += 5;
            }
        }
    else if (ran2 > 4)
    System.out.println("middle section");
    ran2 -= 2;
        {
    System.out.println("unsure section");
    ran1 = ran2;
        }   
 
//Part E
    
    System.out.print("\nEnter name #1: ");
    String name1 = keyboard.nextLine();
    
    System.out.print("Enter name #2: ");
    String name2 = keyboard.nextLine();
    
    char choice = name1.charAt(0);
    
    
    switch (choice)
   {
      case 'A':
         System.out.println("A is for Anna");
         break; 
      case 'B':
         System.out.println("B is for Ben");
         break; 
      case 'C':
       System.out.println("C is for Christina");
         break; 
    default:
       System.out.println("Not yet listed");
         break;
   } 
 
   System.out.println("In order it is Anna, Ben, Christina");
   
   //Finish
   }
}