/*
+----------------------+
|       Person         |
+----------------------+
| - name: String       |
| - age: int           |
+----------------------+
| + Person(name, age)  |
| + getName(): String  |
| + getAge(): int      |
| + setName(name): void|
| + setAge(age): void  |
+----------------------+

*/


public class Person {
    private String name; // Private field for name
    private int age;     // Private field for age

    // Constructor
    public Person(String name, int age) { 
        this.name = name;
        this.age = age; 
    }
    // NOTE: Originally, you wrote:
    // public Person(String name, String age)
    // Issue: The type for "age" should match the field type (int).
    // Issue: The constructor was incomplete (no method body).

    // Getter for name
    public String getName() {
        return name; // Correctly return the name field
    }
    // NOTE: Originally, you wrote:
    // public String getName()
    // {
    //     return String name;
    // }
    // Issue: Incorrect syntax. "String name" redeclares the type unnecessarily.

    // Getter for age
    public int getAge() {
        return age; // Correctly return the age field
    }
    // NOTE: Originally, you wrote:
    // public int getAge()
    // {
    //     return int age;
    // }
    // Issue: Same as above, "int age" redeclares the type unnecessarily.

    // Setter for name
    public void setName(String name) {
        this.name = name; // Assign the parameter value to the field
    }
    // NOTE: Originally, you wrote:
    // public void setName(name)
    // {
    //     this.name = name;
    // }
    // Issue: Missing parameter type. "name" must be declared as "String name".

    // Setter for age
    public void setAge(int age) {
        this.age = age; // Assign the parameter value to the field
    }
    // NOTE: Originally, you wrote:
    // public void setAge(age)
    // {
    //     this.age = age;
    // }
    // Issue: Missing parameter type. "age" must be declared as "int age".

}