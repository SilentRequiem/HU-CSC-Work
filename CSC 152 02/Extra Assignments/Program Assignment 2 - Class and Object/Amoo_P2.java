/*
Name: Michael Amoo
Instructor: Dr B.
Program: Program Assignment 2
Date: 2/28/25
File: Driver
Class: CSC 152 02
I, Michael Amoo, pledge to follow the Honor Code in completing my P2.
*/



import java.util.Scanner;

public class Amoo_P2 {
    public static void main(String[] args) {
    
    Scanner keyboard = new Scanner(System.in);
    
    Triangle tONE_MKA = new Triangle();

    System.out.println(tONE_MKA.toString());

    tONE_MKA.changeBase(396);
    tONE_MKA.setHeight(25);
    tONE_MKA.setColor("Blue");
    
    System.out.println("\nTriangle1:");
    System.out.println(tONE_MKA.toString());

    System.out.println("\nEnter the base of the triangle2: ");
    int tBase = keyboard.nextInt();

    System.out.println("\nEnter the height of the triangle2: ");
    int tHeight = keyboard.nextInt();

    keyboard.nextLine();

    System.out.println("\nEnter the color of the triangle2: ");
    String tColor = keyboard.nextLine();
    
    Triangle tTWO_MKA = new Triangle(tBase, tHeight, tColor);

    System.out.println("\nTriangle2:");
    System.out.println(tTWO_MKA.toString());

    Triangle tTHREE_MKA = new Triangle();

    tTHREE_MKA.changeBase(tTWO_MKA.getBase());
    tTHREE_MKA.setHeight(tONE_MKA.getHeight());

    if (tTHREE_MKA.getBase() % 2 == 0) { //if the base is odd
        tTHREE_MKA.setColor(tONE_MKA.getColor());
    } else {
        tTHREE_MKA.setColor(tTWO_MKA.getColor()); //if the base is even
    }

    System.out.println("\nTriangle3:");
    System.out.println("\n\tBase is " + tTHREE_MKA.getBase() + "\n\tHeight is " + tTHREE_MKA.getHeight() + "\n\tColor is " + tTHREE_MKA.getColor());

    System.out.println("\nCurrent color of triangle1: " + tONE_MKA.getColor());
    System.out.println("Update the color of triangle1:");
    tColor = keyboard.nextLine();
    
    tONE_MKA.setColor(tColor);

    System.out.println("\nNow the color is " + tONE_MKA.getColor());

    System.out.println("Area of triangle1: " + tONE_MKA.calArea());
    System.out.println("Area of triangle2: " + tTWO_MKA.calArea());
    System.out.println("Area of triangle3: " + tTHREE_MKA.calArea());
    System.out.println("Sum of the areas: " + (tONE_MKA.calArea() + tTWO_MKA.calArea() + tTHREE_MKA.calArea()));

    keyboard.close();
    }
}