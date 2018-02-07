Robert George Phillips
rogphill@ucsc.edu
ID# 1597347
Lab 3: Ripple Adder with Memory
01D with Carlos Ramirez

This lab took me some time, but was really enlightening. In particular, I think I really understand how flip flops are connected to create an n-bit register, and how to invert operations with a singular XOR gate. I was thinking I could probably use a MUX gate as well, but figured one XOR was more elegant, plus the MML MUX gate was confusing compared to what we have in our lecture notes. It worked well to keep my circuits clean. At first, I tried to fit all of the circuits on to one page, and that certainly did not work well -- plus I had read on Piazza that people were having bugs when their circuits got too large.

It was also a great exercise to learn how to build circuits. When building my ripple adder, I started with a very inefficient circuit design (brute force method) and was having problems with the left 7-segment display displaying the wrong digit (the right 7-segment display was working perfectly, however). As I was debugging, I realized that I had some circuit errors related to unneccesary inverters, and in the process realized that the sum portion of the adder circuit could be done with (A XOR B XOR C). After a redesign of the circuit armed with this knowledge, the ripple adder finally worked.

To make debugging easier, I added LED lights for each bit of the 6-bit flip flop register. This was a great tool to see what exactly was being stored in the register. For the adder, I started debugging and testing with just one ripple adder, and only after I felt comfortable with it, duplicated it to form a 6-bit adder. Same for the inverter.

When I subtract a larger number from a smaller number, the result makes sense. It "loops" so to speak (as we learned in lecture), such that a 6-bit register takes (2^6)-1 = 63 as the highest possible digit. After 63, it loops to 0. When we subtract 1 from 0, the ripple adder loops backwards to 3F -- hexadecimal for 63, the maximum number possible. Similarly, when I add two numbers that don't fit a 6-bit register, it loops over.