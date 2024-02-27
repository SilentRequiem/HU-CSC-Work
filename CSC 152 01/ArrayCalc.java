public class ArrayCalc {
   public static void main(String[] args) {
      int[] values = {10, 5, 7, 3, 8};
      System.out.println("Sum: " + findSum(values));
      System.out.println("Min: " + findMin(values));
      System.out.println("Max: " + findMax(values));
      System.out.println("Average: " + findAverage(values));
   }

   public static int findSum(int[] values) {
      int sum = 0;
      for (int value : values) {
         sum += value;
      }
      return sum;
   }

   public static int findMin(int[] values) {
      int min = values[0];
      for (int value : values) {
         if (value < min) {
            min = value;
         }
      }
      return min;
   }

   public static int findMax(int[] values) {
      int max = values[0];
      for (int value : values) {
         if (value > max) {
            max = value;
         }
      }
      return max;
   }

   public static double findAverage(int[] values) {
      return (double) findSum(values) / values.length;
   }
}
