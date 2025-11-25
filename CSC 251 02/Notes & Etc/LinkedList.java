public class LinkedList
{
   
   public static void main(String[] args)
   {
      //Initialize head
      Node head = new Node("cake"); // Head node
      
      //Add Basa to next node
      Node firstNode = new Node("basa"); // First node
      head.nextNode = firstNode;
      
      // Add Tapas to the next node in the linkedList
      // You can only access head node and no other intermediary nodes
      Node secondNode = new Node("tapas"); // Second node
      head.nextNode.nextNode = secondNode;
      
      // Add mgic to next node, above rules apply
      Node nthNode = new Node("mgic"); // Nth node
      head.nextNode.nextNode.nextNode = nthNode;
      
      // I added X number of items to this list.
      Node tempNextNode = head; // Temporary node to traverse the list
      while(tempNextNode != null) // Traverse until the end of the list
      {
         tempNextNode = tempNextNode.nextNode; // Move to the next node
      }
      
      Node kthNode = new Node("tacos"); // Kth node
      head.nextNode.nextNode.nextNode.nextNode = kthNode; // Add Kth node

      //Print the linked list
      Node currentNode = head; // Start from the head
      while(currentNode != null) // Traverse until the end of the list
      {
         System.out.println(currentNode.data); // Print the data of the current node
         currentNode = currentNode.nextNode; // Move to the next node
      }
      
   }
}

class Node // Represents a node in the linked list
{
   String data; // Data part of the node
   Node nextNode; // Pointer to the next node in the list
   
   Node(String data) // Constructor to initialize the node with data
   {
      this.data = data; // Set the data
      this.nextNode = null; // Initialize nextNode to null
   }

}