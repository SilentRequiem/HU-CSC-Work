import java.util.Scanner;

public class AmooM_Exam2Program {
    public static void main(String[] args) {
        Scanner keyboard = new Scanner(System.in);
        SqPyramid spP1 = new SqPyramid();
        int studentID = 96;
        int height = studentID;
        spP1.setHeight(height);
        
        System.out.println("Enter base, height, and color: ");
        double base = keyboard.nextDouble();
        double userHeight = keyboard.nextDouble();
        keyboard.nextLine();
        String color = keyboard.nextLine();
        SqPyramid spP2 = new SqPyramid(base, userHeight, color);

        SqPyramid spP3 = new SqPyramid(spP2);
        double newHeightP3 = spP3.getHeight() * 2;
        spP3.setHeight(newHeightP3);

        SqPyramid spP4 = spP1.copy();
        spP4.changeColor("Dark Green");

        //Print out (toString)
        System.out.println("Information of spP1: " + spP1.toString());
        System.out.println("Information of spP2: " + spP2.toString());
        System.out.println("Information of spP3: " + spP3.toString());
        System.out.println("Information of spP4: " + spP4.toString());

        //Calc for Total (G)
        double totalBaseArea = spP1.baseArea() + spP2.baseArea() + spP3.baseArea() + spP4.baseArea();
        System.out.println("Total Base Area of all 4 SqPyramids is: " + totalBaseArea);

        //Compare (H)
        if (spP4.equals(spP3)) 
        {
         System.out.println("spP4 and spP3 are the same!");
        } 
        
        else 
        {
         System.out.println("spP4 and spP3 are NOT the same!");
        }
    }
}
