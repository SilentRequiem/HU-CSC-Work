import java.util.Scanner;
import java.util.Random;
/*
Name: Michael Amoo
Instructor: Dr.B and Aneke
Section: CSC 152 S1
Description: Review Java: Conditioning Statments and Loops
Date: 1/23/24
*/

public class AmooM_Lab2
{
   public static void main(String args[])
   {

Scanner keyboard = new Scanner(System.in);

//Part A
System.out.print("Enter num1: ");
int num1 = keyboard.nextInt();

System.out.print("Enter num2: ");
int num2 = keyboard.nextInt();
keyboard.nextLine();

if (num1 == num2)
System.out.print("Based on user input " + num1 + " and " + num2 + ", num1 is equal to num2");

else if (num1 > num2)
System.out.print("Based on user input " + num1 + " and " + num2 + ", num1 is higher to num2");

else
System.out.print("Based on user input " + num1 + " and " + num2 + ", num1 is lower to num2");

//Part B

System.out.print("\n\nEnter name1: ");
String name1 = keyboard.nextLine();

System.out.print("Enter name2: ");
String name2 = keyboard.nextLine();

if (name1.equalsIgnoreCase(name2))
System.out.println("name1 and name2 are the same");

else if (name1.compareToIgnoreCase(name2) < 0) 
System.out.println(name1 + ", " + name2);

else
System.out.println(name2 + ", " + name1); 

//Part C
System.out.print("\nEnter the first character of lastname: ");
char myChar = keyboard.nextLine().toUpperCase().charAt(0);

switch (myChar) {
            case 'A':
                System.out.println("A for Alligator");
                break;
            case 'B':
                System.out.println("B for Bird");
                break;
                
            case 'C':
                System.out.println("C for Camal");
                break;
            case 'D':
                System.out.println("D for Dog");
                break;
            
            default:
                System.out.println("Your last name doesn't match any in the animal list");
            }

            
//Part D
int limit;

System.out.print("\nEnter a limit between 5 and 10: ");
limit = keyboard.nextInt();

while (limit < 5 || limit > 10){
System.out.print("Invalid, limit should be between 5 and 10: ");
limit = keyboard.nextInt();
}

//Part E

 System.out.println("\nNumber    Squared    Cubed");

 
 for (int number = 1; number <= limit; number++) {  
   int squared = number * number;
   int cubed = number * number * number;
 
 System.out.printf("%d\t\t\t %d\t\t\t   %d%n", number, squared, cubed);
}

//Part F
Random random = new Random();

int dice1, dice2, sum;

do{
dice1 = random.nextInt(6) + 1;
dice2 = random.nextInt(6) + 1;
sum = dice1 + dice2;
System.out.println("\nDice are " + dice1 + " and " + dice2 + ". (Sum = " + sum + ")."); 
}
while (sum != 9);
System.out.println("Nine Rolled");

   }

}