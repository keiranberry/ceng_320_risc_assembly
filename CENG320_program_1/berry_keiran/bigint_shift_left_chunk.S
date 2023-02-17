    .text
    .type   bigint_shift_left_chunk, %function
    .global bigint_shift_left_chunk
bigint_shift_left_chunk:
    stp     x29, x30, [sp, #-16]!
    stp     x27, x28, [sp, #-16]!
    stp     x25, x26, [sp, #-16]!
    stp     x23, x24, [sp, #-16]!

    cmp     x1, #0
    beq     early

    mov     x29, x0                         //x29 = l
    mov     x28, x1                         //x28 = chunks
    ldr     x24, [x29]                       //x24 = l->blks

    ldr     x27, [x0, #8]                   //x27 = l->size
    add     x0, x27, x28
    bl      bigint_alloc
    mov     x26, x0                         //x26 = tmp
    mov     x25, #0
    sub     x25, x25, x28               
    add     x25, x25, #1                    //x25 = -chunks

for:
    cmp     x25, x27
    bge     done

    add     x0, x25, x28

    cmp     x25, #0
    bge     skip
    mov     x1, #0
    str     x1, [x26, x0, lsl #3]
    b       inc

skip:
    ldr     x1, [x29, x25, lsl #3]
    str     x1, [x26, x0, lsl #3]
    
inc:
    add     x25, x25, #1
    b       for

early: 
    mov     x26, x0

done:
    mov     x0, x26

    stp     x23, x24, [sp], #16
    stp     x25, x26, [sp], #16
    stp     x27, x28, [sp], #16
    stp     x29, x30, [sp], #16
    ret
    .size   bigint_shift_left_chunk,(. - bigint_shift_left_chunk)