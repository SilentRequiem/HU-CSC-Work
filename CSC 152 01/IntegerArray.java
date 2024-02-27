import java.util.Scanner;

public class IntegerArray {
   public static void main(String[] args) {
      Scanner keyboard = new Scanner(System.in);
      int[] myNumbers = new int[10];
   
      System.out.println("Enter 10 integer numbers:");
      for (int i = 0; i < myNumbers.length; i++) {
         myNumbers[i] = keyboard.nextInt();
      }
   
      //Print
      System.out.println("Values in the array:");
      for (int num : myNumbers) {
         System.out.print(num + "\t");
      }
      System.out.println();
   
      //Print reverse
      System.out.println("Values in reverse:");
      for (int i = myNumbers.length - 1; i >= 0; i--) {
         System.out.print(myNumbers[i]);
         if (i != 0) {
            System.out.print(",");
         }
      }
      System.out.println();
   
      //Calc and print
      int total = 0;
      int highest = myNumbers[0];
      int lowest = myNumbers[0];
      for (int num : myNumbers) {
         total += num;
         if (num > highest) {
            highest = num;
         }
         if (num < lowest) {
            lowest = num;
         }
      }
      double average = (double) total / myNumbers.length;
      System.out.println("Total: " + total);
      System.out.println("Average: " + average);
      System.out.println("Highest: " + highest);
      System.out.println("Lowest: " + lowest);
   }
}
