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

    li $v0, 4		# wypisz zapytanie
    la $a0, msg_mnoznik	# zapytanie o mnoznik
    syscall		# wywolanie systemowe

    li $v0, 5		# wprowadz mnoznik
    syscall		# wywolanie systemowe
    move $t1, $v0	# przenosze mnoznik do rejestru t1

    # mnozna: $t0, 
    # mnoznik: $t1,
    # wynik: $t2
    # maska na ostatni bit mnoznika: $t3
    
    # shifted_mnozna: $t7
    # shifted_wynik: $t8

    # operacja mnozenia
    loop:
        # zatrzymanie
        beqz $t0, end_loop	# jesli mnozna bedzie 0, nie ma sensu dalej mnozyc
        
        # czy mnozymy:
        and $t3, $t1, 1 	# maska na ostatni bit mnoznika
        beqz $t3, shift	# jesli ostatni bit mnoznika jest 0 to przeskocz
        
        # sprawdzam czy jest overflow
        srl $t7, $t0, 16	# przesuwam w prawo o 16 bitow mnozna
        srl $t8, $t2, 16	# przesuwam w prawo o 16 bitow wynik
        add $t7, $t7, $t8	# dodaje przesuniete wartosci
        srl $t7, $t7, 16
        bnez $7, overflow
        
        # dodawanie mnozenia
        add $t2, $t2, $t0	# dodaj mnozna do wyniku
        
        # przesuniecia
        shift:
        sll $t0, $t0, 1	# przesuwam w lewo mnozna, bo mnoze przez kolejny bit mnoznika
        srl $t1, $t1, 1	# przesuwam w prawo mnoznik aby dostac lsb
        
        # powrot do poczatku petli
        j loop
    end_loop:
    
    # wrzuc wynik do data wynik
    sw $t2, wyn

    # wypisz komunikat z wynikiem
    li $v0, 4	# wypisz
    la $a0, msg_out	# wypisz "Wynik: "
    syscall		# wywolanie systemowe

    # wyprowadz wynik
    li $v0, 1
    lw $a0, wyn
    syscall
    j end
    
    # overflow
    overflow:
    li $t0, 1
    sw $t0, status
    li $v0, 4	# wypisz
    la $a0, msg_overflow	# wypisz "Overflow="
    syscall		# wywolanie systemowe
    
    # zakoncz poprawnie program
    end:
    li $v0, 10
    syscall
