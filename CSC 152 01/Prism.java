/*
Name: Michael Amoo
Section: S1 / March 26, 2024
File: Class
“I, Michael Amoo, pledge to follow the Honor Code in taking my Lab 10.”
*/

public class Prism extends Triangle
{
//Part A: Prism Class Definition (extending/ inheriting from Triangle class)
   
   //Additon attribute for subclass
   private int length;
   private String material;
   //Constructor
   public Prism(int b, int h, String c)
   {
      super(12, 5, "Green"); //Superclass: refer from parent class
      length = 28;           //default values
      material = "wood";     //default values
   }
   
   public Prism(int b, int h, String c, int length, String material)
   {
      super(b, h, c); //parameter
      this.length = length;
      this.material = material;
      
   }
   
   //Accessor methods
   public int getLength() { return length; }
   public String getMaterial()  { return material; }
   
   //mutators
   public void setLength(int len) { length = len; }
   public void setMaterial(String m) { material = m;}
   
   //Overwrite getArea()
   public double getArea()
   {
      double perimeter = base + (Math.sqrt( (base * base) + (height * height)));
      double area = 2 * super.getArea() * perimeter + length;
      return area;
   }
      
   public double calcVolume()
   {
      return super.getArea() * length;
   }   
   
   //Overwrite toString
   public String toString()
   {
      String msg = "Prism Info: " +
                   super.toString() + //get the first part
                   "\n length is " + length +
                   "\n material is " + material +
                   "\n volume is " + calcVolume();
    return msg;
   }
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
}
   