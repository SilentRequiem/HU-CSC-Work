public class ArrayTesting {
   public static void main(String[] args) {
   




         //final int Array_Size = 6; you can initialize like this 
        int[] ArrayTest = new int[6]; // or this
        //int[] days = {1,2,3,4,5,6,7,8,9}; orrrrr this
        //int[] Numbers; and int Numbers[]; are the same thing
        
        
        
        
        System.out.println(ArrayTest);
        System.out.println("Forwards!!");
        
        for (int i = 0;  i < ArrayTest.length; i++) //Print Forwards
        {
            ArrayTest[i] = i + i;
            System.out.println(ArrayTest[i]);
        }
        //When i is 0, as long as i is less than the length of ArrayTest, increment by 1
        
        System.out.println("\nBackwards!!");
        
        for (int i = ArrayTest.length - 1; i>=0; i--) //Print Backwards
        {
            System.out.println(ArrayTest[i]);
        }
        /*When i is equal to the length of ArrayTest minus 1, as long as i is greater or equal to zero
          to 0, decrement by 1. We minus 1 the Array length because arrays START AT 0!!!
        */
        
        //++num is pre increment and num++ is post increment
        
        /*
        
        for(int tmp : arrayName)
        {
        
        String x = "blah blah blah "
        
        }
        
        */
        
        //to copy an array, copy ONE BY ONE
        
        
     }
  }