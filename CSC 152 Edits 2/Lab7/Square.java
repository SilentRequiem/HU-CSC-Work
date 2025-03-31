/*
   Square class - given for Lab 7
   CSC 152 02 - Spring 2025 
   UPDATE with your information below
   NAME : Michael Amoo
   Section: Lab S3 / 3/21/25
   ID : 00549396
   File: Square - this is superclass
   I, Michael Amoo, pledge to follow the Honor Code in completing my Lab 7.
*/
public class Square
{
   // attribute
   private int side; 
   // constructors
   public Square( ) 
   {
      side = 20; // default
   }
   public Square (int side)
   {
      this.side = side ;  // need this reference to differentiate between attribute and parameter
   }
   // accessor
   public int getSide( )
   {
      return side;
   }
   // mutator 
   public void setSide (int newSide)
   {
      side = newSide;
   }
   // calculated method - getArea
   public int getArea( )
   {
      return side * side;
   }
   // toString
   public String toString()
   { 
      String str = "side is " + side + "\t area is " + getArea();
      return str;
   }   
}