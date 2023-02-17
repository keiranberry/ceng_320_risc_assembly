    .globl divide

divide:
    //x is the dividend in x0
    //y is the divisor in x1
    //there will be no subroutine calls so we can use volatile
    //count will be x2
    //quotient will be x3

    mov     x3, #0              //quotient = 0
    mov     x2, #0              //count = 0

shiftleft:
    cmp     x1, x0 
    bge     subloop             //if divisor is >= dividend, done shifting

    asl     x1, x1, #1          //shift divisor left one
    add     x2, x2, #1          //increment count
    b       shiftleft

subloop:
    cmp     x2, #0
    blt     done                //if count is negative then done

    cmp     x1, x0              //if divisor < dividend
    blt     shiftonein          //sub and shift etc

    b       shiftzeroin         //else just shift a 0 in and shift divisor  

shiftzeroin:
    asl     x3, x3, #1          //shift quotient over
    sub     x2, x2, #1          //count --
    b       subloop

shiftonein:
    sub     x0, x0, x1          //dividend - divisor
    asr     x1, x1, #1          //shift divisor over
    asl     x3, x3, #1          //shift quotient over
    add     x3, x3, #1          //add a one at the end
    sub     x2, x2, #1          //count --
    b       subloop

done: 
    mov     x1, x0              //x1 contains the remainder
    mov     x0, x3              //x0 contains the quotient