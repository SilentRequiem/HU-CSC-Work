/*
   Square class - given for Lab 7
   CSC 152 - Spring 2025 
   UPDATE with your information below
   NAME : Michael Amoo
   Section: Lab S3 / 3/21/25
   Class: CSC 152 02
   ID : 00549396
   File: Cube - Class
   I, Michael Amoo, pledge to follow the Honor Code in completing my Lab 7.
*/


public class Cube extends Square {

   private String material;

   //No args
   public Cube() {
      super(12); //Calls Square's constructor and make the default side 12
      material = "wood";
   }

   //Parameter constructor
   public Cube(int side, String material) {
      super(side); //Calls Square's constructor
      this.material = material;
   }

   //Accessor
   public String getMaterial() {
      return material;
   }

   //Mutator
   public void setMaterial(String newMaterial) {
      this.material = newMaterial;
   }

   //Override getArea method for S.Area of cube
   @Override
   public int getArea() {
      return super.getArea() * 6;
   }

   public int getVolume() {
      return super.getArea() * getSide();
   }

   //Override toString method
   @Override
   public String toString() {
      return super.toString() + "\tMaterial: " + material; //One Line Printout
   }
}
