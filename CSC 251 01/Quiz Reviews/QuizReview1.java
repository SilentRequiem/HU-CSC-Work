import java.util.*;
public class QuizReview1 {

    /*
        
        Stack:
        1) ADT
        2) No where in description does it state how it's implemented
        3) many differents ways to implement
        4) only top, remove, add, peek
        5) Linear structure

        Array:
        
        
        
        
    */

    final int size = 10;

    int[] origStack = new int[size];
    int[] tempStack = new int[size];

    int top = 0;
    int ttop = 0;

    Scanner keyboard = new Scanner(System.in);

    public void AddOneEven() {
        
        if (top + 1 <= size) {
            System.out.println("Enter an even number");
            int num = keyboard.nextInt();

            while (num % 2 != 0) {
                System.out.println("Input is not even, enter again");
                num = keyboard.nextInt();
            }
            origStack[top] = num;
            top++;
        } 
    }


    public int searchLess(int num) {
        int amountLess = 0;

        for (int i = top; i >= 0; i--) {
            
            if(num > origStack[i]) {
                amountLess++;
            }
            
            tempStack[ttop] = origStack[i];
            top++;
            ttop++;
        }

        ttop = 0;
        

        return amountLess;
    }


    public static void main(String[] args) {
        
        
        



    }
}



