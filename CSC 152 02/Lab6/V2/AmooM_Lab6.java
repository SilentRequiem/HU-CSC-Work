/*
Name: Michael Amoo
Instructor: Dr B.
Program: Chapter 7 1D Arrays
Date: 2/28/25
Description: Review 1D Arrays
Class: CSC 152 02
I, Michael Amoo, pledge to follow the Honor Code in completing my Lab 6.
*/
import java.util.Arrays;
import java.util.Scanner;

public class AmooM_Lab6 {
   public static void main(String[] args) {
   
   Scanner keyboard = new Scanner(System.in); 

   
   //Part A - Define Integer Arrays and Read Input from user
   final int size = 5;
   
   System.out.println("\nPart A - Define Integer Arrays and Read Input from user\n");
   
   int[] scores_MA = new int[5];
   
   
   for (int i = 0; i < scores_MA.length; i++) {
   System.out.println("Enter a integer #" + (i +1) + ": ");
   scores_MA[i] = keyboard.nextInt();
   }
   
   //Printout
   for (int tmp : scores_MA) {
   System.out.print(tmp + ", ");
   }
   
   
   //Calcs
   int sum = 0;
   int max = scores_MA[0];
   int min = scores_MA[0];
   double average = 0;
   
   for (int tmp : scores_MA) {
   sum += tmp;
   
   if (tmp > max) {
      max = tmp;
      }
      
   if (tmp < min) {
      min = tmp;
      }
   
   average = (double) (sum / scores_MA.length);
   }
   
   //Printout One Line
   System.out.println("\nSum is " + sum 
                     + "\nMax is " + max
                     + "\nMin is " + min
                     + "\nAverage is " + average);


//Part B - String Arrays and String Manipulation Print
   keyboard.nextLine(); //clear buffer
   
   System.out.println("\nPart B - String Arrays and String Manipulation Print\n");
   
   
   String[] friendsList_MA = new String[5]; //array of 5 friends
   
   System.out.println("Enter the 5 of friends you have: ");
   
   for (int i = 0; i < friendsList_MA.length; i++) {
      friendsList_MA[i] = keyboard.nextLine();
      }
   
   System.out.println("\nYour friends are: ");
   
   for (String tmp : friendsList_MA ) { //Remember to use String tmp not int tmp
       System.out.println(tmp + " has " + tmp.length() + " characters - " + tmp.toUpperCase().charAt(0) 
                              + " " + tmp.toUpperCase().charAt(tmp.length() - 1));
      }                    



//Part C - Copy and Compare Array
   System.out.println("\nPart C - Copy and Compare Array\n");
   
   int[] scoresBackup_MA = new int[scores_MA.length];
   
   for (int i = 0; i < scoresBackup_MA.length; i++) {
   scoresBackup_MA[i] = scores_MA[i]; //copy from scores_MA to scoresBackup_MA
}
   scoresBackup_MA[3] = 99; //change scoresBackup_MA[3] to 99

   //Print
   System.out.println("scoresBackup_MA");
   
   //Printout
   for (int tmp : scoresBackup_MA) {
   System.out.print(tmp + ", ");
   }
   
   
   System.out.println("\n\nscores_MA");
   
   for (int tmp : scores_MA) {
   System.out.print(tmp + ", ");
   }
   
   System.out.println("\n"); //just for cleaner output
   
   //Compare
   System.out.println(Arrays.equals(scoresBackup_MA, scores_MA) ? "SAME" : "NOT SAME"); 
                                                               //  TRUE  :    FALSE
//Part D - Partially Filled Array

  System.out.println("\nPart D - Partially Filled Array\n");

   int[] myPoints_MA = new int[100];
        int count = 0;
        
        System.out.println("\nEnter integers (max 100), -1 to stop:");
        
        while (count < 100) {
            int num = keyboard.nextInt();
            
            if (num == -1) 
            {break;}
            
            myPoints_MA[count] = num;
            count++;
        }
        
        //Printout
        System.out.println("\nEntered Numbers:");
        for (int i = 0; i < count; i++) {
            
            System.out.print(myPoints_MA[i] + "\t");
            
            if ((i + 1) % 10 == 0) //After 10 make new Line
            System.out.println();
        }
        
        
        sum = 0;
        int highest = myPoints_MA[0];
        int lowest = myPoints_MA[0];
        average = 0.0;
        
        for (int i = 0; i < count; i++) {
            sum += myPoints_MA[i];
            if (myPoints_MA[i] > highest) 
            highest = myPoints_MA[i];
            if (myPoints_MA[i] < lowest) 
            lowest = myPoints_MA[i];
        }
        
        average = (double) sum / count;
        
        System.out.println("\nTotal Numbers Entered: " + count);
        System.out.println("Sum: " + sum);
        System.out.println("Average: " + average);
        System.out.println("Highest: " + highest);
        System.out.println("Lowest: " + lowest);










   }
   
   
 }