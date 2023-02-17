.text
        
        .type   bigint_sub, %function
        .global bigint_sub

bigint_sub:
        stp     x29, x30, [sp, #-16]!
        stp     x27, x28, [sp, #-16]!
        stp     x25, x26, [sp, #-16]!
        stp     x23, x24, [sp, #-16]!

        mov     x27, x0                         //x27 = l
        mov     x28, x1                         //x28 = r
        mov     x29, #1                         //c = 1

        ldr     w24, [x27, #8]                  //w24 = l->size
        ldr     w25, [x28, #8]                  //w25 = r->size
        cmp     x24, x25                        //compare the sizes
        csel    x0, x24, x25, gt                //x0 = greater one
        add     x26, x0, #1                     //add 1

        mov     x0, x26                         //move greater size + 1 into x0
        bl      bigint_alloc    
        mov     x13, x0                         //move allocated bigint into x13
        ldr     x0, [x27]                       //x0 = l->blks
        ldr     x1, [x28]                       //x1 = r->blks
        ldr     x4, [x13]                       //x4 = nchunks->blks

        cmp     x24, x25                        //compares the sizes
        csel    x14, x0, x1, le                 //x14 = smaller one
        csel    x15, x1, x0, le                 //x15 = remaining one
        csel    x3, x24, x25, le                //select smaller size
        csetm   x17, le 
        csetm   x16, gt

        mov     x5, #0                          //x5 = i
        mov     x6, #0                          //x6 = j
        sub     x26, x26, #1                    //x26 is end of loop

loop_one:   
        cmp     x5, x26                         //check if loop should end
        bge     done

        sub     x6, x6, #1                      //get lsb        
        ldr     x0, [x14, x6, lsl #3]           //get chunk
        asr     x0, x0, #63                     //x0 = sign bit of msb
        eor     x0, x0, x16                     
        add     x6, x6, #1                      //j++
        cmp     x6, x3                          //see if chunk limit reached
        bge     loop_two                      

        ldr     x0, [x14, x5, lsl #3]           //if not use value from x5
        eor     x0, x0, x16
        add     x6, x6, #1                      //j++

loop_two:
        ldr     x1, [x15, x5, lsl #3]           //get chunk
        eor     x1, x1, x17

        cmp     x29, #1             
        adcs    x2, x0, x1                      //add old carry and set new carry
        cset    x29, cs                  

        str     x2, [x4, x5, lsl #3]            //store in sum

        add     w5, w5, #1                      //i++
        b       loop_one

done:
        asr     x1, x1, #63                     //x0 = sign bit of x0
        asr     x0, x0, #63                     //x1 = sign bit of x1
        cmp     x29, #1              
        adc     x2, x0, x1                      //add carry
        str     x2, [x4, x5, lsl #3]            //store in sum 
        mov     x0, x13
        bl      bigint_trim_short

        ldp     x23, x24, [sp], #16
        ldp     x25, x26, [sp], #16
        ldp     x27, x28, [sp], #16
        ldp     x29, x30, [sp], #16
        ret
        .size   bigint_sub,(. - bigint_sub)
