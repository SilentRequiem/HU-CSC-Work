import java.util.Scanner; 
/*
Name: Michael Amoo
Instructor: Dr.B and Aneke
Section: CSC 152 S1
Description: Review Writing a Java Program with User Input from Keyboard, basic calculation, and basic String manipulation
Date: 1/16/24
*/

public class AmooM_Lab1
{
   public static void main(String args[])
   {
   
//Part A
System.out.println("Name: Michael Amoo");
System.out.println("Major: Computer Science");
System.out.println("Favorite Song: Heaven");
System.out.println("Favorite Movie: The Waitress (Orginal)");

//Part A but in one line
System.out.print("\nName: Michael Amoo \nMajor: Computer Science \nFavorite Song: Heaven \nFavorite Movie: The Waitress (Orginal)");
System.out.println(" ");   
//Part B (Import and define Scanner)
Scanner keyboard = new Scanner(System.in);  
   
//Part C
System.out.print("\nPlease enter first name: ");
String firstName = keyboard.nextLine();

System.out.print("Please enter last name: ");
String lastName = keyboard.nextLine();

System.out.print("Please enter age: ");
int age = keyboard.nextInt();
keyboard.nextLine();

System.out.print("Please enter major: ");
String major = keyboard.nextLine();

String fullname = firstName + " " + lastName;
int totalChars = firstName.length() + lastName.length();
String fullUpper = fullname.toUpperCase();

String lastUpper = lastName.toUpperCase();
char lastCharLN = lastUpper.charAt(lastUpper.length() - 1);     
   
System.out.println("\nHello, my name is " + firstName + " " + lastName + "." + " I am " + age + " years old and my major is " + major + ".");
System.out.println("My full name contain " + totalChars + " number of characters.");
System.out.println("My full name in uppercase is " + fullUpper + ".");
System.out.println("The last character of my last name in upper case is " + lastCharLN + ".");

//Part D
System.out.println("\nPlease enter 2 intergers: ");
int num1 = keyboard.nextInt();
int num2 = keyboard.nextInt();
int sum = num1 + num2;
int average = sum / 2;

System.out.println("\nThe sum of " + num1 + " and " + num2 + " is " + sum + ".");
System.out.println("The average of " + num1 + " and " + num2 + " is " + average + ".");

//Part E
System.out.println("\nPlease enter 5 numbers: ");
double d1 = keyboard.nextDouble();
double d2 = keyboard.nextDouble();   
double d3 = keyboard.nextDouble();   
double d4 = keyboard.nextDouble();   
double d5 = keyboard.nextDouble();
double sumDouble = d1 + d2 + d3 + d4 + d5;
double averageDouble = sumDouble / 5;

System.out.println("\nValues are " + d1 + " " + d2 + " " + d3 + " " + d4 + ", and " + d5 + ".");
System.out.println("Sum of these values is " + sumDouble + ".");
System.out.println("Average of these values is " + averageDouble + ".");

   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   }
   
}