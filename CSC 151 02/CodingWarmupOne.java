import java.util.Scanner;
//Name: Michael Amoo
//Section: 151 63
//Instructor: Dr. B
//Description: User Input, Arithmethic Operatiors, String Manipulation + Review Variables and Print

public class CodingWarmupOne
{
   public boolean sleepIn(boolean weekday, boolean vacation, boolean weekend)
   
   {    
   //If it is a vaction, sleep in
   if (vacation) {
      return true;
     }    
   //If it is a weekend, sleep in
   if (!weekend) {
      return true;
      }
   //If it is a weekday, wake up
   return false;
     
   }
  }