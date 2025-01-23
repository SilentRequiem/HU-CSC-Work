/*
+----------------------+
|         Car          |
+----------------------+
| - make: String       |
| - model: String      |
| - year: int          |
| - mileage: double    |
+----------------------+
| + Car(make, model, year, mileage) |
| + getMake(): String    |
| + getModel(): String   |
| + getYear(): int       |
| + getMileage(): double |
| + setMake(make): void  |
| + setModel(model): void|
| + setYear(year): void  |
| + setMileage(mileage): void |
+----------------------+
*/
public class Car {
    private String make;
    private String model;
    private int year;
    private double mileage;

//Constructor
    public Car(String make, String model, int year, double mileage)
    {
        this.make = make;
        this.model = model;
        this.year = year;
        this.mileage = mileage;
    }

    public String getMake()
    {
        return make;
    }

    public String getModel()
    {
        return model;
    }

    public int getYear()
    {
        return year;
    }

    public double getMileage()
    {
        return mileage;
    }
    
    public void setMake(String make)
    {
        this.make = make;
    }

    public void setModel(String model)
    {
        this.model = model;
    }

    public void setYear(int year)
    {
        this.year = year;
    }

    public void setMileage(double mileage)
    {
        this.mileage = mileage;
    }

}
