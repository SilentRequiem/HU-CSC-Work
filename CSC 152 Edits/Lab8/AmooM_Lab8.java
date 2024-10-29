/*
Name: Michael Amoo
Section: 152 S1 
Instructor: Dr. B
Description: – Stack of Integers and String (S1)
Date: 10/23/24
“I, Michael Kwabena Amoo, pledge to follow the Honor Code in completing my Lab 8.”
*/
import java.util.Scanner;
import java.util.Stack;

public class AmooM_Lab8 {
   public static void main(String[] args)
{
//Part A

  Scanner keyboard = new Scanner(System.in);
  Stack<Integer> myScoresStack = new Stack<>();

        int score;
        int total = 0;
        int sum = 0;
        int min = Integer.MAX_VALUE; //Starts at the highest int, if score is lower, that score takes it's place 
        int max = 0;

        // Part 1: Read scores from user input
        System.out.print("Enter a score (-99 to stop): ");
        
         while ((score = keyboard.nextInt()) != -99) 
         {
            myScoresStack.push(score);
            total++;
            sum += score;
            
            if (score < min) 
               min = score;
               
            if (score > max)
               max = score;
               
            System.out.print("Enter a score (-99 to stop): "); //Repeat
        }

        //Print Scores
        System.out.println("\nScores entered:");
        int count = 0;
        while (!myScoresStack.isEmpty()) {
            System.out.print(myScoresStack.pop() + "\t");
            count++;
            if (count % 5 == 0) System.out.println();
        }

        //Printout
        double average = (total > 0) ? (double) sum / total : 0; //?: T/F condition
           System.out.println("\n\nSummary:");
           System.out.println("Total number of scores entered: " + total);
           System.out.println("Sum of all scores: " + sum);
           System.out.println("Average score: " + average);
           System.out.println("Min score: " + min);
           System.out.println("Max score: " + max);
  
  
//Part B

        Stack<String> myNameStack = new Stack<>();
        String name;
        int totalNames = 0;
        int totalChar = 0;
        String longestName = "";
        String shortestName = "";

        //Get names
          while (!(name = keyboard.nextLine()).equalsIgnoreCase("Done")) //While the input is not "done" 
          {
              if (!name.isEmpty()) // check if empty
              { 
                myNameStack.push(name);
                totalNames++;
                totalChar += name.length();
                
                  if (longestName.isEmpty() || name.length() > longestName.length()) 
                  {
                      longestName = name;
                  }
                 
                  if (shortestName.isEmpty() || name.length() < shortestName.length()) 
                  {
                      shortestName = name;
                  }
              }
              System.out.print("\nEnter a name (Done to stop): "); //Repeat
          }
   
          //Print name details
          System.out.println("\nNames entered:");
          while (!myNameStack.isEmpty())
          {
              String currentName = myNameStack.pop(); //Taking the "plate" out
              
              if (!currentName.isEmpty()) 
              {
                  System.out.println("Name: " + currentName.toUpperCase());
                  System.out.println("Last character in lower case: " + currentName.charAt(currentName.length() - 1));
                  System.out.println("Total number of characters: " + currentName.length());
                  System.out.println("\n");
              }
          }
   
          //Printout
             System.out.println("\n\nSummary:");
             System.out.println("Total number of names entered: " + totalNames);
             System.out.println("Total number of characters: " + totalChar);
             System.out.println("Longest name: " + longestName);
             System.out.println("Shortest name: " + shortestName);
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  }
}