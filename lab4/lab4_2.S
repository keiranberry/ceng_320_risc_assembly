    .data

prompt:    .asciz    "Enter text (hit return followed by ctrl-D or hit ctrl-D twice to end) :\n"
           .align 2

string1:   .asciz    "%02x"
           .align 2

string2:   .asciz    "%s\n"
           .align 2

string3:   .asciz    "\nThe checksum is %08X\n"

    .text
    .align 2

    .globl checksum

checksum: 
    str    x25, [sp, #16]!
    stp    x26, x27, [sp, #16]!
    mov    x25, x0
    mov    x26, #0                 //i = 0
    mov    x27, #0                 //sum = 0

chksm_loop: 
    ldrb   w0, [x25, x26]
    add    x27, x27, x0
    add    x26, x26, #1
    cmp    w0, #0
    bne    chksm_loop
    
    mov    x0, x27                 //sum -> return
    ldp    x26, x27, [sp], #16
    ldr    x25, [sp], #16
    ret

    .globl main

main: 
    stp    x29,x30, [sp, #-16]!
    stp    x27,x28, [sp, #-16]!

    sub    sp, sp, #4096         //allocate enough space to have 4096 chars
    mov    x27, sp               //move the stack pointer containing the array to x27

    adr    x0, prompt            //address prompt in x0 so that printf will grab it

    bl     printf                //call printf

loop: 
    bl     getchar               //call getchar
    str    x0, [x27, x28]        //store x0 in the array, buffered by x28
    add    x28, x28, #1          //increment the offset
    cmp    x0, #-1               //if youve reached the end
    bne    loop                  //otherwise, loop
  
    sub    x28, x28, #1          //decrement by one 
    strb   wzr, [x27,x28]        //buffer[i] = 0 so that it isnt off by 1

    adr    x0, string2           //load string2 into x0 for printf to grab
    mov    x1, x27               //load buffer into x1 for printf to grab
    bl     printf 

    mov    x0, x27               //move buffer back into x0
    bl     checksum              //checksum

    mov    x1, x0
    adr    x0, string3
    bl     printf                //print out the checksum

    mov    x0, x27
    bl     checksum              //repeat the whole thing twice to make sure it doesnt
                                 //have the same bug as part 1
    mov    x1, x0
    adr    x0, string3
    bl     printf

    //ldp    x27, x28, [sp], #16
    ldp    x29, x30, [sp], #16    //give these back
    ldp    x27, x28, [sp], #16

    ret

    .end
