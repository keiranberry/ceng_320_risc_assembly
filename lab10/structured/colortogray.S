

/* color_to_gray will allocate a new grayimage structure and fill it
   with the grayscale equivalent of the given image.

   The C prototype is:

   grayimage *color_to_gray(rgbimage *image);

*/
    .equ    rgbrow, 0                   //pointer to array
    .equ    width,  8                   //columns
    .equ    height, 12                  //rows

    .global color_to_gray
color_to_gray:
    stp     x29, x30, [sp, #-16]!
    stp     x27, x28, [sp, #-16]!

    mov     x29, x0      
    ldr     w0, [x29, #width]           //load width into w0 for allocate_grayimage
    ldr     w1, [x29, #height]          //load height into w1 for allocate_grayimage
    bl      allocate_grayimage          //call allocate_grayimage

    ldr     x4, [x0, #rgbrow]
    ldr     x3, [x29, #rgbrow]          //x3 = array
    ldr     w1, [x29, #width]           //x1 = width
    ldr     w2, [x29, #height]          //x2 = height

    movi    v4.8h, #54                  //load in 54
    movi    v5.8h, #184                 //load in 184
    movi    v6.8h, #18                  //load in 18

    mov     w27, #0                     //i = 0

loopheight:  
    mov     w28, #0                     //j = 0
    ldr     x7, [x4, x27, lsl #3]       //gray array at i
    ldr     x8, [x3, x27, lsl #3]       //rgb array at i
loopwidth:

    sub     w9, w1, w28
    cmp     w9, #8                      //see if there are still 8 pixels left 
    blt     singleloopwidth             //if not then branch

    ld3     {v0.8b-v2.8b}, [x8], #24

    uxtl    v0.8h, v0.8b          
    uxtl    v1.8h, v1.8b
    uxtl    v2.8h, v2.8b

    mul     v0.8h, v0.8h, v4.8h         //54r

    mul     v1.8h, v1.8h, v5.8h         //184g

    mul     v2.8h, v2.8h, v6.8h         //18b

    add     v3.8h, v0.8h, v1.8h
    add     v0.8h, v3.8h, v2.8h         //54r + 184g + 18b

    shrn    v0.8b, v0.8h, #8

    st1     {v0.8b}, [x7], #8           //store the gray pixel value

    add     w28, w28, #8                //check if j is less than width
    cmp     w28, w1
    blt     loopwidth

singleloopwidth:

    ldrb    w11, [x8], #1               //load red
    ldrb    w12, [x8], #1               //load green
    ldrb    w13, [x8], #1               //load blue

    mov     x14, #54
    mul     x11, x11, x14               //54r
    mov     x14, #184
    madd    x11, x14, x12, x11          //54r + 184g
    mov     x14, #18
    madd    x11, x14, x13, x11          //54r + 184g + 18b

    lsr     w11, w11, #8                //divide by 256

    strb    w11, [x7, x28]              //store gray

    add     w28, w28, #1
    cmp     w28, w1                     //check if j is less than width
    blt     singleloopwidth

    add     w27, w27, #1
    cmp     w27, w2                     //check if i is less than height
    blt     loopheight

    ldp     x27, x28, [sp], #16
    ldp     x29, x30, [sp], #16
    ret
    .size   color_to_gray, (. - color_to_gray)
