/*******************************************************************
* hellogcc.S
*
* "Hello World" in ARM Assembly
*
* Keiran M Berry
*
* Thur Sep 8, 2022
*
* This is a simple Hello World program written in ARM assembly and
* using printf() from the C standard library.
*
* It should be compiled and linked as follows:
*   gcc -o hellogcc hellogcc.S
*
* gcc will call the assembler and linker, telling the linker to 
* include the C standard library in teh executable program.
*****************************************************************/
       .data

msg:   .asciz "Hello World!\n"

       .text
       .align 2 // Always align on a 4 byte boundary before main on
            // M1 Mac

       .globl _main

_main: //Need to have a _main function for M1 Mac
       stp    x29,x30, [sp, #-16]!
       adrp   x0, msg@PAGE
       add    x0, x0, msg@PAGEOFF
       bl     _printf
       //return from main()
       mov    x0, #0       //Status -> 0
       ldp    x29,x30,[sp], #16
       ret
      .end
