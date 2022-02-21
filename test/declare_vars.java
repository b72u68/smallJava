class Test {
    public static void main (String[] arg) {
        {
            x = 1;
            y = 2;
            if (x < y) {
                x = y + 1;
            } else {
                y = y + 1;
            }
        }
    }
}
