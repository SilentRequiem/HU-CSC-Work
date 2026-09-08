//Name: Michael Amoo
//Instructor: Dr. Muhammad and Dr. Boonthum-Denecke
//Class: CSC-100-33
//Date: July 5, 2023 
//Description: Review for Hands on Exam (Practice)
///////////////////////////////////////////////////

import java.util.Scanner;

public class AmooM_ReviewLabEx
  {
   public static void main(String[] args)
   
   {
  //Scanner  
  Scanner keyboard = new Scanner(System.in); 
  
  //Part A - Read Input from Keyboard using Scanner
  
   //Inputs   
   System.out.print("Input your fullname: ");
      String fullname = keyboard.nextLine(); 
   
   System.out.print("Input your number of siblings: ");
      int noSiblings = keyboard.nextInt(); 
  
   keyboard.nextLine();
   
   System.out.print("Input your hometown (City, State): ");
      String hometown = keyboard.nextLine();
  
   System.out.print("Input your GPA: ");
      double hsGPA = keyboard.nextDouble();
   
   System.out.print("Input your highschool name: ");
      String highSchoolName = keyboard.nextLine();
   
   keyboard.nextLine();

   int size = fullname.length();
   String upper = fullname.toUpperCase();
   String lower = fullname.toLowerCase();
   char thirdLetter = fullname.charAt(0);
   
   
   System.out.println("\nMy name is " + fullname + ", from " + hometown
                                    + ". " + "I have " + noSiblings
                                    + " siblings in my family.");
   
   System.out.println("     I attend " + highSchoolName +
    " and graduated with an overall " + hsGPA + " GPA."); 
   
   System.out.println("\nName, which is " + fullname + ", has " + size + " characters.");
   
   System.out.println("\nMy Hometown is " + hometown + ".");
   System.out.println("     UPPERCASE of hometown is " + upper + ".");
   System.out.println("     lowercase of hometown is " + lower + ".");
   System.out.println("     The third character of my hometown is " + thirdLetter + ".");
   


   
   
   
   
   
   
   
   
   }
   
  }