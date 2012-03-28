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
	
	subl $0x04, %esp
	pushl %eax
	pushl $format_str
	call _printf
	addl $0x0c, %esp
	
	ret
