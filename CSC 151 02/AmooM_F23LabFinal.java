/*
Name: Michael Kwabena Amoo
Lab Instructor: Dr.Boothum
Date: 11/28/23
"I, Michael Kwabena Amoo, pledge to follow the Honor Code in taking my Lab Final Exam Fall 2023"
*/

import java.util.Scanner;
import java.util.Random;
public class AmooM_F23LabFinal
{ public static void main(String args[])
   {
   Random Random = new Random();
   Scanner keyboard = new Scanner(System.in);
   
//Part A: Reading Input From Keyboard, Calculation, String
System.out.println("\nPart A - Output for Michael Kwabena Amoo program is as follows:");
System.out.println("####");
System.out.print("Input interger for a: ");
int a = keyboard.nextInt();

System.out.print("Input interger for b: ");
int b = keyboard.nextInt();
keyboard.nextLine();

System.out.print("Input string for first_name: ");
String first_name = keyboard.nextLine();

System.out.print("Input string for last_name: ");
String last_name = keyboard.nextLine();

System.out.print("Input double for r: ");
double r = keyboard.nextDouble();
keyboard.nextLine();

System.out.print("Input string for fav_song: ");
String fav_song = keyboard.nextLine();

System.out.print("Input string for fav_animal: ");
String fav_animal = keyboard.nextLine();

//Extra Variables
int result1 = (int) ((Math.pow(a,5) + Math.pow(b,4)) / Math.sqrt(r));
double result2 = (r + ((a - 3 * b) / 7));
int total = first_name.length() + last_name.length()  + fav_song.length()  + fav_animal.length() ; 
String upperFav = fav_song.toUpperCase() + " and " + fav_animal.toUpperCase();
String lowerName = first_name.toLowerCase() + last_name.toLowerCase(); 
char firstLetter = fav_song.charAt(0);
char lastLetter = last_name.charAt(0); //Fix Later
int ran1 = Random.nextInt(10,20);
int ran2 = Random.nextInt(30) - 30;

//PrintOut of A

System.out.println("Hello, my name is " + lowerName + ". I love " + upperFav + ",");
System.out.println("\tand I have been there + " + a + " times over this past " + b + " years.");
System.out.println("Total is " + total + ". result1 is " + result1 + " and result2 is " + result2 + ".");
System.out.println("First Letter of my favorite song is " + firstLetter + ".");
System.out.println("Last Letter of my last name is " + lastLetter + ".");
System.out.println("First Random number is " + ran1 + " and Second Random Number is " + ran2 + ".");

//Part B: Input Validation and Condition
System.out.println("\nPart B - Output for Michael Kwabena Amoo program is as follows:");
System.out.println("####");
System.out.print("\nEnter an option [1-5]: ");
int option = keyboard.nextInt();

while (option < 1 || option > 5);
{
System.out.print("\nEnter an option again [1-5]: ");
option = keyboard.nextInt();
}

//Print of B

switch (option)
{
   case 1:
      System.out.println("Based-on your option of " + option + " your quote is \"If you tell the the truth, you don't have to remember anything.\"");
      break; 
   case 2:
      System.out.println("Based-on your option of " + option + " your quote is \"Don't cry because it's over, smile because it happened.\"");
      break; 
   case 3:
      System.out.println("Based-on your option of " + option + " your quote is \"Be \"yourself\"; everyone else is already taken.\""); //Fix quotation later
      break;
   case 4:
      System.out.println("Based-on your option of " + option + " your quote is \"Be the change that you wish to see in the world.\"");
      break; 
   case 5:
      System.out.println("Based-on your option of " + option + " your quote is \"No one can make you feel inferior without your consent.\"");
      break;  
   default:
      System.out.println("Error: Invalid option");
      break;
}
 
//Part C: Loop - Sentinel, Count, Running Total, Average
int number = 0;
int positive = 0;
int negitive = 0;
while (number != -1);
int totalp;
double averageI;
System.out.println("\nPart C - Output for Michael Kwabena Amoo program is as follows:");
System.out.println("####");

{
System.out.print("Enter an interger [-1 to stop]");
number = keyboard.nextInt();

   if (number <= 0)
   positive +=1;
   else 
   negitive +=1;
}
System.out.println("\nPositive Numbers: " + positive);
System.out.println("\nNegitive Numbers: " + negitive);
keyboard.nextLine();
//Part D: Repeat Loop and String Comparison   
System.out.print("Enter String 1");
String name1 = keyboard.nextLine();

System.out.print("Enter String 2");
String name2 = keyboard.nextLine();

//Compare the names.
if (name1.compareTo(name2) == 0)
   {
   System.out.println(name1 + " and " + name2 + " has the same number of characters, is " + name1.length());
   }
   else if (name1.compareTo(name2) > 0)
   {
   System.out.println(name1 + " has more characters than " + name2);
   }
   else if (name1.compareTo(name2) < 0)
   {
   System.out.println(name2 + " has more characters than " + name1);
   }
   
   else
   System.out.println("Dummy");   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   }
}