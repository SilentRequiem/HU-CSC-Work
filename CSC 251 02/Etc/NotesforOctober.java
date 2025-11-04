/*
Linked list: Florida (Head) → Georgia → Algebra → Lousiana → Texas —> null

Things to learn via Linked List:
1) Add to Head
2) Remove from Head
3) Tranverse
4) Add to rear
5) Remove from rear
6) Search
7) Add in-between
8) Remove in-between

Quiz on Thursday (11/6/25)

 */
public class NotesforOctober {









    
    public static void main(String[] args) {
        System.out.println("Notes for October");


        /*
         * Using: LL{
         * Node HEAD;}
         * 
         * Node {
         * String data;
         * Node nn;
         * }
         * 
         * String search = "Alabama";
         * Node cn = HEAD;

         nn is next node 
         cn is current node
         */


         String search = "Alabama";
         Node cn = HEAD;

         while (cn.nn.data != null) {
               
            if (cn.data == search) {
                found = true;
                System.out.println("Found it!");
                break; //exit loop
            }
            
            
            
            
            
            
            cn = cn.nn;
         }

         //cund = The note at which it was found
         cund = cn;

         //if found then remove it (Make Georgia point to Lousiana)
         cn = HEAD;
         Node pn = null; //previous node (you can do Node pn; as well)

         if (cn.data == search) {
            found = true;
         }

         else {
            pn = cn;
            cn = cn.nn;
         }

         while (cn != null) {

            if (cn.data == search) {
                            found = true;
                            System.out.println("Found it!");
                            break; //exit loop
                        }
                        
                
                
                
                
                
                pn = pn.nn; //becomes node before cn (disconnects it from the linklist)
         }
//New list now: Florida (Head) → Lousiana → Texas —> null

//Add Alabama back before Lousiana

/*
 * Step 1: Create new node
 * Node newNode = new Node();
 * 
 * Step 2: put data
 * newNode.data = "Alabama";
 * 
 * 
 * Step 3: Find Position (currently Lousiana)
 * cn = HEAD;
 * 
 * 4.
 *  newn nn = cn; (Lousiana)
 *  pn nn = newn; (Alabama)
 * 
 */

 













    }
}