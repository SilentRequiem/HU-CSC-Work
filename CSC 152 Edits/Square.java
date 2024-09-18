/* Name: Michael Amoo
   Section 152 S1 September 18 2024
   File: Class
   "I, Michael Amoo, pledge to follow the Honor Code in taking my Lab 3."
*/

public class Square {
   //Atributes
   private int side;
   private String color;
   
   //constructor
   public Square()
   {
    side = 5;
    color = "blue";
   
   }

   public Square (int aSide, String aColor)
   {
      side = aSide;
      color = aColor;
   }
   //mutator
   public void setSide(int newSide)
   {
      side = newSide;
   }
   
   public void changeColor(String newColor)
   {
      color = newColor;
   }
   
   public int getSide()
   {
      return side;
   }
   
   public String getColor()
   {
      return color;
   }
   
   
   public int getPerimeter()
   {
      return side * 4;
   }
   
   public int getArea()
   {
     return side * side;
   }
   
   public double getHalfArea() 
   { 
      return (double) 0.5 * getArea(); 
   }
   
   public String toString()
   {
   
   String msg = "\nSquare Info: " + "\n\tside is " + side + "\n\tcolor is " + color
               + "\n\tarea is " + getArea() 
               + ", half Area is " + getHalfArea() 
               + "\n\tperimeter is " + getPerimeter();
               
               return msg;
   
   }






   } //End
   