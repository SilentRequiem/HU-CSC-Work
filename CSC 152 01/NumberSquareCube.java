import java.util.Scanner;

public class NumberSquareCube {
    public static void main(String[] args) {
        Scanner keyboard = new Scanner(System.in);

 System.out.print("Enter a max number: ");
 int x = keyboard.nextInt();


 System.out.println("Number    Squared    Cubed");

 
 for (int number = 1; number <= x; number++) {  
   int squared = number * number;
   int cubed = number * number * number;

 System.out.printf("%d\t\t\t %d\t\t\t   %d%n", number, squared, cubed);
 }

    }
}
