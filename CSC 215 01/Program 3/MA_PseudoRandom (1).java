/* 
Author: Michael Amoo
Instructor: Dr. Aneke
Class: CSC-215-01 Discrete Structures
Description: Random Numbers (Seed)
Date: 10/4/25
*/

public class MA_PseudoRandom {

    public static void main(String[] args) {

        //a long can hold larger numbers than an int
        //The LCG makes a seed number and generates a series of pseudo random numbers from it
        //Making it deterministic and repeatable

        //small series
        System.out.println("\nSmall series of Psuedo Random Numbers");

        int m = 11;
        int a = 7;
        int c = 5;
        int s = 3;

        for (int i = 0; i < 50; i++) { //loop 50 times
            long nextNumof50 = ((long)a * (long)s + (long)c) % (long)m; //LCG formula
            s = (int) nextNumof50;
            System.out.print(s + " ");
        }

        //large series
        System.out.println("\n\nLarge series of Psuedo Random Numbers");

        m = 2147483647;
        a = 16807;
        c = 0;
        s = 3;

        for (int i = 0; i < 50; i++) {          
            long nextNumof50 = ((long)a * (long)s + (long)c) % (long)m; //LCG formula
            s = (int) nextNumof50;
            System.out.print(s + " ");  
        }
        System.out.println();
    }
}
