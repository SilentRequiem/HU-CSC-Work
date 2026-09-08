import java.io.*;

public class ShortestPathMA {
    private static final int INFINITY = 1_000_000;
    private static class EdgeNode {
        String u, v;
        int w;
        EdgeNode next;
        EdgeNode(String u, String v, int w, EdgeNode next) {
            this.u = u; this.v = v; this.w = w; this.next = next;
        }
    }

    public static void main(String[] args) throws Exception {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        System.out.print("Enter the filename: ");
        String promptName = br.readLine().trim();
        String file = resolveFile(promptName);
        EdgeNode head = null;
        int m = 0;
        try (BufferedReader fr = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = fr.readLine()) != null) {
                line = line.trim();
                if (line.length() == 0) continue;
                if (line.startsWith("#") || line.startsWith("//")) continue;
                String[] parts = splitWS(line);
                if (parts.length != 3) continue;
                String u = parts[0];
                String v = parts[1];
                int w;
                try {
                    w = Integer.parseInt(parts[2]);
                } catch (NumberFormatException nfe) {
                    continue;
                }
                head = new EdgeNode(u, v, w, head);
                m++;
            }
        } catch (FileNotFoundException e) {
            System.out.println("Could not open file: " + promptName);
            System.out.println("Tried: " + file);
            listLocalFiles();
            return;
        }
        String[] from = new String[m];
        String[] to   = new String[m];
        int[] dist    = new int[m];
        EdgeNode cur = head;
        for (int i = m - 1; i >= 0; i--) {
            from[i] = cur.u;
            to[i]   = cur.v;
            dist[i] = cur.w;
            cur = cur.next;
        }
        System.out.println();
        System.out.println("The edges of the graph");
        System.out.println();
        for (int i = 0; i < m; i++) {
            System.out.println(from[i] + " " + to[i] + " " + dist[i]);
        }
        System.out.println();
        System.out.print("Enter the starting vertex: ");
        String start = br.readLine().trim();
        System.out.print("Enter the ending vertex: ");
        String end = br.readLine().trim();
        System.out.println();
        String[] vertex = new String[2 * m + 2];
        int n = 0;
        for (int i = 0; i < m; i++) {
            if (!contains(vertex, n, from[i])) vertex[n++] = from[i];
            if (!contains(vertex, n, to[i]))   vertex[n++] = to[i];
        }
        String[] path = new String[n];
        int[] value = new int[n];
        boolean[] circled = new boolean[n];
        for (int i = 0; i < n; i++) {
            value[i] = INFINITY;
            path[i] = "(";
            circled[i] = false;
        }

        int s = indexOf(vertex, n, start);
        int t = indexOf(vertex, n, end);
        if (s == -1 || t == -1) {
            System.out.println("Start or end vertex not found in the graph.");
            return;
        }
        value[s] = 0;
        path[s] = "(" + start;
        while (!circled[t]) {
            int v = -1;
            int best = INFINITY + 1;
            for (int i = 0; i < n; i++) {
                if (!circled[i] && value[i] < best) {
                    best = value[i];
                    v = i;
                }
            }
            if (v == -1) break; // unreachable remaining vertices
            circled[v] = true;
            String nameV = vertex[v];
            for (int k = 0; k < m; k++) {
                if (from[k].equals(nameV)) {
                    int x = indexOf(vertex, n, to[k]);
                    if (!circled[x]) {
                        int alt = value[v] + dist[k];
                        if (alt < value[x]) {
                            value[x] = alt;
                            path[x] = path[v] + ", " + vertex[x];
                        }
                    }
                }
            }
            for (int k = 0; k < m; k++) {
                if (to[k].equals(nameV)) {
                    int x = indexOf(vertex, n, from[k]);
                    if (!circled[x]) {
                        int alt = value[v] + dist[k];
                        if (alt < value[x]) {
                            value[x] = alt;
                            path[x] = path[v] + ", " + vertex[x];
                        }
                    }
                }
            }
        }

        if (value[t] >= INFINITY) {
            System.out.println("No path found between " + start + " and " + end + ".");
            return;
        }

        System.out.println(value[t] + " " + path[t] + ")");
    }

    private static int indexOf(String[] a, int n, String s) {
        for (int i = 0; i < n; i++) if (s.equals(a[i])) return i;
        return -1;
    }
    private static boolean contains(String[] a, int n, String s) {
        return indexOf(a, n, s) != -1;
    }

    private static String[] splitWS(String line) {
        return line.split("\\s+");
    }

    private static String resolveFile(String input) {
        File f = new File(input);
        if (f.exists() && f.isFile()) return f.getPath();
        File f2 = new File(input + ".txt");
        if (f2.exists() && f2.isFile()) return f2.getPath();
        String normalized = input.replaceAll("\\s+", "").replaceAll("-", "");
        File dir = new File(".");
        String[] names = dir.list();
        if (names != null) {
            for (int i = 0; i < names.length; i++) {
                String name = names[i];
                String norm = name.replaceAll("\\s+", "").replaceAll("-", "");
                if (equalsIgnoreCase(norm, normalized) || equalsIgnoreCase(norm, normalized + ".txt")) {
                    return name;
                }
            }
        }
        return input;
    }

    private static boolean equalsIgnoreCase(String a, String b) {
        if (a == null || b == null) return false;
        if (a.length() != b.length()) return false;
        for (int i = 0; i < a.length(); i++) {
            char ca = a.charAt(i);
            char cb = b.charAt(i);
            if (toLower(ca) != toLower(cb)) return false;
        }
        return true;
    }
    private static char toLower(char c) {
        if (c >= 'A' && c <= 'Z') return (char)(c - 'A' + 'a');
        return c;
    }

    private static void listLocalFiles() {
        System.out.println("Files in working directory:");
        File dir = new File(".");
        String[] names = dir.list();
        if (names == null) return;
        for (int i = 0; i < names.length; i++) {
            File cand = new File(names[i]);
            if (cand.isFile()) System.out.println(" - " + names[i]);
        }
    }
}
