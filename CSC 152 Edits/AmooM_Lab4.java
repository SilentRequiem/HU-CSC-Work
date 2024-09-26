/*Name: MIchael Amoo
Date: September 25, 2024
File: [Driver]
“I, Michael Amoo, pledge to follow the Honor Code in taking my Lab 4.”
*/

import java.util.Scanner;
public class AmooM_Lab4{
   public static void main(String[] args)
{
  Scanner keyboard = new Scanner(System.in);
//Triangle 1   
   Triangle tri1 = new Triangle();
   
//Print toString
   System.out.println("tri1");
   System.out.println(tri1.toString());
   
//ID Last 4 (9396)
   tri1.updateBase(6);
   
//Reprint toString
   System.out.println("\nReprint of tri1");
   System.out.println(tri1.toString());   


//Triangle 2
 
 System.out.print("\nEnter a base: ");
 
 int eBase = keyboard.nextInt();
 
 System.out.print("Enter a height: ");
 
 int eHeight = keyboard.nextInt();
 keyboard.nextLine();
 
 System.out.print("Enter a color: ");
 String eColor = keyboard.nextLine();
 
 
 Triangle tri2 = new Triangle();
 tri2.updateBase(eBase);
 tri2.setHeight(eHeight);
 tri2.changeColor(eColor);
 
//Print tri2
 System.out.println("\ntri2");
 System.out.println(tri2.toString());

//Triangle 3
   
   int base3 = tri1.getBase() + tri2.getBase();
   int height3 = tri1.getHeight() + tri2.getHeight();
   String color3;
   
   if (base3 % 2 == 0 )
    { color3 = tri2.getColor(); }
    
   else
   { color3 = tri1.getColor(); }
   
   Triangle tri3 = new Triangle(base3, height3, color3);
//Print tri3 
   System.out.println("\ntri3"); 
   System.out.println(tri3.toString());
   
//Total
int totalArea = (tri1.getArea() + tri2.getArea() + tri2.getArea());
System.out.println("\nThe total area of 3 triangle is " + (totalArea) + ".");
   




















   }
}