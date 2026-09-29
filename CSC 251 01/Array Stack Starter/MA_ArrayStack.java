/*
Program Name:  MA_ArrayStack.java
Author: Michael Amoo
Instructor:  Dr. Jean Muhammad || Mr. Higgs
Class:  CSC251-01-Fall 2026
Description:  Stack Array - using Strings
Due Date:  October 8, 2026
Date: September 29, 2026
*/


/*
TODO:
1) Class : FILI_ArrayStack    - Strings 
Stacks: origStack, tempStack
- stackSize = 20 --- 
- define top, ttop
- create a storeStack() method -------- store 10 elements into the stack ( ask the user for a string  (must be at least 6 characters) inside of the method
- create a printOStack() method -------- print all elements in the stack - In order it was added
-create a printRStack() method ---- print all elements in the stack - In reverse order
- create a searchStack(char myChar) method ----- search all strings in the Stack that have myChar as the 4th character - return how many you found
-create a numOccur(String str)  method ------- return:  int  -  find the number of occurrences of str - return number of occurrences
- create a buildString() method -  create a string with all strings in the stack  with the 2nd character: 'h'  - return string
- create a method  printAllChar(char c): print all elements that have the character c  in the 5th character of the string
- create a method: add5Strings() - add 5 more strings to the stack // test to see if you have the space ( must use a loop)
- create deleteStackOne(String str) ---- this method will delete 1 occurrence of str only
- create deleteStackAll(String str) ---- this method will delete all occurrence of str 
- create a method addOneElementAfter(String search, addString) -  this method adds 1 element to the stack
- create a method to check if stack is full:  stackFull() - returns boolean
- create a method to check if stack is empty:  stackEmpty() - returns boolean
2) Create a FILIStackDriver 
create your object:  your object:  FILI_object - Ex: JM_object
call all the methods
Due Date: Final Stack Program Return Oct. 8th   before Midnight 11:59  - deduction 10 points per day. 

*/

/*
Things to do:
- Check if element can be added before adding
- call object FILI_Object
- Muhammad will input her strings so make sure she can do so via driver or class
- try to call via method (ex: myChar.obj.searchStack("string"))
*/


import java.util.Scanner;

public class MA_ArrayStack{
    public int size;
    public int top;
    public int ttop;
    private String[] origStack;
    private String[] tempStack;

    // second character of "Michael" is 'i'
    private final char secondChar = 'i';

    // constructor
    public MA_ArrayStack() {
        
        size = 20;
        top = -1;
        ttop = -1;
        origStack = new String[size];
        tempStack = new String[size];

    }

    // check if origStack full
    public boolean origStackFull()  { 
        
        return top == size - 1;

    }

    // check if origStack empty
    public boolean origStackEmpty() {
        
        return top == -1;

    }

    private void push(String s) {
        
        if (!origStackFull()) {
            top++;
            origStack[top] = s;
        }

    }

    private String pop() {

        if (origStackEmpty()) {
            return null;
        }
        
        String val = origStack[top];
        origStack[top] = null;
        top--;
        return val;

    }

    // store 8 elements into the origStack
    public void storeStack(Scanner keyboard) {
        
        System.out.println("Enter 8 strings (each at least 6 characters):");
        int added = 0;
        
        while (added < 8 && !origStackFull()) {
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

    // print all elements in the origStack
    public void printStack() {
        
        if (origStackEmpty()) {
            System.out.println("Stack is empty.");
            return;
        }
        
        for (int i = top; i >= 0; i--) {
            System.out.println("origStack[" + i + "] = " + origStack[i]);
        }

    }

    // search for str
    public boolean searchStack(String str) {
        
        for (int i = 0; i <= top; i++) {
            if (origStack[i].equals(str)) return true;
        }
        return false;
    }

    // count occurrences
    public int numOccur(String str) {
        
        int count = 0;
        
        for (int i = 0; i <= top; i++) {
            if (origStack[i].equals(str)) count++;
        }
        return count;

    }

    // build string with elements containing secondChar
    public String buildString() {
        
        String result = "";
        
        for (int i = 0; i <= top; i++) {
            if (origStack[i].indexOf(secondChar) >= 0) {
                
                if (result.equals("")) {
                    result = origStack[i];
                }
                else 
                    result += " | " + origStack[i];
            }
        }
        return result;
    }

    // print all elements with 5th character == c
    public void printAllChar(char c) {
        
        boolean any = false;
        
        for (int i = 0; i <= top; i++) {
            if (origStack[i].length() >= 5 && origStack[i].charAt(4) == c) {
                System.out.println("origStack[" + i + "] = " + origStack[i]);
                any = true;
            }
        }
        
        if (!any) {
            System.out.println("No match for 5th char '" + c + "'.");
        }
        
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
            
            if (origStack[i].equals(str)) {
                idx = i; break;
            }

        }
       
        if (idx == -1) {
            return;
        }
        
        for (int i = idx; i < top; i++) {
            origStack[i] = origStack[i + 1];
        }
        origStack[top] = null;
        top--;

    }

    // delete all occurrences of str
    public void deleteStackAll(String str) {
        
        int write = 0;
        
        for (int i = 0; i <= top; i++) {
            
            if (!origStack[i].equals(str)) {
                origStack[write++] = origStack[i];
            }

        }
        
        for (int i = write; i <= top; i++) {
            origStack[i] = null;
            top = write - 1;
        }

    }

    // add one element after search
    public void addOneElementAfter(String search, String addString) {
        
        if (addString.length() < 6 || origStackFull()) {
            return;
        }
        
        int idx = -1;
        
        for (int i = 0; i <= top; i++) {
            
            if (origStack[i].equals(search)) {
                 idx = i; break; 
            }

        }
        
        if (idx == -1) {
            return;
        }

        for (int i = top; i > idx; i--) {
            origStack[i + 1] = origStack[i];
            origStack[idx + 1] = addString;
            top++;
        }

    }

}
