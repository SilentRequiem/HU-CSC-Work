/*
Name: Michael Amoo
Instructor: Dr B.
Program: Chapter 7 Arrays
Date: 2/24/25
Description: Basic Array
Class: CSC 152 02
I, Michael Amoo, pledge to follow with class header and main method header.
*/
import java.util.Arrays;
import java.util.Scanner;

public class AmooM_Lab6 {
   public static void main(String[] args) {
   
   Scanner keyboard = new Scanner(System.in); 

   
   //Part A - Array and String Manipulation Print
   System.out.println("\nPart A - Array and String Manipulation Print");
String[] friendsList = new String[5]; //array of 5 friends

System.out.println("Enter the 5 of friends you have: ");

for (int i = 0; i < friendsList.length; i++) {
   friendsList[i] = keyboard.nextLine();
   }

System.out.println("Your friends are: ");

for (String tmp : friendsList) { //Remember to use String tmp not int tmp
    System.out.println(tmp + " has " + tmp.length() + " characters - " + tmp.toUpperCase().charAt(0) 
                           + " " + tmp.toUpperCase().charAt(tmp.length() - 1));
   }                    


//Part B - Copy and Compare Arrays

System.out.println("\nPart B - Copy and Compare Arrays\n");

int[] listA = {5, 8, 4, 19, 3, 15, 2, 20}; //initial array
double[] listB = new double[listA.length * 2]; //Make it double the size of listA
int[] listC = new int[listA.length]; //Make it the same size as listA

for (int i = 0; i < listA.length; i++) {
   listB[i] = listA[i]; //copy listA to listB
   listC[i] = listA[i]; //copy listA to listC
}
listC[4] = 25; //change the 5th element of listC to 25

System.out.println("List A:"); //Print A-C
for (int tmp : listA) {
   System.out.print(tmp + ", ");
   }

System.out.println("\nList B:");
for (double tmp : listB) {
   System.out.print(tmp + ", ");
   }

System.out.println("\nList C:");
for (int tmp : listC) {
   System.out.print(tmp + ", ");
   }

   //Comparing Arrays
   System.out.println("\nComparing List A and List C");
   System.out.println(Arrays.equals(listA, listC) ? "SAME" : "NOT SAME");

   //Part C - Array of Objects
   System.out.println("\nPart C - Array of Objects\n");
   int[] myScores_MKA = new int[100];
        int count = 0;
        
        System.out.println("\nEnter integers (max 100), -1 to stop:");
        while (count < 100) {
            int num = keyboard.nextInt();
            if (num == -1) 
            {break;}
            myScores_MKA[count++] = num;
        }
        
        System.out.println("\nEntered Numbers:");
        for (int i = 0; i < count; i++) {
            System.out.print(myScores_MKA[i] + "\t");
            if ((i + 1) % 10 == 0) System.out.println();
        }
        
        int sum = 0;
        int max = Integer.MIN_VALUE;
        int min = Integer.MAX_VALUE;
        
        for (int i = 0; i < count; i++) {
            sum += myScores_MKA[i];
            if (myScores_MKA[i] > max) 
            max = myScores_MKA[i];
            if (myScores_MKA[i] < min) 
            min = myScores_MKA[i];
        }
        
        double avg = (double) sum / count;
        
        System.out.println("\nTotal Numbers Entered: " + count);System.out.println("Sum: " + sum);
        System.out.println("Average: " + avg);
        System.out.println("Max: " + max);
        System.out.println("Min: " + min);















   }
   
   
 }