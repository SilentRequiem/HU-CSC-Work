public class ResolutionProofsExample {
    public static void main(String[] args) {


/*
Write a program that constructs the Truth Table for Resolution Proofs. Declare variables
p, q, and r as boolean variables, then for each row assign each variable true or false as
needed. For example:
 */

//Example 
boolean Example_P = true; 
boolean Example_Q = true; 
boolean Example_R = true;

System.out.println("Table Row for true true true");
System.out.println(Example_P + "\t\t" + Example_Q + "\t\t" + Example_R + "\t\t" +
(Example_P | Example_Q) + "\t\t" + (!Example_P | Example_R) + "\t\t" + (Example_Q | Example_R));


System.out.println("Table Row for true true false");
Example_P = true; Example_Q = true; Example_R = false;
System.out.println(Example_P + "\t\t" + Example_Q + "\t\t" + Example_R + "\t\t" +
(Example_P | Example_Q) + "\t\t" + (!Example_P | Example_R) + "\t\t" + (Example_Q | Example_R));
    }
}