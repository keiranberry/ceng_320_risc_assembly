/* color_to_gray will allocate a new grayimage structure and fill it
   with the grayscale equivalent of the given image.

   The C prototype is:

   grayimage *color_to_gray(rgbimage *image);

*/
.equ    red,    0
.equ    green,  1
.equ    blue,   2

.equ    rgbrow, 0
.equ    width,  8
.equ    height, 12

	.global	color_to_gray
color_to_gray:
	/* Fill in the code to allocate a new grayimage, then convert
	   each pixel from the given rgbimage from color to grayscale,
	   and store it in the grayimage. */

	stp		x29, x30, [sp, #-16]!
	stp 	x27, x28, [sp, #-16]!		//allocating registers for i and j

	mov		x29, x0			
	ldr		w0, [x29, #width]			//load width into w0 for allocate_grayimage
	ldr		w1, [x29, #height]			//load height into w1 for allocate_grayimage
	bl		allocate_grayimage			//call allocate_grayimage

	ldr		w2, [x29, #width]			//load width into w2 because w0 got overwritten
	ldr		x3, [x29, #rgbrow]
	ldr		x4, [x0, #rgbrow]

	mov		x27, #0					// i = 0
loop_height:	
	mov		x28, #0					// j = 0
	ldr		x7, [x4, x27, lsl #3]	// gray array at i
	ldr		x8, [x3, x27, lsl #3]	// rgb array at i

loop_width:
	ldrb	w11, [x8], #1			// red
	ldrb	w12, [x8], #1			// green
	ldrb	w13, [x8], #1			// blue

	mov		x14, #54				
	mul		x11, x11, x14			//x11 = 54*red
	mov		x14, #184
	mul 	x12, x12, x14			//x12 = 184*green
	mov		x14, #18
	mul 	x13, x13, x14			//x13 = 18*blue

	add 	x11, x11, x12			
	add 	x11, x11, x13			//add all 3
	lsr		x11, x11, #8			//divide by 256

	strb	w11, [x7, x28]	

	add		w28, w28, #1
	cmp		w28, w2
	blt		loop_width


	add		w27, w27, #1
	cmp		w27, w1
	blt		loop_height

	ldp 	x27, x28, [sp], #16
	ldp		x29, x30, [sp], #16

	ret