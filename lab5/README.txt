Robert George Phillips
rogphill@ucsc.edu
ID# 1597347
Lab 5: Decimal to Binary
01D with Carlos Ramirez

Magic Numbers: 0b1010, 0x0745

This was an EXTREMELY tough lab that I put a lot of hours in to. However, it was a great teaching tool (albeit very frustrating). 

I had a few things that worked well for me. Debugging tools and step-throughs were CRUCIAL for this lab. I had a syscall print debug that I moved around my source code for various steps of the program. What also worked well for me was taking this in very bite-sized chunks. It was VERY important to work modularly on this, at least for me, and to break this down into separate mini-problems -- I would have never completed this otherwise. In addition, it was extremely helpful to look at the Data Segment window of MARS to see exactly where everything was being stored and at what addresses.

There were many things that didn't work well. Even starting the program was difficult for me, as I was confused by the double address system that is used in MIPS, and I was trying to treat it like a double pointer in C. After some trial and error (and initially using load word), I finally figured out how to incorporate load byte in a fashion that I wanted. 

For the converting from ASCII characters portion of the lab, first I tried a sentinel loop with the intention of working backwards, employing a count to sum 10^i. While working on this, I realized that all we were doing was multiplying by 10 when there was a new byte being read. This was, in my opinion, the hardest portion of the lab. It was difficult to figure out that I needed to increase the address by one with each iteration of the loop, without much of a crash course in lecture. I got around this with some previous knowledge of C pointers and remembering that increasing by 1 brings us to the next address.

The bitmasking portion of this lab was not hard in concept after a look at the Wikipedia page, but coding it in assembly was tricky. At first, I was using the decimal representation of 1 x 10^31 (i.e., the mask) until I tried the hex equivilent, which worked. Shifting was fairly straight forward. The hardest part of this concept was encoding it back into an ASCII character.

1.) What happens if the user inputs a number that is too large to fit in a 32-bit 2SC number?

Answer: There is an arithmetic overflow. There will be 31 bits to represent the number, plus an additional signed bit. When you enter the number 2^31 - 1, you receive 0 followed by 31 1's. When you enter 2^31, there is a runtime exception -- we still need that signed 0 representing a positive number, which would push it into 33 bits -- not possible!

2.) What happens if the user inputs a number that is too small (large magnitude, but negative) to fit in a 32-bit 2SC number? 

Answer: It also throws a runtime exception for an arithmetic overflow. When you enter in -(2^32) you get a runtime exception, but -(2^32)+1 would display as "10000000000000000000000000000001".

3.) What is the difference between the “mult” and the “multu” instructions? Which one did you use, and why?

Answer: "mult" is a signed multiplication -- which takes into account the fact we are using 2s complement representation for negative binary numbers. This means we have one less bit as it will represent either a positive or a negative number.  "multu" is unsigned multiplication, which doesn't take into account signed numbers and can use the full 32 bits. I used a regular signed "mult" for this assignment, as we are displaying our binary numbers in 2sc representation so I wanted to make sure negatives were accounted for.

4.) Consider how you might write a binary-to-decimal converter, in which the user inputs a string of ASCII “0”s and “1”s and your code prints an equivalent decimal string. How would you write your code? How is the BDC like the DBC, and how is it different?

Answer: I would likely perform a similar loop, reading each byte and decoding from ASCII, and also take advantage of the fact that each each bit equaling 1 represents a some exponentiation of 2 such that it is 2^n, and each bit equalling 0 is effectively a null. I think the BDC and DBC are similar in the fact that we are decoding from the ASCII "string" and doing some sort of conversion math. However, they differ in the fact that the math behind the conversion is very different, at least using the solution I came up with for this lab.

# Pseudocode:
#
# echo input back to user / additional formatting text
# load address of the argv with offset 0
#
# if (minus symbol) {
#     flag = 1
# } else {
#     val -= 48 //decodes from ASCII
# }
# while (val != '\0') {
#    sum *= 10
#    val -= 48
#    sum += val
# }
#
# if (flag == 1) {
#     sum *= -1 //turns negative if flagged
# }
#
# bitMask = 1000 0000 0000 0000 0000 0000 0000 0000 //a 32-bit mask that we will shift right 
# while (bitmask != all zeroes) {
#     print AND(bitMask, sum) for each bit
#     SRL(bitMask, 1) //shift right logical
# } 