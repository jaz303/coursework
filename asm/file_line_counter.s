.text

.globl _main

_main:
  pushl %ebp
  movl %esp, %ebp
  
  # allocate space for file pointer and a counter
  subl $8, %esp
  
  # libc return address is at %ebp + 4
  # argc is at %ebp + 8
  # pointer to argv is at %ebp + 12
  # address of argv[0] is *(%ebp + 12) + 0
  # address of argv[1] is *(%ebp + 12) + 4
  # file pointer is at %ebp-4
  # counter is at %ebp-8
  
  movl 8(%ebp), %ecx        # copy argc to %ecx
  cmpl $2, %ecx             # check arg count
  jl print_usage            # print usage
  
  movl 12(%ebp), %eax       # %eax = argv[0]
  addl $4, %eax             # %eax = argv[1]
  movl (%eax), %eax         # deference
  
  subl $8, %esp             # align stack
  pushl $open_mode          # open mode
  pushl %eax                # filename
  call _fopen
  addl $16, %esp            # unwind
  movl %eax, -4(%ebp)       # return value to local
  
  test %eax, %eax           # what does this do?
  jz error_open             # handle file open error
  
  movl $0, -8(%ebp)         # line counter = 0
  
  read_loop:
    subl $12, %esp          # align
    pushl -4(%ebp)          # push file pointer
    call _fgetc             # get char
    addl $16, %esp          # unwind
    
    cmpl $-1, %eax          # compare retval to EOF
    je print_count          # if eof, bail
    
    cmpl $0x0A, %eax        # compare retval to NL
    jne read_loop           # if neq, loop
    
    addl $1, -8(%ebp)       # add 1 to line count
    jmp read_loop           # loop
  
  print_count:
    subl $8, %esp
    pushl -8(%ebp)
    pushl $count_str
    call _printf
    addl $16, %esp
    movl $0, %eax
    jmp done
  
  print_usage:
    movl 12(%ebp), %eax     # argv ptr
    subl $8, %esp           # align stack
    pushl (%eax)            # name of executable (first arg)
    pushl $usage_str        # usage string
    call _printf
    addl $16, %esp          # unwind stack
    movl $0, %eax           # return code = 0
    notl %eax               # return code = -1
    jmp done
    
  error_open:
    movl 12(%ebp), %eax
    subl $8, %esp
    pushl (%eax)
    pushl $error_str
    call _printf
    addl $16, %esp
    movl $0, %eax
    notl %eax
    jmp done
  
  done:
	
	movl %ebp, %esp
	pop %ebp
	ret
	
.data
  usage_str:    .asciz      "usage: %s <file>\n"
  open_mode:    .asciz      "r"
  error_str:    .asciz      "error opening file: %s\n"
  count_str:    .asciz      "%d\n"
