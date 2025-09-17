/* 
Author: Michael Amoo
Instructor:  Dr. Jean Muhammad || Dr. Paudel
Class:  CSC-251-01 Data Structures
Description:  Array Program - practicing writing array methods
Date: 9/9/25
*/


// Array Driver

public class ArrayDriverMA {
    public static void main(String[] args) {

        // create object for calling the class methods
        ArrayStarter1 objectMA = new ArrayStarter1(); // use objectMA object to call your methods

        // call your method in the order listed below
        
            // call the store method 
            objectMA.arrayStore();

            //call arrayPrint()
            objectMA.arrayPrint();

            // call addOneElement (32)
            boolean added = objectMA.addOneElement(32);
            System.out.println("Can you fit a 32? " + added);
            objectMA.arrayPrint();

            // call searchArray( 16)
            System.out.println("Is there a 16 here? " + objectMA.searchArray(16)); // System.out.println("element found:"+  objectJM.searchArray(16))

            // call printMultiple8()
            objectMA.printMultiple8();

            // call findAllRange()
            int Over15 = objectMA.findAllRange();
            System.out.println("Number of elements over 15: " + Over15);

            // call averageArray()
            int avg = objectMA.averageArray();
            System.out.println("Average: " + avg);

            //call smallestEleArray
            int smallest = objectMA.smallestEleArray();
            System.out.println("Smallest element in array: " + smallest);


          
    } // end main method

} //end array driver 