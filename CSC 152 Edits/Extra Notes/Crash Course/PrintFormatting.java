public class PrintFormatting {

    public static void main(String[] args) {
        // Declare integer variables
        int num1 = 5;
        int num2 = 10;
        int result = num1 + num2;

	     //Incorrect use: num1 is treated as part of the string
        System.out.println("The number is + num1"); 

        // Correct use: num1 is concatenated with the string
        System.out.println("The number is " + num1);

        // Print with tabs and new lines
        System.out.println("\nWith Formatting:");
        System.out.println("The numbers are:\nNumber 1: " + num1 + "\nNumber 2: " + num2);
        System.out.println("Result: " + result);

        // Another way to format by adding a tab before and new line after the result
        System.out.println("\nAnother example:");
        System.out.println("\tSum of " + num1 + " and " + num2 + " is: " + result + "\n");
    }
}
