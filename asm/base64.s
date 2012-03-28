.text

.globl _main

_main:
	movl $plain_data, %esi
	movl $encoded_data, %edi
	movl $b64table, %ebp
	
	movl $0x00, %ecx
	movl (plain_data_len), %edx

	base64_loop:
		movb (%esi, %ecx, 1), %al
		incl %ecx
		shl $16, %eax
		movb (%esi, %ecx, 1), %ah
		incl %ecx
		movb (%esi, %ecx, 1), %al
		incl %ecx
		
		movl %eax, %ebx
		
		shr $18, %eax
		andl $0x3f, %eax
		movb (%ebp, %eax, 1), %al
		movb %al, (%edi)
		incl %edi
		movl %ebx, %eax
	
		shr $12, %eax
		andl $0x3f, %eax
		movb (%ebp, %eax, 1), %al
		movb %al, (%edi)
		incl %edi
		movl %ebx, %eax
		
		shr $6, %eax
		andl $0x3f, %eax
		movb (%ebp, %eax, 1), %al
		movb %al, (%edi)
		incl %edi
		movl %ebx, %eax
		
		andl $0x3f, %eax
		movb (%ebp, %eax, 1), %al
		movb %al, (%edi)
		incl %edi
		movl %ebx, %eax
		
		cmpl %edx, %ecx
		jl base64_loop
		
	movb $0, %al
	movb %al, (%edi)
	
	pushl $encoded_data
	pushl $plain_data
	pushl $format_str			# format string
	call _printf					# printf()
	addl $0x0c, %esp			# restore the stack
		
	ret

.data
	b64table:
		.byte 'A,'B,'C,'D,'E,'F,'G,'H
		.byte 'I,'J,'K,'L,'M,'N,'O,'P
		.byte 'Q,'R,'S,'T,'U,'V,'W,'X
		.byte 'Y,'Z,'a,'b,'c,'d,'e,'f
		.byte 'g,'h,'i,'j,'k,'l,'m,'n
		.byte 'o,'p,'q,'r,'s,'t,'u,'v
		.byte 'w,'x,'y,'z,'0,'1,'2,'3
		.byte '4,'5,'6,'7,'8,'9,'+,'/
		
	.comm encoded_data, 1024
		
	format_str:				.asciz		"Plain data: %s\nEncoded data: %s\n"
	plain_data:				.asciz		"Hello World!"
	plain_data_len:		.long			12
