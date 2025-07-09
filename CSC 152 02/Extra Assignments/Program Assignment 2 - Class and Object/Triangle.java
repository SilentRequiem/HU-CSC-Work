/*
Name: Michael Amoo
Instructor: Dr B.
Program: Program Assignment 2
Date: 2/28/25
File: Class
Class: CSC 152 02
I, Michael Amoo, pledge to follow the Honor Code in completing my P2.
*/





public class Triangle {

    //Attributes
    private int base;
    private int height;
    private String color;

    public Triangle() { //no args constructor (defaults)
    base = 96; //student ID
    height = 22; //day of birth day
    color = "February"; //Birth month name
    }

    public Triangle(int aBase, int aHeight, String aColor) {  //Parameter constructor (this.blah)
    this.base = aBase; 
    this.height = aHeight;
    this.color = aColor;
    }

    public void changeBase(int newBase) { //mutators methods
    this.base = newBase;
    }
   
    public void setHeight(int newH) {
    this.height = newH;
    }

    public void setColor (String newColor) {
    this.color = newColor;
    }

    public int getBase() { //accessor methods
    return base;
    }

    public int getHeight() {
    return height;
    }

    public String getColor() {
    return color;
    }

    public double calArea() {
    return (base * height) / 2;
    }

    public String toString() {
    return "Triangle Info:\n\tBase is " + base + "\n\tHeight is " + height + "\n\tColor is " + color;
    }

}