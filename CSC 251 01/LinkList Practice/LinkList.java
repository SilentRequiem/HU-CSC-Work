

/*
Properties:

Size of LL varries; Dyanimic
Sequencial not continuous

Cannot look in the rear
Cannot move head (data loss)
Can add anythere in the LinkList

Node must have element and next position

Head is not a node

Cannot be full ever but can be empty
*/


import java.util.Scanner;

public class LinkList {

    Scanner keyboard = new Scanner(System.in);

    //Attributes
    Integer data;
    LinkList link = null;
    LinkList head = null;
    LinkList tptr;

    //constructors
    public LinkList(int iData, LinkList iLink) {
        data = iData;
        link = iLink;
    }


    public LinkList(int iData){
        data = iData;
        link = null;
    }

    public LinkList(){
        data = null;
        link = null;
    }


    //methods
    public void addFirstNode(int x) {
        
        head = new LinkList(x, null);

    }

    public void addFront(int x, int ihead) {
        
        head = new LinkList(x, head);
    
    }

    public void printList() {
        tptr = head;

        System.out.println("Current Linked List:");

        while (tptr.link != null) {  // while you are not at the last node in list
            System.out.print(tptr.data + " ");// print the data in the node tptr points too
            tptr = tptr.link; // move to the next node
        }

        System.out.print(tptr.data); // print the last node in the list
        System.out.println();//skips a line
    }


    public boolean isEmpty() {
        return head == null;
    }

    public void add5FrontNodes() {
        
        System.out.println("Add 5 nodes: ");

        for (int i = 0; i < 5; i++) {
            
            int input = keyboard.nextInt();
            head = new LinkList(input, head);

        }

    }

    public int numberOfOccur(int x) {
        tptr = head;
        int count = 0;

            while ((tptr.link) != null) {
                
                if ((tptr.data) == x) {
                    count++;
                }
                tptr = tptr.link;
            }
            
            if(tptr.data == x){
                count++;
            }
        return count;
    }






    public static void main(String[] args) {
        
        LinkList LL = new LinkList(0, null);

        LL.addFirstNode(7);
        
        System.out.println(LL.isEmpty());

        LL.printList();

    }
}
