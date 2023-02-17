    .text
    .type   bigint_from_int, %function
    .global bigint_from_int
bigint_from_int:
    stp     x29, x30, [sp, #-16]!

    mov     x29, x0                 //x29 = val
    mov     x0, #1
    bl      bigint_alloc
    ldr     x1, [x0]
    str     x29, [x1]

    ldp     x29, x30, [sp], #16
    ret
    .size   bigint_from_int,(. - bigint_from_int)