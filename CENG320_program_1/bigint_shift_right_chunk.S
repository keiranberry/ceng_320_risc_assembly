	.text
    .type   bigint_shift_right_chunk, %function
    .global bigint_shift_right_chunk
bigint_shift_right_chunk:
    stp     x29, x30, [sp, #-16]!
    stp     x27, x28, [sp, #-16]!

    mov     x27, x0                             //x27 = l
    mov     x28, x1                             //x28 = chunks

    ldr     x0, [x27, #8]                       //x0 = l->size
    sub     x0, x0, x28
    bl      bigint_alloc
    mov     x29, x0                             //x29 = tmp
    mov     x1, #0                              //x1 = i
    ldr     x2, [x29, #8]                       //x2 = tmp->size
    ldr     x3, [x29]                           //x3 = tmp->blks
    ldr     x4, [x27]                           //x4 = l->blks

for:   
    cmp     x1, x2
    bge     donefor

    cmp     x1, x28
    bge     else

    mov     x5, #0
    str     x5, [x3, x1, lsl #3]
    add     x1, x1, #1
    b       for
else:
    sub     x6, x1, x28
    ldr     x5, [x4, x6, lsl #3]
    str     x5, [x3, x1, lsl #3]
    add     x1, x1, #1
    b       for

donefor:
    mov     x0, x29
    ldp     x27, x28, [sp], #16
    ldp     x29, x30, [sp], #16
    ret
    .size   bigint_shift_right_chunk,(. - bigint_shift_right_chunk)