    .text
    .type   bigint_add, %function
    .global bigint_add
bigint_add:
    stp     x29, x30, [sp, #-16]!

    mov     x2, #0                          //add function is the adc with carry of 0
    bl      bigint_adc                      //call it with a carry of 0
    ldp     x29, x30, [sp], #16
    ret
    .size   bigint_add,(. - bigint_add)