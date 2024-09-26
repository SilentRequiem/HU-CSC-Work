/*Name: MIchael Amoo
Date: September 25, 2024
File: [Class]
“I, Michael Amoo, pledge to follow the Honor Code in taking my Lab 4.”
*/

public class Triangle {
   private int base;
   private int height;
   private String color;
   
   public Triangle() {
   base = 10;
   height = 5;
   color = "BLUE";
   }
   
   public Triangle(int aBase, int aHeight, String aColor)
   {
      base = aBase;
      height = aHeight;
      color = aColor;
   }
   
   public void updateBase(int newBase)
   { base = newBase; }
   
   public void setHeight(int newHeight)
   { height = newHeight; }
   
   public void changeColor(String newColor)
   { color = newColor; }
   
   public int getBase()
   { return base; }

   public int getHeight()
   { return height; }
   
   public String getColor()
   { return color; }
   
   public int getArea()
   { return ((base * height) /2 ); }
   
   public String toString()
   { return 
     "Triangle Information:\n\t" + "- base is " +  getBase() + " and height is " + getHeight()
     + "\n\t- color is " + getColor() 
     + "\n\t- area of this triangle is " + getArea() + ".";
   }
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
}