import java.util.Scanner;

public class CharacterArray {
   public static void main(String[] args) {
      Scanner keyboard = new Scanner(System.in);
      char[] myChars = new char[10];
   
   //Yes you could make it the same size of what is inputed if you increase the cap to around 500 or so, Partially filled arrays.
   
      //Array
      System.out.println("Enter 10 characters:");
      String input = keyboard.nextLine();
      if (input.length() < 10) {
         System.out.println("Please enter at least 10 characters in one line.");
         return;
      }
      for (int i = 0; i < myChars.length; i++) {
         myChars[i] = input.charAt(i);
      }
   
      //Print
      System.out.println("Each character on a separate line:");
      for (char ch : myChars) {
         System.out.println(ch);
      }
   
      //All together now
      System.out.println("All characters together:");
      for (char ch : myChars) {
         System.out.print(ch);
      }
      System.out.println();
   
      //All together now (Reverse)
      System.out.println("Characters in reverse:");
      for (int i = myChars.length - 1; i >= 0; i--) {
         System.out.print(myChars[i]);
      }
      System.out.println();
   }
}
//Reverse starts at the end by geting the length number (The length number will be the end)
//The it counts down by 1 because of i-- as long as it's above zero (i >= 0)
// so if I entered a, z, a, a, b, e, o, b, u, w. it will be w, u, b, o, e, b, a, a, z  (I missed a letter but you get the picture)