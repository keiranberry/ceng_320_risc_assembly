    .text
    .type   bigint_abs, %function
    .global bigint_abs
bigint_abs:
    stp     x29, x30, [sp, #-16]!
    ldr     w1, [x0, #8]                         //w1 = l->size
    ldr     x2, [x0]                            //x2 = l->blks
    sub     x1, x1, #1                          //x1 = l->size - 1
    lsl     x1, x1, #3                          //x1 = offset
    ldr     x3, [x2, x1]                        //x3 = l->blks[size-1]

    mov     x4, #1
    lsl     x4, x4, #63

    and     x3, x3, x4

    cmp     x3, #0                              
    bgt     copy
    bl      bigint_negate
    ldr     x2, [x0]
    ldr     x3, [x2, #0]
    b       done

copy:
    bl      bigint_copy

done:
    ldp     x29, x30, [sp], #16
    ret
    .size   bigint_abs,(. - bigint_abs)