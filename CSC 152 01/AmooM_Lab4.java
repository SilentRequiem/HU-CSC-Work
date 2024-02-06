/*
Name: Michael Amoo
Section: S1 / February 6, 2024
File: Driver
“I, Michael Amoo, pledge to follow the Honor Code in taking my Lab 4.”
*/
import java.util.Scanner;
public class AmooM_Lab4{
   public static void main(String[] args)
{

   Scanner keyboard = new Scanner(System.in);
   //Create trill object
   Triangle tri1 = new Triangle();
   System.out.println(tri1.toString());
   tri1.updateBase(6); //Last digit ID
   System.out.println("After update: " + tri1);
   
   //read input for tri2
   System.out.print("Enter base: ");
   int base = keyboard.nextInt();
   System.out.print("Enter height: ");
   int height = keyboard.nextInt();
   keyboard.nextLine(); //clear buff
   System.out.print("Enter color: ");
   String color  = keyboard.nextLine();
   
   //create tri2 object with parameter constructor
   Triangle tri2 = new Triangle(base, height, color);
   System.out.println("Tri2: " + tri2);
   
   //get tri3
   base = tri1.getBase() + tri2.getBase();
   height = tri1.getHeight() + tri2.getHeight();
   if (base % 2 == 1) //odd check
      color = tri1.getColor();
   else
      color = tri2.getColor();
   //create tri3 object
   Triangle tri3 = new Triangle(base, height, color);
   System.out.println("Tri3 " + tri3);
   
   
   
   
   }
 }
    
   
   
   
   
   