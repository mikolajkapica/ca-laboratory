.data
    N:	.word  100
    numall:	.space 400
    primes:	.space 400
    nprimes:	.word  0
.text
    # 1|_________________________________________________________________
    # Wype³nij tablicê liczbami od 1 do N
    
    # $t0 - counter (i)
    # $t1 - przesuniecie numall do konkretnej komórki
    # $t2 - N
    
    lw $t2, N
    wypelnij:
        bge $t0, $t2, end_wypelnij # pêtla do czasu az counter < N
        sll $t1, $t0, 2	 # przesuniecie = counter * 4(dlugosc slowa w bajtach)
        addi $t0, $t0, 1 	 # inkrementujê counter
        sw $t0, numall($t1)	 # zapisujê liczbê (counter) do tablicy
        j wypelnij	 # skok na pocz¹tek pêtli
    end_wypelnij:
    
    
    # 2|________________________________________________________________
    # Wykreœl z tablicy wszystkie wielokrotnoœci liczby n
    
    # $t0 - counter (i)
    # $t1 - przesuniecie numall do konkretnej komorki
    # $t2 - N
    # $t3 - N/2
    # $t4 - counter (j)
    
    li $t0, 2		# ustawiam counter na 2
    div $t3, $t2, 2	# obliczam N/2
    
    # Powtarzaj dla n=2, ... N/2:
    powtarzaj:
        bgt $t0, $t3, end_powtarzaj	# dopóki counter (i) <= N/2        
        add $t4, $t0, $t0		# ustawiam counter (j) na i + i 
        # Wykreœl z tablicy wszystkie wielokrotnoœci liczby n 
        wykresl:
            bgt $t4, $t2, end_wykresl 	# dopóki counter (j) <= N
            sll $t1, $t4, 2		# przesuniêcie = counter (j) * 4(dlugosc slowa w bajtach)
            sub $t1, $t1, 4		# przesuniecie cofam o jedno aby dostac indeks numall
            sw $zero, numall($t1)		# wykreœlenie
            add $t4, $t4, $t0		# inkrementacja counter(j) o counter(i)
            j wykresl		# skok na pocz¹tek pêtli wykreœl
        end_wykresl:
        addi $t0, $t0, 1		# inkrementacja counter(i) o 1
        j powtarzaj		# skok na pocz¹tek pêtli powtarzaj
    end_powtarzaj:
    
    # 3|________________________________________________________________
    # zliczanie i zapisywanie do tablicy wy³¹cznie z liczbami pierwszymi
    
    # $t0 - counter (i)
    # $t1 - przesuniecie numall do konkretnej komorki
    # $t2 - N
    # $t3 - N/2
    # $t4 - nprimes
    # $t5 - przesuniecie primes do konkretnej komorki
    # $t6 - numall[i]
    
    li $t0, 1		# ustawiam counter na 1
    li $t4, 0		# zerujê rejestr $t4 na zliczanie liczb pierwszych
    
    zapisywanie:
        bge $t0, $t3, end_zapisywanie	# dopóki counter(i) >= N/2
        sll $t1, $t0, 2		# przesuniecie = counter(i) * 4(dlugosc slowa w bajtach)
        lw $t6, numall($t1)		# ³adujê do rejestru kolejn¹ liczbê - numall[i]
        beqz $t6, after_storing		# jeœli jest równa zero to pomiñ nastêpne 3 linie
        sll $t5, $t4, 2		# przesuniecie = counter * 4(dlugosc slowa w bajtach)
        sw $t6, primes($t5)		# zapisujê numall[i] do tablicy primes
        addi $t4, $t4, 1		# inkrementacja licznika nprimes
        after_storing: 		# 
        addi $t0, $t0, 1		# inkrementacja counter(i) o 1
        j zapisywanie		# skok na pocz¹tek pêtli zapisywanie
    end_zapisywanie:
    sw $t4, nprimes		# zapisz do .data iloœæ liczb pierwszych
    
    # 4|________________________________________________________________
    # wypisywanie
    
    # $t0 - counter (i)
    # $t1 - primes[i]
    # $t2 - N
    # $t3 - N/2
    # $t4 - nprimes
    
    li $t0, 0			# resetujê counter(i)
    
    wypisywanie:
        beq $t0, $t4, end_wypisywanie	# dopóki counter(i) != nprimes
        sll $t1, $t0, 2		# przesuniecie = counter(i) * 4(dlugosc slowa w bajtach)
        
        li $v0, 1		# typ syscall - print integer
        lw $a0, primes($t1)		# ³adujê primes[i] do argumentu syscalla
        syscall			# wywolanie systemowe
        
        li $v0, 11		# typ syscall - print ascii
        li $a0, 32		# ³adujê whitespace do argumentu syscalla
        syscall			# wywolanie systemowe
        
        addi $t0, $t0, 1		# inkrementacja counter(i)
        j wypisywanie		# skok na pocz¹tek pêtli wypisywanie
    end_wypisywanie:
    
    
    # zakoncz poprawnie program
    end:
    li $v0, 10		# serwis exit
    syscall		# wywolanie systemowe