

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
    String data;
    LinkList head;
    LinkList link;
    LinkList tptr;

    public LinkList(String idata, LinkList ilink) {
        data = idata;
        link = ilink;
    }

    public LinkList(String idata) {
        data = idata;
        link = null;
    }

    public LinkList() {
        data = null;
        link = null;
        head = null;
    }

    public void addFirstNode(String name) {
        head = new LinkList(name, null);
    }

    public void addToFront(String name) {
        head = new LinkList(name, head);
    }

    public void printAllNodes() {
        tptr = head;

        if (tptr == null) {
            
            System.out.println("List is empty.");
            return;

        }

        while (tptr != null) {
            
            System.out.println(tptr.data);
            tptr = tptr.link;

        }
    }

    public void addRear(String name) {
        
        if (head == null) {
            head = new LinkList(name, null);
            return;
        }

        tptr = head;
        
        while (tptr.link != null) {
            tptr = tptr.link;
        }

        tptr.link = new LinkList(name, null);
    }

    public void removeFromFront() {
        
        if (head != null) {
            head = head.link;
        }

    }

    public void removeFromRear() {
        
        if (head == null) {
            return;
        }

        if (head.link == null) {
            head = null;
            return;
        }

        tptr = head;
        
        while (tptr.link.link != null) {
            tptr = tptr.link;
        }

        tptr.link = null;
    }

    public boolean search(String name) {
        
        tptr = head;

        while (tptr != null) {
            
            if (tptr.data.equals(name)) {
                return true;
            }

            tptr = tptr.link;
        }

        return false;
    }

    public void removeNode(String name) {
        
        if (head == null) {
            return;
        }

        if (head.data.equals(name)) {
            head = head.link;
            return;
        }

        tptr = head;
        
        while (tptr.link != null) {
            
            if (tptr.link.data.equals(name)) {
                tptr.link = tptr.link.link;
                return;
            }
            
            tptr = tptr.link;
        }
    }

    public void addAfter(String search, String addName) {
        
        tptr = head;

        while (tptr != null) {
            
            if (tptr.data.equals(search)) {
                LinkList newNode = new LinkList(addName, tptr.link);
                tptr.link = newNode;
                return;
            }
            
            tptr = tptr.link;
        }
    }

    public void addBefore(String search, String addName) {
        
        if (head == null) {
            return;
        }

        if (head.data.equals(search)) {
            head = new LinkList(addName, head);
            return;
        }

        tptr = head;
        
        while (tptr.link != null) {
            
            if (tptr.link.data.equals(search)) {
                LinkList newNode = new LinkList(addName, tptr.link);
                tptr.link = newNode;
                return;
            }
            
            tptr = tptr.link;
        }
    }

    public String collectAllNames() {
        
        String names = "";
        
        tptr = head;

        while (tptr != null) {
            names += tptr.data + " ";
            tptr = tptr.link;
        }

        return names;
    }

    public void printLength6() {
        tptr = head;

        while (tptr != null) {
            
            if (tptr.data.length() == 6) {
                System.out.println(tptr.data);
            }
            
            tptr = tptr.link;
        
        }
    }

    public String longest() {
        
        if (head == null) {
            
            return "";
        }

        String longest = head.data;
        tptr = head;

        while (tptr != null) {
            
            if (tptr.data.length() > longest.length()) {
                longest = tptr.data;
            }
            
            tptr = tptr.link;
        }

        return longest;
    }

    public void add6nodes() {
        for (int i = 0; i < 6; i++) {
            
            System.out.println("Enter a name: ");
            addRear(keyboard.nextLine());
        
        }
    }

    public boolean isEmpty() {
        
        if (head == null) {
            return true;
        }

        return false;
    }




    public static void main(String[] args) {

        LinkList LL = new LinkList("test", null);

        LL.addFirstNode("Test");

        LL.add6nodes();

        System.out.println(LL.isEmpty());

        System.out.println("\nAll names:");
        LL.printAllNodes();

        System.out.println("\nNames with six characters:");
        LL.printLength6();

        System.out.println("\nLongest name: " + LL.longest());

    }
}
