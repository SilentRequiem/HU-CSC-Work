import java.util.Scanner;

public class AmooM_P1_D
{  public static void main(String[] args)
   {
   Scanner keyboard = new Scanner(System.in);
   
   AmooM_P1_C sqONE = new AmooM_P1_C();
   sqONE.changeSide(396);
   
   System.out.println("Enter side: ");
   sqONE.changeSide(keyboard.nextInt());
   System.out.println("Enter color: ");
   keyboard.nextLine();
   sqONE.setColor(keyboard.nextLine());
   
   AmooM_P1_C sqTWO = new AmooM_P1_C();
   sqTWO.setColor(sqONE.getColor());
   sqTWO.changeSide(sqONE.getSide());
   
   AmooM_P1_C sqTHREE = new AmooM_P1_C();
   sqTHREE.changeSide(sqONE.getSide() + sqTWO.getSide());
   sqTHREE.setColor(sqONE.getColor());
   
   //Print 1
   System.out.print("sqONE: side is " + sqONE.getSide() + ", color is " + sqONE.getColor() + ", area is " + sqONE.calArea()
                     + ", and perimeter is " + sqONE.getPerimeter() + ".\nsqTWO: side is " + sqTWO.getSide()
                     + ", color is " + sqTWO.getColor() + ", area is " + sqTWO.calArea() + ", and perimeter is "
                     + sqTWO.getPerimeter() + ".");
   
   //Print 2
   System.out.println("\n\nsqONE special calc: " + sqONE.specialCalculation()
                     + "\nsqTWO special calc: " + sqTWO.specialCalculation()
                     + "\nsqTHREE special calc: " + sqTHREE.specialCalculation()
                     + "\nTotal: "
                     + (sqONE.specialCalculation() + sqTWO.specialCalculation() + sqTHREE.specialCalculation()));
                     
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   }
}