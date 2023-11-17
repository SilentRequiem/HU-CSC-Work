import java.io.PrintWriter;
import java.io.FileWriter;
import java.util.Scanner;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.File;

public class FileHandling
{
   public static void main(String args[])
   throws FileNotFoundException, IOException 
   {
      boolean append = true;
      FileWriter fw = new FileWriter("sample.txt", append);
      PrintWriter writer = new PrintWriter(fw);
      writer.println("Hampton University");
      writer.println("Computer Science Department");
      writer.close();
      
      File myFile = new File("sample.text");
      Scanner keyboard = new Scanner(myFile);
      
      while (in.hasNext())
      { 
      System.out.println(in.nextLine());
      }
   
      in.close();
   
   } // end main method
} // end java program