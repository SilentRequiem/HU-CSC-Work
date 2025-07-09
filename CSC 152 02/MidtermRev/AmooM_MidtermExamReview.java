

//Student ID: 00549396
//Day of birthdate: 22

public class AmooM_MidtermExamReview {
    private int base = 54;
    private int height = 22;
    private String color = "Feburary";
    
    public AmooM_MidtermExamReview() { //no args constructor
        this.base = base;
        this.height = height;
        this.color = color;
    }

    public AmooM_MidtermExamReview(int aBase, int aHeight, String aColor) { //args constructor
        this.base = aBase;
        this.height = aHeight;
        this.color = aColor;
    }

    public void changeBase(int newBase) {
        this.base = newBase;
    }

    public void setHeight(int newH) {
        this.height = newH;
    }

    public void setColor(String newColor) {
        this.color = newColor;
    }

    public int getBase() {
        return base;
    }

    public int getHeight() {
        return height;
    }

    public String getColor() {
        return color;
    }

    public double calArea() {
        return (base * height) / 2;
    }

    public String toString() {
        return "\nBase is " + base + "\nHeight is " + height + "\nColor is " + color;
    }

    public static void main(String[] args) {
        
        System.out.println("Test");

    }

}