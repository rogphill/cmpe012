Robert George Phillips
rogphill@ucsc.edu
ID# 1597347
Lab 7: Floating Point Calculations
01D with Carlos Ramirez

This was a great lab to learn floating point, and also binary arithmetic. I feel super prepared for the final after doing this lab. 

What worked well for me was to take things step-by-step, first by decoding the floating point into binary, then splitting that binary number into a sign bit, 8 exponent bits, and the remaining mantissa bits. 

What didn't work well for me was to dive head first into problems without first understanding the concept of binary multiplication. Number 2b in particular was very tough for me and took numerous tries and attempts (maybe with a bit too much scribble). 

Questions:

1.) Since the exponent bits "1111 1111" or 255 are reserved for NaN, the largest number that IEEE 745 SP floating point can express (besides infinity) is when the sign bit is 0, all of the mantissa bits are 1, and the exponent bits are set to 254 or "1111 1110" in binary. Together, these bits are represented by the IEEE 745 SP floating point number of 0x7f7fffff. This number in decimal is about 3.4E38 -- very, very large! 

Conversely, the smallest positive number you can store would be when the exponent bits are all 0s, giving us an effective real exponent value of 2^(-126). Additionally, all of the mantissa bits should be all zeroes, except for the last bit, which should be 1. Theoretically, this last bit the highest negative power of 2 which is the smallest. If all mantissa bits were checked zero, then the floating point would be equal to 0. This gives us a IEEE 745 SP floating point number of 0x00000001. The decimal equivilent would be about 1.4E-45.

2.) Using a bias instead of 2SC representation helps speed up addition and subtraction with floating point numbers because it makes it very easy to compare two biased numbers. Comparing two 2SC signed binary numbers would be very difficult when we need to use both negative and positive exponent values. In single point IEEE 745, we use a bias of 127. In double point IEEE 745, we use a bias of 1023. 

3.) 
FL_add(float1, float2):

     //assume each hex IEEE 745 SP FP number is binarized to 32 bits

    signbit1 = float1[0]
    signbit2 = float2[0]
    
    for (i = 1; i <= 8; i++) {
        exp1[i-1] = float1[i] //gets exponent bits from float1[1 ... 8]
    }

    for (i = 1; i <= 8; i++) {
        exp2[i-1] = float2[i] //gets exponent bits from float2[1 ... 8]
    }

    for (i = 9; i < 32; i++) {
        mantissa1[i-9] = float1[i] //gets mantissa bits from float1[9 ... 31]
    }

    for (i = 9; i < 32; i++) {
        mantissa1[i-9] = float2[i] //gets mantissa bits from float2[9 ... 31]
    }

    while (exp1 < exp2) {
        mantissa1 >> 1
        exp1++
    }

    while (exp2 < exp1) {
        mantissa2 >> 1
        exp2++
    }

    if (signbit1 == 1) {
        flip bits of mantissa1, add 1
    }

    if (signbit2 == 1) {
        flip bits of mantissa2, add 1
    }

    finalMantissa = mantissa1 + mantissa2
    finalExponent = exp1 //8 bits from exponent (with bias +127)
    
    if (finalMantissa is a negative 2sc binary number) {
        finalSignbit = 1
    } else {
        finalSignbit = 0
    }

    finalFloat[0] = finalSignbit
    
    for (i = 1; i <= 8; i++) {
        finalFloat[i] = finalExponent[i-1] //gets exponent bits from finalExponent
    }

    for (i = 9; i < 32; i++) {
        finalFloat[i] = finalMantissa[i-9] //gets mantissa bits from finalMantissa
    }

    return finalFloat
}

FP_mult(float1, float2):

    //assume each hex IEEE 745 SP FP number is binarized to 32 bits

    signbit1 = float1[0]
    signbit2 = float2[0]

    //assume each hex IEEE 745 SP FP number is binarized to 32 bits
    
    for (i = 1; i <= 8; i++) {
        exp1[i-1] = float1[i] //gets exponent bits from float1[1 ... 8]
    }

    for (i = 1; i <= 8; i++) {
        exp2[i-1] = float2[i] //gets exponent bits from float2[1 ... 8]
    }

    for (i = 9; i < 32; i++) {
        mantissa1[i-9] = float1[i] //gets mantissa bits from float1[9 ... 31]
    }

    for (i = 9; i < 32; i++) {
        mantissa1[i-9] = float2[i] //gets mantissa bits from float2[9 ... 31]
    }

    if (signbit1 == 1 && signbit2 == 1) {
        finalSignbit = 0
    }

    if (signbit1 == 1 && signbit2 == 0) {
        finalSignbit = 1
    }

    if (signbit1 == 0 && signbit2 == 1) {
        finalSignbit = 1
    }

    if (signbit1 == 0 && signbit2 == 0) {
        finalSignbit = 0
    }

    finalExponent = exp1 + exp2 - 127 //since there is an extra bias, we need to subtract one off
    finalMantissa = mantissa1 * mantissa2

    finalFloat[0] = finalSignbit
    
    for (i = 1; i <= 8; i++) {
        finalFloat[i] = finalExponent[i-1] //gets exponent bits from finalExponent
    }

    for (i = 9; i < 32; i++) {
        finalFloat[i] = finalMantissa[i-9] //gets mantissa bits from finalMantissa
    }

    return finalFloat
}