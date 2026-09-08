// - Comments
//Author: Michael Amoo
//Instructor: Dr.B & Dr.M
//Program Name: TestPrg1.java
//Description: Learning to Prg In Java
//Date: June 26, 2023

//Java Program Structure
public class TestPrg1
{
   public static void main(String[] args)
   {
      // Print statement
      System.out.println("Michael Amoo");
      System.out.print("CSC ");
      System.out.println("Virginia");
      
      // Variables
      String name; 
      int age;
      double salary;
      char letter; //It Only holds one char at a time
      boolean myBool; //It can only have two values, true or false. This is also called a FLAG!!!
      myBool = false;
      
      //Define Variables (You can name your variables anything as long you and everyone else knows what it is and what it does)
      name = "Michael";
      age = 18;
      salary = 20000.00;
      letter = 'A'; //Use (') not (")
  System.out.println("My name is "+ name);
  System.out.println("My age is "+ age);
  System.out.println("My salary is "+ salary);
  System.out.println("My first char of last name is "+ letter);
  System.out.println("The value of myBool is "+ myBool);
  
  // You can redefine a variable
  myBool = true;
  System.out.println("The value of myBool is now "+ myBool);
  
     //Calulations (can use +,-,*,%)
      //Additon
      int num1 = 10;
      int num2 = 12;
      int sum;
      sum = num1 + num2;
      System.out.println("The sum of num1 and num2 is " + sum);
      //Subtraction
      int answer = num1 - num2;
      System.out.println("The difference of num1 and num2 is " + answer);
      // Modules - retrieving the remainder
      int num3 = 6, num4 = 5;
      int remainder = num3 % num4; //--> remainder
      System.out.println("Modulus: of 6 modulus 5 is " + remainder);
  
   }//end off main world
}//end class TestPrg1



//Self Note: Semi colon (;) after every STATEMENT!
//Self Note: Quotes for strings! ("")
//Self Note: Variables store values
//Self Note: Compile (The + on the top bar) is used to check if you have errors
//Self Note: The running man is used to run the code
//Self Note: Remember to COMMENT