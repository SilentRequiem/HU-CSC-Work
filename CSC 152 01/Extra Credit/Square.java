public class Square {
    protected double side;
    protected String color;

    // Constructors
    public Square()
    {
        this.side = 396;
        this.color = "Blue";
    }

    public Square(double s, String c)
    {
        this.side = s;
        this.color = c;
    }

    public double getSide() 
    {
        return this.side;
    }

    public void setSide(double newS) 
    {
        this.side = newS;
    }

    public String getColor() 
    {
        return this.color;
    }

    public void setColor(String newC)
    {
        this.color = newC;
    }

    //Calc
    public double getArea()
    {
        return this.side * this.side;
    }
    
    public double getPerimeter()
    {
        return 4 * this.side;
    }
    
    //toString
    @Override
    public String toString() {
        return "Square Side:\t" + side + "\n" +
         "Square color:\t" + color + "\n";
    }
}
