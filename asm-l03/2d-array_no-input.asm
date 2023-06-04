.data
    RAM:		.space 4096
    liczba_wierszy:	.word 31
    liczba_kolumn:	.word 32
.text
    lw $s0, liczba_wierszy    	# ³adujê do rejestru liczbe_wierszy
    lw $s1, liczba_kolumn	# ³adujê do rejestru liczbe_kolumn
    
    # $s0 - liczba wierszy
    # $s1 - liczba kolumn
    # $s2 - rozmiar tablicy adresow
    
    # $t0 - wskaznik na adres komórki
    # $t1 - wskaznik na adres wiersza w tablicy adresów wierszów
    # $t2 - numer kolumny
    # $t3 - numer wiersza
    # $t4 - liczba
    
    mul $s2, $s0, 4	# rozmiar tablicy adresow: ilosc wierszy * 4 to adres pierwszego wiersza w tablicy
    move $t0, $s2	# wskazuje na adres pierwszej komorki
    
    adresy:
        sw $t0, RAM($t1)	# zapisuje adres tablicy na miejscu dotykanym przez wskaŸnik
        mul $t4, $t3, 100	# liczba := numer wiersza * 100
        li $t2, 0	# resetuje numer kolumny
        komorki:		
            addi $t4, $t4, 1	# liczba := liczba + 1 (np. 101, 102, 103...)
            sw $t4, RAM($t0)	# zapisujê t¹ liczbê do tablicy
            addi $t0, $t0, 4	# aktualizujê wskaŸnik na kolejny adres komórki
            addi $t2, $t2, 1	# zwiêkszam numer kolumny
            bne $t2, $s1, komorki	# jesli numer kolumny != liczba kolumn to kontynuuj wpisywanie liczb w komórki
        addi $t3, $t3, 1	# zwiêkszam numer wiersza
        addi $t1, $t1, 4	# aktualizujê wskaŸnik w tablicy adresów wierszów
        blt $t3, $s0, adresy	# jeœli numer wiersza jest mniejszy od liczby wierszy to kontynuuj
        
    # poprawne zakonczenie programu    
    li $v0, 10
    syscall
    



