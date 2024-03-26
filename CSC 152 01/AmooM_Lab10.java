/*
Name: Michael Amoo
Section: S1 / March 26, 2024
File: Driver
“I, Michael Amoo, pledge to follow the Honor Code in taking my Lab 10.”
*/
import java.util.Scanner;
public class AmooM_Lab10 {
   public static void main(String[] args)
   {
   
   Scanner keyboard = new Scanner(System.in);
   System.out.println("Enter base, height, length, color, and material: ");
   int base = keyboard.nextInt();
   int height = keyboard.nextInt();
   int length = keyboard.nextInt();
   keyboard.nextLine();
   
   String color = keyboard.nextLine();
   String material = keyboard.nextLine();
   
   Prism pri3 = new Prism(base, height, color, length, material);
   System.out.println("Prism 3: " + pri3);
   System.out.println("Before update material was: " + pri3.getMaterial());
   pri3.setMaterial("Marble");
   System.out.println("After update material is now: " + pri3.getMaterial());
   
   System.out.println("\n ");
   
   System.out.println("Prism 3: " + pri3);
   System.out.println("Before update color was: " + pri3.getColor());
   pri3.changeColor("Blue");
   System.out.println("After update color is now: " + pri3.getColor());
   
   System.out.println("\n ");
   
   System.out.println("Prism 3: " + pri3);
   System.out.println("Before update length was: " + pri3.getLength());
   pri3.setLength(21);
   System.out.println("After update length is now: " + pri3.getLength());
   
   
   
   
   
   
   
   }
}