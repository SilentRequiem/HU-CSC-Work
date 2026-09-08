import java.util.Scanner;
import java.util.Random;
public class AmooM_Lab11
   {
      public static void main(String args[])
      {
//Part A: Nested Loops with Running Total
      String name; 
      int score;
      int sum = 0;
      double average = 0;
      double totalAverage = 0;
      double overallAverage = 0; 
      Scanner keyboard = new Scanner(System.in);
      
         for (int i = 3; i > 0; --i)
           {
            
            System.out.print("\nEnter a name: ");
            name = keyboard.nextLine();
            sum = 0;
         
            for (int ii = 5; ii > 0; --ii)
               { 
                System.out.print("Enter a score (0 - 100): ");
                score = keyboard.nextInt();
                keyboard.nextLine();
                sum += score;
                average = sum / 5.0;
                totalAverage += average; 
               }
               System.out.println(name + "'s total score is " + sum + " and average is " + average);
             } 
             overallAverage = totalAverage / 3;
             System.out.println("The total average of 3 students is " + totalAverage + " and overall average is " + overallAverage);  
               
//Part B Nested-While and Do-While Loop- guess a random number, until correct; then ask to repeat             
        Random random = new Random();

        char repeat;
        int randomToGuess;
        int guessNumber;
        int attemptCount;

        do {
            // Generate a random number between 0 and 100
            randomToGuess = random.nextInt(101);

            System.out.println("\nGuess the number between 0 and 100.");

            attemptCount = 1;

            do {
                System.out.print("Enter your guess (0-100): ");
                guessNumber = keyboard.nextInt();

                if (guessNumber < randomToGuess) 
                {
                    System.out.println("Higher, guess again.");
                    attemptCount++;
                } 
                
                else if (guessNumber > randomToGuess)
                {
                    System.out.println("Lower, guess again.");
                    attemptCount++;
                 }
                 
               } 
            while (guessNumber != randomToGuess);

            System.out.println("Good Job!! It took you " + attemptCount + " attempts.");

            System.out.print("Do you want to repeat? [Y or y]: ");
            repeat = keyboard.next().charAt(0);

        } 
        while (repeat == 'Y' || repeat == 'y');

//Part C - Input Validation and Condition Switch Case
        
        char choice;
        do 
        {
            System.out.print("\nEnter your choice (A, B, C, or D): ");
            choice = keyboard.next().charAt(0);

            // Convert the choice to uppercase
            choice = Character.toUpperCase(choice);
            
            if (choice < 'A' || choice > 'D') 
            {
                System.out.println("Invalid choice. Please enter A, B, C, or D.");
            }

        } 
        while (choice < 'A' || choice > 'D');
        
        switch (choice) 
        {
            case 'A':
                System.out.println("A for Apple");
                break;
            case 'B':
                System.out.println("B for Banana");
                break;
            case 'C':
                System.out.println("C for Cantaloupe");
                break;
            case 'D':
                System.out.println("D for Dragon Fruit");
                break;
            default:
                System.out.println("Invalid choice");
        }       
//Part D - Read a String and String comparison

        System.out.print("\nEnter an airport code: ");
        String code = keyboard.next().toUpperCase(); 
        keyboard.nextLine();
        switch (code) 
        {
            case "ORF":
                System.out.println("ORF is Norfolk International Airport, Norfolk, VA");
                break;
            case "PHF":
                System.out.println("PHF is Newport News International Airport, Newport News, VA");
                break;
            case "BWI":
                System.out.println("BWI is Baltimore-Washington International Thurgood Marshall Airport, Baltimore, MD");
                break;
            case "DCA":
                System.out.println("DCA is Reagan National Airport, Washington, DC");
                break;
                default:
                System.out.println("Airport code not in the list");
        }

//Part E – Reading Input from Keyboard, String Manipulation and Print
               
        System.out.print("\nEnter your full name: ");
        String fullName = keyboard.nextLine();

        System.out.print("Enter your major: ");
        String major = keyboard.nextLine();

        System.out.print("Enter your GPA: ");
        double gpa = keyboard.nextDouble();
        keyboard.nextLine();
        System.out.print("Enter your favorite sport: ");
        String sport = keyboard.nextLine();

        System.out.print("Enter a number: ");
        int count = keyboard.nextInt();

        System.out.print("Enter your favorite animal: ");
        String animal = keyboard.next();

        //String manip
        int totalChars = fullName.length() + major.length() + sport.length();
        String upper = sport.toUpperCase();
        char firstLetter = sport.charAt(0);
        char lastLetter = Character.toUpperCase(animal.charAt(animal.length() - 1));

        System.out.println("\nHello, my name is " + fullName + ".");
        System.out.println("At \"Hampton University,\" my major is " + major + " with " + gpa + ".");
        System.out.println("I love " + upper + ", and I have " + count + " " + animal + "s at home.");
        System.out.println("There is a total of " + totalChars + " characters in our Strings.");
        System.out.println("The first character of " + sport + " is " + firstLetter + ".");
        System.out.println("The last character of " + animal + " is " + lastLetter);

     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
       
   }
 }
         
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
    