    .text
    .type   bigint_cmp, %function
    .global bigint_cmp
bigint_cmp:
    stp     x29, x30, [sp, #-16]!

    //x0 is l
    //x1 is r

    ldrb    w2, [x0, #8]                //x2 = l->size
    ldrb    w3, [x1, #8]                //x3 = r->size
    mov     x9, #0                      //count of negs = 0

    sub     x7, x2, #1
    sub     x8, x3, #1

    lsl     x7, x7, #3                  //x7 = offset for l
    lsl     x8, x8, #3                  //x8 = offset for r
    ldr     x11, [x0]                   //x11 = l->blks
    ldr     x12, [x1]                   //x12 = r->blks

    ldr     x5, [x11, x7]               //x5 is most sig chunk of l
    ldr     x6, [x12, x8]               //x6 is most sig chunk of r

    cmp     x5, #0
    bge     firstpos
    add     x9, x9, #1                  //neg count++

firstpos:
    cmp     x6, #0
    bge     secondpos
    add     x9, x9, #1                  //neg count++

secondpos:
    cmp     x9, #2
    beq     two_negs                    //if both negative, branch

    cmp     x9, #1
    beq     one_neg                     //if one negative, branch

    cmp     w2, w3                     
    blt     ret_neg                     //if l->size < r->size, ret -1

    cmp     w2, w3
    bgt     ret_pos                     //ir r->size < l->size, ret 1

    cmp     x5, x6      
    blt     ret_neg                     //if l < r, ret -1

    cmp     x6, x5
    blt     ret_pos                     //if r < l, ret 1

cmp_loop:

    sub     x7, x7, #8                  //increment offset down
                                        //offset is the same for both since sizes equal
    ldr     x5, [x11, x7]
    ldr     x6, [x12, x7]

    lsr     x9, x5, #1                  //shift right for 0 in sign bit so positive if it should be
    lsr     x10, x6, #1

    cmp     x9, x10                     //if l < r, ret -1
    blt     ret_neg

    cmp     x10, x9
    blt     ret_pos                     //if r < l, ret 1

    and     x5, x5, #1                  //check last bit in case of off by one
    and     x6, x6, #1                  //this is not an issue in the regression testing,
                                        //but good practice anyway
    cmp     x5, x6
    blt     ret_neg

    cmp     x6, x5
    blt     ret_pos

    cmp     x7, #0
    bgt     cmp_loop                    //if still equal and not all chunks are checked, loop again

    mov     x0, #0
    b       end                         //if equal all the way through, return 0

two_negs:
    cmp     w2, w3                      //if l->size < r->size, ret 1 (opposite bc negative)
    blt     ret_pos 

    cmp     w3, w2                      //if r->size < l->size, ret -1 (opposite)
    blt     ret_neg

    cmp     x5, x6                      //if l < r, return -1
    blt     ret_neg 

    cmp     x6, x5                      //if r < l, return 1
    blt     ret_pos

cmpneg_loop:

    sub     x7, x7, #8                  //decrement offset

    ldr     x5, [x11, x7]
    ldr     x6, [x12, x7]

    cmp     x5, x6                      //compare chunks
    blt     ret_neg                     //if l < r, return -1

    cmp     x6, x5                      //if r < l, return 1
    blt     ret_pos

    cmp     x7, #0                      //see if last chunk
    bgt     cmpneg_loop                 //branch if not

    mov     x0, #0                      //if equal, return 0
    b       end

one_neg:
    cmp     x5, #0                      //if l is negative, it is smaller
    blt     ret_neg

    b       ret_pos                     //otherwise r is the negative
    

ret_pos:
    mov     x0, #1                      //return 1
    b       end

ret_neg:
    mov     x0, #-1                     //return -1
    b       end

end:
    ldp     x29, x30, [sp], #16
    ret

    .size   bigint_cmp,(. - bigint_cmp)

