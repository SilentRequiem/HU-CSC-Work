/* 
Name: Michael Amoo
Section: 152 S1
Date: 4/16/24
Program: Arrays in-class exercises
 “I, Michael Amoo, pledge to follow the Honor Code in taking my Lab 13.”
*/
import java.util.Scanner;
import java.util.Arrays;

public class AmooM_Lab13
{
   public static void main(String[] args)
   {
   Scanner keyboard = new Scanner(System.in);
   int[] scores = new int[30];
        int index = 0;
        int total = 0;
        int highest = Integer.MIN_VALUE;
        int lowest = Integer.MAX_VALUE;

        // Part A: Partially Filled Integer Array
        System.out.println("Enter positive integers to fill the array (enter -1 to stop):");
        int input = keyboard.nextInt();
        while (input != -1 && index < scores.length) {
            if (input >= 0) {
                scores[index] = input;
                total += input;
                if (input > highest) {
                    highest = input;
                }
                if (input < lowest) {
                    lowest = input;
                }
                index++;
            }
            input = keyboard.nextInt();
        }

        // Print entered numbers
        System.out.println("Numbers entered by the user (10 numbers per line):");
        for (int i = 0; i < index; i++) {
            System.out.print(scores[i] + "\t");
            if ((i + 1) % 10 == 0) {
                System.out.println();
            }
        }

        // Print statistics
        System.out.println("\nTotal scores entered: " + index);
        System.out.println("Total of scores entered: " + total);
        System.out.println("Highest score entered: " + highest);
        System.out.println("Lowest score entered: " + lowest);

        // Part B: Sequential and Binary Search
        System.out.println("\nEnter a target number to search:");
        int target = keyboard.nextInt();

        // Sequential search
        boolean found = false;
        for (int i = 0; i < index; i++) {
            if (scores[i] == target) {
                found = true;
                break;
            }
        }

        if (found) {
            System.out.println("Target number is found in the array.");
        } else {
            System.out.println("Target number is not found in the array.");
        }

        // Create sortedScores array and perform binary search
        int[] sortedScores = Arrays.copyOf(scores, index);
        Arrays.sort(sortedScores);

        int binarySearchResult = Arrays.binarySearch(sortedScores, target);
        if (binarySearchResult >= 0) {
            System.out.println("Target number is found in the sorted array.");
        } else {
            System.out.println("Target number is not found in the sorted array.");
        }
    }
}