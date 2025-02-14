/*
Name: Michael Amoo
Section: S3 / 2/5/25
File: [Driver]
“I, Michael Amoo, pledge to follow the Honor Code in taking my Lab 4.”
*/
import java.util.Scanner;


public class AmooM_Lab4 {
   public static void main(String[] args) {
   
   Scanner keyboard = new Scanner(System.in);
   Square square1 = new Square();
   
   System.out.println(square1); //Lab 4 - print object //same as .toString()
   
   square1.changeColor("Blue"); //default values
   square1.setSide(96); //default values
   
   System.out.println("square1: ");
   System.out.println("\tside is " + square1.getSide() + "\n\tcolor is " + square1.getColor()
            + "\n\tarea is " + square1.getArea() + "\n\tperimeter is " + square1.getPerimeter()
            + "\n\thalf area is " + square1.getArea() / 2 ); //Manual toString
   
      // Square square2 = new Square(); //Square2 define
        
//       System.out.println("Enter your favorite color: ");
//       square2.changeColor(keyboard.nextLine());
//       
//       System.out.println("Enter your side: ");
//       square2.setSide(keyboard.nextInt());
//       keyboard.nextLine();// clear buffer

   //Lab 4 - parameter constructor
    int side;
    String color;
    
   System.out.println("Enter your favorite color: ");
   color = keyboard.nextLine();       
   System.out.println("Enter your side: ");
   side = keyboard.nextInt();
   keyboard.nextLine();// clear buffer
    
    
    
   Square square2 = new Square(side, color); //Parameter constructor
   
   System.out.println("Square2 info");
   System.out.println(square2.toString());
   
   // Square square3 = new Square();
//    
//    square3.setSide(square1.getSide() + square2.getSide()); //total of sides from square1 and square2
//    square3.changeColor(square1.getColor()); // SQ3 color = SQ1 color

   Square square3 = new Square(square1.getSide() + square2.getSide(), square1.getColor() ); //Lab 4 - parameter constructor
   
   System.out.println("Square3 before update - " + square3);
   //update side
   System.out.print("Enter a new side: ");
   side = keyboard.nextInt();
   square3.setSide( side );
   System.out.println("Square3 after update - " + square3);
   
   int totalArea = square1.getArea() + square2.getArea() + square3.getArea();
   int totalPerimeter = square1.getPerimeter() + square2.getPerimeter() + square3.getPerimeter();
   double totalHalfArea = square1.getHalfArea() + square2.getHalfArea() + square3.getHalfArea();
   
   System.out.println("The total area of 3 squares is " + totalArea + " square inches.");
   System.out.println("The total perimeter of 3 squares is " + totalPerimeter  + " inches.");
   System.out.println("The total half area of 3 squares is " + totalHalfArea  + " square inches.");
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   }
}