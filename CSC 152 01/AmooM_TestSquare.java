import java.util.Scanner;

public class AmooM_TestSquare{
   public static void main(String[] args) {
      
      Square square1 = new Square(12, "Black"); 
      square1.changeColor("Red"); 
      square1.setSide(96); 
   
      System.out.println("Square 1:");
      System.out.println("Side: " + square1.getSide());
      System.out.println("Color: " + square1.getColor());
      System.out.println("Area: " + square1.getArea());
      System.out.println("Half Area: " + square1.getHalfArea());
      System.out.println("Perimeter: " + square1.getPerimeter());
      System.out.println("Number of objects created so far by square1: " + square1.getCount());
      System.out.println();
      
      Scanner keyboard = new Scanner(System.in);
      
      System.out.print("Enter side for square2: ");
      int side2 = keyboard.nextInt();
      keyboard.nextLine();
      
      System.out.print("Enter color for square2: ");
      String color2 = keyboard.nextLine();
   
      Square square2 = new Square(side2, color2);
   
      System.out.println("\nSquare 2:");
      System.out.println("Side: " + square2.getSide());
      System.out.println("Color: " + square2.getColor());
      System.out.println("Area: " + square2.getArea());
      System.out.println("Half Area: " + square2.getHalfArea());
      System.out.println("Perimeter: " + square2.getPerimeter());
      System.out.println();
   
      Square square3 = new Square(0, "");
      
      System.out.println("Number of objects created so far by square3: " + square3.getCount());
      System.out.println();
   
      int side3 = square1.getSide() + square2.getSide();
      String color3 = (side3 == square1.getSide()) ? square1.getColor() : ((side3 % 2 == 0) ? square2.getColor() : square3.getColor());
      square3.setSide(side3);
      square3.changeColor(color3);
   
      System.out.println("Square 3:");
      System.out.println("Side: " + square3.getSide());
      System.out.println("Color: " + square3.getColor());
      System.out.println("Area: " + square3.getArea());
      System.out.println("Half Area: " + square3.getHalfArea());
      System.out.println("Perimeter: " + square3.getPerimeter());
      System.out.println();
   
      int totalArea = square1.getArea() + square2.getArea() + square3.getArea();
      System.out.println("Total Area of all 3 squares: " + totalArea);
      
      /*
      
      Michael Kwabena Amoo: No because it goes up by 1 each time another square is created.
      
      */
      
      Square square4 = square1.copy();
      System.out.println("\nSquare 1:");
      System.out.println(square1.toString());
      System.out.println("\nSquare 4 (copy):");
      System.out.println(square4.toString());
      
      square4.changeColor("Magenta");
      System.out.println("\nSquare 4 (Update):");
      System.out.println(square4);
      
      Square square5 = square2.copy();
      System.out.println("\nSquare 2:");
      System.out.println(square2.toString());
      System.out.println("\nSquare 5 (copy):");
      System.out.println(square5.toString());
      
      square5.setSide(square5.getSide() * 2);
      System.out.println("\nDoubled Side of Square 5:");
      System.out.println(square5);
      
      if (square1.equals(square4)) {
         System.out.println("\nSAME");
      } else {
         System.out.println("\nDIFFER");
      }
      
      totalArea = square1.getArea() + square2.getArea() + square3.getArea() + square4.getArea() + square5.getArea();
      System.out.println("\nTotal Area of all 5 squares: " + totalArea);
      
      System.out.println("\nMichael Kwabena Amoo, Computer Science");
   }
}
