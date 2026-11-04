import java.util.Scanner;

/* 
Author: Michael Amoo
Instructor: Dr. Abu Bakar Siddiqur Rahman
Class: CSC-215-02 Discrete Structures
Description: Programming Assignment 3 - Antisymmetric Relation
Date: 10/23/26
*/

public class AmooM_PA3 {
    public static void main(String[] args) {

        Scanner keyboard = new Scanner(System.in);

        //Read the number of employees and create the graph
        System.out.print("Enter number of employees: ");
        int n = keyboard.nextInt();

        int[][] graph = new int[n][n];

        //Read the number of permissions
        System.out.print("Enter number of permissions: ");
        int m = keyboard.nextInt();

        System.out.println("Use employee numbers from 0 to " + (n - 1));
        System.out.println();

        //Read each permission pair and store it in the graph
        for (int k = 0; k < m; k++) {
            System.out.println("Permission " + (k + 1) + ":");

            System.out.print("Enter sender employee number: ");
            int sender = keyboard.nextInt();

            System.out.print("Enter receiver employee number: ");
            int receiver = keyboard.nextInt();

            graph[sender][receiver] = 1;
        }

        //Assume the relation is antisymmetric until a violation is found
        boolean antisymmetric = true;

        //Check for two different employees with permissions in both directions
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (i != j && graph[i][j] == 1 && graph[j][i] == 1) {
                    antisymmetric = false;
                }
            }
        }

        //Print the final result
        if (antisymmetric) {
            System.out.println("The relation is antisymmetric.");
        } else {
            System.out.println("The relation is not antisymmetric.");
        }
    }
}
