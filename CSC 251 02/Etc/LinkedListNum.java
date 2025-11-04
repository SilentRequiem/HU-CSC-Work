public class LinkedListNum
{
 //Ordered List: 11, 19, 20, 35, 44  
   public static void main(String[] args)
   {
      Node head;
      Node firstNode =  new Node(35);
      head = firstNode;
      //35, 20, 11, 44, 19
      
      Node secondNode = new Node(20);
      secondNode.nextNode = head.nextNode;
      head.nextNode = secondNode;

      Node thirdNode = new Node(11);
      thirdNode.nextNode = head.nextNode;
      head.nextNode = thirdNode;

      Node fourthNode = new Node(44);
      fourthNode.nextNode = head.nextNode;
      head.nextNode.nextNode.NextNode = fourthNode;

      Node fifthNode = new Node(19);
      fifthNode.nextNode = head.nextNode.nextNode;
      head.nextNode.nextNode = fifthNode;

      Node tempNextNode = head;
      while(tempNextNode != null) // Traverse until the end of the list
      {
         tempNextNode = tempNextNode.nextNode; // Move to the next node
      }

      //Print the linked list
      Node currentNode = head;
      while(currentNode != null) // Traverse until the end of the list
      {
         System.out.println(currentNode.data); // Print the data of the current node
         currentNode = currentNode.nextNode; // Move to the next node
      }


      

      










   }
}

class Node // Represents a node in the linked list
{
   int data; // Data part of the node
   Node nextNode; // Pointer to the next node in the list
   
   Node(int data) // Constructor to initialize the node with data
   {
      this.data = data; // Set the data
      this.nextNode = null; // Initialize nextNode to null
   }

}