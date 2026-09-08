/*
Author: Miles Walker and Michael Amoo
Instructor: Dr. B & Dr. Muhammad
Date: 7/17/23
Program Name: TaxTechnicians 
Description: Source code for our final project, a tax calculator. This program will read user input for a purchase, calculate the tax, 
and then present with the total price. Finally, the calculator will compare this price with the user's budget and tell them whether it is over or under. If 
the purchase is over the budget, user will be instructed to adjust their budget to a suitable amount
*/ 

import java.util.Scanner;

public class TaxTechnicians_Project
{

   public static void main (String args[])
   { 
      Scanner keyboard = new Scanner(System.in);
      
      //variables 
      String firstName;
      String lastName;
      String midName;
      double price; 
      double total;
      double tax;
      double budget; 
     
      System.out.println("User, enter your first name: ");
      firstName = keyboard.nextLine();
      String upperFirst = firstName.toUpperCase();
      
      System.out.println("User, enter your middle name: ");
      midName = keyboard.nextLine(); 
      char midInit = midName.charAt(0);
      
      System.out.println("User, enter your last name: ");
      lastName = keyboard.nextLine();
      String upperLast = lastName.toUpperCase();
     
      System.out.println(upperFirst + " " + midInit + " " + upperLast + ", what is the estimated price of your purchase?");
      price = keyboard.nextDouble();
      
      while (price < 0)
      {
         System.out.println("Invalid price. \nEnter new price: ");
         price = keyboard.nextDouble();
      } //this loop will prompt the user to enter a new price if their price is negative
      
      tax = price * 0.06;
      total = price + tax; 
      
      System.out.println(upperFirst + " " + midInit + " " + upperLast + ", your purchase has a value of $" + price + "." +
      "\nAccounting for the average US sales tax of 6%, your purchase has an added sales tax of $" + tax + ", resulting in a total price of $" + total + ".");
      
      System.out.println(upperFirst + " " + midInit + " " + upperLast + ", what is the budget for this purchase?");
      budget = keyboard.nextDouble();
      
      while (budget < 0)
      {
         System.out.println("Invalid budget. \nEnter new budget: ");
         budget = keyboard.nextDouble();
      } //Same as the price loop, prevents invalid inputs
      
      if (budget != total)
      {
         if (budget < total)
         { 
            System.out.print(upperFirst + " " + midInit + " " + upperLast + ", your purchase is exceeds your current budget of $" + budget + ". It is recommended that you adjust your purchase." +
            "\nEnter new estimated price of purchase: "); //This conditional statement/loop informs the user if their purchase exceeds their budget and prompts them to adjust the price of their purchase (basically finding a new item)
            while (budget < total)
            {
            price = keyboard.nextDouble();
            tax = price * 0.06;
            total = price + tax; 
            System.out.print("Your purchase of $" + total + " (including tax) still exceeds budget." + 
            "\nEnter new estimated price of purchase: ");
            } //this while loop prompts the user for a new price and re-calculates the tax and total price to see if it is within the budget. If not, the loop repeats.
         }
         
         if (budget >= total)
         {  
            double remaining = budget - total;
            System.out.println("\n" + upperFirst + " " + midInit + " " + upperLast + ", your purchase of $" + total + " is within your budget of $" + budget + "." +
            " After your purchase, you will have $" + remaining + " left in your budget.");                   
         }
      }
      
      
   }  

} 
