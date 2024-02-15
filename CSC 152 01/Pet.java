public class Pet {
    private String name;
    private String animal;
    private int age;

    //Constructors for Pet
    public Pet(String name, String animal, int age) 
    {
     this.name = name;
     this.animal = animal;
     this.age = age;
    }

    //Methods
    public void setName(String name) 
    { this.name = name; }

    public void setAnimal(String animal) 
    { this.animal = animal; }

    public void setAge(int age) 
    { this.age = age; }

    public String getName() 
    { return name; }

    public String getAnimal() 
    { return animal; }

    public int getAge() 
    { return age; }
}
