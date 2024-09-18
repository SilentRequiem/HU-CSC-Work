//Name: Michael Amoo
//Phone: (757)-776-2017
//Date: 09/11/24
//Lab 2 Homework

import java.util.Scanner;

import java.util.Random;   

public class AmooM_Lab2 {
   public static void main(String args[]) {
       
        
//Part C
        Scanner keyboard = new Scanner(System.in); 
        
        int limit;
        System.out.print("\nPlease enter an integer for limit (5 - 10): ");
        
        do {
            
            
            limit = keyboard.nextInt();
            
            if (limit < 5 || limit > 10) 
            {
                System.out.print("Invalid, limit should be between 5 and 10, please reenter: ");
            }
            
        } while (limit < 5 || limit > 10);
        
        System.out.println("\n\tYou entered " + limit + " for limit.");
        
// Part D
        
        System.out.println("\nNumber\tSquare\tCube\tSquare Root");
        for (int i = 1; i <= limit; i++) 
        {
          System.out.printf("%d\t\t\t%d\t\t\t%d\t\t%.3f\n", i, i * i, i * i * i, Math.sqrt(i));
        }
        
//Part E
        System.out.println("");
        Random rand = new Random();
        int dice1, dice2, sumDices;
        
        do {
             dice1 = rand.nextInt(6) + 1;
             dice2 = rand.nextInt(6) + 1;
             sumDices = dice1 + dice2;
             
             System.out.println("Dice are " + dice1 + " " + dice2 + " (sum = " + sumDices + ")");
            
           } while (sumDices != 9);
        
        System.out.println("\tNine Rolled");
    }
}
