import java.util.Scanner;
public class ArrayInitialization
{
   public static void main(String[] args)
   {
      Scanner keyboard = new Scanner(System.in);
      
      int[] days = { 31, 28, 31, 30, 31, 30,
                     31, 31, 30, 31, 30, 31 };
      System.out.print("Is this a leap year? y/n: ");
      char x = keyboard.nextLine().toLowerCase().charAt(0);
      System.out.println(" ");
         if (x == 'y')
            days[1] = 29; //Array "days" slot 2 will be changed to 29

      for (int index = 0; index < 12; index++)
      {
         System.out.println("Month " + (index + 1) +
                            " has " + days[index] +
                            " days.");
      }
      keyboard.close();
   }
}
