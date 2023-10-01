//Name: Michael Amoo
//Instructor: Dr. M & Dr. B
//Date: July 6, 2023
//I, Michael Kwabena Amoo, pleage to follow the Honor Code in taking my Lab Exam.
/////////////////////////////////////////////////////////////////////////////////

import java.util.Scanner;

public class AmooM_LabExam1
{
   public static void main(String[] args)
   {
   //Create Scanner
   Scanner keyboard = new Scanner(System.in);
   
   
   
   
//Part A - Reading Input from Keyboard and Print

System.out.print("Enter a String for sport: ");
String sport = keyboard.nextLine();

System.out.print("Enter an interger for count: ");
int count = keyboard.nextInt();

keyboard.nextLine();

System.out.print("Enter a String for animal: ");
String animal = keyboard.nextLine();

System.out.print("Enter an interger for year: ");
int year = keyboard.nextInt();

keyboard.nextLine();

System.out.print("Enter a double for distance: ");
double distance = keyboard.nextDouble();

keyboard.nextLine();

System.out.print("Enter a String for event: ");
String event = keyboard.nextLine();

//Printout of A
System.out.println("\nHello, my name is Michael Kwabena Amoo. I love "
                   + sport
                   + " " + event
                   + ", and over this last\n"
                   + year + " years, I've been attending "
                   + count + " times.");

int yrcnt = (int) year + count;

System.out.println("\nAnd during last " + event + " season finale, I saw "
                   + yrcnt + " " + animal + "s" + "\n" + distance
                   + " feet away from my station.");


//Part B - Reading Input from Keyboard and String Manipulation

System.out.print("\n\nEnter a String for firstName: ");
String firstName = keyboard.nextLine();

System.out.print("Enter a String for lastName: ");
String lastName = keyboard.nextLine();

int FNtotal;
int LNtotal;

FNtotal = firstName.length();
LNtotal = lastName.length();

int total = FNtotal + LNtotal;

String upper = sport.toUpperCase();
String lower = lastName.toLowerCase();

char fourthLetter = event.charAt(3);
char lastLetter = sport.charAt(sport.length()-1);

//Printout of B

System.out.println("\nMy Name is " + firstName + " " + lastName + ", I love " + upper + ".");
System.out.println("    My last name in lowercase is " + lower + ".");
System.out.println("    My full name has a total of " + total + " characters.");
System.out.println("       The fourth character of " + event + " is " + fourthLetter + ".");
System.out.println("       The last character of " + sport + " is " + lastLetter + ".");


//Part C - Read 3 integers and 2 double to calculate various values


System.out.print("Enter an interger for a: ");
int a = keyboard.nextInt();

System.out.print("Enter an interger for b: ");
int b = keyboard.nextInt();

System.out.print("Enter an interger for c: ");
int c = keyboard.nextInt();

System.out.print("Enter a double for m: ");
double m = keyboard.nextDouble();

System.out.print("Enter a double for n: ");
double n = keyboard.nextDouble();

//Calulations
double RATE =  9.0;

int result1 = (int) Math.pow(a,3) + 9 * RATE - Math.sqrt(b * c); //Error
//Precedence:           1         4   3      5     2
int result2 = (int) Math.pow(a,3) - 7 * (Math.pow(c,5)) * a + Math.pow(c,7); //Error
//Precedence:           1         6   4      2          5   7     3



// Solve within radican first















   }
   
}