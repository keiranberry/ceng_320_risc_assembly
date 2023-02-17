    .text
    .type   bigint_shift_left, %function
    .global bigint_shift_left
bigint_shift_left:
    stp     x29, x30, [sp, #-16]!
    stp     x27, x28, [sp, #-16]!

    mov     x29, x1                     //x29 = shamt
    mov     x1, #0x000000000000003F     //x1 = mask for mod
    and     x29, x29, x1                //x29 = extra
    ldr     w1, [x0, #8]                //w1 = size
    add     x1, x1, #1                  //x1 = size + 1
    mov     x28, x1                     //x28 = size + 1
    bl      bigint_extend               //x0 = l
    
    cmp     x29, #0
    bne     done
    sub     x28, x28, #2                //x28 = size - 1 = i
    ldr     x1, [x0]                    //x1 = l->blks
    mov     x2, #64
    sub     x2, x2, x29                 //x2 = BITSPERCHUNK - extra

forloop:
    cmp     x28, #0
    ble     doneloop

    ldr     x3, [x1, x28, lsl #3]
    lsl     x3, x3, x29
    sub     x4, x28, #1
    ldr     x5, [x1, x4, lsl #3]
    lsr     x5, x5, x2
    orr     x3, x3, x5

    str     x3, [x1, x28, lsl #3]

    sub     x28, x28, #1
    b       forloop

doneloop:
    ldr     x3, [x1, #0]
    lsl     x3, x3, x29
    str     x3, [x1, #0]
    str     x1, [x0, #0]

done:
    bl      bigint_trim_short
    ldp     x27, x28, [sp], #16
    ldp     x29, x30, [sp], #16
    .size   bigint_shift_left,(. - bigint_shift_left)