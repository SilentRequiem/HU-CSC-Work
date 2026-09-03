import java.util.Scanner;

public class ArrayAnswer {
    Scanner keyboard = new Scanner(System.in);

//Define an array: intergers size 20
        int size = 20;
        int[] myArray = new int[size];
        

//Create a method to store 15 numbers in the array (ask the user for data and you only accept odd numbers)    
    public void store15Numbers() { 
        int num;
        
        for (int i = 0; i < 15; i++) {
            
            System.out.println("Enter a number: ");
            num = keyboard.nextInt();
            

            while (num % 2 == 0) {
                System.out.print("That is even. Enter an odd number: ");
                num = keyboard.nextInt();
            }

            myArray[i] = num;
        }
        
    }      

//Create an array method to print numbers in reverse 
    public void printReverse() {
       
        for (int i = size - 1; i >= 0; i--) {
            
            System.out.print(myArray[i] + ", ");

        }


    }
  
//Create an array method to print out all numbers multiples of 5
    public void printMulti5() {

        for (int i = 0; i < size; i++) {
            
            if (myArray[i] % 5 == 0){
                System.out.print(myArray[i] + ", ");
            }
            

        }


    }

//Create an array method to print out the largest number
    public int printLargest() {
     int largest = myArray[0];

        for (int i = 0; i < size; i++) {
            
            if (myArray[i] > largest) {
                largest = myArray[i];
            }

        }

     return largest;

    }

//Create an array method to print out all numbers in array
    public void printAll(){
        for (int i = 0; i < size; i++) {
            System.out.print(myArray[i] + ", ");
        }
    }


    public static void main(String[] args) {
        ArrayAnswer test = new ArrayAnswer();
        
        System.out.println("\nStoring 15 numbers that are odd");
        test.store15Numbers();

        System.out.println("\nPrinting all numbers:");
        test.printAll();

        System.out.println("\nPrinting all numbers in reverse:");
        test.printReverse();

        System.out.println("\nPrinting all multiples of 5:");
        test.printMulti5();

        System.out.println("\nPrinting largest:");
        System.out.println(test.printLargest());

    }
}


//You must be able to do this with a variable size and no APIs.