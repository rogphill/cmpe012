class DeadBeef {
    static final int RUNS = 1000;
    public static void main(String[] args) {
        for (int i = 0; i < RUNS; i++) {
            if (((i+1)%4!=0)&&((i+1)%9!=0)) {
                System.out.println(i+1);
            } else if (((i+1)%4==0)&&((i+1)%9==0)) {
                System.out.println("DEADBEEF");
            } else if (((i+1)%4==0)) {
                System.out.println("BEEF");
            } else if (((i+1)%9==0)) {
                System.out.println("BEEF");
            }
        }

    }

}