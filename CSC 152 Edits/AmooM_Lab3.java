/* Name: Michael Amoo
   Section 152 S1 September 18 2024
   File: Driver
   "I, Michael Amoo, pledge to follow the Honor Code in taking my Lab 3."
*/



import java.util.Scanner;
public class AmooM_Lab3
{  public static void main(String[] args)
   {
   
   Scanner keyboard =  new Scanner(System.in);
   
   //square1
   Square square1 = new Square();
   square1.changeColor("black");
   square1.setSide(96);
   
   //Print
   System.out.println("\nSquare 1: " + "\n\tside is " + square1.getSide() + "\n\tcolor is " + square1.getColor() + "\n\tperimeter is " + square1.getPerimeter() );
   
   
   Square square2 = new Square();
   
   System.out.print("\nEnter side: ");
   square2.setSide(keyboard.nextInt());
   
   keyboard.nextLine();
   
   
   System.out.print("Enter color: ");
   square2.changeColor(keyboard.nextLine());  
  
   //Print out (toString)
   System.out.println(square2.toString());
  
   
   
   
   }
} 