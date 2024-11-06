import java.util.Scanner;
import java.util.concurrent.*;

public class AmooM_Lab9
{
   public static void main(String[] args)
   {
      Scanner keyboard = new Scanner(System.in);

//Part A - Queue of Integer
   ArrayBlockingQueue<Integer> myScoreQueue = new ArrayBlockingQueue<Integer> (10); //Creation
   int total = 0;
   int cnt = 0;
   int min = 0;
   int max = 0;
   System.out.print("Enter a #, -99 to stop: ");
   int score = keyboard.nextInt();
      
      if (score != -99)
      {
      total += score;
      max = score;
      min = score;
      cnt++;
      }
      
      
   while (score != -99)
   {
      myScoreQueue.add(score); //== enqueue
      System.out.print("Enter a #, -99 to stop: ");
      score = keyboard.nextInt();
      
         if (score != -99)
         {total += score;}
         
         if (score > max && score != -99)
         {max = score;}
         
         if (score < min && score != -99)
         {min = score;}
         cnt++;
   }
   System.out.println("");
   keyboard.nextLine();
   
   double average = (double) total / (cnt - 1);
   
   //Print queue
   int printCnt = 0;
   
   while (!myScoreQueue.isEmpty() )
   {
      int num = myScoreQueue.remove(); // == dequeue
      System.out.print(num + "\t");
      printCnt++;
      
      if (printCnt % 5 == 0 ) //5 #s per line
         System.out.println();
         
              
   }
   //Part A Results
   System.out.println("\n\nTotal is " + total);
   System.out.println("Min is " + min);
   System.out.println("Max is " + max);
   System.out.println("Average is " + average);
   
//Part B - Queue of String
   System.out.println();
   ArrayBlockingQueue<String> myNameQueue = new ArrayBlockingQueue<String> (20); //Creation
   System.out.print("Enter a name, DONE to stop: ");
   String name = keyboard.nextLine();
   
   String longName = name;
   String shortName = name;
   
   while (!name.equalsIgnoreCase("done"))
   {
      myNameQueue.add (name); //enqueue
      System.out.print("Enter a name, DONE to stop: ");
      name = keyboard.nextLine();
      
      if (name.length() >= longName.length())
        { if (!name.equalsIgnoreCase("done"))
          { longName = name; }}
      
      if (name.length() <= longName.length())
      { if (!name.equalsIgnoreCase("done"))
      { shortName = name; }}
      
   }
  
  //Print queue
   printCnt = 0; //reused
   System.out.println("");
   while (!myNameQueue.isEmpty())
   {
      String name2 = myNameQueue.remove(); // == dequeue
      System.out.print(name2.toUpperCase() + " " +  name2.charAt(name2.length() - 1) + " " + name2.length() + "\n");
      printCnt++;

   }
   //Part B results
   System.out.println( printCnt + " numbers entered ");
   System.out.println( longName + " is the longest name ");
   System.out.println( shortName + " is the shortest name ");


//Part C – Partially Filled Array Integer



//Part D – Linear/Sequential Search 


   
  
  
  
  
  
  
  
  
  
  
      }
 }
   
   

   
   
      