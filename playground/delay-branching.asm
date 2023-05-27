.text
#j test
#test: addi $t3, $t3, 2 # dwa razy!! 


# tutaj mamy: wykonujemy test, a potem kolejna instrukcjê czyli nie j test 1 tylko jej kolejna, etc.. czyli test: 
# czyli mamy dwa razy test robiony a potem juz idzie pokolei
j test
j test1
j test1
j test1
j test1
test: addi $t3, $t3, 5
add $t3, $zero, $t3
add $t3, $zero, $t3
add $t3, $zero, $t3
test1: addi $t3, $t3, 2