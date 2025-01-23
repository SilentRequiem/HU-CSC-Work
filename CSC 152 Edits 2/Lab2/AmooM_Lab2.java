import java.util.Scanner;
/*
Name: Michael Amoo
Instructor: Dr B.
Program: Review Java Loops from CSC 151
Date: 1/15/25
*/

public class AmooM_Lab2
{
   public static void main(String args[])
   {

Scanner keyboard = new Scanner(System.in);

//Part A
 int limit;

 System.out.print("Please enter an integer for limit (5 - 10): ");

 limit = keyboard.nextInt();
 System.out.println("");

 while (limit > 10 || limit < 5)
 {
    System.out.print("Invalid, limit should be between 5 and 10, please reenter: ");
    limit = keyboard.nextInt();
 }

 System.out.println("\tYou enter " + limit + " for limit.");
   
//Part B
System.out.println("Number Square Cube Square Root");

        for (int i = 1; i <= limit; i++)
        {
            double squareRoot = Math.sqrt(i);
            System.out.printf("%d\t%d\t%d\t%.3f\n", i, i * i, i * i * i, squareRoot);
        }

//Part C

        int dice1, dice2, sum;

        do {
            dice1 = (int) (Math.random() * 6) + 1;
            dice2 = (int) (Math.random() * 6) + 1;
            sum = dice1 + dice2;
            System.out.println("Dice are " + dice1 + " " + dice2 + " (sum = " + sum + ")");
        } while (sum != 9);
        
        System.out.println("\tNine Rolled");

//Part D

int num, countOdd = 0, countEven = 0, sumOdd = 0, sumEven = 0;
        
        System.out.print("Please enter an integer [-1 to exit]: ");
        num = keyboard.nextInt();
        
        while (num != -1) {
            if (num % 2 == 0) {
                System.out.println(num + " is even");
                sumEven += num;
                countEven++;
            } else {
                System.out.println(num + " is odd");
                sumOdd += num;
                countOdd++;
            }
            System.out.print("Please enter an integer [-1 to exit]: ");
            num = keyboard.nextInt();
        }
        
        System.out.println("*** You enter " + (countOdd + countEven) + " numbers:");
        System.out.println(countOdd + " odd integers; a total of " + sumOdd);
        System.out.println(countEven + " even integers; a total of " + sumEven);

//Bonus

System.out.print("What a character you want to use for pattern? ");
        char pattern = keyboard.next().charAt(0);
        System.out.print("How many rows to print? ");
        int row = keyboard.nextInt();
        System.out.print("How many columns to print? ");
        int col = keyboard.nextInt();
        
        System.out.println("Printing " + pattern + " for " + row + " rows and " + col + " columns:");
        for (int i = 0; i < row; i++) {
            for (int j = 0; j < col; j++) {
                System.out.print(pattern);
            }
            System.out.println();
        }

    }

}