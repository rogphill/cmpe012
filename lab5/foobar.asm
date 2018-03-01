.text
main:
	move $t0, $zero
	
	# Outputs "This number in binary is: \n":
    	li $v0, 1 #syscall 4 = print string from $a0
	lw $a0, 0($t0)
	syscall
	
	# Exits program:
	li $v0, 10
	syscall
.data
