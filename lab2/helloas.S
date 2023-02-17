/************************************************************************
* helloas.s
*
* "Hello World" in ARM Assembly
*
* Keiran M Berry
*
* Thur Sep 8, 2022
*
* This is a simple Hello, Word program written in ARM assembly using 
* MacOS system calls.
* This version will run without the C standard library, and provides 
* its own _start function.
*
* It should be assembled and linked as follows:
*    as -arch arm64 -o helloas.o hellosd.S
*    ld -o helloas helloas.o -lSystem i -syslibroot
*       'xcrun -sdk macosx --show-sdk-path' -e _start -arch arm64
**********************************************************************/
        .data           //static variables are declared here
msg:    .ascii "Hello World!\n"
        .align 3
len:    .word  13

        .text           //begin code here
        .align 2

        .globl  _start
        // main is called by the _start function which is in the C
        // standard library
_start:
        // write( int fd, const void *buf, size_t count)
        stp     x29,x30, [sp, #-16]!
        mov     x0, #1
        adrp    x1, msg@PAGE
        add     x1, x1, msg@PAGEOFF
        adrp    x2, len@PAGE
        ldr     x2, [x2, len@PAGEOFF]

        mov     x16, #4           //Unix write system call#
        svc     #0x80

        //return from main()
        ldp     x29,x30,[sp], #16
        mov     x0, #0            //Status -> 0
        mov     x16, #1           //Unix terminate system call
        svc     #0x80

        .end
