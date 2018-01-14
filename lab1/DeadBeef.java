/*
by Rob Phillips (rogphill@ucsc.edu)

Used the following from Oracle as documentation:
https://docs.oracle.com/javase/tutorial/essential/environment/sysprop.html
*/

import java.io.FileWriter;
import java.io.IOException;

class DeadBeef {
    private static final int RUNS = 1000;
    static String fileName =  System.getProperty("user.dir") + System.getProperty("file.separator") + "lab1" + System.getProperty("file.separator") + "Output.txt";
    public static void main(String[] args) {
        try {
            FileWriter output = new FileWriter(fileName);
            for (int i = 0; i < RUNS; i++) {
                if (((i+1)%4!=0)&&((i+1)%9!=0)) {
                    output.write(i+1 + System.getProperty("line.separator"));
                } else if (((i+1)%4==0)&&((i+1)%9==0)) {
                    output.write("DEADBEEF" + System.getProperty("line.separator"));
                } else if (((i+1)%4==0)) {
                    output.write("DEAD" + System.getProperty("line.separator"));
                } else if (((i+1)%9==0)) {
                    output.write("BEEF" + System.getProperty("line.separator"));
                }
            }
            output.flush();
            output.close();
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}