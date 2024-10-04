import java.util.Scanner;
public class Array {
   public static void main(String[] args) {
   Scanner keyboard = new Scanner(System.in);
   
      int count = 10;        
      int[] hours = new int[count]; //Basic array: "I want 10 places to store"
                          
      
      /* Examples of creating array data types
      
      int[] numbers = new int[6];
      float[] temperatures = new float[100];
      char[] letters = new char[41];
      long[] units = new long[50];
      double[] sizes = new double[1200];
      */
      
      /* Can make it in parts if needed 
      
      int[] numbers;
      numbers = new int[6];
      */
      
      System.out.println("Enter " + count + " numbers.");

      //Basic For Loop
      for (int i = 0; i < count; i++) //This array would have indexes 0 through 9.
      //<= or equal to would give an error because that would allow 10 which is NOT an index.
      
      {
         System.out.print("count " + (i + 1) + ": "); //just for the "count X:"  message.
         hours[i] = keyboard.nextInt(); //For every i that is increased, that i goes into the array.
             //^Subscript
      }

      System.out.println("\nPrintout:");

      // Display the values entered.
      for (int i = 0; i < count; i++)
         {
         System.out.println(hours[i]);   
         }
         
         
       //Array Initialization
       int[]days = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
       System.out.println("\nPrintout 2: ");
       
       for (int i = 0; i < days.length; i++)
         {
         System.out.println(days[i]);   
         }

  //Part A  
  
  final int size = 5;
  int[] numbers = new int[size];
  
  System.out.println(" ");
  
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
   //Copying array
   int[] firstArray = {5, 10, 15, 20, 25 };
   int[] secondArray = new int[5];
   for (int i = 0; i < firstArray.length; i++)
   {
   secondArray[i] = firstArray[i];
   }
   
   
  //Print
   System.out.println("\n ");
   for (int tmp : firstArray)
  {
   System.out.print(tmp + ", ");
  }
  
  System.out.println("\n ");
  
  for (int tmp2 : secondArray)
  {
   System.out.print(tmp2 + ", ");
  }




  }
}