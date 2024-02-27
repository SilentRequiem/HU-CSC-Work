import java.util.Scanner;

public class PartiallyFilledArray {
   public static void main(String[] args) {
      Scanner keyboard = new Scanner(System.in);
      Integer[] myScores = new Integer[20];
      int count = 0;
   
      //Array
      System.out.println("Enter up to 20 integer numbers (-1 to stop):");
      int num;
      while ((num = keyboard.nextInt()) != -1 && count < 20) {
         myScores[count] = num;
         count++;
      }
   
      //Print
      System.out.println("Numbers entered: " + count);
      System.out.println("Numbers:");
      for (int i = 0; i < count; i++) {
         System.out.print(myScores[i] + " ");
      }
      System.out.println();
   
      //Print but reversed
      System.out.println("Numbers in reverse:");
      for (int i = count - 1; i >= 0; i--) {
         System.out.print(myScores[i] + " ");
      }
      System.out.println();
   }
}
