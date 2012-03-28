.text

.globl _main

_main:
	pushl $22
	pushl $20
	pushl $42
	pushl $3
	call sum_numbers
	addl $16, %esp
	
  subl $4, %esp
  push %eax
  push $format_str
  call _printf
  addl $12, %esp
	
	mov $0, %eax
	ret
	
	sum_numbers:
	  pushl %ebp            # save old FP
	  movl %esp, %ebp       # setup new FP
	  subl $4, %esp         # allocate 4 bytes on stack
	  
	  movl $0, %eax
	  movl $0, %ecx
	  movl 8(%ebp), %edx
	  
	  sum_loop:
	    addl 12(%ebp, %ecx, 4), %eax
	    incl %ecx
	    
	    decl %edx
	    jnz sum_loop
	    
	  movl %ebp, %esp
	  pop %ebp
	  ret
	  
.data
  format_str:   .asciz      "Sum: %d\n"