# Program File: Lab4.asm
# Author: Robert George Phillips (rogphill)
# Email: rogphill@ucsc.edu

.text
main:

	# Assigns divisors needed for division to registers:
	li $s1, 4
	li $s2, 9
	
	# Prompts user for input:
	li $v0, 4
	la $a0, numberprompt
	syscall
	
	# Reads the integer and save it in $s0:
 	li $v0, 5
 	syscall
 	move $s0, $v0
 	
 	# Initializes a counter with user's inputted number, then emulates a for-loop:
 	move $t7, $s0
 	start_loop:
 	
 		# Checks to see if user's number is divisible by 4:
 		div $s0, $s1
 		mfhi $t0
 		beqz $t0, dead
 		j checkbeef
 		
 		# Prints "DEAD" if divisible by 4:
 		dead:
		li $v0, 1
		la $a0, outdead
		syscall
 		
 		# Checks to see if user's number is divisible by 9:
 		checkbeef:
 		div $s0, $s2
 		mfhi $t0
 		beqz $t0, beef
 		j increment
 		
 		# Prints "BEEF" if divisible by 9:
 		beef:
		li $v0, 1
		la $a0, outbeef
		syscall
		
		increment:
		beq $t6, $t7, end_loop
		addiu $t6, $t6, 1
		j start_loop
 	
 	end_loop:
	
	# Exits program:
	li $v0, 10
	syscall

.data
numberprompt: .asciiz "Please enter a number N: "
outdead: .asciiz "DEAD"
outbeef: .asciiz "BEEF"
