//Name: Michael Amoo
//Date: 10/3/23
//Phone: (757)-776-2017
//Section: 151 63
//Instructor: Dr. B
//Description: Coding Homework Two: Number Game
import java.util.Scanner;
import java.util.Random;
public class AmooM_P2
{  public static void main(String[] args)
   {
   
   
//Section 1: Introduce the Game
   
   System.out.println("Let's play a number guessing game");
   
//Section 2: Determining the Range
   
   Scanner keyboard = new Scanner(System.in);
   
   System.out.print("Enter an interger: ");
   int num1 = keyboard.nextInt();
   
   System.out.print("Enter another interger: ");
   int num2 = keyboard.nextInt();
   keyboard.nextLine();

   if (num1 == num2)
   {
   System.out.println("Not cool. I asked for different numbers");
   return;
   }
   
   int largest;
   int smallest;
   
   if (num1 > num2)
   smallest = num2;
   else
   smallest = num1;
   
   if (num1 < num2)
   largest = num2;
   else
   largest = num1; 
   
   int range = -1;
   
   if (num1 < 0 && num2 < 0)
   range = Math.abs(smallest) - Math.abs(largest) + 1;  
   
   else if (num1 >= 0 && num2 >= 0)
   range = largest - smallest + 1;
   
   else
   range = Math.abs(smallest) + largest + 1;
   
   
        
//Section 3: Choosing a Number   
   
   Random random = new Random();
   int target = random.nextInt(range) + smallest;

   System.out.println("I've chosen a random number in the range you specified.");
   
   System.out.println("There are " + range + " numbers to choose from, between and including "
                                   + smallest + " and " + largest + ".");
   
//Section 4: First Guess - Nested If
   System.out.println("Guess a whole number between and including " + smallest + " and " + largest + ": ");
        int guess = keyboard.nextInt();

        if(guess == target)
        {
            System.out.println(guess + " is correct.");
            return;
        }
        else
        {
            if(guess > target){
                System.out.println(guess + " is too large.");
                largest = guess -1;
        }
        else
        {
        
        System.out.println(guess + " is too small.");
        smallest = guess + 1;
        
        }
        }



//Section 5: If Without Nesting
   System.out.println("Guess a whole number between and including " + smallest + " and " + largest + ": ");
   guess = keyboard.nextInt();

        if(guess == target)
        {
        System.out.println(guess + " is correct.");
        return;
        }
        
        if (guess > target)
        {
         System.out.println(guess + " is too large.");
         largest = guess -1;
        }
        else
        {
            System.out.println(guess + " is too small.");
            smallest = guess + 1;
        }



//Section 6: Conditional Opertators

   System.out.println("Guess a whole number between and including " + smallest + " and " + largest);
        guess = keyboard.nextInt();

        if(guess == target)
        {
            System.out.println("guess is correct.");
            return;
        }
        String direction = (guess > target) ? "large" : "small";
        largest = (guess > target) ? guess - 1 : largest;
        smallest = (guess < target) ? guess + 1 : smallest;

        System.out.println(guess + " is too " + direction);


//Section 7: Switch   

System.out.println("Enter a whole number between and including " + smallest + " and " + largest);
        guess = keyboard.nextInt();

        int offBy = -1;
        
        if(guess < target){
            offBy = -1;
        }
        else if (guess > target)
        {
            offBy = 1;
        }
        else
        {
            offBy = 0;
        }

        switch(offBy)
        {
            case -1:
                System.out.println(guess + " is not small. The number was " + target + ".");
                break;

            case 1:
                System.out.println(guess + " is too large. The number was " + target + ".");
                break;

            case 0:
                System.out.println(guess + " is correct.");
                break;
  
      }
   }
}