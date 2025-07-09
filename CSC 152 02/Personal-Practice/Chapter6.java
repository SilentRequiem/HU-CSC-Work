import java.io.PrintWriter;
import java.io.FileWriter;
import java.io.IOException;
//Needed for PrintWriter

import java.util.Scanner;
import java.util.Random;

public class Chapter6 {
    public static void main(String[] args) {
       
        //Some classes we used before
        
        Scanner keyboard = new Scanner(System.in);
        //Make a new Scanner that is called keyboard which takes input from the system (the keyboard if you will)
        
        Random rand = new Random();
        //Make a new Random function called rand
        
        try {
            PrintWriter writer = new PrintWriter("C:\\Users\\Micha\\OneDrive\\Documents\\GitHub\\HU-CSC-Work\\CSC 152 Edits 2\\Personal-Practice\\output.txt");  //Syntax for PrintWriter
            //AbsouteFile

            
            //Writing
            writer.println("Coming from Chapter6.java");
            System.out.println("Write something to output.txt!");
            writer.println(keyboard.nextLine());

            writer.close();

        } catch (IOException e) {
            System.out.println("An error occurred: " + e.getMessage());
        }
        
        







        

        keyboard.close();
        
    }
    
}
