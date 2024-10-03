/*
Name: Michael Amoo
Section: 152 S1
Date: October 2, 2024
Desc: Basic Array
“I, Michael Amoo, pledge to follow the Honor Code in taking my Lab 5.”
*/

import java.util.Scanner;
public class AmooM_Lab5 {
   public static void main(String[] args)
{
  Scanner keyboard = new Scanner(System.in);

//Part A  
  
  final int size = 5;
  int[] numbers = new int[size];
  
  //Scanning 
  for (int i = 0; i < size; i++)
  { 
    System.out.print("Enter #" + (i + 1) + ": ");
    numbers[i] = keyboard.nextInt();
  }
  keyboard.nextLine();
  
  System.out.println(" ");
  
  System.out.println("Regular For Loop: ");
  for (int i = 0; i < size; i++)
  { 
    System.out.print(numbers[i] + ", ");
  }
  
  System.out.println("\n\nEnhanced For Loop: ");
  //format: for (dataType variable : arrayName)
  for (int tmp : numbers)
  {
   System.out.print(tmp + ", ");
  }

//Part B
  int total = 0;
  int min = numbers[0];
  int max = numbers[0];
  
  //Finding Highest
  for (int i = 0; i < size; i++)
  {
    total += numbers[i];
    if (numbers[i] > max)
    max = numbers[i];
    
    if (numbers[i] < min)
    min = numbers[i];
  }
  double average = (double) total / size;
  System.out.println("\n\nRegular For Loop:\n"
                       + "\tTotal: " + total + "\n"
                       + "\tMin: " + min + "\n"
                       + "\tMax: " + max + "\n"
                       + "\tAverage: " + average + "\n");
  
  
  //Enhanced
  for (int tmp2 : numbers)
  {
   total += tmp2;
   if (tmp2 > max)
   max = tmp2;
   
   if (tmp2 < min)
   min = tmp2;
  }
  
  System.out.println("\n\nEnhanced For Loop:\n"
                       + "\tTotal: " + total + "\n"
                       + "\tMin: " + min + "\n"
                       + "\tMax: " + max + "\n"
                       + "\tAverage: " + average + "\n");
  
//Part C
     final int noFRIENDS = 5;
     String[] myFriends_MKA = new String[noFRIENDS];
  //Scanning 
  for (int i = 0; i < noFRIENDS; i++)
  { 
    System.out.print("Enter String #" + (i + 1) + ": ");
    myFriends_MKA[i] = keyboard.nextLine();
  } 
  
  System.out.println("\n\nRegular For Loop: "); 
  for (int i = 0; i < noFRIENDS; i++)
  { 
    System.out.println(myFriends_MKA[i] + " has " + myFriends_MKA[i].length() + " characters." );

  } 
  
  System.out.println("\n\nEnhanced For Loop: ");
  for (String tmp3 : myFriends_MKA)
  {
  System.out.println(tmp3 + " has " + tmp3.length() + " characters.");
  }


//Part D
 int cntOdd = 0;
 int cntEven = 0;
 int cnt25Higher = 0;
  
 for (int i = 0; i < numbers.length; i++)
 {
    if (numbers[i] % 2 != 0)
    cntOdd++;
    
    if (numbers[i] % 2 == 0)
    cntEven++;
    
    if (numbers[i] >= 25)
    cnt25Higher++;
 }
 
 System.out.println("\n\nOutput D: ");
 
 System.out.println("My array has " + numbers.length + " integers: ");
 System.out.println("\t" + cntOdd + " integers are odd.");
 System.out.println("\t" + cntEven + " integers are even.");
 System.out.println("\t" + cnt25Higher + " have at least 25 or higher."); 
 

//Part E
  System.out.println("\n\nOutput E: ");
  for (int i = 0; i < myFriends_MKA.length; i++)
 {
    System.out.println(myFriends_MKA[i] + " has " + myFriends_MKA[i].length() + " characters - " 
                                        + myFriends_MKA[i].toUpperCase().charAt(0) + " " + myFriends_MKA[i].toUpperCase().charAt( myFriends_MKA[i].length() - 1));
 }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
   }
}