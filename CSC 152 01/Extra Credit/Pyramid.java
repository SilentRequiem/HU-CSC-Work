public class Pyramid extends Square {
    private double height;
    private String material;

    // Constructors
    public Pyramid()
    {
        super();
        this.height = 20;
        this.material = "Granite";
    }

    public Pyramid(double s, String c)
    {
        super(s, c);
        this.height = 20;
        this.material = "Granite";
    }

    public Pyramid(double s, double height, String c, String m)
    {
        super(s, c);
        this.height = height;
        this.material = m;
    }

    public void setMaterial(String material)
    {
        this.material = material;
    }

    public String getMaterial()
    {
        return this.material;
    }

    public double getArea()
    {
        return (side * side) + (2 * side) * Math.sqrt( (Math.pow(side,2)/4) + Math.pow(height,2) );
    }

    public double getVolume()
    {
        return 1/3 * (side *  side) * height;
    }

    public boolean equals(Pyramid p2) 
    {
        return false;
    }
    @Override
    public String toString() {
        String SupString = super.toString();
        SupString += "\n  Height: " + height;
        SupString += "\n  Material: " + material;
        SupString += "\n  Area: " + getArea();
        SupString += "\n  Volume: " + getVolume();
        return SupString;
    }
}
