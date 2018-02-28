# Program File: Lab5.asm
# Author: Robert George Phillips (rogphill)
# Email: rogphill@ucsc.edu
# Description: This program converts a single program arg in the form of a number into a 2's complement binary representation.

.text
main:
	# Prompts user:
	li $v0, 4 #syscall 4 = print string from $a0
	la $a0, prompt
	syscall
	
	lw $a1, 0($a1) # Abstracts away the double pointer.
	lw $s0, 0($a1)
	move $s7, $a1 # Stores original address for later use.
	
	# Displays program argument back to output:
	move $a0, $a1
	syscall
	
	# Simply prints a new line for formatting using syscall:
	li $v0, 11 # syscall 11 = print character
    	li $a0, 10 # 10 = newline character
    	syscall
    	
    	# Outputs "This number in binary is: \n":
    	li $v0, 4 #syscall 4 = print string from $a0
	la $a0, output
	syscall
	
	# Initializes a count register $s1 to 0:
	addi $s1, $s1, 0
	
	# Iterates through byte by byte to find to the null terminator, thus setting up for converting to decimal integer:
	sentinel:
		# Adds "count" to address where input is stored:
		add $a1, $a1, $s1
	
		# Loads byte stored at new address of $a1, then loads it into $s2 so we can perform comparison:
		lb $s2, 0($a1)
		
		# If the byte is a null terminator, we jump out of the loop
		beq $s2, 0x00, endSentinel
		
		#If not equal to 0, keep iterating:
		addi $s1, $s1, 1
		j sentinel
	endSentinel:
	
	# Initializes a sum register $s3 and a exponentiation count $s4:
	move $s3, $zero
	move $s4, $zero
	
	summer:
		
		
		
		
		# Decrements count by 1 and loop maitenance:
		beq $s1, $zero, endSummer
		subi $s1, $s1, 1
		j summer
		
	endSummer:
	
	# ***DEBUG*** Print count:
	li $v0, 1 #syscall 1 = print integer from $a0
	move $a0, $s1
	syscall
	
	# Exits program:
	li $v0, 10
	syscall
	
.data
prompt: .asciiz "Please enter a number N: \n"
output: .asciiz "This number in binary is: \n"