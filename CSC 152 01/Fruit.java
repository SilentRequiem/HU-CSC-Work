import java.util.Scanner;

public class Fruit {
    public static void main(String[] args) {
        // Create a Scanner object for user input
        Scanner keyboard = new Scanner(System.in);

        // Ask the user to enter a choice
        System.out.print("Enter a choice (A, B, C, or D): ");
        char Fruit = keyboard.next().charAt(0); // Read the first character

        // Check the user's choice and print the corresponding fruit name
        switch (Character.toUpperCase(Fruit)) {
            case 'A':
                System.out.println("You selected Apple");
                break;
            case 'B':
                System.out.println("You selected Banana");
                break;
            case 'C':
                System.out.println("You selected Cantaloupe");
                break;
            case 'D':
                System.out.println("You selected Dragon Fruit");
                break;
            default:
                System.out.println("No fruit on the list");
        }

        
    }
}
