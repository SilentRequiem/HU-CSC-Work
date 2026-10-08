/* 
Author: Michael Amoo
Instructor: Dr. Abu Bakar Siddiqur Rahman
Class: CSC-215-02 Discrete Structures
Description: ResolutionProofs
Date: 10/6/26
*/

public class ResolutionProofs {
    public static void main(String[] args) {
        System.out.print("\nResolution Proofs Question: ");
        System.out.println("If (p || !q) and (q || r) are both true, then (p || r) is true.\n");

        boolean p, q, r;

        System.out.println("--------------------------------------------------------------------------------------------");
        System.out.println("p\t\tq\t\tr\t\tp||!q\t\tq||r\t\tp||r");
        System.out.println("--------------------------------------------------------------------------------------------");

        p = true;  q = true;  r = true;
        System.out.println(p + "\t\t" + q + "\t\t" + r + "\t\t" + (p || !q) + "\t\t" + (q || r) + "\t\t" + (p || r));

        p = true;  q = true;  r = false;
        System.out.println(p + "\t\t" + q + "\t\t" + r + "\t\t" + (p || !q) + "\t\t" + (q || r) + "\t\t" + (p || r));

        p = true;  q = false; r = true;
        System.out.println(p + "\t\t" + q + "\t\t" + r + "\t\t" + (p || !q) + "\t\t" + (q || r) + "\t\t" + (p || r));

        p = true;  q = false; r = false;
        System.out.println(p + "\t\t" + q + "\t\t" + r + "\t\t" + (p || !q) + "\t\t" + (q || r) + "\t\t" + (p || r));

        p = false; q = true;  r = true;
        System.out.println(p + "\t\t" + q + "\t\t" + r + "\t\t" + (p || !q) + "\t\t" + (q || r) + "\t\t" + (p || r));

        p = false; q = true;  r = false;
        System.out.println(p + "\t\t" + q + "\t\t" + r + "\t\t" + (p || !q) + "\t\t" + (q || r) + "\t\t" + (p || r));

        p = false; q = false; r = true;
        System.out.println(p + "\t\t" + q + "\t\t" + r + "\t\t" + (p || !q) + "\t\t" + (q || r) + "\t\t" + (p || r));

        p = false; q = false; r = false;
        System.out.println(p + "\t\t" + q + "\t\t" + r + "\t\t" + (p || !q) + "\t\t" + (q || r) + "\t\t" + (p || r));

        System.out.println("--------------------------------------------------------------------------------------------");

        System.out.println("\nIn every row where both premises are true, the conclusion is true.");
    }
}