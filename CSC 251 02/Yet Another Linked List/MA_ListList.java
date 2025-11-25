class Node {
    int num;  //number
    Node NN;  //next node

    public Node(int x) { //constructor
        num = x;
        NN = null; //next is null
    }
}

public class MA_ListList {
    Node head; //start of the list

    public MA_ListList() { //constructor
        head = null;
    }

    //1) add to rear
    public void addToRear(int x) {
        //adds x to end of list
        Node newNode = new Node(x);

        if (head == null) { //empty list
            head = newNode;
            return;
        }

        Node CN = head; //current node

        //move until CN is last
        while (CN.NN != null) {
            CN = CN.NN;
        }

        //CN is last
        CN.NN = newNode;
    }

    //2) add to front
    public void addToFront(int x) {
        //adds x to start of list
        Node newNode = new Node(x);
        newNode.NN = head; //new points to old head
        head = newNode; //new becomes head
    }

    //3) remove from end
    public int removeRear() {
        //removes last node
        if (head == null) {
            System.out.println("List empty.");
            return -1;
        }

        if (head.NN == null) { //only one node
            int removed = head.num;
            head = null;
            return removed;
        }

        Node PN = head;
        Node CN = head.NN;

        //move until CN is last
        while (CN.NN != null) {
            PN = CN;
            CN = CN.NN;
        }

        int removed = CN.num;
        PN.NN = null;
        return removed;
    }

    //4) remove node x
    public boolean removeNode(int x) {
        if (head == null) {
            System.out.println("List empty.");
            return false;
        }

        //head is target
        if (head.num == x) {
            head = head.NN;
            return true;
        }

        Node PN = head;
        Node CN = head.NN;

        while (CN != null && CN.num != x) {
            PN = CN;
            CN = CN.NN;
        }

        if (CN == null) {
            System.out.println(x + " not found.");
            return false;
        }

        //skip CN
        PN.NN = CN.NN;
        return true;
    }

    //5) add after y → insert z
    public boolean addAfter(int y, int z) {
        if (head == null) {
            System.out.println("List empty.");
            return false;
        }

        Node CN = head;

        //find y
        while (CN != null && CN.num != y) {
            CN = CN.NN;
        }

        if (CN == null) {
            System.out.println(y + " not found.");
            return false;
        }

        Node newNode = new Node(z);
        newNode.NN = CN.NN;
        CN.NN = newNode;

        return true;
    }

    //print list
    public void printList() {
        Node CN = head;

        while (CN != null) {
            System.out.print(CN.num + " ");
            CN = CN.NN;
        }
        System.out.println();
    }
}
