/******************************************************************************** 

     YOU MUST KEEP THE CODE OUTLIINE and COMMENTS AS GIVEN 
   
   * only Program Assignment 1 that you will be given the outline 
     so that you will see what basic information that you will have
     at the beginning of Program Assignment
     
     DUE Wednesday, January 29, 11:59 PM EST
  
*********************************************************************************/


// *******************************************************************
// CSC 152 - Computer Programming II - Dr. Aneke
// 
// Programmed Assignment 1 by :  Michael Kwabena Amoo
//                               00549396
//                               Cyber Security
//
// Location where you completed this assignment (lab / apt / dorm):  DORM
// Tutor, if any (who help you with this program assignment):  TUTOR
//
// *******************************************************************

import java.util.Date;  // DO NOT REMOVE THIS LINE 
// (1) Import additional class(es) below
import java.util.Scanner;

public class AmooM_P1  
// make sure that you change LASNAME to your last name
//                    change initial to your first name initial
{
	public static void main (String[] args)
	{

		String myName = "Michael Kwabena Amoo"; // put your full name here
      String myMajor = "Cyber Security"; // put your major here
		System.out.println ( "\nSpring 2025 Program 1 by " + myName + "\n\n");
		System.out.println ( " I, Michael Kwabena Amoo, did not receive any assistant\n" +
									" from another person except CSC 152 instructors\n" +
									" and assigned tutors.\n\n");  // completed by Michael Kwabena Amoo

		/* Begin your code here :: Michael Kwabena Amoo */
		// (2) Create an object to read an input from a keyboard
		Scanner keyboard = new Scanner(System.in); //used for keyboard



		// (3) Input 2 integers and 1 double (including declare variables)  and 1 String
      //     Note that you must add _XXX, where XXX are your initials (first, middle, last) 
      //     at the end of each variable
		
      //Entering a, b, r, and name
      System.out.print("Enter an interger for a: ");
		int a_MKA = keyboard.nextInt();
		System.out.print("Enter an interger for b: ");
		int b_MKA = keyboard.nextInt();
		System.out.print("Enter an Double for r: ");
		double r_MKA = keyboard.nextDouble();
		keyboard.nextLine(); //clear buffer
		System.out.print("Enter a name: ");
		String name = keyboard.nextLine();
		System.out.println(""); //adjusting format

		System.out.println(name + ", your values inputs were: ");
		System.out.println("\ta_MKA = " + a_MKA);
		System.out.println("\tb_MKA = " + b_MKA);
		System.out.println("\tc_MKA = " + r_MKA);

		// (4) Calculate several math expressions (including declare variables)
		//     by  Michael Kwabena Amoo
		
		int result1 = (int) (Math.pow(a_MKA, 7)) + 5 * 9; // (int) is needed
		int result2 = (int) (Math.pow(a_MKA, 4)) - (8 * a_MKA * b_MKA) + (int) (Math.pow(b_MKA, 5)); //(int) is needed
		double result3 = (((2.0 * a_MKA - 5.0) / 18.0 ) + ((3.0 * b_MKA - 7.0) / 13.0 ));
		double result4 = (5.0 * Math.pow(r_MKA, 10.0) + 3.0 ) / 7.0;


		
		// (5) Output results by Michael Kwabena Amoo 
		
		System.out.println("\nCalculated results were: ");
		System.out.println("\tresult1 = " + result1);
		System.out.println("\tresult2 = " + result2);
		System.out.println("\tresult3 = " + result3);
		System.out.println("\tresult4 = " + result4);



      
      // (6) String manipulation - make sure that you use methods defined in String class
	 System.out.print("\nEnter your hometown (City and State): ");	
	 String hometown = keyboard.nextLine();

	 System.out.println("\n" + name + ", your hometown is " + hometown + "\t(" + hometown.length() + " characters)");
	 System.out.println("\tUpper Case ==> " + hometown.toUpperCase());
	 System.out.println("\tLower Case ==> " + hometown.toLowerCase());
	 System.out.println("\tLast Character ==> " + hometown.toUpperCase().charAt(hometown.length() -1));



      
      
		/* code completion by Michael Kwabena Amoo */ 
		
   /* =====================================================================================
   
       DO NOT CHANGE ANY CODE AFTER THESE SECTION  
       ONLY UPDATE IN COMMENTS AREA
       
   */   
      
	//*********************  DO NOT REMOVE THIS CODE  ****************************		
		// This is to print at the end showing the completion and timestap
		System.out.println ( "\nProgram 1 is completed by " + myName);
		Date today = new Date(); 
		System.out.println(today);
		System.out.println ( "\n\n"); 
	} // end main
}

// This program is for CSC 152 class for Dr. Aneke
// Spring 2025 - Due January 29
//  Michael Kwabena Amoo