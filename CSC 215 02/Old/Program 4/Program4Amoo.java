/* 
Author: Michael Amoo
Instructor: Dr. Joseph Aneke & Abu Bakar Siddiqur Rahman
Class: CSC-215-01 Discrete Structures
Description: RSA Public-Key Cryptosystem Algorithm
Date: 10/25/25
*/

import java.math.BigInteger;
import java.util.Scanner;

public class Program4Amoo {

    /*  Given RSA values
     p = 23, q = 31
     n = 29   (this is the public exponent, normally called e)
     z = 713  (this is the modulus, normally called n)
     φ = 660  (used to compute s)
     s = 569  (this is the private exponent, normally called d)
    */


    static final BigInteger z = BigInteger.valueOf(713);
    static final BigInteger n = BigInteger.valueOf(29); 
    static final BigInteger s = BigInteger.valueOf(569);
    /*
     Encrypt one character into an integer.
     Convert the character to its int value,
     Apply: encryptedValue = m^n mod z
     */

    public static int encryptChar(char letter) {
        BigInteger m = BigInteger.valueOf((int) letter);
        BigInteger encryptedValue = m.modPow(n, z); //encryption formula
        return encryptedValue.intValue();
    }

    /**
     * Decrypt one integer back into a character.
     * Apply: decryptedValue = encryptedValue^s mod z
     */

    public static char decryptChar(int encryptedValue) {
        BigInteger c = BigInteger.valueOf(encryptedValue);
        BigInteger decryptedValue = c.modPow(s, z); //decryption formula
        return (char) decryptedValue.intValue();
    }

    public static void main(String[] args) {

        Scanner keyboard = new Scanner(System.in);

        //Step 1: Read message from user
        System.out.println("Enter Message: ");
        String message = keyboard.nextLine();

        //Step 2: Display the original message
        System.out.println("\nClear Text Message");
        System.out.println(message);

        //Step 3: Encrypt message character at a time and store in array
        int[] encryptedValues = new int[message.length()];
        System.out.println("\nEncrypted Message");
        
        for (int i = 0; i < message.length(); i++) {
            encryptedValues[i] = encryptChar(message.charAt(i));
            System.out.print(encryptedValues[i] + " "); //print
        }

        System.out.println();

        // Step 4: Turn back into characters
        System.out.println("\nDecrypted Message");
        StringBuilder decryptedMessage = new StringBuilder();
        for (int value : encryptedValues) {
            decryptedMessage.append(decryptChar(value));
        }

        // Step 5: print decrypted message
        System.out.println(decryptedMessage.toString());
    }

}
