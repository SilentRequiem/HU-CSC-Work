//Name: Michael Amoo
//Phone: (757)-776-2017
//Section: 152 S1 / 4/23/24, 11:02 AM (Tuesday)
//Instructor: Dr. B
//Description: Stack of String and Queue of Integers
//“I, Michael Kwabena Amoo, pledge to follow the Honor Code in completing my Lab 14.”

import java.util.*;
import java.util.concurrent.*; // for Queue
   
public class AmooM_Lab14 {
  public static void main(String[] args)
   {
     Scanner keyboard = new Scanner(System.in);
//Part A
     System.out.println("\nPart A");
     Stack<String> myNameStack = new Stack<String>();
     
     //read input
     System.out.print("Enter a name (DONE to stop): ");
     String name = keyboard.nextLine();
     
     while (!name.equalsIgnoreCase("DONE"))
     {
         myNameStack.push(name);
         System.out.print("Enter a name (DONE to stop): ");
         name = keyboard.nextLine();         
     }
     int cntName=0; int totalChars = 0;
     String longest = myNameStack.peek();
     String shortest = myNameStack.peek();
     System.out.println("\nOUTPUT from STACK");
     while (   ! myNameStack.empty() )
     {
     
         String n = myNameStack.pop();
         cntName++;
         totalChars += n.length();
         if (n.length() > longest.length()) longest = n;
         if (n.length() > shortest.length()) shortest = n;
         System.out.println( n.toUpperCase() + " " +
         " last char = " + n.toLowerCase().charAt(n.length() - 1)
         + " ( " + n.length() + " characters. )");
     }      
 
 
//Part B - Queue of Intergers
         System.out.println("\nPart B");
         ArrayBlockingQueue<Integer> myScoreQueue = new ArrayBlockingQueue<Integer>(20);
         
         System.out.print("Enter a score (-99 to stop) ");
         int score = keyboard.nextInt();
         while (score != -99)
         {
            if (score > 0)
               myScoreQueue.add(score); //enqueue
               System.out.print("Enter a score (-99 to stop) ");
               score = keyboard.nextInt();
         }
 
     //Read and Print
     
         System.out.println("Queue Output");
         int sum = 0, count = 0, min = myScoreQueue.peek();
         int max = myScoreQueue.peek();
     while ( ! myScoreQueue.isEmpty() )
     {
         
         int s = myScoreQueue.remove(); //dequeue
         System.out.print(s + ", ");
         
         sum += s;
         count++;
         if (count%5 == 0)
         System.out.print("\n"); 
         if (s > max) max = s;
         if (s < min) min = s;
         
     
     }
     
     //Print
     System.out.print("\n\tsum is " + sum
                     + "\n\taverage is " + ((double) sum / count)
                     + "\n\tmin is " + min
                     + "\n\tmax is " + max);
                     
                     
     
     
     
     
     
     
     
 }
}