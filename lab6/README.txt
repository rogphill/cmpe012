Robert George Phillips
rogphill@ucsc.edu
ID# 1597347
Lab 6: Vignere Cipher
01D with Carlos Ramirez

Magic Number: 0123

This was a very tough lab! EncryptChar and DecryptChar were relatively straight-forward, but EncryptString was the real time sink. The surprising part with this lab was all of the book keeping that needed to be done, with storing things in the stack, repointing to correct addresses, incrementing counts, preparing variables for the EncryptChar and DecryptChar calls, etc. 

What worked well for me was to take everything in very bite-sized modular chunks, like I approached the last lab. It really helped to make macros for push and pull for use in the EncryptString and DecryptString subroutines, as I ended up having to use the stack a lot -- something I had not envisioned needing when I started the lab. I also made a flowchart/map type of diagram on paper which helped a LOT with thought process. It was also imperative to use stepthroughs and breakpoints to find out exactly what was happening. I had a nasty memory address bug that I would not have been able to figure out without looking at it in the memory -- MARS is great for that!

There was a lot that didn't work well for me. I had many initial problems with improperly using the command "la" until I finally found out what was happening when I stepped through the program. Also, in terms of writing pseudocode, it seems counter-intuitive in my opinion to translate my thoughts from a higher-level language to assembly (a flowchart worked much better for me, but I understand how other people find it useful). 

Questions:

1.) For additional test code, I wrote a flowchart / diagram in my notebook which helped a ton and definitely worked. For me, pseudocode didn't work too well. I think writing things down here, or referring to "comment logic" so to speak, is almost a must here.

2.) In the case of my program since it includes some key sanitation logic, an illegal key such as "NotALegalKey" would jump out of the loop and return no output. Without sanitation, the key logic that my program would have would be out of sync trying to load in the lower-case ASCII letters. 

3.) This is a tough question to conceptualize for me -- I think the base case is when the string counter hits 31 and thus exits the recursion. It would then call itself with more or less the same logic. Maybe it's possible to stuff some recursion logic into EncryptChar and DecryptChar and have it iterate over a string. This would definitely make the problem a lot harder!

4.) I think the answer would be to use a stack -- you could pass in effectively as many arguments as you'd like in that case. In my program, I ended up storing a lot of things on the stack -- up to 5 at a time. It would be easiest to make pop and push macros like I have, as well.