//Setup

public class myManualStack {
    public int size;
    public int top;
    private String[] arr;


    myManualStack(int size) {
        this.size = size;
        this.top = -1;
        this.arr = new String[size];
    }

    public void insertToTop(String element) {
        top++;
        this.arr[top] = element;
    }

    public String retriveFromTop() {
        String retrived = this.arr[top];
        top--;
        return retrived;
    }

    public void fillUp() {
        this.insertToTop("adam");
        this.insertToTop("bob");
        this.insertToTop("carol");
        this.insertToTop("david");
        this.insertToTop("eric");
        this.insertToTop("fred");
        this.insertToTop("gabe");
    }

//Driver
public static void main(String[] args) {

    myManualStack stk = new myManualStack(10);
    stk.fillUp();
    
//TODO Phase

    //Have an array that can hold your names from the Stack
    String[] arr2 = new String[10];
    
    //Retrive from the stack and insert into your array
    for(int i=0; i < 7; i++) {

        String retrive = stk.retriveFromTop();  // retrive from Stack
        arr2[i] = retrive  ;  // copy into array                       

        System.out.println("i is currently : " + i + "\ttop is : " + stk.top + "\tretrived: " + retrive);
        
        if (stk.top != -1) {
        System.out.println("____________________________________________________________");
        }

        


    }
    //Loop through the print out the array
    System.out.println("\nThe names in the array are: ");
    for(int j=0; j < 7; j++) {
        System.out.println("arr2[" + j + "] = " + arr2[j]);
    }


    System.out.println("\nSize of myManualStack is: " + stk.size + "\nThe top index is: " + stk.top + "\nMeaning the stack is empty");

    

    }

}
