.data
    RAM:		.space 4096
    prompt_wiersze: 	.asciiz "Liczba wierszy: "
    prompt_kolumny: 	.asciiz "Liczba kolumn: "
    prompt_operacja:	.asciiz "Zapis/Odczyt/End [Z/O/E]: "
    prompt_error:	.asciiz "Blad, sprobuj ponownie\n"
    prompt_indeks_wiersza:	.asciiz "Indeks wiersza: "
    prompt_indeks_kolumny:	.asciiz "Indeks kolumny: "
    prompt_liczba:	.asciiz "Liczba: "
.text
    # pytam o wartoœci
    la $a0, prompt_wiersze
    li $v0, 4
    syscall
    
    li $v0, 5
    syscall
    move $s0, $v0
    
    la $a0, prompt_kolumny
    li $v0, 4
    syscall
    
    li $v0, 5
    syscall
    move $s1, $v0
    
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
        li $t2, 0
        komorki:		
            addi $t4, $t4, 1	# liczba := liczba + 1 (np. 101, 102, 103...)
            sw $t4, RAM($t0)	# zapisujê t¹ liczbê do tablicy
            addi $t0, $t0, 4	# aktualizujê wskaŸnik na kolejny adres komórki
            addi $t2, $t2, 1	# zwiêkszam numer kolumny
            bne $t2, $s1, komorki	# jesli numer kolumny != liczba kolumn to kontynuuj wpisywanie liczb w komórki
        addi $t3, $t3, 1	# zwiêkszam numer wiersza
        addi $t1, $t1, 4	# aktualizujê wskaŸnik w tablicy adresów wierszów
        blt $t3, $s0, adresy	# jeœli numer wiersza jest mniejszy od liczby wierszy to kontynuuj
    
    operacje:   
        # wypisujê zapytanie 
        la $a0, prompt_operacja
        li $v0, 4
        syscall
        
        # pytam o operacjê
        li $v0, 12
        syscall
        move $s7, $v0
        # drukuje nowa linie
        li $v0, 11
        li $a0, 10   # ASCII value for newline
        syscall
        
        # jesli operacja nalezy do zbioru {z, Z, o, O} to przeskocz obsluge bledu
        beq $s7, 90, end_blad
        beq $s7, 122, end_blad
        beq $s7, 111, end_blad
        beq $s7, 079, end_blad
        
        # jesli operacja nalezy do zbioru {e, E} to przeskocz do zakonczenia programu
        beq $s7, 101, end
        beq $s7, 069, end
        
        # inaczej mamy blad, wiec wypisuje komunikat i pytam kolejny raz
        la $a0, prompt_error
        li $v0, 4
        syscall
        j operacje
        end_blad:
        
        # pytanie o wiersz
        la $a0, prompt_indeks_wiersza
        li $v0, 4
        syscall
        li $v0, 5
        syscall
        move $s0, $v0
        
        # pytanie o kolumne
        la $a0, prompt_indeks_kolumny
        li $v0, 4
        syscall
        li $v0, 5
        syscall
        move $s1, $v0
        
        # $s0 - indeks wiersza
        # $s1 - indeks kolumny
    
        mul $t0, $s0, 4	# adres komorki w tablicy adresów wierszów
        lw $t0, RAM($t0)	# adres wiersza szukanego
        mul $t1, $s1, 4	# kolumna * d³ugoœæ s³owa 
        
        # $s2 - adres komórki
        add $s2, $t0, $t1	# pozycja w pamiêci naszej komórki
        
    
        beq $s7, 90, zapis	# jesli s7 = 'Z' lub 'z' to zapis
        beq $s7, 122, zapis
        beq $s7, 111, odczyt	# jesli s7 = 'o' lub 'O' to odczyt
        beq $s7, 079, odczyt
        
    
        zapis:
            la $a0, prompt_liczba	# zapytaj o liczbe do wpisania
            li $v0, 4
            syscall
            li $v0, 5
            syscall
            
            # zapisywanie tej liczby do komorki o wskazanym adresie $s2
            sw $v0, RAM($s2)
            j operacje	# powrot do pytania o operacje
        
        odczyt:
            lw $a0, RAM($s2)	# zapisz liczbe o wskazanym adresie $s2 do rejestru 
            li $v0, 1
            syscall
            li $v0, 11	# drukowanie litery
            li $a0, 10	# ASCII value for newline
            syscall
            j operacje	# powrot do pytania o operacje
    end:
        li $v0, 10
        syscall
    



