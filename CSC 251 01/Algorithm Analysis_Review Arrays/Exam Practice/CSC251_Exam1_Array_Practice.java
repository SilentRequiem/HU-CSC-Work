import java.util.Scanner;

/*
    CSC 251 - Exam 1 Array Practice
    Based on the array review questions and in-class patterns.

    TEST RULES / REMINDERS
    - Assume Scanner has already been created as: Scanner keyboard = new Scanner(System.in);
    - On the paper test, your professor allows S.O.P / S.O.Pln as shorthand.
    - In this actual Java file, use System.out.print / System.out.println so it can compile.
    - Do NOT use .length for the practice questions unless your professor specifically allows it.
    - Use your own variables such as size and count.
    - Try each question BEFORE looking at the answer key at the bottom.
*/

public class CSC251_Exam1_Array_Practice {

    Scanner keyboard = new Scanner(System.in);

    /*
        =========================================================
        QUESTION 1 - ARRAY PROPERTIES
        =========================================================

        Write FOUR properties of an array.

        Your answers:
        1. fixed size
        2. access by name and index
        3. can use any data type but have to use the same type it intialized
        4. sequencial collection 

        TIP:
        Think about:
        - size
        - data type
        - indexes
        - last valid index
    */


    /*
        =========================================================
        QUESTION 2 - CREATE AND FILL AN ARRAY
        =========================================================

        Create an integer array named numbers with a size of 10.
        Use a variable named size.

        Then use a for loop to ask the user for 10 numbers
        and store them in the array.

        Do NOT use .length.

        TIP:
        You need:
        1. a size variable
        2. an int array
        3. a for loop
        4. numbers[i] = ...
    */
    public void question2() {

        // TODO: Create int size = 10;

        int size = 10;

        // TODO: Create int[] numbers using size;

        int[] numbers = new int[size];

        // TODO: Use a loop to fill the array;

        for (int i = 0; i < size; i++) {
            
            System.out.println("Enter a number: ");
            numbers[i] = keyboard.nextInt();

        }

    }


    /*
        =========================================================
        QUESTION 3 - ONLY STORE MULTIPLES OF 3
        =========================================================

        Assume:
            int size = 10;
            int[] numbers = new int[size];

        Fill the array, but ONLY accept multiples of 3.

        If the user enters an invalid number, keep asking
        until they enter a multiple of 3.

        Do NOT use .length.

        TIP:
        - for loop = move through the array
        - while loop = reject bad input
        - A multiple of 3 has remainder 0 when divided by 3
    */
    public void question3() {

        int size = 10;
        int[] numbers = new int[size];

        // TODO: Write the input + validation loop here.

        int num; 
        for (int i = 0; i < size; i++) {
            
            System.out.println("Enter a multiple of 3");
            num = keyboard.nextInt();

            while (num % 3 != 0) {
                System.out.println("Please enter a multiple of 3");
                num = keyboard.nextInt();
            }
            
            numbers[i] = num; 

        }


    }


    /*
        =========================================================
        QUESTION 4 - PRINT VALUES BETWEEN 15 AND 25
        =========================================================

        Go through an already-filled array and print every
        number between 15 and 25, INCLUSIVE.

        That means 15 and 25 both count.

        IMPORTANT:
        This is a FILTER question.
        Do NOT ask the user for new input.

        TIP:
        Use:
            numbers[i] >= 15
        AND
            numbers[i] <= 25
    */
    public void question4() {

        int size = 10;
        int[] numbers = {3, 15, 18, 25, 30, 9, 21, 50, 16, 12};

        // TODO: Traverse the array and print only values in range.

        for (int i = 0; i < size; i++) {
         
            if (numbers[i] >= 15 && numbers[i] <= 25) {
                System.out.print(numbers[i] + ", ");
            }

        }

    }


    /*
        =========================================================
        QUESTION 5 - RETURN THE LARGEST NUMBER
        =========================================================

        Write the logic that finds and returns the largest
        value in the array.

        TIP:
        Start with an ACTUAL value from the array:

            int largest = numbers[0];

        Then compare each current number with largest.

        REMEMBER:
        return is NOT the same as print.
    */
    public int question5() {

        int size = 10;
        int[] numbers = {4, 17, 2, 99, 31, 8, 44, 6, 20, 11};

        // TODO: Find the largest value.

        int largest = numbers[0];

        for (int i = 0; i < size; i++) {
            
            if (numbers[i] > largest) {

                largest = numbers[i];
            }

        }

        return largest;
    }


    /*
        =========================================================
        QUESTION 6 - COUNT STRING OCCURRENCES
        =========================================================

        Search the USED part of arrayStr and return how many
        times str appears.

        Example:
            arrayStr = {"Hi", "Hello", "Hi", "Hope"}
            str = "Hi"

        Return:
            2

        TIP:
        - Use count to control how far you search.
        - Use a SEPARATE variable to count matches.
        - For Strings, use .equals(), NOT ==.
    */
    public int question6(String str) {

        int stringSize = 15;
        String[] arrayStr = new String[stringSize];

        arrayStr[0] = "Hi";
        arrayStr[1] = "Hello";
        arrayStr[2] = "Hi";
        arrayStr[3] = "Hope";

        int count = 4;

        // TODO: Count how many times str appears.

        int strCount = 0;
        for (int i = 0; i < count; i++) {
            
            if (arrayStr[i].equals(str)){
                strCount++;
            }

        }

        return strCount;
    }


    /*
        =========================================================
        QUESTION 7 - CALCULATE THE AVERAGE
        =========================================================

        Calculate and return the average of all 10 numbers.

        TIP:
        - Start sum at 0.
        - Add every element into sum.
        - Avoid integer division.
        - If sum is a double, the decimal part is kept.
        - You may also keep a count of how many values you added.
    */
    public double question7() {

        int[] numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        
        // TODO: Calculate the average.

        double sum = 0.0;
        int count = 0;
        
        for (int i = 0; i < 10; i++) {
            sum += numbers[i];
            count++;
        }



        double avg = sum / count;

        return avg; 
    }


    /*
        =========================================================
        QUESTION 8 - FIND A NUMBER
        =========================================================

        Search for x in the array.

        Return true IMMEDIATELY if x is found.
        If the loop finishes without finding x, return false.

        TIP:
        This question asks:
            "Did I find it?"

        So the return type is boolean.
    */
    public boolean question8(int x) {

        int[] numbers = {4, 8, 12, 16, 20, 24, 28, 32, 36, 40};

        // TODO: Search for x.

        for (int i = 0; i < numbers.length; i++) {
            
            if (numbers[i] == x) {

                return true;

            }

        }

        return false;
    }


    /*
        =========================================================
        QUESTION 9 - LONGEST STRING LENGTH
        =========================================================

        Return the LENGTH of the longest String in the used
        part of the array.

        Example:
            {"Hi", "Hello", "Hampton"}

        Return:
            7

        TIP:
        This is almost the same pattern as finding the
        largest integer.

        Start with:
            arrayStr[0].length()

        Then compare each String's length to your current longest.
    */
    public int question9() {

        String[] arrayStr = {
            "Hi",
            "Hello",
            "Hampton",
            "Hope",
            "Henry"
        };

        int count = 5;

        // TODO: Find the longest String length.
        int largest = arrayStr[0].length();
        
        for (int i = 0; i < count; i++) {
            
            if (arrayStr[i].length() > largest) {

                largest = arrayStr[i].length();
            }

        }


        return largest; // Replace this when you finish.
    }


    /*
        =========================================================
        QUESTION 10 - ONLY STORE WORDS STARTING WITH CAPITAL H
        =========================================================

        Create a String array with a capacity of 15.

        Store 10 words.

        ONLY accept words whose first character is capital H.

        Keep asking if the word does not begin with H.

        Keep track of how many valid words are stored.

        TIP:
        - String word;
        - word.charAt(0)
        - Compare a char with: 'H'
        - while loop rejects bad input
        - arrayStr[i] = word;
        - count++;
    */
    public void question10() {

        int size = 15;
        String[] arrayStr = new String[size];
        int count = 0;


        // TODO: Store 10 valid words beginning with capital H.

            String[] capH = new String[size];
            String word;    
            for (int i = 0; i < size; i++) {
                
                System.out.println("Enter a word that begins with capital H");
                word = keyboard.nextLine();

                while (word.charAt(0) != 'H') {
                    System.out.println("Please enter a word that begins with capital H");
                    word = keyboard.nextLine();
                }
                
                capH[i] = word;
                count++;
            }

    }


    public static void main(String[] args) {

        /*
            You can create an object and test ONE question at a time.

            Example:

            CSC251_Exam1_Array_Practice test =
                new CSC251_Exam1_Array_Practice();

            test.question3();

            For methods that RETURN values, print the call:

            System.out.println(test.question5());
            System.out.println(test.question8(24));
        */

    }


    /*
        =========================================================
        QUICK PATTERN SHEET
        =========================================================

        FOR LOOP
        --------
        Usually means:
        "Travel through the array."

            for (int i = 0; i < size; i++) {
                // use array[i]
            }


        WHILE LOOP
        ----------
        Usually means:
        "Keep asking while the input is invalid."

            while (input is invalid) {
                input = keyboard.nextInt();
            }


        IF STATEMENT
        ------------
        Usually means:
        "Check/filter the current value."

            if (condition) {
                // do something
            }


        COUNT
        -----
        count = how many VALID elements are stored

        A separate variable such as strCount can mean:
        how many MATCHES were found


        SIZE
        ----
        size = total capacity of the array


        STRING COMPARISON
        -----------------
        Use:
            arrayStr[i].equals(str)

        Not:
            arrayStr[i] == str


        LAST INDEX
        ----------
        If size = 10:

            valid indexes = 0 through 9
            last index = size - 1


        REVERSE LOOP
        ------------
            for (int i = size - 1; i >= 0; i--) {
                ...
            }


        RETURN VS PRINT
        ---------------
        return value;
            sends a value back to the caller

        System.out.println(value);
            displays the value on the screen
    */
}
