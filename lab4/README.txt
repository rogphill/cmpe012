Robert George Phillips
rogphill@ucsc.edu
ID# 1597347
Lab 4: DEADBEEF in MIPS
01D with Carlos Ramirez

Magic Numbers: 0b0111, 9671

As I have only had previous experience with x86, this lab using MIPS was very educational. In some ways, I think it's easier to understand than higher level languages like Java and C, and certainly I found MIPS better to work with over x86. Consequently, it didn't work very well when I tried to translate the x86 commands that I knew, except for a few ones like the "move" command. It also helped a lot to create this program in bite-sized chunks. While loop structure was a lot like x86, it was still confusing at first to get the branches and labels correct.

I believe the theoretical limit of N for this program is 2^32-1, as the size of the register $v0 that is used for the input is 32-bit -- that's where it dumps the data. 

According to MARS and the data segment display after I assemble, the text of my prompt is stored in addresses 0x10010000 through 0x10010016. It was helpful here for me to click the "ASCII" checkbox.

A pseudo operation is also known as an "extended operation," and combines sets of basic instructions to make it easier for the programmer to use. If we press F1 within MARS, we can see a list of both basic instructions and extended or pseudo operations. It seems like I used quite a bit of pseudo-ops! We can see which pseudo-ops we used very well when we assemble and look at what basic instructions are being sent into machine language. Namely, I used these commands:

"li" is a more intuitive use of "addui"
"la" is a combination of "lui" and "ori"
"move" is a more intuitive use of "addu"
"beqz" is a more intuitive version of "beq" when dealing with zeroes

You can definitely reduce the registers here. For one, the 4 and the 9 I put into registers $s1 and $s2 respectively are probably very unneccesary, but I felt helped clarify my code. Other than that -- I am not exactly sure where else I can reduce my registers used.




