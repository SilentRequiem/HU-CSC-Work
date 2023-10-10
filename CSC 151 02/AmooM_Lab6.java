/**
Name: Michael Amoo
Phone: 757-776-2017
Instructor: Dr.B
Section: CSC 151 63 F23
Date: 10/10/23
Desc: Review Chapter 2 and Chapter 4
*/
import java.util.Scanner;
public class AmooM_Lab6
{  public static void main(String[] args)

   { 
    Scanner keyboard = new Scanner(System.in);
    
//Part A - read the input, basic String manipulation, and print out
    //User Input    
    System.out.print("Enter firstName: ");
    String firstName = keyboard.nextLine();
     
    System.out.print("Enter lastName: ");
    String lastName = keyboard.nextLine();
  
    System.out.print("Enter age: ");
    int age = keyboard.nextInt();
    keyboard.nextLine();
     
    System.out.print("Enter major: ");
    String major = keyboard.nextLine();
     
    System.out.print("Enter gpa: ");
    double gpa = keyboard.nextDouble();
    keyboard.nextLine();
     
    System.out.print("Enter hometown: ");
    String hometown = keyboard.nextLine();

    System.out.print("Enter favChar: "); // Favorite Character
    char favChar = keyboard.nextLine().charAt(0);

    //Print out
    System.out.println("\nFirst Name is " + firstName + ".");
    System.out.println("Last Name is " + lastName + ".");
    System.out.println("Age is " + age + "."); 
    System.out.println("Major is " + major + ".");
    System.out.println("GPA is " + gpa + ".");
    System.out.println("Hometown is " + hometown + ".");
    System.out.println("Favorite character is " + favChar + "."); 
   
    //String Manipulation
    int majorLen = major.length();
    String upperHometown = hometown.toUpperCase();
    String lowerMajor = major.toLowerCase();
    String initials = (firstName.charAt(0) + "" + lastName.charAt(0));
    
    //Print Out #2
    System.out.println("\nThe number of character in " + major + " is " + majorLen + ".");
    System.out.println("The uppercase of " + hometown + " is " + upperHometown + ".");
    System.out.println("The lowercase of " + major + " is " + lowerMajor + ".");
    System.out.println("The initials are " + initials + ".");
    
//Part B - Reading Number, Calculation, Order of Precedence, Math class, and Data Conversion
    
    System.out.print("\nEnter interger a: ");
    int a = keyboard.nextInt();
    
    System.out.print("Enter interger b: ");
    int b = keyboard.nextInt();

    System.out.print("Enter interger c: ");
    int c = keyboard.nextInt();
    
    System.out.print("Enter double m: ");
    double m = keyboard.nextInt();
    final double RATE = 6.25;
    
    int result1 = (int) ( Math.pow(a,5) + 5 * RATE -  Math.sqrt(a * b) ); //Self Note: To fix loose conversion, cast the whole problem via parethesis
    
    int result2 = (int) ( Math.pow(a,5) - 5 * Math.pow(c,4) * b + Math.pow(b,7) );
    
    double result3 = ( ((5 * Math.pow(m,2) + 7) / Math.sqrt(8)) + ((25 * c % a) / 5) );
    
    //Print Out #3
    System.out.println("\nResult1 is " + result1);
    System.out.println("Result2 is " + result2);
    System.out.println("Result3 is " + result3);

//Part C - Basic Conditioning Statement
   
    System.out.print("\nEnter num1: ");
    int num1 = keyboard.nextInt();

    System.out.print("Enter num2: ");
    int num2 = keyboard.nextInt();
    
    System.out.print("Enter num3: ");
    int num3 = keyboard.nextInt();

    
    {
    //Highest
    if (num1 > num2 && num1 > num3)
    System.out.print("\n" + num1 +" (num1) is the highest.");
    
    else if (num2 > num1 && num2 > num3)
    System.out.print("\n" + num2 +" (num2) is the highest.");
    
    else if (num3 > num1 && num3 > num1)
    System.out.print("\n" + num3 +" (num3) is the highest.");

    
    //Lowest
    else if (num1 < num2 && num1 < num3)
    System.out.print("\n" + num1 +" (num1) is the lowest.");
    
    else if (num2 < num1 && num2 < num3)
    System.out.print("\n" + num2 +" (num2) is the lowest.");
    
    else if(num3 < num1 && num3 < num1)
    System.out.print("\n" + num3 +" (num3) is the lowest.");
    
    //Same
    else 
    System.out.print("\nnum1, num2, and num3 are equal.");
    }
    
    //Define variables
    int x = 5;
    int y = 3;
    int z = 10;
    
    //Condition Statement #1
    {
    if (num1 > num2)
    y += 15;
    
    else if (num2 > num3)
    y -= 2;
    
    else
    y = 5;
    }
    
    //Condition Statement #2
    if (num3 >= num1)
    {
    y = 10;
    z = 17;
    }
    
    //Condition Statement #3
    
    if (num1 < num3)
    {
    z = 4;
    y = 3;
   } 
    else
    {
    x = 10;
    }
       
//Part D - Nested-if, Logical with if-else Statement
    
    System.out.print("\nEnter your salary: ");
    double salary = keyboard.nextDouble();  
    
    System.out.print("Enter your yearsWork: ");
    int yearsWork = keyboard.nextInt();
    int bonus;
    
    if (salary > 70000)
      { 
      if (yearsWork >= 2)
             bonus = 2000;
      }
      else if (salary > 50000)
         bonus = 1500;
      
      else {
          bonus = 2000;
           }
          
              
//Part E - Random Number and Switch-Case    
    


//Bonus: Part F - String Comparision    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
     
   }
}   