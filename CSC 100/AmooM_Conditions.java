//Name: Michael Amoo
//Instructor: Dr. Muhammad and Dr. Boonthum-Denecke
//Class: CSC-100-33
//Date: 7/10/23  
//Description: Basic Condition Part 1
///////////////////////////////////////////////////

/* 

> means greater than
< means less than
>= means is greater than or equal to
<= means less than or equal to
== means equal to
!= means not equal to      

*/



import java.util.Scanner;

public class AmooMConditions
  { // class header
   public static void main(String[] args)
    { // main method header
    
    Scanner keyboard = new Scanner(System.in);   
   
   System.out.print("Enter a number between 0 and 10: ");
   int num1 = keyboard.nextInt();
   keyboard.nextLine();
   
   System.out.println("You entered " + num1 );
   //check if this number is larger than 5
   //-------------------if-else statment------------------------
   if (num1 > 5)
      System.out.println("num1 is larger than 5");
                                 //less than
                                 
   else
       System.out.println("num1 is NOT larger than 5");                                
 
   //check if this number is equal 10
   
    if (num1 == 10)
      System.out.println(num1 + " is equal to 10");
                                 //equal to
    
    else
        System.out.println(num1 + " is NOT equal to 10");
   //check if this number is at most 7
   
    if (num1 <= 7)
      System.out.println(num1 + " is at most 7");
                                 //less than or equal to
    else
        System.out.println(num1 + " is NOT at most 7"); 
        
   //-----------------------Compare------------------------
   System.out.print("Enter another number between 0 and 10: ");
   int num2 = keyboard.nextInt();
   keyboard.nextLine();  
   
   //check if num1 is larger or num2 is larger?
   if (num1 > num2)
                   System.out.println("num1 is larger than num2");
                   
   
   if (num1 < num2)
                   System.out.println("num2 is larger than num1");                        
   
   //check if both are the same
   if (num1 == num2)
                    System.out.println("num1 is the equal to num2"); 
   
   //check if num2 is larger than double value of num1
   if (num1 * 2 < num2)
                       System.out.println(num2 + " is > double of " + num1);   
   else
       System.out.println(num2 + " is not > double of " + num1);
       
   //can you print num1 and num2 in order small to large
   if ( num1 < num2 )
      System.out.println("Order numbers: " + num1 + ", " + num2);
   else
       System.out.println("Order numbers: " + num2 + ", " + num1);
      
   
//---------------------------if-else-if-------------------------------
   
//checks equals first, and then which one ever is one is larger
System.out.println("\n\nif-else-if");
if (num1 == num2)
   System.out.println(num1 + " is equal to " + num2);

else if (num1 > num2)
   System.out.println(num1 + " is larger than " + num2);

else
   System.out.println(num2 + " is larger than " + num1);


//calculation - based on num1 and num2 that we have
//if num1 is larger then to the following
//    create a int diff variable, use num1 - num2
//    create a double result1, diff / num2
//    then print the result both diff and result1
System.out.println("\n\nCalculation");
if (num1 > num2)
 {
   int diff = num1 - num2;
   double result1 = (double) diff / num2;
   System.out.println("Diff is " + diff + "\nresult1 is " + result1);
 }
    
   
   
   

//if num2 is larger then do the following
//    create a int diff variable, use num2 - num1
//    create a double result2, diff / num1
//    then print the result both diff and result2

   else
   {
     int diff = num2 - num1;
     double result2 = (double) diff / num1;
     System.out.println("Diff is " + diff + "\nresult is " + result2);
     
   }

  
   
   
   
   
   
   
   
   
   } // end main method 
  } //ending of program