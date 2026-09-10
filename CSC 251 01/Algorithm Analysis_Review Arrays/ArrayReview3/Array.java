import java.util.Scanner;

/*

1) arrayStr = size = 15
    store 10 strings


2) only store strings with 1st char is H

3) Search array for how many occurences of: str
    return numbers of occurences

4) search array for longest string return longest string

*/

public class Array {
    private int size = 15;
    private String[] arrayStr = new String[size];
    private int count;

    Scanner keyboard = new Scanner(System.in);

    public void store10() {
        count = 0;

        for(int i = 0; i < 10; i++) {

            System.out.println("Enter a name: ");
            arrayStr[i] = keyboard.nextLine();
            count++;
        }

        System.out.println("Inputed " + count + " times.");
    }

    public void store1stH() {
        String word;
        count = 0;

        for (int i = 0; i < 10; i++) {
            
            System.out.println("Enter only a word that begins with a capital H: ");
            word = keyboard.nextLine();

            while(word.charAt(0) != 'H') {
                System.out.println("ONLY enter words that begin in CAPITAL H: ");
                System.out.println("Enter a word: ");
                word = keyboard.nextLine();
            }

            arrayStr[i] = word;
            count++;
        }
        System.out.println(count + "times");
    }


    public int search(String str){
        int strCount = 0;

        for(int i = 0; i < count; i++) {
            
            if(arrayStr[i].equals(str)){
                strCount++;
            }

        }
        
        return strCount;
    }

    public int longest() {
        int longest = arrayStr[0].length();

        for (int i = 0; i < count; i++) {
            
            if(arrayStr[i].length() > longest){
                longest = arrayStr[i].length();
            }

        }
        return longest;
    }


    public double average() {
        int[] numArray = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        int sum = 0;

        for (int i = 0; i < 10; i++) {
            sum += numArray[i];
        }

        double avg = sum / 10;
        return avg;

    }


    public boolean find(int x) {
        int[] numArray2 = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        for (int i = 0; i < 10; i++) {
            if (numArray2[i] == x){
                return true;
            }
        }
        return false;
    }

    public void findRange() {
        int[] numArray3 = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        for (int i = 0; i < 10; i++) {
            
            if (numArray3[i] > 10 && numArray3[i] < 160) {
                
                System.out.print(numArray3[i] + ", ");
            }
        }

    }



    public static void main(String[] args) {
        
        Array test = new Array();

        test.store10();

        test.store1stH();

        System.out.println(test.search("Hi"));

        System.out.println(test.longest());


        System.out.println(test.average());
        
        System.out.println(test.find(9));

        test.findRange();



        


    }
}