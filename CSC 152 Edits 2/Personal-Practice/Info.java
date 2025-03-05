// Main method for testing
import java.util.Scanner;

public class Info {
    public static void main(String[] args) {

    int bruh = 1;
    
    switch bruh {
    
    case 0: 2;
    
    
   default: 5;
    }
    
    System.out.println(bruh);
    
    
    
    
    
        Scanner keyboard = new Scanner(System.in);
        // Create an object of Person
        Person person = new Person("Michael", 25);
        Car car = new Car("Ford", "S5", 1995, 300);
        // Access and print fields using getters
        System.out.println("Name: " + person.getName());
        System.out.println("Age: " + person.getAge());

        // Modify fields using setters
        System.out.println("Enter a name");
        person.setName(keyboard.nextLine());
        System.out.println("Enter an Age");
        person.setAge(keyboard.nextInt());
        keyboard.nextLine();


        // Print updated fields
        System.out.println("Updated Name: " + person.getName());
        System.out.println("Updated Age: " + person.getAge());
        System.out.println(car.getMake());

    keyboard.close();
    
    
    
    }
}