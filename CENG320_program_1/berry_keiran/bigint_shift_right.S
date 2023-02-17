	.text
    .type   bigint_shift_right, %function
    .global bigint_shift_right
bigint_shift_right:
    stp     x29, x30, [sp, #-16]!
    stp     x27, x28, [sp, #-16]!
    stp     x25, x26, [sp, #-16]!

    mov     x27, x0                         //x27 = l
    mov     x28, x1                         //x28 = shamt

    and     x29, x28, #0x000000000000003F   //mask to get extra
    asr     x28, x28, #6                    //shamt = shamt/64

    bl      bigint_shift_right_chunk
    mov     x27, x0
    ldr     x4, [x27, #8]
    sub     x4, x4, #1
    ldr     x5, [x27]
    mov     x8, #64

    cmp     x29, #0
    beq     skipif

    mov     x3, #0

for:
    cmp     x3, x4
    bge     donefor
    ldr     x0, [x5, x3, lsl #3]
    asr     x0, x0, x29
    add     x7, x3 ,#1
    ldr     x1, [x5, x7, lsl #3]
    sub     x7, x8, x29
    lsl     x1, x1, x7
    orr     x0, x0, x1
    str     x0, [x5, x3]

    add     x3, x3, #1
    b       for

donefor:
    ldr     x6, [x5, x4]
    asr     x6, x6, x29
    str     x6, [x5, x4]
    str     x5, [x27, #0]

skipif:
    mov     x0, x27
    bl      bigint_trim_short

    ldp     x25, x26, [sp], #16
    ldp     x27, x28, [sp], #16
    ldp     x29, x30, [sp], #16
    ret
    