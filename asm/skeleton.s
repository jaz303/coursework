.text

.globl _main

_main:
  pushl %ebp
  movl %esp, %ebp
  
  # code
	
	movl %ebp, %esp
	pop %ebp
	movl $0, %eax
	ret
	
.data

