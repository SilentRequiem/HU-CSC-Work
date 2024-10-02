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

  }
}