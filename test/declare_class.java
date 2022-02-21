class Test {
    public static void main(String[] arg) {
        System.out.println(!true);
    }
}

class Test2 {
    int x;
    int y;

    public int sum(int x, int y) {
        return x + y;
    }
}

class Test3 extends Test2 {
    public int sum(int x, int y) {
        return y + x;
    }
}
