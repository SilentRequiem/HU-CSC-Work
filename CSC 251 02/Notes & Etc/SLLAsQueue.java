

public class SLLAsQueue {
 
   //Things you can do on a Queue as a SLL:
   //1. Add To Rear
   //2. Remove From Front (enabling, non-traversed, peak)

   //null (Head) (tail)
   //NorthCarolina (Head) (tail) > null
   //NC (Head) > TN > null (tail)
   //NC (Head) > TN > TX (tail)> null
   //NC (Head) > TN > TX > MD (tail) > null


   class LL {
      Node head;
   }

   class Node {
      String data;
      Node NN; //next node

      public Node(String data) {
         this.data = data;
         this.NN = null;
      }

      //Instead of using newNode = new Node("TN"); we can use this method: 
      //tail.NN = new Node("TN");
      //Then tail = newNode; to make the tail point to the new node

      /* Remember the properties of a Queue though
      1. FIFO
      2. You can only add to the rear
      3. You can only remove from the front
      4. You can only peak at the front
      5. You can check if it's empty
      6. You cannot traverse the queue like a normal linked list
      7. You need to keep track of both the head and tail of the queue
      8. When removing from the front, you need to update the head to the next
      9. When adding to the rear, you need to update the tail to the new node
      10.If the queue is empty, both head and tail should be null

      */

      //to remove the tail you would need to use this.nn = null; because you cannot traverse in a queue
      //only use tail when you don't need to traverse otherwise it's pointless because you can just use head
      




   }



   public static void main(String[] args) {
 
   


   
   }
}