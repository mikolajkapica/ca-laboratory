import java.util.Arrays;

public class Main {
    // data
    static final int N = 10;
    static int[] numall = new int[N];
    static int[] primes = new int[N];
    public static void main(String[] args) {
        // Wypełniej tablicę liczbami od 1 do N
        for (int i = 0; i < N; i++) {
            numall[i] = i+1;
        }

        // Powtarzaj dla n=2, ... N/2:
        for (int i = 2; i <= N/2; i++) {
            // Wykreśl z tablicy wszystkie wielokrotności liczby n
            for (int j = i+i; j <= N; j = j + i) {
                numall[j-1] = 0;
            }
        }

        // zliczanie i zapisywanie do tablicy wyłącznie z liczbami pierwszymi
        int nprimes = 0;
        for (int i = 1; i < N; i++) {
            if (numall[i] != 0) {
                primes[nprimes] = numall[i];
                nprimes += 1;
            }
        }

        System.out.println(nprimes + " primes: " + Arrays.toString(primes));
    }
}