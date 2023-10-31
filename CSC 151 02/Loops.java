import java.util.Scanner;
public class Loops
{   public static void main(String args[])
  
   {
    Scanner keyboard = new Scanner(System.in);
     
     System.out.print("How high do you want me to count?");
     int num = keyboard.nextInt();
     
     System.out.printf("You asked me to count from 0 to %d%n", num);
     
 //Count
 
 int count = 0;
 while (count <= num)
 { System.out.println(count);
   count += 1;
 }
 
 
 int i = 0;
 while (1 < 10)
 {
   System.out.println(i);
  i++;
   
 }
 
 //Can use for loops for a more consise way of coding
 for(int i = 0; i < 10; i++) {
   System.out.println(i);
   }
 //for(<initilization>; <conditiion/test> ; <incremement/upgrade>)
 
 //Prefix ++Num
 //Postfix Num++
 
 int count = 0;
 for(int hours = 0; hours < 24; hours++)
 { for(int minutes = 0; minutes < 60; ++minutes)
    for (int seconds = 0; seconds < 60; ++seconds)
      for (int micros = 0; micros < 10000; ++micros)
         {count++;)
        }
      }
    }
  
 
      }
   }

