import java.util.Scanner;

public class AmooM_TestSquare{
    public static void main(String args[]) {
        
        Square square1 = new Square(12, "Black"); 
        square1.changeColor("Red"); 
        square1.setSide(96); 

        System.out.println("Square 1 Information:");
        System.out.println("Side: " + square1.getSide());
        System.out.println("Color: " + square1.getColor());
        System.out.println("Area: " + square1.getArea());
        System.out.println("Half Area: " + square1.getHalfArea());
        System.out.println("Perimeter: " + square1.getPerimeter());
        System.out.println();
        
        Scanner keyboard = new Scanner(System.in);
        System.out.print("Enter side for square2: ");
        int side2 = keyboard.nextInt();
        System.out.print("Enter color for square2: ");
        String color2 = keyboard.nextLine();

        Square square2 = new Square(side2, color2);

        System.out.println("Square 2 Information:");
        System.out.println("Side: " + square2.getSide());
        System.out.println("Color: " + square2.getColor());
        System.out.println("Area: " + square2.getArea());
        System.out.println("Half Area: " + square2.getHalfArea());
        System.out.println("Perimeter: " + square2.getPerimeter());
        System.out.println();

        Square square3 = new Square(0, "");

        int side3 = square1.getSide() + square2.getSide();
        String color3 = (side3 == square1.getSide()) ? square1.getColor() : ((side3 % 2 == 0) ? square2.getColor() : square3.getColor());
        square3.setSide(side3);
        square3.changeColor(color3);

        System.out.println("Square 3 Information:");
        System.out.println("Side: " + square3.getSide());
        System.out.println("Color: " + square3.getColor());
        System.out.println("Area: " + square3.getArea());
        System.out.println("Half Area: " + square3.getHalfArea());
        System.out.println("Perimeter: " + square3.getPerimeter());
        System.out.println();

        int totalArea = square1.getArea() + square2.getArea() + square3.getArea();
        System.out.println("Total Area of all 3 squares: " + totalArea);
    }
}
