    .bss
n:          .word   0
            .align  2

    .data

prompt:     .asciz    "Enter a natural number: "
            .align 2

input:      .asciz    "%d"
            .align 2

output:     .asciz      "Primes: \n"
            .align 2

primeout:   .asciz      "%d\n"
            .align 2

    .text

    .globl  isprime

isprime: 
    //stp     x24, x25, [sp, #16]!
    //stp     x22, x23, [sp, #16]!
    mov     x22, x0                 //move p into x22

    lsr     x23, x0, 1              //x23 = p/2
    mov     x24, #2                 //x24 = i = 2

loopi:
    mov     x25, #2                 //j = 2
loopj:

    mul     x1, x24, x25            //x1 = i*j

    cmp     x1, x22                 //if i*j > p
    bgt     plusplus                //break and loop

    cmp     x1, x22                 //if i*j == p
    beq     notprime                //

plusplus:
    add     x25, x25, #1            //j++
    cmp     x25, x23                //if j < p/2
    ble     loopj                   //loop

    add     x24, x24, #1            //i++
    cmp     x24, x23                //if i < p/2
    ble     loopi                   //loop

    //ldp    x22, x23, [sp], #16
    //ldp    x24, x25, [sp], #16
    mov    x0, #1
    ret

notprime:
    //ldp    x22, x23, [sp], #16
    //ldp    x24, x25, [sp], #16
    mov    x0, #0
    ret

    .type   main, %function
    .globl  main

main:   
    stp     x29, x30, [sp, #-16]!
    stp     x27, x28, [sp, #-16]!
    stp     x24, x25, [sp, #16]!
    stp     x22, x23, [sp, #16]!

    adr     x0, prompt
    bl      printf
    adr     x0, input
    adr     x1, n
    bl      scanf
    adr     x0, output
    bl      printf

    mov     w29, #1
    ldr     w27, n

test:   
    mov     w0, w29
    bl      isprime

    cmp     x0, xzr
    beq     increment

    adr     x0, primeout
    mov     w1, w29
    bl      printf

increment:   
    add     w29, w29 , #1
    cmp     w29, w27
    ble     test

    ldp     x22, x23, [sp], #16
    ldp     x24, x25, [sp], #16
    ldp     x27, x28, [sp], #16
    ldp     x29, x30, [sp], #16

    ret