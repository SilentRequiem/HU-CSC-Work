public class SqPyramid 
{
    private double base;
    private double height;
    private String color;
    private static int count = 0;

    public SqPyramid() 
    {
       this.base = 96;
       this.height = 10;
       this.color = "blue";
       count++;
    }

    public SqPyramid(double b, double h, String c) 
    {
       this.base = b;
       this.height = h;
       this.color = c;
       count++;
    }

    public SqPyramid(double base, double height)
    {
       this.base = base;
       this.height = height;
       this.color = "green";
       count++;
    }

    public SqPyramid(SqPyramid sp2)
    {
       this.base = sp2.base;
       this.height = sp2.height;
       this.color = sp2.color;
       count++;
    }

    public void setBase(double base) 
    {
      this.base = base;
    }

    public void setHeight(double height) 
    {
      this.height = height;
    }

    public void changeColor(String newC) 
    {
      this.color = newC;
    }
    
    public double baseArea() 
    {
      return base * base;
    }
    
    public double surfaceArea() 
    {
      return base * base + 2 * base * Math.sqrt( (Math.pow(base, 2) / 4 ) + height * height);
    }

    public boolean equals(SqPyramid sp2) 
    {
      return this.base == sp2.base && this.height == sp2.height && this.color.equals(sp2.color);
    }

    public SqPyramid copy() 
    {
      return new SqPyramid(this.base, this.height, this.color);
    }

    public String toString() 
    {
      return "Base is " + base + "\n" 
           + "Height is " + height + "\n" 
           + "Color is " + color + "\n"
           + "Base area is " + baseArea() + "\n"
           + "Base suface area is " + surfaceArea() + "\n"
           + "Volume is " + volume() + "\n";
    }

    public double getBase() 
    {
      return base;
    }

    public double getHeight() 
    {
      return height;
    }

    public String getColor() 
    {
      return color;
    }

    public static int getCount() 
    {
      return count;
    }
    
    public double volume()
    {
      return (1.0 / 3.0) * baseArea() * height;
    }
}
