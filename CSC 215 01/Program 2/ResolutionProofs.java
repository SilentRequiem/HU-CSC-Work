/* 
Author: Michael Amoo
Instructor:  Dr. Aneke
Class:  CSC-215-01 Discrete Structures
Description: ResolutionProofs
Date: 9/26/25
*/


public class ResolutionProofs {
    public static void main(String[] args) {
        System.out.print("\nResolution Proofs Question: ");
        System.out.println("If p or q and not p or r are both true, then q or r is true.\n");

        boolean P, Q, R;

        System.out.println("--------------------------------------------------------------------------------------------");
        System.out.println("P\t\tQ\t\tR\t\t(p||q)\t\t(!p||r)\t\t(q||r)");
        System.out.println("--------------------------------------------------------------------------------------------");

        P = true;  Q = true;  R = true;
        System.out.println(P + "\t\t" + Q + "\t\t" + R + "\t\t" + (P || Q) + "\t\t" + (!P || R) + "\t\t" + (Q || R));

        P = true;  Q = true;  R = false;
        System.out.println(P + "\t\t" + Q + "\t\t" + R + "\t\t" + (P || Q) + "\t\t" + (!P || R) + "\t\t" + (Q || R));

        P = true;  Q = false; R = true;
        System.out.println(P + "\t\t" + Q + "\t\t" + R + "\t\t" + (P || Q) + "\t\t" + (!P || R) + "\t\t" + (Q || R));

        P = true;  Q = false; R = false;
        System.out.println(P + "\t\t" + Q + "\t\t" + R + "\t\t" + (P || Q) + "\t\t" + (!P || R) + "\t\t" + (Q || R));

        P = false; Q = true;  R = true;
        System.out.println(P + "\t\t" + Q + "\t\t" + R + "\t\t" + (P || Q) + "\t\t" + (!P || R) + "\t\t" + (Q || R));

        P = false; Q = true;  R = false;
        System.out.println(P + "\t\t" + Q + "\t\t" + R + "\t\t" + (P || Q) + "\t\t" + (!P || R) + "\t\t" + (Q || R));

        P = false; Q = false; R = true;
        System.out.println(P + "\t\t" + Q + "\t\t" + R + "\t\t" + (P || Q) + "\t\t" + (!P || R) + "\t\t" + (Q || R));

        P = false; Q = false; R = false;
        System.out.println(P + "\t\t" + Q + "\t\t" + R + "\t\t" + (P || Q) + "\t\t" + (!P || R) + "\t\t" + (Q || R));

        System.out.println("--------------------------------------------------------------------------------------------");
    }
}
