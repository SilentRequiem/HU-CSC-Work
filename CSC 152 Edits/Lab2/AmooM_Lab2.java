// LastnameFirstinitial_Lab2.java

// Import required classes
import java.util.Scanner;  // For user input and file reading
import java.io.File;       // For reading files
import java.io.PrintWriter; // For writing to files
import java.io.IOException; // To handle input/output exceptions
import java.util.Random;    // For generating random numbers

public class AmooM_Lab2 {

    public static void main(String[] args) throws IOException {
        Scanner input = new Scanner(System.in); // Input from keyboard
        
        // Part A: Read integers from a file and calculate sum, count, and average
        File file = new File("data.txt");
        Scanner fileReader = new Scanner(file);
        int sum = 0, count = 0;
        
        System.out.println("Part A – Read Data from a file");
        System.out.print("Integers from a data.txt file are:\n");
        
        // Read the integers and print them in rows of 10
        while (fileReader.hasNextInt()) {
            if (count % 10 == 0 && count != 0) {
                System.out.println(); // Print new line after 10 numbers
            }
            int number = fileReader.nextInt();
            System.out.print(number + "\t");
            sum += number;
            count++;
        }
        
        double average = (double) sum / count;
        System.out.println("\nSum of all " + count + " integers is " + sum);
        System.out.printf("Average of all %d integers is %.2f\n", count, average);
        
        fileReader.close();

        // Part B: Write user input to a text file
        System.out.println("\nPart B – Writing Output to a Text File");
        System.out.print("Please enter first name: ");
        String firstName = input.next();
        System.out.print("Please enter last name: ");
        String lastName = input.next();
        System.out.print("Please enter age: ");
        int age = input.nextInt();
        System.out.print("Please enter your major: ");
        String major = input.next();
        String fullName = firstName + " " + lastName;
        
        PrintWriter outputFile = new PrintWriter("Lastname_output.txt");
        outputFile.println("Hello, my name is " + firstName + " " + lastName + ". I am " + age + " years old and my major is " + major + ".");
        outputFile.println("My full name contains " + fullName.length() + " characters.");
        outputFile.println("My full name in uppercase is " + fullName.toUpperCase() + ".");
        outputFile.println("The last character of my last name in uppercase is " + lastName.toUpperCase().charAt(lastName.length() - 1) + ".");
        outputFile.close();
        
        // Part C: While-loop for input validation
        System.out.println("\nPart C – While-loop: Data Validation");
        int limit;
        do {
            System.out.print("Please enter an integer for limit (5 – 10): ");
            limit = input.nextInt();
            if (limit < 5 || limit > 10) {
                System.out.println("Invalid, limit should be between 5 and 10, please reenter.");
            }
        } while (limit < 5 || limit > 10);
        System.out.println("You entered " + limit + " for limit.");
        
        // Part D: For-loop calculations
        System.out.println("\nPart D – For-loop: Square, Cube, Square Root");
        System.out.println("Number\tSquare\tCube\tSquare Root");
        for (int i = 1; i <= limit; i++) {
            System.out.printf("%d\t%d\t%d\t%.3f\n", i, i * i, i * i * i, Math.sqrt(i));
        }
        
        // Part E: Do-While loop for rolling dice
        System.out.println("\nPart E – Do-While-loop: Rolling Dices");
        Random rand = new Random();
        int dice1, dice2, sumDices;
        do {
            dice1 = rand.nextInt(6) + 1; // Generate number between 1-6
            dice2 = rand.nextInt(6) + 1;
            sumDices = dice1 + dice2;
            System.out.println("Dice are " + dice1 + " " + dice2 + " (sum = " + sumDices + ")");
        } while (sumDices != 9);
        System.out.println("Nine Rolled");
    }
}
