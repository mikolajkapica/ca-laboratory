.data
    coefs: .float 2.3 3.45 7.67 5.32
    degree: .word 3
    enter_number_msg: .asciiz "Please enter a number: "
    result_msg: .asciiz "Result: "
    continue_msg: .asciiz "\nDo you want to continue? (y) "
    buffer: .space 64
.text
main:   
    # print enter_number_msg
    la $a0, enter_number_msg
    li $v0, 4
    syscall

    # get argument from user
    li $v0, 7
    syscall
    mov.d $f14, $f0 # load next argument

    # eval_poly(coefs, degree, x);
    la $a0, coefs
    lw $a1, degree
    jal eval_poly

    # print "Result: "
    la $a0, result_msg
    li $v0, 4
    syscall

    # print result
    mov.d $f12, $f0
    li $v0, 3
    syscall

    # ask if continue
    li $v0, 4
    la $a0, continue_msg
    syscall

    # enter y or n
    li $v0, 8
    la $a0, buffer
    li $a1, 64
    syscall
    lb $t0, buffer # load first char

    # if y then restart
    seq $t0, $t0, 121
    seq $t1, $t0, 89
    or $t0, $t0, $t1
    beqz $t0, exit 
                    
    # nowa linia (\n)
    li $v0, 11
    li $a0, 10
    syscall
    
    j main
        
    exit:    
    li $v0, 10
    syscall
    
eval_poly:
    # argumenty:
    # $a0 - float* coefs
    # $a1 - degree
    # $f14 - x
    
    # $f4(result) = coefs[degree]
    # $t1 = adres pamieci dla coefs[degree]
    sll $t1, $a1, 2   # offset dla coefs[degree]
    add $t1, $t1, $a0 # dokladny adres
    lwc1 $f4, ($t1)   # result inicjalizacja
    cvt.d.s $f4, $f4  # konwersja na double
    
    # $f6(currentX) = x
    mov.d $f6, $f14
    
    # $t0(i) = degree - 1
    move $t0, $a1    # int i = degree;
    subi $t0, $t0, 1 # int i = degree - 1
    
    loop:
        bltz $t0, return     # if (i < 0) return
        subi $t1, $t1, 4     # adres pamieci dla kolejnego wspolczynnika
        lwc1 $f8, ($t1)      # coefs[i]
        cvt.d.s $f8, $f8     # konwersja na double
        mul.d $f8, $f8, $f6  # coefs[i] * currentX
        add.d $f4, $f4, $f8  # result = result + coefs[i] * currentX
        mul.d $f6, $f6, $f14 # currentX = currentX * x
        subi $t0, $t0, 1     # i = i - 1
        j loop
    return:
        mov.d $f0, $f4       # kopia do $f0, wartosc zwracana
        jr $ra               # powrot do return address
