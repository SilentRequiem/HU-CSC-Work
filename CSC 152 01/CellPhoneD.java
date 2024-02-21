import java.util.Scanner;
public class CellPhoneD { 
   public static void main(String []args){
      Scanner keyboard = new Scanner(System.in);
   
      CellPhone CP1 = new CellPhone(); //New Object
   
      CellPhone CP2 = new CellPhone("Honda", "WQ3500", 60000);
   
      CP1.setModel("Nissan");
   
      CP2.setModel("Toyota");
   
      System.out.print(CP1.getRetailPrice());
   
      System.out.print("\nEnter your model: ");
      String x = keyboard.nextLine();
      
      if (x.equals("Nissan"))
      {CP1.setModel("Nissan");}
      else
      {CP1.setModel("Toyota");}
     
      System.out.println(CP1.getModel());
      
   
   
   
   
   
   
   }
}