    .text
    .type   bigint_div, %function
    .global bigint_div
bigint_div:
    stp     x29, x30, [sp, #-16]!
    stp     x27, x28, [sp, #-16]!
    stp     x25, x26, [sp, #-16]!
    stp     x23, x24, [sp, #-16]!
    stp     x21, x22, [sp, #-16]!

    //x0 = l
    //x1 = r

    mov     x21, x0                         //x21 = l
    mov     x22, x1                         //x22 = r

    mov     x0, x21
    bl      bigint_trim
    mov     x23, x0                         //x23 = lt

    mov     x0, x22
    bl      bigint_trim
    mov     x24, x0                         //x24 = rt

    mov     x0, #0
    bl      bigint_from_int
    mov     x25, x0                         //x25 = q

    mov     x26, #0                         //x26 = shift
    ldrb    w2, [x23, #8]                   //x2 = lt->size
    ldrb    w3, [x24, #8]                   //x3 = rt->size
    sub     x27, x2, x3                     //x27 = chunkshift

    cmp     x27, #0
    bge     firstif
    mov     x0, x25
    b       end

firstif:
    ldrb    w11, [x21, #8]                  //w11 = l->size
    ldrb    w12, [x22, #8]                  //w12 = r->size
    ldr     x13, [x21]                      //x13 = l->blks
    ldr     x14, [x22]                      //x14 = r->blks

    sub     w11, w11, #1
    sub     w12, w12, #1

    ldr     x4, [x13, x11]
    ldr     x5, [x14, x12]

    mov     x28, #0
    cmp     x4, #0
    bge     firstpositive
    add     x28, x28, #1
    mov     x0, x23
    bl      bigint_negate
    mov     x23, x0

firstpositive:
    cmp     x5, #0
    bge     secondpositive
    add     x28, x28, #1
    mov     x0, x24
    bl      bigint_negate
    mov     x24, x0

secondpositive:
    cmp     x27, #0
    ble     skipchunkshift
    mov     x1, x27
    mov     x0, x24
    bl      bigint_shift_left_chunk
    mov     x24, x0

skipchunkshift:
    mov     x29, #0                             //x29 = shift

shiftwhile:
    cmp     x29, #63
    bge     doneshifting
    mov     x0, x24
    mov     x1, x23
    bl      bigint_lt
    cmp     x0, #1
    bne     doneshifting

    mov     x0, x24
    mov     x1, #1
    bl      bigint_shift_left
    mov     x24, x0
    b       shiftwhile

doneshifting:
    add     x29, x29, x27, lsl #6

divloop:
    cmp     x29, #0
    blt     donediv
    mov     x1, #1
    mov     x0, x25
    bl      bigint_shift_left

    mov     x0, x24
    mov     x1, x23
    bl      bigint_le
    cmp     x0, #1
    bne     nosub

    mov     x0, x23
    mov     x1, x24
    bl      bigint_sub
    mov     x23, x0

    ldr     x0, [x25]
    ldr     x1, [x25, #0]
    add     x1, x1, #1
    str     x1, [x0, #0]

nosub:
    mov     x0, x24
    mov     x1, #1
    bl      bigint_shift_right
    mov     x24, x0
    sub     x29, x29, #1
    b       divloop

donediv:
    cmp     x28, #1
    bne     end
    mov     x0, x25
    bl      bigint_negate
    mov     x25, x0
end:
    mov     x0, x25

    ldp     x21, x22, [sp], #16
    ldp     x23, x24, [sp], #16
    ldp     x25, x26, [sp], #16
    ldp     x27, x28, [sp], #16
    ldp     x29, x30, [sp], #16
    ret
    .size   bigint_div,(. - bigint_div)
