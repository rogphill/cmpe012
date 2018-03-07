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

.text
EncryptChar:
	move $v0, $a0
	move $t1, $a1
	addi $t1, $t1, -65 # subtracts 65 from the key in preparation for shift
	blt $v0, 65, __endEncryptChar # branches if less than 65, guaranteed to not be in range.
	bgt $v0, 122, __endEncryptChar # branches if greater than 122, guaranteed to not be in range.
	ble $v0, 90, __lowerCase # if less than or equal to 90, must be a lower case ASCII letter, good to go.
	bge $v0, 97, __upperCase # if greater than or equal to 97, must be an upper case ASCII letter, good to go.
	b __endEncryptChar # handles rest of cases (i.e., 91, ..., 96)
	
	__lowerCase:
		add $v0, $v0, $t1 # adds shift to character
		bgt $v0, 90, __fixShift # checks if greater than 90, if it is, needs to be fixed
		b __endEncryptChar # otherwise, character is encrypted
		
	__upperCase:
		add $v0, $v0, $t1 # adds shift to character
		bgt $v0, 122, __fixShift # checks if greater than 122, if it is, needs to be fixed
		b __endEncryptChar # otherwise, character is encrypted
		
	__fixShift:
		addi $v0, $v0, -26 # subtracts 26 to arrive back at the start of the ASCII alphabet	

__endEncryptChar: jr $ra

# Subroutine DecryptChar
# Decrypts a single character using a single key character.
# input: $a0 = ASCII character to decrypt
# $a1 = key ASCII character
# output: $v0 = Vigenere-decrypted ASCII character
# Side effects: None
# Notes: Plain and cipher will be in alphabet A-Z or a-z
# key will be in A-Z

DecryptChar:
	jr $ra
__endDecryptChar:

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
	jr $ra
__endEncryptString:

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
	jr $ra
__endDecryptString:

# Subroutine __upperEncrypt

__upperEncrypt:

# Subroutine __lowerEncrypt

__lowerEncrypt: