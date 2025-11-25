import java.util.LinkedList;

public class TestingWorkspace {
   
   public static void main(String[] args) {
 
   

// Study LinkedLists with the nodes: "Head", "able" "apple", "ball", "coach", "dive", "emerge". The current node is "able"
      String[] nodes = {"Head", "able", "apple", "ball", "coach", "dive", "emerge"}; // Array representing the linked list nodes
      String currentNode = nodes[1]; // "able"
      
      // Print the current node
      System.out.println("Current Node: " + currentNode);
      
      // Print all nodes in the linked list
      System.out.println("Linked List Nodes:");
      for (String node : nodes) {
         System.out.println(node);
      }

      //Rules of a Linked list
      System.out.println("\nRules of a Linked List:");
      System.out.println("1. Each node points to the next node in the sequence.");
      System.out.println("2. The first node is called the head.");
      System.out.println("3. The last node points to null, indicating the end of the list.");
      System.out.println("4. Nodes can be added or removed from the list.");
      System.out.println("5. Traversing the list involves following the pointers from one node to the next.");
      System.out.println("6. Linked lists can be single or double linked.");
      System.out.println("7. You can make it like a stack or a queue.");

      // Example of traversing the linked list
      System.out.println("\nTraversing the Linked List:");
      for (int i = 0; i < nodes.length; i++) { // Iterate through the nodes
         System.out.println("Node " + i + ": " + nodes[i]); // Print each node with its index
      }

      // Example of adding a new node
      String newNode = "fruit"; // New node to be added
      System.out.println("\nAdding a new node: " + newNode); // Add "fruit" at the end
      String[] updatedNodes = new String[nodes.length + 1]; // New array with one extra node
      System.arraycopy(nodes, 0, updatedNodes, 0, nodes.length); // Copy old nodes to new array
      updatedNodes[updatedNodes.length - 1] = newNode; // Add new node at the end
      System.out.println("Updated Linked List Nodes:"); // Print updated list
      
      for (String node : updatedNodes) {
         System.out.println(node);
      }

      // Example of removing a node (removing "ball")
      String nodeToRemove = "ball"; // Node to be removed
      System.out.println("\nRemoving a node: " + nodeToRemove); // Remove "ball"
      String[] finalNodes = new String[updatedNodes.length - 1]; // New array with one less node
      int index = 0; // Index for finalNodes
      for (String node : updatedNodes) { // Iterate through updatedNodes
         if (!node.equals(nodeToRemove)) { // If the node is not the one to remove
            finalNodes[index++] = node; // Add it to finalNodes and increment index
         }
      }
      System.out.println("Final Linked List Nodes:");
      for (String node : finalNodes) {
         System.out.println(node);
      }

      // End of the workspace
      System.out.println("\nEnd of Linked List demonstration.");

      // Using Java's LinkedList class
      LinkedList<String> list = new LinkedList<>();
      list.add("Head");
      list.add("able");
      list.add("apple");
      list.add("ball");
      list.add("coach");
      list.add("dive");
      list.add("emerge");
      System.out.println("\nUsing Java's LinkedList class:");
      System.out.println(list);
      
      // Demonstrating adding and removing with LinkedList
      list.add("fruit");
      System.out.println("After adding 'fruit': " + list);
      list.remove("ball");
      System.out.println("After removing 'ball': " + list);

   }

   
}