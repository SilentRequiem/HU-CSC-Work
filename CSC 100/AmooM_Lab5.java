// Author: Michael Amoo
// Instuctor : Dr. M & Dr. B
// Class: CSC-100
// Description: Lab 5
// Date: June 30, 2023


public class AmooM_Lab5
{ //start class
   public static void main(String[] args)
   { 
      //order if precedence
      // (- right to left) (* / % left to right) (- + left to right)
      
     double a = 3, b = 4, c =5; 
     double answer1, answer2, answer3, answer4;
     
   // #1) -4 + 3 * 7 -5
   answer1 = -4 + 3 * 7 -5;
   System.out.println("Answer1: " + answer1);
   /* Order of precednece
   1) -4;
   2) 3 * 7
   3) +
   4)- 5
   */
   
   
   // #2) 6 * 3 % 5 + 6 - 2 * 4 
   answer2 = 6 * 3 % 5 + 6 - 2 * 4;
   System.out.println("Answer2: " + answer2);
   /*
   1) 6 * 3
   2) 18 % 5
   3) 2 * 4
   4) + 6
   */
   
   // #3) 2a + 4c + 12
   answer3 = (2 * a) + (4 * c) + 12;
   System.out.println("Answer3: " + answer3);
   /*
   1) 2 * a
   2) 4 * 2
   3) + 12
   */
   
   // #4) sqrt(a + 4b * 3)
   answer4 = Math.sqrt(a + (4 * b) * 3);
   System.out.println("Answer4: " + answer4);
   /*
   1)4 * b
   2)* 3
   3)+ a
   6)Math.sqrt
   */
   
      // Combined assignment operator
  
   int t = 3, n =6, s = 10;
   
   t = t % 2;   // Covert to combined assignment operator
   System.out.println("t: "+ t);
   
   n = n * 15;
   System.out.println("n: "+ n);
   
   s = s + n;
   System.out.println("s: "+ s);
   
   n = n / 5;
   System.out.println("n: "+ n);
   
   
   } // end main method
} //ending of program