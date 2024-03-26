import java.util.Scanner;

public class PartiallyFilledArrayPractice {
   public static void main(String[] args) {
   Scanner keyboard = new Scanner(System.in);
   int[] myScores = new int[20]; //Make array 
   int count = 0; //counter
   
   //Array
   System.out.println("Enter 20 interger numbers (-1 to stop)");
   int num;
   
   while (( num = keyboard.nextInt() ) != -1 && count < 20) //While user input is not equal to user -1, AND count is less that 20
   {
      myScores[count] = num;
      count++; //Total
   }
   
   //Print
   System.out.println("Number entered: " + count);
   System.out.println("Numbers:");
   for (int i = 0; i < count; i++) {
         System.out.print(myScores[i] + " ");
      }
      System.out.println();
      
   //Reverse is this
   for (int i = count - 1; i > 0; i--) {
         System.out.print(myScores[i] + " ");
      }
      System.out.println();
      
      
   
   
   
   
   
   
   
   
   
   
   
   
   }
 }