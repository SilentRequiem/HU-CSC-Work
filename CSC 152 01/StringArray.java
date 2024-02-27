import java.util.Scanner;

public class StringArray {
   public static void main(String[] args) {
      Scanner keyboard = new Scanner(System.in);
      String[] myRoster = new String[5];
   
      //Array
      System.out.println("Enter 5 names:");
      for (int i = 0; i < myRoster.length; i++) {
         myRoster[i] = keyboard.nextLine();
      }
   
      //to.UpperCase and length
      System.out.println("Names in uppercase with length:");
      for (String name : myRoster) {
         System.out.println(name.toUpperCase() + " - " + name.length() + " characters");
      }
   }
}
