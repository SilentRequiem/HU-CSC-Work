import java.util.Scanner;

public class MA_Driver {
    public static void main(String[] args) {

        MA_ListList List = new MA_ListList();
        Scanner keyboard = new Scanner(System.in);

        //sample run in your style
        System.out.println("Testing FILI_ListList");

        //add to front
        List.addToFront(10);
        List.addToFront(5);
        List.addToFront(2);

        //add to rear
        List.addToRear(20);
        List.addToRear(25);

        System.out.println("List now:");
        List.printList(); //2 5 10 20 25

        //remove last
        int r = List.removeRear();
        System.out.println("Removed rear: " + r);
        List.printList();

        //remove node x
        System.out.println("Removing node 10");
        List.removeNode(10);
        List.printList();

        //add after y
        System.out.println("Adding 99 after 5");
        List.addAfter(5, 99);
        List.printList();

        System.out.println("Done.");
    }
}
