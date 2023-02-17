        .data
doubleval:
        .double 0
        .align  3

        .section .rodata
briefdescription:
        .asciz  "\nThis program will produce a table given a domain for x to evaluate the function f(x).\n\n f(x) = ( x^3 - x^2 -2x ) / ( ( ( x - 2 )^4 / 11 ) + 3 )\n\n"
        .align  2

lowprompt:
        .asciz  "Please enter a lower limit for x: "
        .align  2

highprompt:
        .asciz  "Please enter an upper limit for x: "
        .align  2

rowprompt:
        .asciz  "Please enter the number of rows in the table: "
        .align  2

head:
        .asciz  "x\tf(x)\n"
        .align  2

format:    
        .asciz  "%lf"
        .align  2

tab:
        .asciz  "\t"
        .align  2

newline:
        .asciz  "\n"
        .align  2

        .text

        .type   main, %function
        .globl  main
main:   stp     x29, x30, [sp, #-16]!
        stp     d10, d11, [sp, #-16]!
        stp     d8, d9, [sp, #-16]!

        adr     x0, briefdescription
        bl      printf

        adr     x0, lowprompt
        bl      printf

        adr     x0, format
        adr     x1, doubleval
        bl      scanf

        ldr     d8, doubleval

        adr     x0, newline
        bl      printf

        adr     x0, highprompt
        bl      printf

        adr     x0, format
        adr     x1, doubleval
        bl      scanf

        ldr     d9, doubleval

        adr     x0, newline
        bl      printf

        adr     x0, rowprompt
        bl      printf

        adr     x0, format
        adr     x1, doubleval
        bl      scanf

        ldr     d10, doubleval

        fmov    d0, #1.0
        fsub    d10, d10, d0                //rows--
        frintm  d10, d10              

        adr     x0, newline
        bl      printf

        fsub    d0, d9, d8                  //d0 = upper - lower 
        fdiv    d11, d0, d10                //d11 = delta x

        adr     x0, head
        bl      printf

print:
        adr     x0, format
        fmov    d0, d8
        bl      printf

        adr     x0, tab
        bl      printf

        fmul    d0, d8, d8                  //d0 = x^2
        fnmsub  d0, d0, d8, d0              //d0 = - ( x^2 - x^3 ) = x^3 - x^2
        fmov    d1, 2.0                     //d1 = 2
        fmsub   d0, d8, d1, d0              //d0 = ( x^3 - x^2 ) - 2x

        fmov    d1, 2.0
        fsub    d1, d8, d1                  //d1 = x - 2
        fmul    d1, d1, d1
        fmul    d1, d1, d1                  //d1 = ( x - 2 )^4
        fmov    d2, 11.0
        fdiv    d1, d1, d2                  //d1 = ( x - 2 )^4 / 11
        fmov    d2, 3.0
        fadd    d1, d1, d2                  //d1 = ( x - 2 )^4 / 11 + 3

        adr     x0, format
        fdiv    d0, d0, d1
        bl      printf

        adr     x0, newline
        bl      printf

        adr     x0, newline
        bl      printf

        fadd    d8, d8, d11     
        fcmp    d8, d9
        ble     print 

        ldp     d8, d9, [sp], 16
        ldp     d10, d11, [sp], 16
        ldp     x29, x30, [sp], 16
        mov     x0, 0
        ret
        .size   main, (. - main)