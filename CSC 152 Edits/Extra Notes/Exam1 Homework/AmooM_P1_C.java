public class AmooM_P1_C {
   private int side;
   private String color;
   
   public AmooM_P1_C()
   {
     side = 96;
     color = "white";
   }
   
   public AmooM_P1_C(int s, String c)
   {
      side = s;
      color = c;
   }
   
   public void changeSide(int newSide)
   {
      side = newSide;
   }
   
   public void setColor(String newColor)
   {
      color = newColor;
   }
   
   public int getSide()
   {
      return side;
   }
   
   public String getColor()
   {
      return color;
   }
   
   public int calArea()
   {
      return (int) Math.pow(side,2);
   }
   
   public int getPerimeter()
   {
      return (side * 4);
   }
   
   public double specialCalculation()
   {
      return Math.sqrt(Math.pow(side, 3) + 72);
   }
}
   
   