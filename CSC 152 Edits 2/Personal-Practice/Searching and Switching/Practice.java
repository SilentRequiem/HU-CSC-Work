import java.util.Scanner;

public class Practice {
    public static void main(String[] args) {
        System.out.println("Partially Filled Array - Enter -1 to stop:");

        Scanner keyboard = new Scanner(System.in);
        int[] array1 = new int[100]; // Create an array of 100 elements
        int count = 0; // Count of actual numbers entered

        // Fill the array with user input
        for (int i = 0; i < array1.length; i++) {
            int num = keyboard.nextInt();
            
            if (num == -1) {
                break; // Stop input when -1 is entered
            }

            array1[count] = num; // Store the number in the array
            count++; // Increment count of valid elements
        }

        System.out.println("Array: ");

        // Print the stored values with 10 elements per line
        for (int i = 0; i < count; i++) {
            System.out.print(array1[i] + " ");
            
            // Print a newline every 10 elements
            if ((i + 1) % 10 == 0) {
                System.out.println();
            }
        }
        
        keyboard.close(); // Close the scanner


        int num = 0;
        switch (num) {

            case 1:
                System.out.println("Case 1");
                break;

            case 2:
                System.out.println("Case 2");
                break;

            default:
                System.out.println("Default case");
                break;
        }

        /*
        int highest = array1[0];
        int lowest = array1[0];
        int sum = 0;
        average = 0;
        
        average = (double) sum / count;
        System.out.println("Average: " + average);


         */



         int[] numbers = {1, 2, 3, 4, 5};
         int results = 0;

         //search the array for the value 3

         

         if (results == -1) {
             System.out.println("The value 3 was not found in the array");
         } else {
             System.out.println("The value 3 was found at index " + results);
         }


    }
}
