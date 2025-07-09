/*
+-----------------------------+
|       Pokemon               |
+-----------------------------+
| - name: String              |
| - level: int                |
| - type: String              |
+-----------------------------+
| + Pokemon(name, level, type)|
| + getName(): String         |
| + getLevel(): int           |
| + getType(): String         |
| + setName(name): void       |
| + setLevel(level): void     |
| + setType(type): void       |
+-----------------------------+

*/





import java.util.Scanner;

public class Pokemon {
    private String name;
    private int level;
    private String type;

    //Constructor
    public Pokemon(String name, int level, String type)
    {
        this.name = name;
        this.level = level;
        this.type = type;
    }
    
    public String getName()
    {
        return name;
    }

    public int getLevel()
    {
        return level;
    }

    public String getType()
    {
        return type;
    }

    public void setName (String name)
    {
        this.name = name;
    }

    public void setLevel(int level)
    {
        this.level = level;
    }

    public void setType(String type)
    {
        this.type = type;
    }

    public static void main(String[] args) {
        Scanner keyboard = new Scanner(System.in);
        Pokemon pokemon = new Pokemon("Bulbasuar", 1,"Grass" );
        
        System.out.println("Enter a pokemon:");
        pokemon.setName(keyboard.nextLine());

        System.out.println("Enter level");
        pokemon.setLevel(keyboard.nextInt());
        keyboard.nextLine();

        System.out.println("Enter type");
        pokemon.setType(keyboard.nextLine());

        System.out.println(pokemon.getName() + " is level " + pokemon.getLevel() + " and its type is " + pokemon.getType());
        
        keyboard.close();
    }
}