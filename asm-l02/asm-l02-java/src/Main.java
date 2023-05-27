import java.util.Arrays;

public class Main {
    // data
    static final int N = 25;
    static int[] numall = new int[N];
    static int[] primes = new int[N];
    public static void main(String[] args) {
        int[] avg = new int[1];
        for (int n = 0; n < 1; n++) {
            // get current time
            long startTime = System.nanoTime();

            // Wypełniej tablicę liczbami od 1 do N
            for (int i = 0; i < N; i++) {
                numall[i] = i+1;
            }

            // Powtarzaj dla n=2, ... N/2:
            for (int i = 2; i <= N/2; i++) {
                // OPTYMALIZACJA: jesli dana liczba i jest wielokrotnoscia liczby juz znalezionej to continue
            if ((i % 2 == 0 && i != 2) || (i % 3 == 0 && i != 3) || (i % 5 == 0 && i != 5) || (i % 7 == 0 && i != 7)) {
                continue;
            }
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
            // get current time
            long endTime = System.nanoTime();
            // calculate time
            long timeElapsed = endTime - startTime;
            avg[n] = (int) timeElapsed;
        System.out.println(nprimes + " primes: " + Arrays.toString(primes));
        }
//        int sum = 0;
//        for (int i = 0; i < avg.length; i++) {
//            sum += avg[i];
//        }
//        System.out.println("Average time: " + sum/avg.length);


    }
}