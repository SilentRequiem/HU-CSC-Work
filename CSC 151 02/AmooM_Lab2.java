import java.util.Scanner;
//Name: Michael Amoo
//Section: 151 63
//Instructor: Dr. B
//Description: User Input, Arithmethic Operatiors, String Manipulation + Review Variables and Print

public class AmooM_Lab2
{
   public static void main(String[] args)
   {
    //Part A - Read Input from Keyboard using Scanner
    Scanner keyboard = new Scanner(System.in);
    
    System.out.print("Enter your name: ");
    String name = keyboard.nextLine();
    
    System.out.print("Enter your age: ");
    int age = keyboard.nextInt();
    
    System.out.print("Enter your gpa: ");
    double gpa = keyboard.nextDouble();
    
    keyboard.nextLine();
    System.out.print("Enter your major: ");
    String major = keyboard.nextLine();
    
    System.out.println("\nName is " + name + ".");
    System.out.println("Age is " + age + ".");
    System.out.println("Gpa is " + gpa + ".");
    System.out.println("Major is " + major + ".");
   
   // Part B - Basic String Manipulation
   
   int size = name.length();
   String upper = name.toUpperCase();
   String lower = name.toLowerCase();
   char firstLetter = name.charAt(0);
   
   System.out.println("\nName is " + name + ", has " + size + " characters.");
   System.out.println("UPPERCASE of name is " + upper + ".");
   System.out.println("lowercase of name is " + lower + ".");
   System.out.println("The first character of the name is " + firstLetter + ".");
   
   //Part C - Boolean, Math Class and Combined Operators
   
   boolean flag = false;
   System.out.println("\nThe flag is " + flag + ".");
   
   double myAnswer1 = Math.pow(6,8);
   System.out.println("The result of 6 power 8 is " + myAnswer1 + ".");
   
   double myAnswer2 = Math.sqrt(256);
   System.out.println("The result of square root of 256 is " + myAnswer2 + ".");
   
   double myAnswer3 = (Math.sqrt(Math.pow(age,5) + size) / 3);
   System.out.println("The calculation is " + myAnswer3 + ".");
   /*Order of P:  (Math.sqrt(Math.pow(age,5) + size) / 3);
                   [   4   ][       1      ][2] [3] [5]                       
                                                                             
   */
   
   //Part D - Arthmentic Operators 
   
   int dividend = 15;
   int divisor = 4;
   int quotient = dividend / divisor;
   int remainder = dividend % divisor;
   
   System.out.println("\nWhen " + dividend + " is divided by " + divisor + ",");
   System.out.println("the quotient is " + quotient + " and"); 
   System.out.println("the remainder is " + remainder + ".");
   
   int x = 12, y = 8, z = 14, s = 25;
   
   x = x % 7;
   y = y + z;
   s = s * 10;
   z = z / 3;
   
   
   /*
   x = x % 7
   y = y + z
   s = s * 10
   z = z / 3
   */
   
  System.out.println("\nx = x % 7 \ny = y + z \ns = s * 10 \nz = z / 3");
   
  System.out.println("\nx is "+ x + ".");
  System.out.println("y is " + y + ".");
  System.out.println("s is " + s + ".");
  System.out.println("z is " + z + "."); 
   
  //No Extra Credit done 
   
   
   
   
   
   
   
   }
}