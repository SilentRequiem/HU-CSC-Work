public class ResolutionProofs2 {
    public static void main(String[] args) {
        System.out.print("\nResolution Proofs Question: ");
        System.out.println("If p or q and not p or r are both true, then q or r is true.\n");

        // Draw the table header
        System.out.println("--------------------------------------------------------------------------");
        System.out.println("P\tQ\tR\t(p||q)\t(!p||r)\t(q||r)\tHolds?");
        System.out.println("--------------------------------------------------------------------------");

        boolean[] vals = { false, true };
        boolean allGood = true;

        // Loop through all 8 combinations of truth values
        for (boolean P : vals) {
            for (boolean Q : vals) {
                for (boolean R : vals) {
                    boolean left1 = (P || Q);     // (p||q)
                    boolean left2 = (!P || R);    // (!p||r)
                    boolean right = (Q || R);     // (q||r)

                    boolean premiseTrue = left1 && left2;
                    boolean implicationHolds = !premiseTrue || right; // (premise -> conclusion)

                    if (!implicationHolds) {
                        allGood = false;
                    }

                    // Add a per-row comment note
                    String rowNote = premiseTrue
                        ? "  // Premise is TRUE here, so (q||r) must be TRUE"
                        : "";

                    // Print the row
                    System.out.println(P + "\t" + Q + "\t" + R + "\t" +
                                       left1 + "\t" + left2 + "\t" + right + "\t" +
                                       (implicationHolds ? "✓" : "✗") + rowNote);
                }
            }
        }

        // Draw line and result
        System.out.println("--------------------------------------------------------------------------");
        System.out.println("Result: " + (allGood ? "No counterexample — rule holds." : "Counterexample found."));

        // Real-world example
        System.out.println();
        System.out.println("Real-world example:");
        System.out.println("Let P = 'Alarm is set', Q = 'Door is locked', R = 'There is a night guard'.");
        System.out.println("The rule says: If (alarm OR lock) AND (not alarm OR guard), then (lock OR guard).");
        System.out.println("Example assignment: P=false, Q=true, R=false  →  (P||Q)=true, (!P||R)=true, so (Q||R)=true.");
        System.out.println("Interpretation: If the alarm isn't set but the door is locked, and whenever the alarm");
        System.out.println("isn't set there is a guard, then we are still secure via lock or guard.");
    }
}
