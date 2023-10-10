import java.util.Scanner;
public class Example
{ public static void main(String[] args)
{
Scanner keyboard = new Scanner(System.in);
  int myInterger = 123456789;
   byte myByte = (byte)myInterger;
   
   myInterger = 45;
   System.out.println(myInterger);
   
   String uniName = ("Hampton University");
   System.out.println(uniName);
   System.out.println(uniName.length());
   
   String name = "Michael";
   int age = 18;
   String input = keyboard.nextLine();
   System.out.println("You typed: " + input.length() + " characters");
   
   System.out.printf("Hi, my name is %s and I'm %d", name, age);


}
}