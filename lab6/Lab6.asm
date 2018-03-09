# Program File: Lab6.asm
# Author: Robert George Phillips (rogphill)
# Email: rogphill@ucsc.edu
# Description: This program is a collection of subroutines to be used by an independent driver that will emulate the encryption and decryption of a Vignere Cipher.

# Subroutine EncryptChar
# Encrypts a single character using a single key character.
# input: $a0 = ASCII character to encrypt
# $a1 = key ASCII character
# output: $v0 = Vigenere-encrypted ASCII character
# Side effects: None
# Notes: Plain and cipher will be in alphabet A-Z or a-z
# key will be in A-Z.
# 65 (0x41) = 'A', 90 (0x5A) = 'Z', 97 (0x61) = 'a', 122 (0x7A) = 'z'

EncryptChar:
.text
	move $t0, $a0
	move $t1, $a1
	addi $t1, $t1, -65 # subtracts 65 from the key in preparation for shift
	# blt $t0, 65, __endEncryptChar # branches if less than 65, guaranteed to not be in range.  # commented out as moving alphabet catchers to string function
	# bgt $t0, 122, __endEncryptChar # branches if greater than 122, guaranteed to not be in range.
	ble $t0, 90, __lowerCaseEncrypt # if less than or equal to 90, must be a lower case ASCII letter, good to go.
	bge $t0, 97, __upperCaseEncrypt # if greater than or equal to 97, must be an upper case ASCII letter, good to go.
	b __endEncryptChar # handles rest of cases (i.e., 91, ..., 96)
	
	__lowerCaseEncrypt:
		add $t0, $t0, $t1 # adds shift to character
		bgt $t0, 90, __fixShiftEncrypt # checks if greater than 90, if it is, needs to be fixed
		b __endEncryptChar # otherwise, character is encrypted
		
	__upperCaseEncrypt:
		add $t0, $t0, $t1 # adds shift to character
		bgt $t0, 122, __fixShiftEncrypt # checks if greater than 122, if it is, needs to be fixed
		b __endEncryptChar # otherwise, character is encrypted
		
	__fixShiftEncrypt:
		addi $t0, $t0, -26 # subtracts 26 to arrive back at the start of the ASCII alphabet	

__endEncryptChar: 
	move $v0, $t0
	jr $ra

# Subroutine DecryptChar
# Decrypts a single character using a single key character.
# input: $a0 = ASCII character to decrypt
# $a1 = key ASCII character
# output: $v0 = Vigenere-decrypted ASCII character
# Side effects: None
# Notes: Plain and cipher will be in alphabet A-Z or a-z
# key will be in A-Z
# 65 (0x41) = 'A', 90 (0x5A) = 'Z', 97 (0x61) = 'a', 122 (0x7A) = 'z'

DecryptChar:
	.text
	move $t0, $a0
	move $t1, $a1
	addi $t1, $t1, -65 # subtracts 65 from the key in preparation for shift
	# blt $t0, 65, __endDecryptChar # branches if less than 65, guaranteed to not be in range. # commented out as moving alphabet catchers to string function
	# bgt $t0, 122, __endDecryptChar # branches if greater than 122, guaranteed to not be in range.
	ble $t0, 90, __lowerCaseDecrypt # if less than or equal to 90, must be a lower case ASCII letter, good to go.
	bge $t0, 97, __upperCaseDecrypt # if greater than or equal to 97, must be an upper case ASCII letter, good to go.
	b __endDecryptChar # handles rest of cases (i.e., 91, ..., 96)
	
	__lowerCaseDecrypt:
		sub $t0, $t0, $t1 # subtracts shift to character
		blt $t0, 65, __fixShiftDecrypt # checks if less than 65, if it is, needs to be fixed
		b __endDecryptChar # otherwise, character is encrypted
	
	__upperCaseDecrypt:
		sub $t0, $t0, $t1 # subtracts shift to character
		blt $t0, 97, __fixShiftDecrypt # checks if less than 97, if it is, needs to be fixed
		b __endDecryptChar # otherwise, character is encrypted
	
	__fixShiftDecrypt:
		addi $t0, $t0, 26 # adds 26 to arrive back at the ASCII alphabet	
	
__endDecryptChar:
	move $v0, $t0
	jr $ra

# Subroutine EncryptString
# Encrypts a null-terminated string of length 30 or less,
# using a keystring.
# input: $a0 = Address of plaintext string
# $a1 = Address of key string
# $a2 = Address to store ciphertext string
# output: None
# Side effects: String at $a2 will be changed to the
# Vigenere-encrypted ciphertext.
# $a0, $a1, and $a2 may be altered

EncryptString:
	.data
	encryptLength: .space 31
	.text
	la $a2, encryptLength # points to address to store cipher text string with .space length 31
	la $s0, 0($a1) # stores address of key[0] for later use in __resetKeyAddress
	addi $sp, $sp, -4 # increases stack pointer by 4
	sw $ra, 0($sp) # pushs the return address on to the stack so we can come back out of the subroutine
	 
	__encryptLoop:
		lb $t0, 0($a0) # loads byte stored at address of the unciphered string
		beqz $t0, __endEncryptString # tests if byte is null-terminator. if it is, branch to __endEncryptString
		
		lb $t1, 0($a1) # loads byte stored at the address of the key
		beq $t1, $zero, __resetKeyAddress # if null-terminator, repoint the address of key to first char
		b __testInput # otherwise, branch to __testInput
		
		__resetKeyAddress:
			move $a1, $s0
			move $t1, $s0
			
		__testInput:
			blt $t0, 65, __notAlphabet # is punctuation, so branch to __notAlphabet
			bgt $t0, 122, __notAlphabet # is punctuation, so branch to __notAlphabet
			ble $t0, 90, __callEncryptChar # if less than or equal to 90, must be a lower case ASCII letter, good to go.
			bge $t0, 97, __callEncryptChar # if greater than or equal to 97, must be an upper case ASCII letter, good to go.
			# else, punctuation (i.e., 91, ..., 96) and falls to __notAlphabet
		
		__notAlphabet:
			sb $v0, 0($a2)
			addi $a0, $a0, 1 # increments address of unciphered string
			addi $a2, $a2, 1 # increments address of ciphered string
			b __encryptLoop
			
			
		__callEncryptChar:
			addi $sp, $sp, -4 # increases stack pointer by 4
			sw $a0, 0($sp) # stores a0 on the stack
			
			addi $sp, $sp, -4 # increases stack pointer by 4
			sw $a1, 0($sp) # stores a1 on the stack
			
			addi $sp, $sp, -4 # increases stack pointer by 4
			sw $v0, 0($sp) # stores v0 on the stack
			
			move $a0, $t0 # loads plaintext "variable" for EncryptChar
			move $a1, $t1 # loads key "variable" for EncryptChar
			jal EncryptChar # calls EncryptChar subroutine
			sb $v0, 0($s0) # moves output from EncryptChar to a temp
			
			lw $v0, 0($sp) # loads v0 back in from stack
			addi $sp, $sp, 4 # decreases stack pointer by 4
			
			lw $a1, 0($sp) # loads a1 back in from stack
			addi $sp, $sp, 4 # decreases stack pointer by 4
			
			lw $a0, 0($sp) # loads a0 back in from stack
			addi $sp, $sp, 4 # decreases stack pointer by 4
			
			lb $s1, 0($s0)			
			sb $s1, 0($a2) # adds result of EncryptChar to the string
			addi $a0, $a0, 1 # increments address of unciphered string
			addi $a1, $a1, 1 # increments address of key string
			addi $a2, $a2, 1 # increments address of ciphered string
			b __encryptLoop
			
__endEncryptString: 
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	

# Subroutine DecryptString
# Decrypts a null-terminated string of length 30 or less,
# using a keystring.
# input: $a0 = Address of ciphertext string
# $a1 = Address of key string
# $a2 = Address to store plaintext string
# output: None
# Side effects: String at $a2 will be changed to the
# Vigenere-decrypted plaintext
# $a0, $a1, and $a2 may be altered

DecryptString:
	
__endDecryptString: jr $ra
