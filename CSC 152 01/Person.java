public class Person { //Object Name
   
   //Attributes - Naming the variables that you will use in a object
   private String name;
   private int age;
   private double money = 140;
   
   //Constuctors - defining the variables for the object
   
   public Person() //Empty Constructor: Anything that doesn't have something in the "()", when creating the object it set it to those values
   {
   name = "Mark";
   age = 19;
   }
   //Methods - Intructions for the object 
   public String getName()
   {
   System.out.println(name);
   return name;
   }
   
   public int getAge()
   {return age;}
   
   public double getMoney()
   {return money;}
   
   public void setMoney()
   { 
   money = 17;
   }
   
  }