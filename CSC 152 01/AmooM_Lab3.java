//Name: Michael Amoo
//Section: S1/ 1/30/24
//File: Driver
//"I, Michael Amoo, pledge to follow the Honor Code in taking my Lab 3."

//Part B
import java.util.Scanner;
public class AmooM_Lab3
{
   public static void main(String[] args)
   {
      Scanner keyboard = new Scanner(System.in);
      
      //Create 3 Rectangle object
      Rectangle posterA = new Rectangle();
      Rectangle posterB = new Rectangle();
      Rectangle posterC = new Rectangle();
      
      //Poster A
      System.out.print("Enter the name of poster A: ");
      String name = keyboard.nextLine();
      System.out.print("Enter the length of poster A: ");
      double length = keyboard.nextDouble();
      System.out.print("Enter the width of poster A: ");
      double width = keyboard.nextDouble();
      keyboard.nextLine();
      
      //Poster B
      System.out.print("\nEnter the name of poster B: ");
      String nameB = keyboard.nextLine();
      System.out.print("Enter the length of poster B: ");
      double lengthB = keyboard.nextDouble();
      System.out.print("Enter the width of poster B: ");
      double widthB = keyboard.nextDouble();
      keyboard.nextLine();
      
      //Poster C
      System.out.print("\nEnter the name of poster C: ");
      String nameC = keyboard.nextLine();
      System.out.print("Enter the length of poster C: ");
      double lengthC = keyboard.nextDouble();
      System.out.print("Enter the width of poster C: ");
      double widthC = keyboard.nextDouble();
      keyboard.nextLine();
      
      
      //Update value to posterA
      posterA.changeName(name);
      posterA.setLength(length);
      posterA.setWidth(width);
      
      //Update value to posterB
      posterB.changeName(nameB);
      posterB.setLength(lengthB);
      posterB.setWidth(widthB);
      
      //Update value to posterC
      posterC.changeName(nameC);
      posterC.setLength(lengthC);
      posterC.setWidth(widthC);
      
      //Print
      System.out.println("\n\nThe " + posterA.getName() + " Poster is " + posterA.getLength() + " by " + posterA.getWidth() + "." 
                        + "\n\t- area of this poster is " + posterA.calcArea() + " square inches."
                        + "\n\t- perimeter of this poster is " + posterA.calcPerimeter() + " inches.");
                        
     //PrintB
      System.out.println("\n\nThe " + posterB.getName() + " Poster is " + posterB.getLength() + " by " + posterB.getWidth() + "." 
                        + "\n\t- area of this poster is " + posterB.calcArea() + " square inches."
                        + "\n\t- perimeter of this poster is " + posterB.calcPerimeter() + " inches.");
     
     //PrintC
      System.out.println("\n\nThe " + posterC.getName() + " Poster is " + posterC.getLength() + " by " + posterC.getWidth() + "." 
                        + "\n\t- area of this poster is " + posterC.calcArea() + " square inches."
                        + "\n\t- perimeter of this poster is " + posterC.calcPerimeter() + " inches.");
                        
     //Get total                  
     double totalArea = posterA.calcArea() + posterB.calcArea() + posterC.calcArea();
     double totalPeri = posterA.calcPerimeter() + posterB.calcPerimeter() + posterC.calcPerimeter();
     
     //Print
     System.out.println("\nThe total area is " + totalArea);
     System.out.println("The total perimeter is " + totalPeri);
                       
     
                         


   }
}