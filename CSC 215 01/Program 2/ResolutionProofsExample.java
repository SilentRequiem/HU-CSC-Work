import java.util.Stack;

public class ResolutionProofsExample {
    public static void main(String[] args) {


/*
Write a program that constructs the Truth Table for Resolution Proofs. Declare variables
p, q, and r as boolean variables, then for each row assign each variable true or false as
needed. For example:
 */

boolean p = true; 
boolean q = true; 
boolean r = true;

System.out.println(p + "\t\t" + q + "\t\t" + r + "\t\t" +
(p | q) + "\t\t" + (!p | r) + "\t\t" + (q | r));
// Table Row for true true false
p = true; q = true; r = false;
System.out.println(p + "\t\t" + q + "\t\t" + r + "\t\t" +
(p | q) + "\t\t" + (!p | r) + "\t\t" + (q | r));








    }
}