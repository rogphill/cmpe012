import java.io.FileWriter;
import java.io.IOException;

class DeadBeef {
    static final int RUNS = 1000;
    static String fileName = "C:\\Users\\dacty\\Documents\\UCSC\\CMPE012\\rogphill\\lab1\\Output.txt";
    public static void main(String[] args) {
        try {
            FileWriter output = new FileWriter(fileName);
            for (int i = 0; i < RUNS; i++) {
                if (((i+1)%4!=0)&&((i+1)%9!=0)) {
                    output.write(i+1 + System.lineSeparator());
                } else if (((i+1)%4==0)&&((i+1)%9==0)) {
                    output.write("DEADBEEF" + System.lineSeparator());
                } else if (((i+1)%4==0)) {
                    output.write("DEAD" + System.lineSeparator());
                } else if (((i+1)%9==0)) {
                    output.write("BEEF" + System.lineSeparator());
                }
            }
            output.flush();
            output.close();
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}