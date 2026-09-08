/* 
Author: Michael Amoo
Instructor:  Dr. Jean Muhammad || Dr. Paudel
Class:  CSC-251-01 Data Structures
Description:  Manual String Stack (size 25) with custom methods
Date: 9/29/25
*/

import java.util.Scanner;

public class FILI_ArrayStack
{
    public int size;
    public int top;
    private String[] stack;

    // second character of "Michael" is 'i'
    private final char secondChar = 'i';

    // constructor
    public FILI_ArrayStack() {
        size = 25;
        top = -1;
        stack = new String[size];
    }

    // check if stack full
    public boolean stackFull()  { return top == size - 1; }

    // check if stack empty
    public boolean stackEmpty() { return top == -1; }

    private void push(String s) {
        if (!stackFull()) {
            top++;
            stack[top] = s;
        }
    }

    private String pop() {
        if (stackEmpty()) return null;
        String val = stack[top];
        stack[top] = null;
        top--;
        return val;
    }

    // store 8 elements into the stack
    public void storeStack(Scanner keyboard) {
        System.out.println("Enter 8 strings (each at least 6 characters):");
        int added = 0;
        while (added < 8 && !stackFull()) {
            System.out.print("#" + (added + 1) + ": ");
            String input = keyboard.nextLine().trim();
            if (input.length() < 6) {
                System.out.println("Must be at least 6 characters.");
                continue;
            }
            push(input);
            added++;
        }
    }

    // print all elements in the stack
    public void printStack() {
        if (stackEmpty()) {
            System.out.println("Stack is empty.");
            return;
        }
        for (int i = top; i >= 0; i--) {
            System.out.println("stack[" + i + "] = " + stack[i]);
        }
    }

    // search for str
    public boolean searchStack(String str) {
        for (int i = 0; i <= top; i++) {
            if (stack[i].equals(str)) return true;
        }
        return false;
    }

    // count occurrences
    public int numOccur(String str) {
        int count = 0;
        for (int i = 0; i <= top; i++) {
            if (stack[i].equals(str)) count++;
        }
        return count;
    }

    // build string with elements containing secondChar
    public String buildString() {
        String result = "";
        for (int i = 0; i <= top; i++) {
            if (stack[i].indexOf(secondChar) >= 0) {
                if (result.equals("")) result = stack[i];
                else result += " | " + stack[i];
            }
        }
        return result;
    }

    // print all elements with 5th character == c
    public void printAllChar(char c) {
        boolean any = false;
        for (int i = 0; i <= top; i++) {
            if (stack[i].length() >= 5 && stack[i].charAt(4) == c) {
                System.out.println("stack[" + i + "] = " + stack[i]);
                any = true;
            }
        }
        if (!any) System.out.println("No match for 5th char '" + c + "'.");
    }

    // add 5 more strings
    public void add5Strings(Scanner keyboard) {
        int toAdd = Math.min(5, size - (top + 1));
        for (int i = 0; i < toAdd; i++) {
            System.out.print("#" + (i + 1) + ": ");
            String s = keyboard.nextLine().trim();
            if (s.length() < 6) {
                System.out.println("Must be at least 6 characters.");
                i--;
                continue;
            }
            push(s);
        }
    }

    // delete 1 occurrence of str
    public void deleteStackOne(String str) {
        int idx = -1;
        for (int i = 0; i <= top; i++) {
            if (stack[i].equals(str)) { idx = i; break; }
        }
        if (idx == -1) return;
        for (int i = idx; i < top; i++) stack[i] = stack[i + 1];
        stack[top] = null;
        top--;
    }

    // delete all occurrences of str
    public void deleteStackAll(String str) {
        int write = 0;
        for (int i = 0; i <= top; i++) {
            if (!stack[i].equals(str)) {
                stack[write++] = stack[i];
            }
        }
        for (int i = write; i <= top; i++) stack[i] = null;
        top = write - 1;
    }

    // add one element after search
    public void addOneElementAfter(String search, String addString) {
        if (addString.length() < 6 || stackFull()) return;
        int idx = -1;
        for (int i = 0; i <= top; i++) {
            if (stack[i].equals(search)) { idx = i; break; }
        }
        if (idx == -1) return;
        for (int i = top; i > idx; i--) stack[i + 1] = stack[i];
        stack[idx + 1] = addString;
        top++;
    }
}
