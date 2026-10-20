import java.util.Scanner;
public class MidtermPart2 {
    public int size;
    public int top;
    public int ttop;
    private int[] myArray;
    private int[] tempStack;
    private int[] origStack;

    Scanner keyboard = new Scanner(System.in);

/*
Midterm:
 
1) Arrays
2) Stack

Array Properties and Stack Properties are 7 of them.

8 Methods of Stack Implementation.

Around 10 questions.

Exam/Midterm on Thursday

    CSC 251 Quiz Notes: Stacks and Arrays
    Stack Properties
    * A Stack is an Abstract Data Type, ADT
    * A Stack is a collection
    * A Stack is a linear structure
    * A Stack follows LIFO
        * Last In, First Out
    * A Stack is accessed only from the top
    * You add from the top
    * You remove from the top
    * You view or peek from the top
    * The Stack definition does not say how it must be implemented
    * A Stack can be implemented in many different ways
    Array Properties
    * Arrays have a fixed size
    * An array stores one data type at a time
    * Elements are accessed using:
        * array name
        * index
    * Arrays are a sequential collection
    * Arrays use contiguous or continuous memory
    * Indexes start at 0
    * Last valid index is: size - 1
    * 

    Stack vs Array
    Stack = ADT
    Array = Data Structure

    Create a Stack Using an Array
    Example:
    int size = 20;
    String[] origStack = new String[size];
    int top = -1;
    Meaning:
    size
    = capacity of the array

    origStack
    = array used to store the Stack

    top
    = keeps track of the current top element

    top = -1
    = Stack is empty


    STACK
    - ADT
    - LIFO
    - Top only
    - Linear
    - Collection
    - Many implementations
    - Implementation not defined

    ARRAY
    - Fixed size
    - One data type at a time
    - Name + index
    - Sequential
    - Contiguous memory

    STACK VIA ARRAY
    Stack = rules
    Array = storage

    top = -1
    Stack is empty



How to study:

There will be more on Stacks than Arrays
For every test you have there will be at least one question from the previous unit.
Final Exam is comprehensive
Review Tests and Quizzes
Review Programs and Self Teach
Look at Notes
Use Tutors (Today is the last day but after midterm week they are back)
You will see the same concepts but in differnet data types; some might be puzzling

Review days are usually on Wednesdays (if mentioned)


Complete Array Properties (In Class Version as of 10/8/26)
1. Reference by arrayname and index
2. Fixed Size
3. One Continuiogus block of memory
4. Sequential Collection
5. Can use all data types 1 at a time.
6. Linear Structure
7. Access by name and index



Complete Stack Properties (In Class Version as of 10/8/26)
1. ADT
2. Can be implemented in many ways
3. Nowhere in it's description does it say how it's implemented 
4. Only access to top, add, remove, peek
5. Linear Structure
6. Any data type but one at a time

Be able to explain line for line
*/

public void storeArray() {
    
    /*
        Store array method ask user to enter interger between 23-66 that are multpile  of 4
    */

    int x;
    int count = 0;


    while (count != size) {
        System.out.println("Store array method ask user to enter interger between 23-66 that are multpile  of 4");
        x = keyboard.nextInt();

        if (x >= 26 && x <= 66 && x % 4 == 0) {

            myArray[count] = x;
            count++;
        }

    }

}


public boolean arrayFull() {
    /*
        Give the method(s) that will determine if array is full and if array is empty.
    */

    int count = 0;

    if (count == size) {
        return true;
    }
    else {
        return false;
    }
}

public void addOneElement() {
/*
    Stack add one element that is a multiple of 7 that is greater than 25
*/

    if (top < size) {
        System.out.println("Give me one element: ");
        int user = keyboard.nextInt();
    }



}


public void deleteStringGreaterThan5() {
    
}

public void arrayBuildButInReverse() {

}


    public static void main(String[] args) {
        
        
        



    }
}



