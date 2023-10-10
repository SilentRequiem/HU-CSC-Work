//Name: Michael Kwabena Amoo
//Date: 10/6/23
//Phone: (757)-776-2017
//Section: 151 02 F23 Home
//Instructor: Dr. B
//Description: Computer Programming I Chapter 2 Coding Assignment

import java.util.Scanner;
public class AmooM_P1
{
   public static void main(String[] args)
   {
      Scanner keyboard = new Scanner(System.in);
      
      //Variables
      System.out.print("Please enter the name of a school: ");
      String school = keyboard.nextLine();
      
      System.out.print("Please enter the name of a person: ");
      String person1 = keyboard.nextLine();
      
      System.out.print("Please enter the name of another person: ");
      String person2 = keyboard.nextLine();
      
      System.out.print("Please enter a color: ");
      String color1 = keyboard.nextLine();
      
      System.out.print("Please enter another color: ");
      String color2 = keyboard.nextLine();
      
      System.out.print("Please enter a positive interger: ");
      int years = keyboard.nextInt();
      int halfYears = years/2;
      keyboard.nextLine();
      
      System.out.print("Please enter the name of a food: ");
      String food1 = keyboard.nextLine();
      String food1AllCaps = food1.toUpperCase();
      
      System.out.print("Please enter the name of another food: ");
      String food2 = keyboard.nextLine();

      System.out.print("Please enter a personal pronoun (ex. he/she/they): ");
      String pronoun = keyboard.nextLine();
      
      System.out.print("Please enter an adjective: ");
      String adjective1 = keyboard.nextLine();
      
      System.out.print("Please enter another adjective: ");
      String adjective2 = keyboard.nextLine();
      
      System.out.print("Please enter an adverb: ");
      String adverb = keyboard.nextLine();
      
      System.out.print("Please enter a number with a decimal point: ");
      double radius = keyboard.nextDouble();
      double searchArea = Math.PI * Math.pow(radius,2);
      int eachSearchArea = (int) searchArea / 2;
      keyboard.nextLine();
      
      System.out.print("Please enter a unit of distance measurement in plural form: ");
      String distanceUnits = keyboard.nextLine();

      System.out.print("Please enter a unit of time measurement in plural form: ");
      String timeUnits = keyboard.nextLine();
      
      //Printing
      System.out.printf("%d years ago at %s the esteemed %s desperately needed to find a %s %s.", years, school, person1, color1, food1);
      System.out.printf("\n%s searched and searched for the evasive %s %s, but alas, the %s was never found.", pronoun, color1, food1, food1);
      System.out.printf("\n%d years after the search began %s enlisted the help of %s the %s.", halfYears, person1, person2, adjective1); 
      System.out.println("\nIt turns out that this might have been " + person1 + "'s fatal mistake.");
      System.out.printf("You see, %s suggested that they focus their search only on %s.", person2, school); 
      System.out.printf("\nThey would create a circle to search around the school and run around shouting \"%s!! %s!!\".", food1AllCaps, food1AllCaps);
      System.out.printf("\nThe search parameter was going to be %f square %s", searchArea, distanceUnits);
      System.out.printf("\nThat is roughly %d square %s each", eachSearchArea, distanceUnits);
      System.out.println("\nThe search could take " + timeUnits + " to complete.");
      System.out.printf("In the end %s %s settled for some %s %s and told %s to bug off!", person1, adverb, adjective2, food2, person2);
      
      
      
      
      }
}