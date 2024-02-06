public class Square {
    private int side;
    private String color;

    //Attributes
    public Square(int side, String color) {
        this.side = side;
        this.color = color;
    }

    // Mutator
    public void setSide(int newSide) {
        this.side = newSide;
    }

    public void changeColor(String newColor) {
        this.color = newColor;
    }

    // Accessors
    public int getSide() {
        return side;
    }

    public String getColor() {
        return color;
    }

    //Calc
    public int getPerimeter() {
        return 4 * side;
    }

    public int getArea() {
        return side * side;
    }

    public double getHalfArea() 
    {
        return 0.5 * getArea();
    }
}
