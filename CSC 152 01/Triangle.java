/*
Name: Michael Amoo
Section: S1 / February 6, 2024
File: Class
“I, Michael Amoo, pledge to follow the Honor Code in taking my Lab 4.”
*/

public class Triangle {

//attributes
private int base;
private int height;
private String color;

//no arg construtor (intilizes a value for the attriable)
public Triangle()
{
   base = 10;
   height = 5;
   color = "BLUE";
}

//parameter constructor
public Triangle(int aBase, int aHeight, String aColor)
{
   base =  aBase;
   height = aHeight;
   color = aColor;
}
public void updateBase (int newBase)
{base = newBase; }

public void setHeight (int newHeight)
{ height = newHeight; }

public void changeColor (String newColor)
{ color = newColor; }


//Calc

public int getBase()
{ return base; }

public int getHeight()
{ return height; }

public String getColor()
{ return color; }

public double getArea()
{ return (double) base * height / 2; }


//toString
public String toString()
{
   String msg = "Triangle Information: " + "\n\t - base is " + base
                  + base + " and height is " + height
                  + "\n\t - color is " + getColor()
                  + "\n\t - area of this triangle is "
                  + getArea() + ".";
                  return msg;
   
   }
}
