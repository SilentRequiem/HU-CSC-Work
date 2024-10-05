/* Debug 1

public class Debug {
    public static void main(String[] args) {
    
        int num = 10; //Need semicolon;
        System.out.println("The number is: " + num);
        //System.out.println("Undefined variable: " + undefinedVar); No need for this since using printMessage method

        printMessage("hello"); //no string
    }

    public static void printMessage(String message) 
    {
        System.out.println(message);
    }
}

*/

//Debug 2: Fixed formating
public class Debug {
    public static void main(String[] args) {
        
        //Which character comes first alphabetically
        char letter1 = 'b'; //string should be char
        char letter2 = 'f'; // same as before

           if (letter1 < letter2) //comparison is wrong
           {
               System.out.println(letter1 + " is first alphabetically");
           } 
           else 
           {
               System.out.println(letter2 + " is first alphabetically"); //letter not lettar
           }

        //Print the first letter of each word
        String name1 = "Adam";
        String name2 = "Carter";
        String name3 = "Mike"; //Missing ";"

        System.out.println(name1.charAt(0) + " " + name2.charAt(0) + "   " + name3.charAt(0)); 
        //nane2.charAt(0) --> name.charAt(0) and name.chartAt[0] should be name.charAt(0)



        //Check if both people passed the test
        int grade1 = 72; //Int to int
        int grade2 = 95;

            if (grade1 > 70)
            {
               if (grade2 > 70) 
               {
                System.out.println("Everyone passed the test"); //Extra parentheis ")"
               }
               else
               {
                System.out.println("Not everyone passed the test"); //SYstem.out.pritln to System.out.println
               }
        }
    }

}
//Extra bracket "}"
