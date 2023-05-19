.data
    licz1:        .word 0
    licz2:        .word 0
    wyn:          .word 0
    status:	 .byte 0
    msg_mnozna:   .asciiz "Mnozna: "
    msg_mnoznik:  .asciiz "Mnoznik: "
    msg_out:      .asciiz "Wynik: "
    msg_overflow: .asciiz "Nastapilo przepelnienie!"

.text
    # wprowadzanie danych
    li $v0, 4		# wypisz zapytanie
    la $a0, msg_mnozna	# zapytanie o mnozna
    syscall		# wywolanie systemowe

    li $v0, 5		# wprowadz mnozna
    syscall		# wywolanie systemowe
    move $t0, $v0	# wrzucam mnozna do rejestru t0
    sw $t0, licz1

    li $v0, 4		# wypisz zapytanie
    la $a0, msg_mnoznik	# zapytanie o mnoznik
    syscall		# wywolanie systemowe

    li $v0, 5		# wprowadz mnoznik
    syscall		# wywolanie systemowe
    move $t1, $v0	# przenosze mnoznik do rejestru t1
    sw $t1, licz2


    # ----------------------------------------------------------------
    # mnozna: $t0, 
    # mnoznik: $t1,
    # wynik: $t2
    # maska na ostatni bit mnoznika: $t3
    
    # pierwszy bit mnoznej: $t6
    # shifted_mnozna: $t7
    # shifted_wynik: $t8
    
    # operacja mnozenia
    loop:
        # spprawdzam czy mnozymy:
        and $t3, $t1, 1 	# maska na ostatni bit mnoznika
        beqz $t3, shift	# jesli ostatni bit mnoznika jest 0 to nie dodawaj
        
        # sprawdzam czy jest overflow
        srl $t7, $t0, 16	# przesuwam w prawo o 16 bitow mnozna
        srl $t8, $t2, 16	# przesuwam w prawo o 16 bitow wynik
        add $t7, $t7, $t8	# dodaje przesuniete wartosci
        srl $t7, $t7, 15	# przesuwam w prawo sume aby dostac mozliwe przepelnienie
        bnez $7, overflow	# jesli suma nie jest rowna 0 to mamy overflow
        
        # dodawanie mnozenia
        add $t2, $t2, $t0	# dodaj mnozna do wyniku
        
        
        shift:        
        #sprawdzam czy drugi bit (pierwszy po znaku) jest 1
        #wtedy po przesunieciu o 1 utracimy informacje o tym bicie
        #czyli nie zauwazywmy overflowa
        
        # maska na pierwszym bit po bicie znaku mnoznej
        srl $t6 $t0, 30	# przesuwam w lewo mnozna (maska2)
        
        # przesuniecia mnoznej i mnoznika
        sll $t0, $t0, 1	# przesuwam w lewo mnozna, bo mnoze przez kolejny bit mnoznika
        srl $t1, $t1, 1	# przesuwam w prawo mnoznik aby dostac lsb
        
        # warunki wyjscia z petli
        beqz $t1, end_loop	# jesli juz wiecej nie bedzie dodawania to po prostu zwracam liczbe
        bnez $t6, overflow	# jesli maska2 jest 1 to jest to overflow
        
        j loop		# powrot do poczatku petli
    end_loop:
    
    sw $t2, wyn	# wrzuc wynik do data wynik

    # wypisz komunikat z wynikiem
    li $v0, 4		# wypisz
    la $a0, msg_out	# wypisz "Wynik: "
    syscall		# wywolanie systemowe

    # wyprowadz wynik
    li $v0, 1		# serwis "print intger"
    lw $a0, wyn		# argumentem jest wynik
    syscall		# wywolanie sytemowe
    j end		# pomijam obsluzenie oveflowa
    
    # overflow
    overflow:
    li $t0, 1		# wrzuc do rejestru $t0 1
    sw $t0, status	# status "zmien status na 1"
    li $v0, 4		# serwis "print string"
    la $a0, msg_overflow	# wypisz "Nastapilo przepelnienie!"
    syscall		# wywolanie systemowe
    
    # zakoncz poprawnie program
    end:
    li $v0, 10		# serwis exit
    syscall		# wywolanie systemowe
