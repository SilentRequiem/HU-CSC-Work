/*
    CSC 251 - Exam 1 Array Practice Answer Key
    Separate answer key with explanations and tips.

    IMPORTANT:
    This file is meant for REVIEW.
    Read the explanation first, then study the code pattern.

    Your professor's common test expectations:
    - Scanner is already created as: Scanner keyboard = new Scanner(System.in);
    - S.O.P and S.O.Pln may be used as shorthand on paper.
    - Do not rely on .length when the question expects you to use size/count.
*/

import java.util.Scanner;

public class CSC251_Exam1_Array_AnswerKey {

    Scanner keyboard = new Scanner(System.in);


    /*
        =========================================================
        QUESTION 1 - ARRAY PROPERTIES
        =========================================================

        ANSWER:
        1. An array has a fixed size once it is created.
        2. An array stores one data type at a time.
        3. Array indexes start at 0.
        4. The last valid index is size - 1.

        EXPLANATION:
        If size = 10, then the valid indexes are:

            0 1 2 3 4 5 6 7 8 9

        There are still 10 spaces, but index 10 does NOT exist.

        TIP:
        Think:
            amount of spaces = size
            last index = size - 1
    */


    /*
        =========================================================
        QUESTION 2 - CREATE AND FILL AN ARRAY
        =========================================================
    */
    public void question2() {

        int size = 10;
        int[] numbers = new int[size];

        for (int i = 0; i < size; i++) {

            System.out.println("Enter a number: ");
            numbers[i] = keyboard.nextInt();
        }

        /*
            EXPLANATION:

            int size = 10;
                Creates a normal integer variable.

            int[] numbers = new int[size];
                Creates an integer array with 10 spaces.

            for (int i = 0; i < size; i++)
                Makes i travel through:
                    0, 1, 2, ... 9

            numbers[i] = keyboard.nextInt();
                Stores the user's number into the current index.

            Example:
                i = 3
                user enters 17

                numbers[i] = 17
                becomes:
                numbers[3] = 17

            TIP:
            i tells you WHERE.
            The input tells you WHAT.
        */
    }


    /*
        =========================================================
        QUESTION 3 - ONLY STORE MULTIPLES OF 3
        =========================================================
    */
    public void question3() {

        int size = 10;
        int[] numbers = new int[size];
        int num;

        for (int i = 0; i < size; i++) {

            System.out.println("Enter a multiple of 3: ");
            num = keyboard.nextInt();

            while (num % 3 != 0) {

                System.out.println("Please enter a multiple of 3: ");
                num = keyboard.nextInt();
            }

            numbers[i] = num;
        }

        /*
            EXPLANATION:

            num % 3 != 0
                means the number is NOT divisible by 3.

            Examples:
                9 % 3 = 0   valid
                12 % 3 = 0  valid
                10 % 3 = 1  invalid

            The while loop keeps running only while the input
            is invalid.

            Once the user enters a valid number, the while loop
            ends and the value is stored.

            TIP:
            for loop = move through array
            while loop = reject bad input

            Think:
                while INVALID
                    ask again
        */
    }


    /*
        =========================================================
        QUESTION 4 - PRINT VALUES BETWEEN 15 AND 25
        =========================================================
    */
    public void question4() {

        int size = 10;
        int[] numbers = {3, 15, 18, 25, 30, 9, 21, 50, 16, 12};

        for (int i = 0; i < size; i++) {

            if (numbers[i] >= 15 && numbers[i] <= 25) {

                System.out.println(numbers[i]);
            }
        }

        /*
            EXPLANATION:

            This is NOT an input-validation problem.

            The numbers are already stored.

            Your job is to:
                1. travel through the array
                2. inspect numbers[i]
                3. print it if it is in range

            >= 15
                means 15 counts.

            <= 25
                means 25 counts.

            && means BOTH conditions must be true.

            Example:
                18 >= 15  true
                18 <= 25  true

                true && true = print 18

            TIP:
            If the question says:
                "print values already in the array"

            think:
                for + if

            NOT:
                for + input + while
        */
    }


    /*
        =========================================================
        QUESTION 5 - RETURN THE LARGEST NUMBER
        =========================================================
    */
    public int question5() {

        int size = 10;
        int[] numbers = {4, 17, 2, 99, 31, 8, 44, 6, 20, 11};

        int largest = numbers[0];

        for (int i = 0; i < size; i++) {

            if (numbers[i] > largest) {

                largest = numbers[i];
            }
        }

        return largest;

        /*
            EXPLANATION:

            Start with:
                int largest = numbers[0];

            This means:
                "For now, I will assume the first value
                is the largest."

            Then compare every number against largest.

            Example:
                current largest = 17
                current number = 99

                99 > 17
                true

                largest becomes 99

            TIP:
            Think of largest as the current champion.

            Every new number challenges the champion.

            If the new number is bigger:
                largest = numbers[i];

            IMPORTANT:
            return largest;
                sends the answer back.

            It does NOT print it.
        */
    }


    /*
        =========================================================
        QUESTION 6 - COUNT STRING OCCURRENCES
        =========================================================
    */
    public int question6(String str) {

        int size = 15;
        String[] arrayStr = new String[size];

        arrayStr[0] = "Hi";
        arrayStr[1] = "Hello";
        arrayStr[2] = "Hi";
        arrayStr[3] = "Hope";

        int count = 4;
        int strCount = 0;

        for (int i = 0; i < count; i++) {

            if (arrayStr[i].equals(str)) {

                strCount++;
            }
        }

        return strCount;

        /*
            EXPLANATION:

            count:
                tells us how many array positions are actually used.

            strCount:
                tells us how many matches we found.

            These are NOT the same job.

            Example:
                arrayStr:
                ["Hi", "Hello", "Hi", "Hope"]

                count = 4

                search for "Hi"

                match at index 0 -> strCount = 1
                no match at index 1
                match at index 2 -> strCount = 2
                no match at index 3

                return 2

            IMPORTANT:
            For Strings use:

                .equals()

            Example:
                arrayStr[i].equals(str)

            Do NOT use == for String contents.

            TIP:
            count = stored elements
            strCount = matching elements
        */
    }


    /*
        =========================================================
        QUESTION 7 - CALCULATE THE AVERAGE
        =========================================================
    */
    public double question7() {

        int[] numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

        double sum = 0;
        int count = 0;

        for (int i = 0; i < 10; i++) {

            sum += numbers[i];
            count++;
        }

        double avg = sum / count;

        return avg;

        /*
            EXPLANATION:

            Start:
                sum = 0
                count = 0

            Every loop:
                add current number to sum
                increase count

            For this array:
                sum = 55
                count = 10

            average:
                55.0 / 10 = 5.5

            WHY use double sum?

            If you do:
                int sum = 55;
                int count = 10;

                sum / count

            Java performs integer division:
                55 / 10 = 5

            Using double lets you keep the decimal.

            TIP:
            Average always means:

                total / amount
        */
    }


    /*
        =========================================================
        QUESTION 8 - FIND A NUMBER
        =========================================================
    */
    public boolean question8(int x) {

        int[] numbers = {4, 8, 12, 16, 20, 24, 28, 32, 36, 40};

        for (int i = 0; i < 10; i++) {

            if (numbers[i] == x) {

                return true;
            }
        }

        return false;

        /*
            EXPLANATION:

            This method answers one question:

                "Does x exist in the array?"

            That answer is either:
                true
            or:
                false

            As soon as x is found:
                return true;

            The method ends immediately.

            If Java finishes the whole loop and never finds x:
                return false;

            TIP:
            If the question says:
                "Does it exist?"
                "Was it found?"

            think:
                boolean
        */
    }


    /*
        =========================================================
        QUESTION 9 - LONGEST STRING LENGTH
        =========================================================
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

        int longest = arrayStr[0].length();

        for (int i = 0; i < count; i++) {

            if (arrayStr[i].length() > longest) {

                longest = arrayStr[i].length();
            }
        }

        return longest;

        /*
            EXPLANATION:

            This uses almost the exact same pattern as finding
            the largest integer.

            Instead of comparing:

                numbers[i]

            you compare:

                arrayStr[i].length()

            Example:
                "Hi"      length 2
                "Hello"   length 5
                "Hampton" length 7

            longest starts at 2.

            Then:
                5 > 2 -> longest = 5
                7 > 5 -> longest = 7

            return 7

            IMPORTANT:
            This version returns the LENGTH.

            It does NOT return the actual word "Hampton".

            TIP:
            largest number pattern:
                numbers[i] > largest

            longest string-length pattern:
                arrayStr[i].length() > longest
        */
    }


    /*
        =========================================================
        QUESTION 10 - ONLY STORE WORDS STARTING WITH CAPITAL H
        =========================================================
    */
    public void question10() {

        int size = 15;
        String[] arrayStr = new String[size];
        int count = 0;
        String word;

        for (int i = 0; i < 10; i++) {

            System.out.println("Enter a word beginning with capital H: ");
            word = keyboard.nextLine();

            while (word.charAt(0) != 'H') {

                System.out.println("Enter a word beginning with capital H: ");
                word = keyboard.nextLine();
            }

            arrayStr[i] = word;
            count++;
        }

        System.out.println("Stored " + count + " words.");

        /*
            EXPLANATION:

            word.charAt(0)
                gets the character at index 0 of the String.

            Example:
                word = "Hello"

                H e l l o
                0 1 2 3 4

                word.charAt(0) = 'H'

            We want capital H.

            So invalid input means:

                word.charAt(0) != 'H'

            The while loop keeps asking until the first character
            is exactly capital H.

            Then:
                arrayStr[i] = word;

            stores the valid word.

            count++;
                records that another valid element was stored.

            TIP:
            Strings use double quotes:
                "Hello"

            chars use single quotes:
                'H'
        */
    }


    /*
        =========================================================
        FINAL EXAM-PATTERN REVIEW
        =========================================================

        1. CREATE ARRAY
           int size = 10;
           int[] numbers = new int[size];


        2. TRAVERSE FORWARD
           for (int i = 0; i < size; i++) {
               ...
           }


        3. TRAVERSE ONLY USED ELEMENTS
           for (int i = 0; i < count; i++) {
               ...
           }


        4. TRAVERSE BACKWARDS
           for (int i = size - 1; i >= 0; i--) {
               ...
           }


        5. FILTER EXISTING DATA
           for (...) {
               if (condition) {
                   print
               }
           }


        6. VALIDATE USER INPUT
           get input

           while (input is invalid) {
               ask again
           }

           store input


        7. COUNT MATCHES
           int matchCount = 0;

           if (match found) {
               matchCount++;
           }


        8. FIND LARGEST
           start with first value

           if (current > largest) {
               largest = current;
           }


        9. BOOLEAN SEARCH
           if found:
               return true;

           after loop:
               return false;


        10. RETURN VS PRINT

            return answer;
                sends value back

            System.out.println(answer);
                displays value


        =========================================================
        FAST TEST-DAY CHECKLIST
        =========================================================

        Before finishing a coding question, ask yourself:

        - Did I start i at 0?
        - Did I stop before size/count?
        - Did I accidentally use <= where < is needed?
        - Am I using size or count correctly?
        - If this is String comparison, did I use .equals()?
        - If this method returns something, did I write return?
        - If I need decimal division, is one value a double?
        - If I am validating input, did I use a while loop?
        - If I am filtering existing data, did I avoid asking for new input?
    */


    public static void main(String[] args) {

        CSC251_Exam1_Array_AnswerKey test =
            new CSC251_Exam1_Array_AnswerKey();

        /*
            Uncomment ONE line at a time if you want to test methods.

            test.question2();

            test.question3();

            test.question4();

            System.out.println(test.question5());

            System.out.println(test.question6("Hi"));

            System.out.println(test.question7());

            System.out.println(test.question8(24));

            System.out.println(test.question9());

            test.question10();
        */
    }
}
