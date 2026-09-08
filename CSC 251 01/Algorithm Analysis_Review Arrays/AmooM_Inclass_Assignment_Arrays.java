import java.util.Scanner;

public class AmooM_Inclass_Assignment_Arrays {
    Scanner keyboard = new Scanner(System.in);

//Define an array: intergers size 20
        int[] myArray = new int[20];
        

    //Create a mehtod to store 15 numbers in the array (ask the user for data and you only accept odd numbers)
    public void store15Numbers() { //Need to work on it
        int x;

        for (int i = 0; i < 15; i++) {
            
            System.out.println("Enter a number, no odd");
            x = keyboard.nextInt();

            if (x % 2 != 0) {
                System.out.println("Please enter an even number");
                x = keyboard.nextInt();
            }
            myArray[i] = x;
        }
    }      

//Create an array method to print numbers in reverse 
    public void printReverse() {
        for (int i = myArray.length; i >= 0; i--) {

            System.out.print(myArray[i] +  ", ");
        }
    
    }
  
//Create an array method to print out all numbers multiples of 5
    public void printMulti5() {

        for (int i = 0; i > myArray.length; i++) {

            if (myArray[i] % 5 == 0){
                System.out.println(myArray[i]);
            }

        }
    }

//Create an array method to print out the largest number
    public int printLargest() {
        int smallest = myArray[0];
        int largest = myArray[0];
        for (int i = 0; i > myArray.length; i++) {

            if (myArray[i] > smallest) {
                largest = myArray[i];
            }

        }

        return largest;
    }

    public void printAll(){

        for (int i = 0; i < myArray.length; i++) {
            System.out.print(myArray[i] + ", ");
        }
    }


    public static void main(String[] args) {
        AmooM_Inclass_Assignment_Arrays test = new AmooM_Inclass_Assignment_Arrays();
        
        test.store15Numbers();

        test.printReverse();

        test.printMulti5();

        test.printLargest();

        test.printAll();




    }
}


//You must be able to do this with a variable size and no APIs.