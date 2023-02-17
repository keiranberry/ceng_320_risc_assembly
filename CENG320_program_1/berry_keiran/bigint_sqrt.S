    .text
    .type   bigint_sqrt, %function
    .global bigint_sqrt
bigint_sqrt:
    stp     x29, x30, [sp, #-16]!
    stp     x27, x28, [sp, #-16]!

    //x0 is b
    mov     x29, x0                         //x29 = b
    mov     x1, #1
    bl      bigint_shift_right

    mov     x28, x0                         //x2
    

    ldp     x27, x28, [sp], #16
    ldp     x29, x30, [sp], #16