public class Square {
   private int side;
   private String color;
   private static int cntSquare = 0;

    
   public Square() {  //Empty Constructor: Anything that doesn't have something in the "()", when creating the object it set it to those values (Default)
      side = 15;
      color = "Cyan";
      cntSquare++;
   }  
   
   
  
   //Attributes
   public Square(int aSide, String aColor) {
      side = aSide;
      color = aColor;
      cntSquare++;
   }
   
   public Square(Square s2) 
   {
      side = 15;
      color = "Cyan";
      cntSquare++;
   }
   
   public void setSide(int newBase)
   { side = newBase; }
   
   public void changeColor(String newColor) 
   { color = newColor; }
   
   public Square copy () 
   { 
      return new Square(this); }
   
   public boolean equals(Square s2)
   
   { 
      return side == s2.side && color.equals(s2.color); }
   
   public int getCount()
   { 
      return cntSquare; }
   
   public int getSide() 
   { 
      return side; }

   public String getColor() 
   { 
      return color; }

   //Calc
   public int getPerimeter() 
   { 
      return 4 * side; }

   public int getArea() 
   { 
      return side * side; }

   public double getHalfArea() 
   { 
      return (double) 0.5 * getArea(); }
   
   public String toString() {
      return "Square Information:\n\tSide: " + this.side + "\n\tColor: " + this.color 
         + "\n\tArea: " + getArea() 
         + "\n\tHalf Area: " + getHalfArea() 
         + "\n\tPerimeter: " + getPerimeter();
   }
}
