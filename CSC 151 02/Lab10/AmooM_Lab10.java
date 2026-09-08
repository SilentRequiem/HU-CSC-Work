//Name: Michael Amoo
//Instructor: Dr. B
//Date: 10/17/23
import java.util.Scanner;
import java.util.Random;
import java.text.DecimalFormat;
public class AmooM_Lab10
{ 
public static void main(String[] args)
   {
   Scanner keyboard = new Scanner(System.in);
   Random Random = new Random();
  
//Part A. For Loop with Running Total  
  System.out.print("How many days of sale you have? ");
  int days = keyboard.nextInt();
  System.out.print("\n");
  
  double total = 0.0;
  
    for (int count = 1; count <= days; count++)
    {
      System.out.print("Sale for Day " + count + ": ");
      double sales = keyboard.nextDouble();
      keyboard.nextLine();
      total += sales;  
    }
    double average = total /days;
    System.out.printf("\nThe result of %d sales you entered: \n", days);
    System.out.printf("\tTotal is $%f\n", total);
    System.out.printf("\tAverage is %f\n", average);
//Part B. Do-While Loop - read scores and get average; then ask to repeat
    String input;         
    int score1, score2, score3; 
    double average1;        
    char repeat; // Holds 'y' or 'n'            
    
    do
    {
      System.out.print("\nEnter a name for the following score(s): ");
      String name = keyboard.nextLine();
      System.out.print("Enter score #1: ");
      score1 = keyboard.nextInt();
      System.out.print("Enter score #2: ");
      score2 = keyboard.nextInt();
      System.out.print("Enter score #3: ");
      score3 = keyboard.nextInt();
      int sum = (score1 + score2 + score3);
      
      average1 = (score1 + score2 + score3) / 3.0;
      System.out.printf("%s has a score of %d, %d, %d.\n", name, score1, score2, score3);
      System.out.println("Sum is " + sum + ", Average is " + average1 + ".\n");
      System.out.println();
 
      
      System.out.println("Would you like to average " + "another set of test scores?");
      System.out.print("Enter Y for yes or N for no: ");
      input = keyboard.next();  // Read a string.
      repeat = input.charAt(0); // Get the first char.
      keyboard.nextLine();
 
    } 
    while (repeat == 'Y' || repeat == 'y');


//Part C. - Input Validation and Condition Switch Case
      String fullname = "Michael Kwabena Amoo";
      
      String quote1 = "Be the change that you wish to see in the world.";
      String quote2 = "Life is what happens when you're busy making other plans.";
      String quote3 = "If you look at what you in have in life, you'll will always have more.";
      String quote4 = "If you look at what you don't have in life, you'll never have enough.";
      String quote5 = "The way to get started is to quit talking and begin doing.";
      
      
      
      System.out.print("\nEnter 1, 2, 3, 4, or 5 to select a quote: ");
      int selection = keyboard.nextInt();
      switch (selection)
        {
           case 1:
              System.out.println("Be the change that you wish to see in the world.");
              break;
           case 2:
              System.out.println("Life is what happens when you're busy making other plans.");
              break;
           case 3:
              System.out.println("If you look at what you in have in life, you'll will always have more.");
              break;
           case 4:
              System.out.println("If you look at what you don't have in life, you'll never have enough.");
              break;
           case 5:
              System.out.println("The way to get started is to quit talking and begin doing.");
              break;
           default:
              System.out.print("Please enter one of these numbers: 1, 2, 3, 4, or 5: ");
        }   
            while (selection > 5 || selection < 1)
            {
            selection = keyboard.nextInt();
               
               while (selection > 5 || selection < 1)
               {
               selection = keyboard.nextInt();
               }
               
            }
            
            System.out.println("\nOutput for " + fullname + " program is as follows: ");
            
            if (selection == 1)
            System.out.println("Based-on your selection of " + selection + " your quote is, " + quote1);
            
            else if (selection == 2)
            System.out.println("Based-on your selection of " + selection + " your quote is, " + quote2);
            
            else if (selection == 3)
            System.out.println("Based-on your selection of " + selection + " your quote is, " + quote3);
            
            else if (selection == 4)
            System.out.println("Based-on your selection of " + selection + " your quote is, " + quote4);
            
            else
            System.out.println("Based-on your selection of " + selection + " your quote is, " + quote5);
            

//Part D. - From Program Challenge Question 12 - Bar Chart (page 349) in the textbook -- include in the same program   
  int tdays = 5;
  System.out.print("\n");
  
  double ttotal = 0.0;
  
    for (int count = 1; count <= tdays; count++)
    {
      System.out.print("Enter today's sales for store " + count + ": ");
      double sales = keyboard.nextDouble();
      keyboard.nextLine();
      ttotal += sales;  
    }
    
   }
}