
/*
Name: Michael Amoo
Date: S3 / DATE: 2/5/25
File: [Class]
“I, Michael Amoo, pledge to follow the Honor Code in taking my Lab 4.”
*/

public class Square {
   private int side; //attributes
   private String color;
   
   public Square() { //no args constructor (defaults)
   side = 7;
   color = "BLUE";
   }
   
   public Square(int aSide, String aColor) {  //Parameter constructor //Basically for doing...Square sq1 = new Square(92, "Yellow");
   this.side = aSide;
   this.color = aColor;
   }
   
   public void setSide(int newSide) { //mutators methods
   this.side = newSide;
   }
   
   public void changeColor(String newColor) {
   this.color = newColor;
   }
   
   public int getSide() { //accessors methods
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
   
   public double getHalfArea() {
   return ((double) getArea() / 2); //or make 2, 2.0 so it comes as a double
   }
   
   public String toString() {
   return "Square Info:\n\tside is " + side
            + "\n\tcolor is " + color
            + "\n\tarea is " + getArea()
            + ", half area is " + getHalfArea()
            + "\n\tperimeter is " + getPerimeter();
   }
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   }
   