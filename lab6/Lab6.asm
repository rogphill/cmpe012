# Program File: Lab6.asm
# Author: Robert George Phillips (rogphill)
# Email: rogphill@ucsc.edu
# Description: This program is a collection of subroutines to be used by an independent driver that will emulate the encryption and decryption of a Vignere Cipher.
# Pseudocode:
# 
# encryptString (String unciphered, String key): //decrypt is very similar with same logic
#     String ciphered[len(unciphered)]
#     for (i = 0, i < len(unciphered), i++) {
#         key[i] -= 97 //to get shift value
#         if ((unciphered[i] >= 65 && unciphered[i] <= 90) || (unciphered[i] >= 97 && unciphered[i] <= 122){
#             ciphered[i] = unciphered[i] + key[i]
#         } else {
#             ciphered[i] = unciphered[i]
#         if (key[i+1] == null) {
#             point back to key[0]
#         }
#     }
#     return ciphered


.macro push(%reg)
	sw %reg, 0($sp)
	addi $sp, $sp, -4
.end_macro

.macro pop(%reg)
	addi $sp, $sp, 4
	lw %reg, 0($sp)
.end_macro

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
	.text
	push($ra) # push return address to stack so we can jump back out of loop
	push($v0) # preserve "output" value by pushing to stack
	push($a2) # preserve original address of ciphertext string

	move $t2, $a1 # stores address of key[0] for later use in __resetKeyAddress
	move $t7, $zero # initializes a counter for sanitization 
	
__validateInput:
	lb $v0, 0($a0) # load character byte
	beqz $v0, __checkInputValidation # if null-terminated, check if anything has been counted
	beq $t7, 31, __errorEncryptString # if longer than 31, sends to error handling
	addi $a0, $a0, 1 # otherwise, good to go. increment string address
	addi $t7, $t7, 1 # increment counter
	b __validateInput # otherwise, continue through the loop

	__checkInputValidation:
		beqz $t7, __errorEncryptString # if no character has been reached yet there is a null-terminater, exit
		sub $a0, $a0, $t7 # otherwise move back to string[0] to prepare for encryption
		move $t7, $zero # reset counter for use in validateKey
	
# 65 (0x41) = 'A', 90 (0x5A) = 'Z', 97 (0x61) = 'a', 122 (0x7A) = 'z'					
__validateKey:
	lb $v0, 0($a1) # load key character byte
	beqz $v0, __checkKeyValidation # if null-terminated, check validation
	blt $v0, 65, __errorEncryptString # if less than value of a capital ASCII letter, send to error
	bgt $v0, 90, __errorEncryptString # if greater than value of a capital ASCII letter, send to error
	addi $a1, $a1, 1 # otherwise, good to go. increment string address.
	addi $t7, $t7, 1 # and increment count
	b __validateKey # repeat loop
	
	__checkKeyValidation:
		beqz $t7, __errorEncryptString # if null terminator has been reached and count is zero, send to error
		sub $a1, $a1, $t7 # otherwise move back to key[0] to prepare for encryption
		
__encryptLoop:
	push($a0) # save $a0, pushing on to stack
	push($a1) # save $a1, pushing on to stack

	lb $a0, 0($a0) # loads byte stored at address of the unciphered string
	lb $a1, 0($a1) # loads byte stored at the address of the key

	beqz $a0, __endEncryptString # tests if byte is null-terminator. if it is, branch to __endEncryptString
	beqz $a1, __resetKeyAddress # if key is null-terminator, repoint the address of key to first char
	b __testInput # otherwise, branch to __testInput
		
	__resetKeyAddress:
		move $a1, $t2 # moves pointer to first character of key address
		addi $sp, $sp, 4 # bumps stack pointer up one word
		sw $a1, 0($sp) # store updated $a1 into stack
		addi $sp, $sp, -4 # bumps stack back
		lb $a1, 0($a1) # loads byte at address of a1 into a1
			
	__testInput:
		blt $a0, 65, __notAlphabet # is punctuation, so branch to __notAlphabet
		bgt $a0, 122, __notAlphabet # is punctuation, so branch to __notAlphabet
		ble $a0, 90, __callEncryptChar # if less than or equal to 90, must be a lower case ASCII letter, good to go.
		bge $a0, 97, __callEncryptChar # if greater than or equal to 97, must be an upper case ASCII letter, good to go.
		# else, punctuation (i.e., 91, ..., 96) and falls to __notAlphabet
		
	__notAlphabet:
		sb $a0, 0($a2) # store unciphered character to ciphered string
		
		pop($a1) # pops off $a1
		pop($a0) # pops off $a0
		
		addi $a0, $a0, 1 # increments address of unciphered string
		addi $a2, $a2, 1 # increments address of ciphered string
		b __encryptLoop
			
	__callEncryptChar:
		
		
		jal EncryptChar # calls EncryptChar subroutine
		sb $v0, 0($a2) # loads result of EncryptChar into $a2
		
		pop($a1) # pops off $a1
		pop($a0) # pops off $a0
			
		addi $a0, $a0, 1 # increments address of unciphered string
		addi $a1, $a1, 1 # increments address of key string
		addi $a2, $a2, 1 # increments address of ciphered string
		b __encryptLoop
			
__endEncryptString: 	
	addi $sp, $sp, 8
	
__errorEncryptString:
	pop($a2)
	pop($v0) # restores values to original input before entering subroutine
	pop($ra)
	
	jr $ra # jumps out of subroutine
	

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
	.text
	push($ra) # push return address to stack so we can jump back out of loop
	push($v0) # preserve "output" value by pushing to stack
	push($a2) # preserve original address of ciphertext string

	move $t2, $a1 # stores address of key[0] for later use in __resetKeyAddress
	move $t7, $zero # initializes a counter for sanitization 
	
__validateInputDecrypt:
	lb $v0, 0($a0) # load character byte
	beqz $v0, __checkInputValidationDecrypt # if null-terminated, check if anything has been counted
	beq $t7, 31, __errorDecryptString # if longer than 31, sends to error handling
	addi $a0, $a0, 1 # otherwise, good to go. increment string address
	addi $t7, $t7, 1 # increment counter
	b __validateInputDecrypt # otherwise, continue through the loop

	__checkInputValidationDecrypt:
		beqz $t7, __errorDecryptString # if no character has been reached yet there is a null-terminater, exit
		sub $a0, $a0, $t7 # otherwise move back to string[0] to prepare for encryption
		move $t7, $zero # reset counter for use in validateKey
	
# 65 (0x41) = 'A', 90 (0x5A) = 'Z', 97 (0x61) = 'a', 122 (0x7A) = 'z'					
__validateKeyDecrypt:
	lb $v0, 0($a1) # load key character byte
	beqz $v0, __checkKeyValidationDecrypt # if null-terminated, check validation
	blt $v0, 65, __errorDecryptString # if less than value of a capital ASCII letter, send to error
	bgt $v0, 90, __errorDecryptString # if greater than value of a capital ASCII letter, send to error
	addi $a1, $a1, 1 # otherwise, good to go. increment string address.
	addi $t7, $t7, 1 # and increment count
	b __validateKeyDecrypt # repeat loop
	
	__checkKeyValidationDecrypt:
		beqz $t7, __errorDecryptString # if null terminator has been reached and count is zero, send to error
		sub $a1, $a1, $t7 # otherwise move back to key[0] to prepare for encryption
		
__decryptLoop:
	push($a0) # save $a0, pushing on to stack
	push($a1) # save $a1, pushing on to stack

	lb $a0, 0($a0) # loads byte stored at address of the unciphered string
	lb $a1, 0($a1) # loads byte stored at the address of the key

	beqz $a0, __endDecryptString # tests if byte is null-terminator. if it is, branch to __endEncryptString
	beqz $a1, __resetKeyAddressDecrypt # if key is null-terminator, repoint the address of key to first char
	b __testInputDecrypt # otherwise, branch to __testInput
		
	__resetKeyAddressDecrypt:
		move $a1, $t2 # moves pointer to first character of key address
		addi $sp, $sp, 4 # bumps stack pointer up one word
		sw $a1, 0($sp) # store updated $a1 into stack
		addi $sp, $sp, -4 # bumps stack back
		lb $a1, 0($a1) # loads byte at address of a1 into a1
			
	__testInputDecrypt:
		blt $a0, 65, __notAlphabetDecrypt # is punctuation, so branch to __notAlphabet
		bgt $a0, 122, __notAlphabetDecrypt # is punctuation, so branch to __notAlphabet
		ble $a0, 90, __callDecryptChar # if less than or equal to 90, must be a lower case ASCII letter, good to go.
		bge $a0, 97, __callDecryptChar # if greater than or equal to 97, must be an upper case ASCII letter, good to go.
		# else, punctuation (i.e., 91, ..., 96) and falls to __notAlphabet
		
	__notAlphabetDecrypt:
		sb $a0, 0($a2) # store unciphered character to ciphered string
		
		pop($a1) # pops off $a1
		pop($a0) # pops off $a0
		
		addi $a0, $a0, 1 # increments address of unciphered string
		addi $a2, $a2, 1 # increments address of ciphered string
		b __decryptLoop
			
	__callDecryptChar:
		jal DecryptChar # calls DecryptChar subroutine
		sb $v0, 0($a2) # loads result of DecryptChar into $a2
		
		pop($a1) # pops off $a1
		pop($a0) # pops off $a0
			
		addi $a0, $a0, 1 # increments address of unciphered string
		addi $a1, $a1, 1 # increments address of key string
		addi $a2, $a2, 1 # increments address of ciphered string
		b __decryptLoop
			
__endDecryptString: 	
	addi $sp, $sp, 8
	
__errorDecryptString:
	pop($a2)
	pop($v0) # restores values to original input before entering subroutine
	pop($ra)
	
	jr $ra # jumps out of subroutine
