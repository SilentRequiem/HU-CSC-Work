import java.util.Scanner;
public class Classroom {
   private String announcment;
   private String student;
   
   
   public Classroom() {
   this.announcment = "Dummy announcment";
   this.student = "John Doe";
   }
   
   public Classroom(String announcment, String student) {
    this.announcment = announcment;
    this.student = student;
    }
    
   public String Speech()
   {
      return student + " is saying testing testing 1,2,3. this is my speech: " + announcment;
   }
   
   public void changeAnno(String announcment) { //Same as setName, setPrice, etc
      this.announcment = announcment;
   }
   
   public void changeStudent(String student) { //Same as setName, setPrice, etc
      this.student = student;
   }
   
   public static void main(String[] args) { 
   
   Classroom RoomCommand = new Classroom();
   Scanner keyboard = new Scanner(System.in);
   
   System.out.println("Design your anno: ");
   RoomCommand.changeAnno(keyboard.nextLine());
   
   System.out.println("Change student: ");
   RoomCommand.changeStudent(keyboard.nextLine());
   
   System.out.println(RoomCommand.Speech());
   
   }}
    
     


   
