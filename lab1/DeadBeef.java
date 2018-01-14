import java.io.FileWriter;
import java.io.IOException;

class DeadBeef {
    static final int RUNS = 1000;
    static String fileName = "Output.txt";
    public static void main(String[] args) {
        try {
            FileWriter output = new FileWriter(fileName);
            for (int i = 0; i < RUNS; i++) {
                if (((i+1)%4!=0)&&((i+1)%9!=0)) {
                    output.write(i+1 + "\n");
                } else if (((i+1)%4==0)&&((i+1)%9==0)) {
                    output.write("DEADBEEF\n");
                } else if (((i+1)%4==0)) {
                    output.write("DEAD\n");
                } else if (((i+1)%9==0)) {
                    output.write("BEEF\n");
                }
            }
            output.close();
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}