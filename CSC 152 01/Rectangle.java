//Name: Michael Amoo
//Section: S1/ 1/30/24
//File: Class
//"I, Michael Amoo, pledge to follow the Honor Code in taking my Lab 3."

//Part A
public class Rectangle {

//Attributes
private String name;
private double length;
private double width;

//Mutator (Changes value of attributes)
public void changeName(String newName)
{ name = newName; }
public void setLength(double len)
{ length = len; }
public void setWidth(double w)
{ width = w; }

//accessor method (Returns the current values
public String getName()
{ return name; }
public double getLength()
{ return length; }
public double getWidth()
{ return width; }
  
//calculate methods
public double calcArea()
{ return length * width; }
public double calcPerimeter()
{ return 2 * (length + width); }}