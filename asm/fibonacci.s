.data
	format_str:
		.asciz "Result: %i\n"
	
.text

.globl _main

_main:
	movl $0, %ecx
	movl $1, %ebx
	movl $1, %eax
	movl $12, %edi
	
	fib_loop:
		movl %ebx, %ecx
		movl %eax, %ebx
		addl %ecx, %eax
		
		decl %edi
		jnz fib_loop
	
	subl $0x04, %esp			# align stack
	pushl %eax						# %i
	pushl $format_str			# format string
	call _printf					# printf()
	addl $0x0c, %esp			# restore the stack
	
	movl $0x00, %eax			# return 0
	
	ret
