	.text
    .type   bigint_free, %function
    .global bigint_free
bigint_free:
    stp     x29, x30, [sp, #-16]!
    mov     x29, x0
    ldr     x0, [x29]
    bl      free
    mov     x0, x29
    bl      free
    ldp     x29, x30, [sp], #16
    ret
    .size   bigint_free,(. - bigint_free)