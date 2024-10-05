import java.util.Scanner;

public class MathEquation {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // Part 1: Calculating Powers with Math.pow()
        System.out.println("** Part 1: Calculating Powers **");
        System.out.print("Enter a base number: ");
        double base = scanner.nextDouble();

        System.out.print("Enter an exponent: ");
        double exponent = scanner.nextDouble();

        // TODO: Use Math.pow() to calculate the result and print it
        double powerResult = Math.pow(base, exponent);
        System.out.println("Result: " + base + " raised to the power of " + exponent + " is: " + powerResult);

        // Part 2: Calculating Square Roots with Math.sqrt()
        System.out.println("\n** Part 2: Calculating Square Roots **");
        System.out.print("Enter a number to find its square root: ");
        double number = scanner.nextDouble();

        // TODO: Use Math.sqrt() to calculate the square root and print it
        double sqrtResult = Math.sqrt(number);
        System.out.println("The square root of " + number + " is: " + sqrtResult);

        //EXTRA Part 3: Application Example - Pythagorean Theorem
        System.out.println("\n** Part 3: Pythagorean Theorem **");
        System.out.print("Enter the length of side a: ");
        double a = scanner.nextDouble();

        System.out.print("Enter the length of side b: ");
        double b = scanner.nextDouble();

        // TODO: Use Math.pow() and Math.sqrt() to calculate the hypotenuse and print the result
        double c = Math.sqrt( Math.pow(a, 2) + Math.pow(b, 2) );
        System.out.println("The hypotenuse (side c) is: " + c);
    }
}
