import java.util.Scanner;

public class Array {
   Scanner keyboard = new Scanner(System.in);
   
   int size = 10;
   
   int[] myArray = new int[size];

   int count = 0;
   
   
   public void printArray() {
   
      for (int i = 0; i < size; i++) {
      
      
      System.out.print(myArray[i] + ", ");
   
      }
   
   }
   
   
   public void MultiOf3() {
      int num;
      
      for (int i = 0; i < size; i++) {
         
         System.out.println("Enter a multiple of 3");
         num = keyboard.nextInt();
         
         while (num % 3 != 0) {
            System.out.println(num + " is not a multiple of 3" + ". Enter a multiple of 3.");
            num = keyboard.nextInt();
         
         }
         
         myArray[i] = num;
        
        }
     
      }
      
      public void Between() {
      
         for (int i = 0;  i < size; i++) {
      
            if (myArray[i] >= 15 && myArray[i] <= 25) {
            
               System.out.print(myArray[i] + ", ");
          
            }
      
         }
      
      }
      
      
      public int Largest() {
         int largest = myArray[0];
      
         for (int i = 0; i < size; i++) {
         
            if (myArray[i] > largest) {
               
               largest = myArray[i];
            
            }
         
         }
         
         return largest;
      }
      
      public void PartArray() {
         int[] myArray2 = new int[size];
         int num2;
         
         
         
         //we are storing 6 elements
         //only wants even numbers
         
         for (int i = 0; i < 6; i++) {
            
            System.out.println("Enter an element (Must be Even): ");
            
            num2 = keyboard.nextInt();
               
               while (num2 % 2 != 0) {
                  
                  System.out.println("Please enter an even number");
                  num2 = keyboard.nextInt();
               
               }
         
            myArray2[i] = num2;
            count++;
         
         }
         
         
         for (int i = 0; i < 6; i++) {
      
      
            System.out.print(myArray2[i] + ", ");
   
         }

      System.out.println("Has " + count + " elements.");
         
      }
         
         
      
      
   
   
   public static void main(String[] args) {
   
      Array test = new Array();
      
      
      System.out.println("Adding numbers: ");
      test.MultiOf3();
      
      System.out.println("Printing Array: ");
      test.printArray();
      
      
      System.out.println("\nPrinting Between 15-25: ");
      test.Between();
      
      System.out.println("\nPrinting Largest: ");
      System.out.println(test.Largest());
      
      System.out.println("\nAdding PartArray: ");
      test.PartArray();
      
      
      
   
   
   
   
   
   
   
   
   }
   
 }