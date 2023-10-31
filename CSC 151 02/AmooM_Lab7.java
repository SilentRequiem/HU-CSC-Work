//Name: Michael Kwabena Amoo
//Phone: 757-776-2017
//Instructor: Dr. B
//Date: 10/26/23
import java.util.Scanner;
import java.util.Random;
public class AmooM_Lab7
{  public static void main(String[] args)
   {
   
   Scanner keyboard = new Scanner(System.in);

//Part A - Review Random Number
System.out.println("Part A - Review Random Number");
   
   Random Random = new Random();
   int ran1 = Random.nextInt(10);
   int ran2 = Random.nextInt(6)+1;
   int ran3 = Random.nextInt(20)+10;
   int ran4 = Random.nextInt(10)-10;
   
   System.out.println("This time ran1 is " + ran1 + ".");
   System.out.println("This time ran2 is " + ran2 + ".");
   System.out.println("This time ran3 is " + ran3 + ".");
   System.out.println("This time ran4 is " + ran4 + ".");

//Part B - While Loop with Guessing a Favorite Digit
System.out.println("\nPart B - While Loop: Guessing a Favorite Digit");

   int myFavoriteDigit = Random.nextInt(9); //Made FavoriteDigit Random for better testing purposes
   
   System.out.print("Guess what my favorite digit is? (0-9): ");
   int guessDigit = keyboard.nextInt();

      while (myFavoriteDigit < guessDigit)
      {
      System.out.print("Incorrect, please try to guess again. (0-9): ");
      guessDigit = keyboard.nextInt();
      }

      while (myFavoriteDigit > guessDigit)
      {
      System.out.print("Incorrect, please try to guess again. (0-9): ");
      guessDigit = keyboard.nextInt();
      }
      System.out.println("\tGood Job!!");
   
   
//Part C - While Loop with Guessing a Random Number
System.out.println("\nPart C - While Loop: Guessing a Random Number");  
   
   int randomToGuess;
   int attemptCount = 1;
   
   randomToGuess = Random.nextInt(100);
   
   System.out.print("Guess a random number (0-100): ");      
   int guessNumber = keyboard.nextInt();
   
      while (guessNumber < randomToGuess)
         {
         System.out.print("Higher, guess again. (0-100): ");
         guessNumber = keyboard.nextInt();
         attemptCount += 1;
         }
      while (guessNumber > randomToGuess)
         {
         System.out.print("Lower, guess again. (0-100): ");
         guessNumber = keyboard.nextInt();
         attemptCount += 1;
         }
         System.out.println("\tGood Job!! It took you " + attemptCount + " attempts.");
      
//Part D - While Loop For Data Validation
System.out.println("\nPart D - While Loop: Data Validation");

   int speed;
   
   System.out.print("Please enter an integer for speed (25 - 45): ");
         speed = keyboard.nextInt();
   
      while (speed < 25)
      {
      System.out.print("Invalid, speed should be between 25 and 45, please reenter: ");
         speed = keyboard.nextInt();
      
         while (speed > 45)
         {
         System.out.print("Invalid, speed should be between 25 and 45, please reenter: ");
            speed = keyboard.nextInt();
         }
      }
      System.out.print("\tYou enter " + speed + " for speed.");      


   }
}