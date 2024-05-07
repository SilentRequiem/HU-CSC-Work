import java.util.Scanner;
public class AmooM_Exam3Q2Driver {
   public static void main(String args[]) {
   
//Part A   
   Pyramid pyrONE = new Pyramid();
   pyrONE.setSide(96);

//Part B
   Scanner keyboard = new Scanner(System.in);
   System.out.println("Enter side, height, color, and material in that order:");
   double side = keyboard.nextDouble();
   double height = keyboard.nextDouble();
   keyboard.nextLine();
   String color = keyboard.nextLine();
   String material = keyboard.nextLine();
   Pyramid pyrTWO = new Pyramid(side, height, color, material);

//Part C
   pyrTWO.setColor(pyrONE.getColor());

//Part D
   Pyramid pyrThree = new Pyramid(pyrONE.getSide(), pyrTWO.getColor());

//Part E
   System.out.println("Printing information for Pyramid#1:");
   System.out.println(pyrONE.toString());
   System.out.println("\nPrinting information for Pyramid#2:");
   System.out.println(pyrTWO.toString());
   System.out.println("\nPrinting information for Pyramid#3:");
   System.out.println(pyrThree.toString());

    }
}
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
