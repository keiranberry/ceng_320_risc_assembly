/*****************************************************************
* enque: _ZN5queue5enqueEi
* deque: _ZN5queue5dequeERi
* isfull: _ZN5queue6isfullEv
* isempty: _ZN5queue7isemptyEv
*****************************************************************/


	.equ 	MAX_QUEUE_SIZE,	52

	.equ 	frontindex,		MAX_QUEUE_SIZE * 4
	.equ 	endindex,		frontindex + 4
	.equ 	nitems, 		endindex + 4

	.global _ZN5queue5enqueEi

_ZN5queue5enqueEi:

	stp 	x29, x30, [sp, #-16]!
	stp 	x19, x20, [sp, #-16]!

	mov 	x20, x0 			//move the queue into a nonvolatile
	mov 	x19, x1 			//move item to a nonvolatile

	bl 		_ZN5queue6isfullEv	//x0 is already the correct argument

	cmp 	x0, xzr 			//compare x0 to the zero register
	bne		queue_full

	ldr 	w1, [x20, endindex] //get endindex
	mov 	x2, x1 				//copy it for use later

	lsl 	x1, x1, 2			//endindex*4

	str 	w19, [x20, x1] 		//array[endindex] = item

	add 	x2, x2, #1			//endindex++

	cmp 	x2, MAX_QUEUE_SIZE 	//if statement
	bge 	loop_end_index 		

	str 	w2, [x20, endindex] 

	ldr 	w4, [x20, nitems]
	add 	x4, x4, #1 			//nitems++
	str 	w4, [x20, nitems]
	mov 	x0, #1
	ldp 	x19, x20, [sp], #16
	ldp 	x29, x30, [sp], #16
	ret

queue_full:

	mov 	x0, #0 				//return 0
	ldp 	x19, x20, [sp], #16
	ldp 	x29, x30, [sp], #16
	ret

loop_end_index:

	mov 	x3, #0
	str 	x3, [x20, endindex] //endindex = 0

	ldr 	x4, [x20, nitems]
	add 	x4, x4, #1 			//nitems++
	str 	x4, [x20, nitems]
	mov 	x0, #1
	ldp 	x19, x20, [sp], #16
	ldp 	x29, x30, [sp], #16
	ret


		.global _ZN5queue5dequeERi

_ZN5queue5dequeERi:

	stp 	x29, x30, [sp, #-16]!
	stp 	x19, x20, [sp, #-16]!

	mov	    x19, x1			//load item into a less volatile register
	mov 	x20, x0			//load queue class

	bl _ZN5queue7isemptyEv

	cmp 	x0, #1			//if(isfull())
	beq		queue_empty

	ldr 	w1, [x20, frontindex]
	mov 	x2, x1

	lsl 	x1, x1, 2 		//frontindex*4

	ldr 	w29, [x20, x1] 		
	str 	w29, [x19]		//item = array[frontindex]

	add 	x2, x2, #1			//frontindex++

	cmp 	x2, MAX_QUEUE_SIZE
	bge 	front_index_greater //if frontindex++ >= MAX_QUEUE_SIZE

	str 	w2, [x20, frontindex] 

	ldr 	w4, [x20, nitems]
	sub 	x4, x4, #1				//nitems--
	str 	w4, [x20, nitems]

	mov 	x0, x29					//return item

	ldp 	x19, x20, [sp], #16
	ldp 	x29, x30, [sp], #16
	ret

queue_empty:

	mov 	x0, #0					//return 0
	ldp 	x19, x20, [sp], #16
	ldp 	x29, x30, [sp], #16
	ret

front_index_greater:
	mov 	x3, #0
	str		w3, [x20, frontindex] 	//frontindex = 0
	
	ldr 	w4, [x20, nitems]
	sub 	x4, x4, #1				//nitems--
	str 	w4, [x20, nitems]

	mov 	x0, x29					//return item

	ldp 	x19, x20, [sp], #16
	ldp 	x29, x30, [sp], #16
	ret
