/*****************************************************************************
*
* lab3.S
*
* Program that gets 2 integer inputs, adds them up and then outputs the sum
* of the 2
*
* Keiran Berry
*
* Thur Sep 15 2022
*
* Compilation Instructions
* gcc -o lab3 lab3.S
*
*****************************************************************************/

    .data

scan_32:    .asciz "%d" // Format for reading int with scanf
            // %d is the keyword for a 32 bit int

scan_64:    .asciz "%ld"    //Format for reading 64 bit int
            // %ld is the keyword of a 64 bit int

prompt_32:  .asciz  "Enter an integer between -%d and %d : "

prompt_64:  .asciz  "Enter an integer between -%ld and %ld: "


out_str:    .asciz  "The sum is %ld. \n"

        .align 2
max_int32:  .word 0x0FFF
        .align 3
max_int64:  .dword 0x0fffffff

stored_32:  .word 0
        .align 3
stored_64:  .dword 0

stored_32_2: .word 0
        .align 3

stored_64_2: .dword 0


/* Begin Main here */
    .text
    .align 2    // always word align before starting main for M1 Mac(s)

    .globl _main

_main:
    stp x29,x30, [sp, #-16]!

    //load format string into register 0
    adrp    x0, prompt_32@PAGE
    add x0, x0, prompt_32@PAGEOFF

    //load first value in format string from memory
    adrp   x8, max_int32@PAGE
    ldr w8, [x8, max_int32@PAGEOFF]
    sub sp, sp, #16 // free up space on stack to put args on stack

    // store the arguments onto the stack for printf to grab
    str w8, [sp]    // store first argument
    str w8, [sp, #8]    // store second argument (same as first)
    bl  _printf

    // free up the stack
    add sp, sp, #16


/**********************************************************
*        Reading in the 32bit int part
*
**********************************************************/
    // load format string into x0
    adrp    x0, scan_32@PAGE
    add x0, x0, scan_32@PAGEOFF

    sub sp, sp, #16 //make space on stack

    // load x1 with the mem addr of where you want to store the 32bit int
    adrp    x1, stored_32@PAGE
    add x1, x1, stored_32@PAGEOFF
    str x1, [sp]    //store it on the stack

    bl  _scanf      //branch to scanf

    add     sp, sp, #16 //free up the stack

/*********************************************************
*     Prompt Section for second 32bit number
*********************************************************/
    adrp    x0, prompt_32@PAGE  //load prompt_32 format string
    add x0, x0, prompt_32@PAGEOFF

    sub sp, sp, #16 // make space on the stack
    adrp    x1, max_int32@PAGE
    ldr x1, [x1, max_int32@PAGEOFF]
    str x1, [sp]    // store max_int32 on the stack
    str x1, [sp, #8]
    bl  _printf
    add sp, sp, #16 // free the stack

/*********************************************************
*    Reading in the 32bit int part
*********************************************************/
    adrp    x0, scan_32@PAGE     //load format string
    add x0, x0, scan_32@PAGEOFF

    adrp    x1, stored_32_2@PAGE    //load the address of where the
                                  //32 bit number to be stored
    add x1, x1, stored_32_2@PAGEOFF
    sub sp, sp, #16      //make space on the stack
    str x1, [sp]         //store the mem addr of where the scanned
                         //# is to be stored

    bl _scanf
    add sp, sp, #16      //free up the stack

/********************************************************
*   Addition section
********************************************************/
    // Load 32bit int from label/memory
    adrp    x0, stored_32@PAGE
    ldr w0, [x0, stored_32@PAGEOFF]

    // Load second 32bit int from label/memory
    adrp    x1, stored_32_2@PAGE
    ldr x1, [x1, stored_32_2@PAGEOFF]

    add x1, x0, x1  // add both the numbers together

    adrp    x0, out_str@PAGE
    add x0, x0, out_str@PAGEOFF
    sub sp, sp, #16
    str x1, [sp]
    bl  _printf
    add sp, sp, #16
 

/********************************************************
* Beginning with 64bit ints
********************************************************/

    // load format string into register 0
    adrp    x0, prompt_64@PAGE
    add x0, x0, prompt_64@PAGEOFF

    // load first value in format string from memory
    adrp    x8, max_int64@PAGE
    ldr x8, [x8, max_int64@PAGEOFF]
    sub sp, sp, #16 // free up space on stack to put args on stack

    // store the arguments onto the stack for printf to grab
    str x8, [sp]   // store first argument
    str x8, [sp, #8]    // store second argument (same as first)
    bl  _printf

    // free up the stack
    add sp, sp, #16


/****************************************************
*    Reading in the 64bit int part
*
***************************************************/
    // load format string into x0
    adrp    x0, scan_64@PAGE
    add x0, x0, scan_64@PAGEOFF

    sub sp, sp, #16 //make space on stack

    //load x1 with the mam addr of where you want to store the 64bit int
    adrp    x1, stored_64@PAGE
    add x1, x1, stored_64@PAGEOFF
    str x1, [sp]    //store it ont eh stack

    bl  _scanf    //branch to scanf

    add    sp, sp, #16  //free up the stack

/****************************************************
*     Prompt section for second 64-bit number
**************************************************/
    adrp    x0, prompt_64@PAGE  //load prompt_64 format string
    add x0, x0, prompt_64@PAGEOFF

    sub sp, sp, #16  //make space on the stack
    adrp    x1, max_int64@PAGE
    ldr x1, [x1, max_int64@PAGEOFF]
    str x1, [sp]   // store max_int64 on the stack
    str x1, [sp, #8]
    bl  _printf
    add sp, sp, #16 // free the stack

/***************************************
* Reading in the second 64-bit int part
***************************************/
    adrp    x0, scan_64@PAGE   // load format string
    add x0, x0, scan_64@PAGEOFF

    adrp    x1, stored_64_2@PAGE //load the address where it is to be stored
    add x1, x1, stored_64_2@PAGEOFF
    sub sp, sp, #16   // make space on the stack
    str x1, [sp]      //store the mem addr of where the scanned num will store

    bl _scanf
    add sp, sp, #16    //free up the stack

/*************************************
* Addition section
************************************/
    //Load 64 bit int from label/memory
    adrp    x0, stored_64@PAGE
    ldr w0, [x0, stored_64@PAGEOFF]

    //Load second 64 bit int in from label/memory
    adrp    x1, stored_64_2@PAGE
    ldr x1, [x1, stored_64_2@PAGEOFF]

    add x1, x0, x1 // add both the numbers together
 
    adrp    x0, out_str@PAGE
    add x0, x0, out_str@PAGEOFF
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16

    ldp x29, x30, [sp], #16
    ret

.end
