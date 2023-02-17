    .bss
value:  .quad   0

store:  .byte   0
	.align 2

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

string: 
	.asciz  "%s"
    .align  2

quadvalIO:
    .asciz  "%ld"
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
main:  
	stp     x29, x30, [sp, #-16]!
    stp     x27, x28, [sp, #-16]!

    adr     x0, briefdescription
    bl      printf

    adr     x0, lowprompt
    bl      printf

    adr     x0, string
    adr     x1, store
    bl      scanf

    adr     x0, store
    mov     x1, #16
    bl      strtoSfixed

    mov     x27, x0                     //x27 = S(47, 16)

    adr     x0, newline
    bl      printf

    adr     x0, highprompt
    bl      printf

    adr     x0, string
    adr     x1, store
    bl      scanf

    adr     x0, store
    mov     x1, #16
    bl      strtoSfixed

    mov     x28, x0                     //x28 = S(47, 16)

    adr     x0, newline
    bl      printf

    adr     x0, rowprompt
    bl      printf

    adr     x0, quadvalIO
    adr     x1, value
    bl      scanf

    ldr     x29, value

    adr     x0, newline
    bl      printf

    sub     x29, x29, #1 
    sub     x0, x28, x27                //x0 = high - low
    udiv    x29, x0, x29                //x29 = delta x

    adr     x0, head
    bl      printf

print:
    mov     x0, x27
    mov     x1, #16
    bl      printS

    adr     x0, tab
    bl      printf

    mul     x1, x27, x27                //x1 = x^2
    lsr     x1, x1, #16                 //x1 = S(47, 16)
	mul     x0, x27, x1                 //x0 = x^3
    lsr     x0, x0, #16                 //x0 = S(47, 16)
    mov     x3, #2						//x3 = 2
    lsl     x3, x3, #16                 //x3 = S(47, 16)
    mul     x2, x27, x3                 //x2 = 2x
    lsr     x2, x2, #16                 //x2 = S(47, 16)
    sub     x0, x0, x1                  //x0 = x0 - x1
    sub     x0, x0, x2                  //x0 = x0 - x2

    sub     x1, x27, x3                 //x1 = x-2
    mul     x1, x1, x1                  //x1 = x1*x1
    lsr     x1, x1, #16                 //x1 = S(47, 16)
    mul     x1, x1, x1                  //x1 = (x - 2)^4
    lsr     x1, x1, #16                 //x1 = S(47, 16)

    mov     x2, #11						//x2 = 11
    sdiv    x1, x1, x2                  //x1 = S(47, 16)

    mov     x2, #3						//x2 = 3
    lsl     x2, x2, #16					//x2 = S(47,16)
    add     x1, x1, x2

    lsl     x0, x0, #16                 //x0 = S(31,32)
    sdiv    x0, x0, x1                  //x0 = (47,16)
    mov     x1, #16
    bl      printS

    adr     x0, newline
    bl      printf
    adr     x0, newline
    bl      printf

    add     x27, x27, x29 
    cmp     x27, x28
    blt     print

    ldp     x27, x28, [sp], #16
    ldp     x29, x30, [sp], #16
    mov     x0, 0
    ret
    .size   main, (. - main)