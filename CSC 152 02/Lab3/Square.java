/*
Name: Michael Amoo
Section: S3 / 1/29/25
File: [Class]
“I, Michael Amoo, pledge to follow the Honor Code in taking my Lab 3.”
*/

public class Square {

   //attributes
   private int side;
   private String color;
   
   
   //mutators methods
   public void setSide(int newSide)
   {
     this.side = newSide;
   }
   
   public void changeColor(String newColor)
   {
      this.color = newColor;
   }
   
   
   //accessors methods
   public int getSide() {
    return side;
   }
   
   public String getColor() {
   return color;
   }
   
   public int getPerimeter() {
    return side * 4;
   }
   
   public int getArea() {
   return side * side;
   }
   
   public String toString() {
   return "Square Info:\n\tside is " + side + "\n\tcolor is " + color
            + "\n\tarea is " + getArea() + "\n\tperimeter is " + getPerimeter();
   }

  
}
