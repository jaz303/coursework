.text

.globl _main

_main:
	mov	$99, %eax
	
	loop:
		push %eax
		
		subl $12, %esp
		push %eax
		push %eax
		push $format_str_1
		call _printf
		addl $24, %esp
		
		pop %eax
		decl %eax
		push %eax

		push %eax
		push $format_str_2
		call _printf
		addl $8, %esp
		
		pop %eax
		
		test %eax, %eax
		jnz loop
	
	subl $8, %esp
	push $format_str_3
	call _printf
	addl $12, %esp
	
	movl $0, %eax
	ret
	
.data
	format_str_1:			.asciz		"%d bottles of beer on the wall! %d bottles of beer,\n"
	format_str_2:			.asciz		"Take one down, pass it around, %d bottles of beer on the wall\n"		
	format_str_3:			.asciz		"No more bottles of beer on the wall!\n"