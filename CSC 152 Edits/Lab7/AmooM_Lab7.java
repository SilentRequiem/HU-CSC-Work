/*
Name: Michael Amoo
Section: 152 S1 
Instructor: Dr. B
Description: – REVIEW char and String Arrays and Partially Filled Array
Date: 10/16/24
“I, Michael Kwabena Amoo, pledge to follow the Honor Code in completing my Lab 7.”
*/
import java.util.Scanner;
public class AmooM_Lab7 {
   public static void main(String[] args)
{
  Scanner keyboard = new Scanner(System.in);
  
//Part A - array of chars
   
   System.out.println("Enter name: ");
   String name = keyboard.nextLine();
   
   char[] nameChars = new char [name.length()];
   
   //assigns values
   for (int i = 0; i < nameChars.length; i++)
   nameChars[i] = name.charAt(i);
   
   
   System.out.println("\nPrints every other Char");
   for (int i = 0; i < nameChars.length; i+=2)
   System.out.print(nameChars[i]);
   
   System.out.println("\n\nPrint in reverse: ");
   for (int i = nameChars.length - 1; i >= 0; i--)
   System.out.print(nameChars[i]);
   
   
//Part B - String Arrays and String Manipulation Print in REVERSE

   System.out.println(); //fixes the cursor
   
   String[] friendsList = new String[5];
   System.out.println("\nEnter " + friendsList.length + " names: ");
  
   //assigns values
   for (int i = 0; i < friendsList.length; i++)
   friendsList[i] = keyboard.nextLine();
   
   
   //in reverse
   System.out.println("\n\nPrint in reverse: ");
   for (int i = friendsList.length - 1; i >= 0; i--)
   {
      name = friendsList[i];
      String upper = name.toUpperCase();
      char firstChar = upper.charAt(0);
      char lastChar  = upper.charAt(name.length() - 1);
      System.out.println(name + " has " + name.length() + " number of characters " + firstChar + lastChar);
   }
   
//Part C - Copy and Compare Array
   int[] listA = {5,8, 4, 9, 3, 15, 2, 20}; //intialized
   
   int[] listB = new int [listA.length * 2];
   
   int[] listC = new int [listA.length];
   
   //copy
   
   for (int i = 0; i < listA.length; i++)
   {
      listB[i] = listA[i]; //A to C
      listC[i] = listA[i]; //A to C
   }
   
   listC[4] = 25; //Update to 25
   System.out.println("\n");
   System.out.println("Enchanced listA: ");
   for (int tmp : listC) 
   {
     System.out.print(tmp + ", ");
   }
   System.out.println();
   System.out.println("Enchanced listB: ");
   for (int tmp : listC) 
   {
     System.out.print(tmp + ", ");
   }
   System.out.println();
   System.out.println("Enchanced listC: ");
   for (int tmp : listC) 
   {
     System.out.print(tmp + ", ");
   }
   System.out.println();
   
   
  //Compare
  boolean sameValue = true;
  
  if( listA.length != listC.length)
      sameValue = false;
  else
  {
      for (int i = 0; i < listA.length; i++) 
      {
         if (listA[i] < listC[i])
            sameValue = false;
      }
  }
  //Print
  System.out.print("\nCompared the content from listA and listC: ");
  System.out.println(sameValue ? "SAME" : "NOT SAME");


//Part D - Partially Filled Array
  int[] myScores_MKA = new int [100];
  int count = 0;
  System.out.println();
  System.out.print("Enter #: -1 to stop: ");
  int num = keyboard.nextInt();
  
  while ( num != -1 && count < myScores_MKA.length)
  {
   myScores_MKA[count] = num;
   count++;
   
   System.out.print("Enter #: -1 to stop:");
   num = keyboard.nextInt();
  }
  
  System.out.println("\n");
  //Print in enchanced
  int cntP = 0; //count print
  for (int tmp : myScores_MKA)   
  {
      System.out.print(tmp + "\t");
      cntP++;
      if (cntP % 10 == 0) //10 numbers per line
            System.out.println();
  }
  
  System.out.println("\n");
  //Print Filled Elements
  cntP = 0;
  
  for (int i = 0; i < count; i++) //only go up to count
  {
      System.out.print(myScores_MKA[i] + "\t"); 
         cntP++;
         if (cntP % 10 == 0)
               System.out.println();
  }
  
  //From Lab5
  
  int total = 0;
  int min = myScores_MKA[0];
  int max = myScores_MKA[0];
  
  //Finding Highest
  for (int i = 0; i < count; i++)
  {
    total += myScores_MKA[i];
    if (myScores_MKA[i] > max)
    max = myScores_MKA[i];
    
    if (myScores_MKA[i] < min)
    min = myScores_MKA[i];
  }
  double average = (double) total / count;
  System.out.println("\n\nRegular For Loop:\n"
                       + "\tTotal: " + total + "\n"
                       + "\tMin: " + min + "\n"
                       + "\tMax: " + max + "\n"
                       + "\tAverage: " + average + "\n"); 
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  }
}