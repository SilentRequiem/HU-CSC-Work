import java.util.Random;

public class RandomGenerator {
    // Generate a single random number between a and b (inclusive)
    public static int generateRandomNumber(int a, int b) {
        if (a > b) {
            throw new IllegalArgumentException("Error: Lower bound 'a' must be less than or equal to upper bound 'b'.");
        }

        Random random = new Random();
        return random.nextInt(b - a + 1) + a;
        
    }

    // Generate and return an array of N random numbers between a and b
    public static int[] generateRandomArray(int N, int a, int b) {
        int[] array = new int[N];

        for (int i = 0; i < N; i++) {
            array[i] = generateRandomNumber(a, b);
        }

        return array;
    }

    // Print an array
    public static void printArray(int[] array, int a, int b) {
        System.out.println("Random numbers between " + a + " and " + b + ":");
        for (int num : array) {
            System.out.print(num + " ");
        }
        System.out.println(); // Newline


        
    }
}