import java.util.*;

public class simpleCalc extends Classroom
   {
   public static void main(String[] args)
      {
      Scanner keyboard = new Scanner(System.in);
      Classroom CompileTest = new Classroom();
      
      //17 % 3 = 2 because 3 * 5  = 15 and 17 - 15 = 2!
      CompileTest.changeAnno(keyboard.nextLine());
      int x=4, y=14;
      double  z = 8 / 3.0;
      System.out.println(CompileTest.Speech());
      
      
      int num1, num2;
      System.out.println("% test!\n");
      
      System.out.print("Enter the first number: ");
      num1 = keyboard.nextInt();
      
      System.out.println();
      
      System.out.print("Enter the second number: ");
      num2 = keyboard.nextInt();
      
      System.out.println("\nAnswer is " + num1 % num2);
      
      }
   }