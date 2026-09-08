import java.util.*;

public class NotesonExam1 {

    // ===== added: shared state your methods expect =====
    // for Questions 4–8 (strings array)
    static final int SIZE = 5;                 // you asked for 5 strings in Q4
    static String[] stringArray = new String[SIZE];
    static int count = 0;

    // for Question 9 (stacks)
    static final int STACK_SIZE = 20;          // roomy stack so inserts succeed
    static int[] originalStack = new int[STACK_SIZE];
    static int[] temporaryStack = new int[STACK_SIZE];
    static int top = -1;                       // top of originalStack
    static int ttop = -1;                      // top of temporaryStack

    // single Scanner used everywhere
    static Scanner keyboard;

    public static void main(String[] args) {
        keyboard = new Scanner(System.in);

        // Question 1
        System.out.println("\n1. Give 3 properties unique to an Abstract Data Type (ADT).");
        System.out.println("Arrays have a fixed size, Homogerous, can call from an index, contigious and random access");
        System.out.println("Stacks don't need a fixed size, Homogeneous, has access to the top only and LIFO/FIFO");

        // Question 2
        System.out.println("\n2. Give 3 properties unique to a Stack");
        System.out.println("Stacks don't need a fixed size, Homogeneous, has access to the top only and LIFO/FIFO");

        // Question 3
        System.out.println("\n3. Define an Array of size 10 that...ll hold intergers. You must define SIZE as a final constant. " +
                           "You must use SIZE to define your array. Your array name is: arrayExam1");
        final int SIZE = 10;
        int[] arrayExam1 = new int[SIZE];

        // Question 4
        System.out.println("\n4. Give a java method: storeArray() that will accept strings from the keyboard and check to " + 
                                "ensure the each string has at l.... If they have 6 or more characters, you will add to the array."
                                + "You will keep track of how ma...d: (Use variable: count). You will add a total of 5 strings. " +
                                "So you will keep adding form the user until you get 5 strings. You must use a loop.");
        storeArray();
        
        // Question 5
        System.out.println("Give a java method: findStrings that...\"begin\" with the your first initial of your last name (a). " +
                           "The method will return the number of...the array that begin with the first intial of your last name." +
                           "There are no parameters passed into this method.");
        System.out.println("Number of strings that begin with 'a': " + findStrings());

        // Question 6
        System.out.println("\n6. Give a java method: add3Elements(). This method will accept 3 strings from the user and add to the array.");
        add3Elements();
        System.out.println("After add3Elements, count = " + count);

        // Question 7
        System.out.println("\n7. Give a java method: deleteLast(). This method will delete the last string added to the array.");
        deleteLast();
        System.out.println("After deleteLast, count = " + count);

        // Question 8
        System.out.println("\n8. Give a java method: buildString() that will build a string of elements that have length between 8 and 10.");
        System.out.println("Result: " + buildString());

        // ===== Question 9 setup (seed stack with a few values so prints aren’t empty) =====
        push(5); push(7); push(9); push(7); push(12);

        // Question 9A
        System.out.println("\n9A. Give a complete method: printStack() that will print the stack");
        printStack();

        // Question 9B
        System.out.println("\n9B. Give a complete method: searchStack(int x) that will search the stack for x");
        System.out.print("Enter an integer to search in the stack: ");
        int x = readInt();
        boolean found = searchStack(x);
        if (found) {
            System.out.println(x + " is found in the stack.");
        } else {
            System.out.println(x + " is not found in the stack.");
        }
        
        // Question 9C
        System.out.println("\n9C. Give a complete method: addAfter(int search, int addElement) that will add addElement AFTER search in the stack.");
        System.out.print("Enter an integer already in the stack (search): ");
        int search = readInt();
        System.out.print("Enter an integer to add after " + search + ": ");
        int addElement = readInt();
        addAfter(search, addElement);
        System.out.println("Stack after adding " + addElement + " after " + search + ":");
        printStack();

        keyboard.close();

        // End of main
    }

    //Question 4 method
    public static void storeArray() { 
        // uses: stringArray, count, keyboard
        while (count < SIZE) {
            System.out.print("Enter a string (at least 6 characters): ");
            String input = keyboard.nextLine().trim();
            if (input.length() >= 6) {
                stringArray[count] = input;
                count++;
            } else {
                System.out.println("Too short. Try again.");
            }
        }
    }

    //Question 5 method
    public static int findStrings() {
        // count strings that begin with 'a' (case-insensitive)
        int num = 0;
        for (int i = 0; i < count; i++) {
            String s = stringArray[i];
            if (s != null && !s.isEmpty() && Character.toLowerCase(s.charAt(0)) == 'a') {
                num++;
            }
        }
        return num;
    }

    //Question 6 method
    public static int add3Elements() {
        int added = 0;
        while (added < 3 && count < SIZE) {
            System.out.print("Enter a string to add: ");
            String s = keyboard.nextLine().trim();
            stringArray[count++] = s;
            added++;
        }
        if (added < 3) {
            System.out.println("Array is full; only added " + added + " element(s).");
        }
        return added;
    }

    //Question 7 method
    public static int deleteLast() {
        if (count > 0) {
            stringArray[--count] = null;
        } else {
            System.out.println("Array is already empty.");
        }
        return count;
    }

    //Question 8 method
    public static String buildString() {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < count; i++) {
            String s = stringArray[i];
            if (s != null && s.length() >= 8 && s.length() <= 10) {
                if (sb.length() > 0) sb.append(' ');
                sb.append(s);
            }
        }
        return sb.toString();
    }

    //9A method
    public static void printStack() {
        if (top < 0) {
            System.out.println("(stack is empty)");
            return;
        }
        for (int i = top; i >= 0; i--) {
            System.out.println(originalStack[i]);
        }
    }

    // helper push (used to seed the stack)
    public static boolean push(int v) {
        if (top == STACK_SIZE - 1) return false;
        originalStack[++top] = v;
        return true;
    }

    //9B method
    public static boolean searchStack(int x) {
        for (int i = top; i >= 0; i--) {
            if (originalStack[i] == x) return true;
        }
        return false;
    }

    //9C method
    public static void addAfter(int search, int addElement) {
        // Check if the stack is full
        if (top == originalStack.length - 1) {
            System.out.println("Stack is full. Cannot add element.");
            return;
        }

        // Search for the element (from top downward, typical stack view)
        int idx = -1;
        for (int i = top; i >= 0; i--) {
            if (originalStack[i] == search) { idx = i; break; }
        }

        if (idx != -1) {
            // Shift elements up to make space AFTER idx
            for (int j = top; j > idx; j--) {
                originalStack[j + 1] = originalStack[j];
            }
            originalStack[idx + 1] = addElement;
            top++;
            return;
        }

        System.out.println("Element " + search + " not found in the stack.");
    }

    // End of class
}
