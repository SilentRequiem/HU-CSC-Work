/*
Name: Michael Amoo
Instructor: Dr B.
Program: Lab 7 Inheritance
Date: 3/21/25
Description: Superclass and Extends
File: Driver
Class: CSC 152 02 / Lab Section 3
I, Michael Amoo, pledge to follow the Honor Code in completing my Lab 7.
*/
import java.util.Scanner;

public class AmooM_Lab7 {
   public static void main(String[] args) {
      Scanner keyboard = new Scanner(System.in);

      //Cube 1 creation
      Cube cube1 = new Cube();

      //Cube 2 creation
      System.out.print("Enter side length for cube2: ");
      int side2 = keyboard.nextInt();
      keyboard.nextLine(); // Consume newline
      System.out.print("Enter material for cube2: ");
      String material2 = keyboard.nextLine();
      Cube cube2 = new Cube(side2, material2);

      //Cube 3 creation
      System.out.print("Enter side length for cube3: ");
      int side3 = keyboard.nextInt();
      keyboard.nextLine(); //clear buff
      System.out.print("Enter material for cube3: ");
      String material3 = keyboard.nextLine();
      Cube cube3 = new Cube(side3, material3);

      //Printout for Each
      System.out.println("\nCube 1 Details:\n" + cube1);
      System.out.println("\nCube 2 Details:\n" + cube2);
      System.out.println("\nCube 3 Details:\n" + cube3);
      
      
      //Cube Updating Process 
      System.out.println("\nDo you want to update a cube? Y/N");
      String answer = keyboard.nextLine();
      Cube selectedCube = null; //No selection

          if (answer.equalsIgnoreCase("y")) {
          System.out.println("You picked yes");
      
          System.out.println("Which cube do you want to update? 1, 2, or 3?");
          answer = keyboard.nextLine();
      
          if (answer.equals("1")) {
              selectedCube = cube1;
          } else if (answer.equals("2")) {
              selectedCube = cube2;
          } else if (answer.equals("3")) {
              selectedCube = cube3;
          } else {
              System.out.println("Invalid selection. No cube updated.");
          }
               
               
              if (selectedCube != null) {   
              System.out.print("Enter new side length: ");
              int newSide = keyboard.nextInt();
              keyboard.nextLine(); 
      
              
              System.out.print("Enter new material: ");
              String newMaterial = keyboard.nextLine();
      
              //Applying updates
              selectedCube.setSide(newSide);
              selectedCube.setMaterial(newMaterial);
      
              System.out.println("\nUpdated Cube Details:\n" + selectedCube);
          }
      } else 
      {
          System.out.println("You said no, no updates made.");
      }

      
     
      

      //Calc S.Area & Volume
      int totalSurfaceArea = cube1.getArea() + cube2.getArea() + cube3.getArea();
      int totalVolume = cube1.getVolume() + cube2.getVolume() + cube3.getVolume();

      System.out.println("\nTotal Surface Area of all Cubes: " + totalSurfaceArea);
      System.out.println("Total Volume of all Cubes: " + totalVolume);

   }
}
