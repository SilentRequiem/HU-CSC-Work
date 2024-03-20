public class Square5 {
   private int side;
   
   public int Square(){
      side = 10; //default
      return side;
   }   
   
   public int Square(int s) {
      side = s;
      return side;
   }
   
   public int getSide() {
      return side;
   }
   
   public void setSide(int newS) {
      side = newS;
   }
   
   public int getArea() {
      return side * side;
   }
   
   public String toString() {
      return "Area is " + getArea() + " and side is " + getSide();
   }

   
}