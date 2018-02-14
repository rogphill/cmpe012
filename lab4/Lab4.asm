# Program File: Lab4.asm
# Author: Robert George Phillips (rogphill)
# Email: rogphill@ucsc.edu
# Description: This program tests a user-inputted number to see if all numbers less than or equal to that number are divisible by 4, divisible by 9, or both. 

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
 	li $t6, 1
 	move $t7, $s0
 	start_loop:
 	
 		# Resets $v0 to ensure proper label jumps in the loop:
 		li $v0 0
 		
 		# Checks to see if number is divisible by 4:
 		div $t6, $s1
 		mfhi $t0
 		beqz $t0, dead
 		j checkbeef
 		
 		# Prints "DEAD" if divisible by 4:
 		dead:
		li $v0, 4
		la $a0, outdead
		syscall
 		
 		# Checks to see if user's is divisible by 9:
 		checkbeef:
 		div $t6, $s2
 		mfhi $t0
 		beqz $t0, beef
 		j checknumber
 		
 		# Prints "BEEF" if divisible by 9:
 		beef:
		li $v0, 4
		la $a0, outbeef
		syscall
		j increment
		
		#If neither DEAD or BEEF, simply prints number:
		checknumber:
		beq $v0, $s1, increment
		li $v0, 1
		move $a0, $t6
		syscall
		
		# Performs maintenance, such as entering a newline character and incrementing the count:
		increment:
		li $v0, 11 # syscall 11 = print character
    		li $a0, 10 # 10 = newline character
    		syscall
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
