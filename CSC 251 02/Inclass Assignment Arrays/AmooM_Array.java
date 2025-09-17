public class AmooM_Array {
    public static void main(String[] args) {
/*
TODO:
Use this random number generator in your main class java 
file to create and print a random array of size 10. */

int size = 10; 
int min = 0;
int max = 150;

int[] rngArray = RandomGenerator.generateRandomArray(size, min, max); //no instance needed because it's static 
//This is an instance RandomGenerator randobject = new RandomGenerator();

/*

 public static int[] generateRandomArray(int N, int a, int b) {
 int[] array = new int[N];

    for (int i = 0; i < N; i++) {
        array[i] = generateRandomNumber(a, b);
        }
        return array;
    }
 */

RandomGenerator.printArray(rngArray, min, max);
/*
 public static void printArray(int[] array, int a, int b) {
        System.out.println("Random numbers between " + a + " and " + b + ":");
        for (int num : array) {
            System.out.print(num + " ");
        }
        System.out.println(); // Newline       
    }
 */



    }
}
