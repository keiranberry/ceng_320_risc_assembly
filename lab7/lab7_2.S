    .bss
pennies:    .word   0
            .align 2

nickels:    .word   0
            .align 2

dimes:      .word   0
            .align 2

quarters:   .word   0
            .align 2
    .data
prompt:     .asciz      "Enter the number of pennies, nickels, dimes, and quarters for week %d: "
            .align 2

readin:     .asciz      "%d %d %d %d"
            .align 2

collected:  .asciz "\nOver four weeks you have collected %d pennies, %d nickels, %d dimes, and %d quarters \n\n"
            .align  2

total:      .asciz  "This comes to $%d.%02d \n"
            .align  2

average:    .asciz  "Your weekly average is $%d.%02d \n"
            .align  2

yearly:     .asciz  "Your estimated yearly savings is $%d.%02d \n"
            .align  2

    .text

    .globl main
main:

    stp     x29, x30, [sp, #-16]!
    stp     x27, x28, [sp, #-16]!
    stp     x25, x26, [sp, #-16]!
    stp     x23, x24, [sp, #-16]!

    mov     x25, #0                 //pennies = 0
    mov     x26, #0                 //nickels = 0
    mov     x27, #0                 //dimes = 0
    mov     x28, #0                 //quarters = 0

    mov     x24, #1                 //use for week num

weekprompt:

    adr     x0, prompt
    mov     x1, x24                 //move week number in
    bl      printf                  //print prompt

    add     x24, x24, #1            //week++

    adr     x0, readin
    adr     x1, pennies
    adr     x2, nickels
    adr     x3, dimes
    adr     x4, quarters
    bl      scanf

    ldr     x0, pennies
    ldr     x1, nickels
    ldr     x2, dimes
    ldr     x3, quarters

    add     x25, x25, x0                //add pennies to total
    add     x26, x26, x1                //add nickels to total
    add     x27, x27, x2                //add dimes to total
    add     x28, x28, x3                //add quarters to total

    cmp     x24, #5                     //if not gotten all 4 weeks
    blt     weekprompt                  //ask for the next week

    adr     x0, collected               //total collected string
    mov     x1, x25                     //total pennies
    mov     x2, x26                     //total nickels
    mov     x3, x27                     //total dimes
    mov     x4, x28                     //total quarters
    bl      printf                      //printf call NUMBER ONE

    //using multiplication as a series of shifts and adds to sum
    //no need to multiply pennies

    mov     w0, #0
    add     w0, w0, w26, lsl #2         //w0 = 4*nickels
    add     w26, w26, w0                //w26 = 5*nickels

    mov     w0, #0 
    add     w0, w0, w27, lsl #3         //w0 = 8*dimes
    add     w27, w0, w27, lsl #1        //w27 = 10*dimes

    mov     w0, #0
    add     w0, w0, w28, lsl #4         //w0 = 16*quarters
    add     w0, w0, w28, lsl #3         //w0 = 24*quarters
    add     w28, w0, w28                //w28 = 25*quarters

    mov     w23, #0
    add     w23, w25, w26               //w23 = pennies + nickels
    add     w23, w23, w27               //w23 = p + n + d
    add     w23, w23, w28               //w23 = p + n + d + q

    //division by a constant to get the dollars and cents
    ldr     x0, =0xA3D8                 //total divided by 100
    mul     x1, x23, x0
    asr     x2, x1, #22
    sub     x2, x2, x1, asr #63         //x2 is dollars

    //cents will be remainder
    mov     x1, #100
    mul     x3, x1, x2
    sub     x3, x23, x3

    mov     x1, x2                      //move these into the right place
    mov     x2, x3                      //for printf
    adr     x0, total
    bl      printf                      //printf call NUMBER TWO

    //divide by 400 to get the average
    ldr     x2, =0x28F6
    mul     x3, x23, x2
    asr     x1, x3, #22
    sub     x1, x1, x3, asr #63

    mov     x2, #400
    mul     x2, x2, x1
    sub     x2, x23, x2

    lsr     x2, x2, #2

    adr     x0, average
    bl      printf                      //printf call NUMBER THREE

    mov     x0, #0
    add     x0, x0, x23, lsl #3         //x0 = total*8
    add     x23, x0, x23, lsl #2        //x23 = total*12 = yearly total in cents
    
    //division by a constant to get the dollars and cents
    ldr     x0, =0xA3D8                 //total divided by 100
    mul     x1, x23, x0
    asr     x2, x1, #22
    sub     x2, x2, x1, asr #63         //x2 is dollars

    //cents will be remainder
    mov     x1, #100
    mul     x3, x1, x2
    sub     x3, x23, x3

    mov     x1, x2                      //move these into the right place
    mov     x2, x3                      //for printf
    adr     x0, yearly
    bl      printf                      //printf call NUMBER FOUR

    ldp     x23, x24, [sp], #16
    ldp     x25, x26, [sp], #16
    ldp     x27, x28, [sp], #16
    ldp     x29, x30, [sp], #16

    ret
