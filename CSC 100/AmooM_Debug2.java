/////////////////////////////////////////////////////////////
// Comments at the beginining
//Author: Michael Amoo
//Instructor: Dr. Muhammad and Dr. Boonthum-Denecke
//Class: CSC-100-33
//Date: June 30, 2023 -- you will have until July 3rd (1pm) to submit this assignment
//Description: Debugging Assignment 2
//             You will compile and modify this code to make it work
//             Please make sure to replace your information 
////////////////////////////////////////////////////////////

//**************************************************************
// Instruction:  For everything that you fix, you will need 
//               to put in a comment ABOVE or END of the line that you fixed
//**************************************************************

//================================ NO ERROR ABOVE THIS LINE =============================

// import Scanner class
// add (;), change "java.Util.scanner" to
import java.util.Scanner;

public class AmooM_Debug2    // please make sure that you replace LASTNAME and first-inital with your own

//Flip {{ to }} at the end of file

{
   // change "MAIN" to "main", remove ";"
   public static void main(String[] args) // Main Method Header
   {
   
   // change "scanner" to "Scanner" and remove the space between scanner and (sytem,in)
   // change (system.in) to (System.in)
      Scanner keyboard = new Scanner(System.in); // Create Scanner object to read from keyboard
     
      //Part A: read 3 integers, calculate sum and average. Average should have correct decimal point 
      int num1, num2, num3, sum;
      double average;
            
      //A.1) read input from keyboard
      //Change capitalizations, misspellings, and add "()"
      System.out.print("Enter the first integer: " );
      num1 = keyboard.nextInt();
      
      System.out.print("Enter the second integer: " );
      num2 = keyboard.nextInt();
      
      System.out.print("Enter the third integer: " );
      num3 = keyboard.nextInt();
      
      //A.2) calculate sum
      //remove "int", change the l in "numl" to 1, add ";"
      sum = num1 + num2 * num3;
      
      // A.3) calculate average
      average = sum/3;
      
      // A.4) print out result -- make sure to check spacing
      //change "num 3" to "num3"
      //change "Sytem.out.print1n" to "System.out.println"
      //change "system.Out.println" to "System.out.println"
      //Add " here --> (is ")
      //Optional: add spaces for readability
      System.out.println("You enter 3 integers: " + num1 + "," + num2 + ", and" + num3);
      System.out.println("Sum of these integers is " + sum);
      System.out.println("Average of these integers is "  + average);
      
      
      // Part B: Reading mixed data type - String, int, double
      //Add "t" at System.out.prin
      //change "Int" to "int"
      //change "string" to String
      //change "keyboard.nextdouble" to "keyboard.nextDouble"
      //change "keyboard.nextline" to "keyboard.nextLine"
      //Add keyboard.nextLine(); in the correct places
      //Add add "()" in keyboard.nextLine; 
      
      keyboard.nextLine();
      System.out.print("Enter your name: "); // Tells user what to enter
      String name = keyboard.nextLine(); // Reads user imput, assigns to name
                                         // Change comment "imput" to "input"
      
      System.out.print("Enter your age: ");
      int age =  keyboard.nextInt(); // Reads the age: int
      
      keyboard.nextLine();
      System.out.print("Enter your major: ");
      String major = keyboard.nextLine(); // Reads the major: string

      System.out.print("Enter your high-school GPA: ");
      double gpa = keyboard.nextDouble(); // Reads the gpa: double
      
      keyboard.nextLine();
      System.out.print("Enter your favorite artist (actor/singer): ");
      String artist = keyboard.nextLine(); // reads the artist: string
      
      //B.2) Print out all the input given by user with one print statement and tab/indentation from line age onward
      //Optional: Space out print statment
      //Add "+" after "gpa"
      //Close the statement
      System.out.println("Name is " + name  + "\n\tAge is " + age + "\n/tGPA is " + gpa +
                           "/n\tMajor is " + major + "\tFavorite Artist is " + artist);
      
      
      // Part C: String Manipulation
      //change "major.toUppercase" to "major.toUpperCase"
      //change "major.lowerCase" to "major.toLowerCase"
      //change "major.charAt(3)" to "major.charAt(2)"
      //change "artist.charAt(1)" to "artist.charAt(0)"
      //add () to "major.length"
      int num_chars = major.length(); // how many char in string
      String str_caps = major.toUpperCase(); // converts to all upper case
      String str_lower = major.toLowerCase(); // converts to all lower case
      char thirdLetter = major.charAt(3); //  get the third letter of major and assigns it to thirdLetter as a char variable
      char firstLetter = artist.charAt(1); //  get the first letter of artist and assigns it to firstLetter as a char variable
      
      // C.2) print out all information
      //Optional: Space out statements
      //change "System.oUt.println" to "System.out.println"
      //Space "artis" to "art is"
      //Add "" from "^The" to "is ^"
      //change capitlizaion of FirstLetter to firstletter
      System.out.println("Major is " + name + ", has " + num_chars + " characters");
      System.out.println("UPPERCASE of major is " + str_caps);
      System.out.println("lowercase of major is " + str_lower);
      System.out.println("The third character of major is " + thirdLetter);
      System.out.println("The first character of art is " + firstLetter);
      
      // Part D: Math Calculations
      //Optional: Space out statments
      //Add ";" after myAnswer1)
      //change math.pow to Math.pow
      //add (int) in both equations
      //change Math.Sqrt to Math.sqrt
      //Capitlize the "s" in system.out.println
      int myAnswer1 = (int) Math.pow(8, 4); // 8 to the power of 4 -- result should be 4096 as integer
      System.out.println("myAnswer is " + myAnswer1);
      
      int myAnswer2 = (int) Math.sqrt(4); // square root of 4 is 2 -- result shold be 2 as integer
      System.out.println("myAnswer2 is " + myAnswer2);
      
      /*===============  submit the first submission before you start extra credit  ===========*/
      /*===============  You will write additional Java code to complete the following ========*/
      
      /* Part E: Bonus 1- reading more and printing  (7 points)
       You will definite your own variables or reuse variables - make sure do not duplicate 
       E.1) Read input (use appropriate data type - String, int, double): name, age, hometown_city, college_name, company, salary, dream_vacation
       E.2) based on the input you will print out using the following format in 1 print statement, variables are in { .. } 
       
            There once was a person named {name} who lived in {hometown_city}.
               At the age of {age}, {name} went to college at {college_name}.
               {name} graduated and went to work for {company} with starting saraly at {salary}.
               {name} hope that to travel to {drame_vacation}
      
      */
      
      
      /*  Part F: Bonus 2 - reading and calcuation (8 points)
          F.1) You will ask the user to enter an integer variable called side;  NOTE that side will be used for all calculation
          F.2) You will then look up the formular and calculate the following 
               (need to make sure that the results that need decimal points are double data type)
              (a) an area of a square with {side}  
              (b) a perimeter of a square with {side}
              (c) an area of a circle with a radius of {side}
              (d) a perimeter of a circle with a radius of {side}
              (e) an area of a circle with a diameter of {side}
              (f) a perimeter of a circle with a diameter of {side}
              (g) a volume of a ball with a radius of {side}
              (h) an area of a hexagon with {side}

          F.3) You will print out each result one per line - don't forget to provide a label, eg. an area of a square with {side} is {area_sq}.
      
      */
      
      
         //Flip {{ to }} at the end of file
         
   } // End of Main
} // End of Class
