# dvir segev 
# 318651627
	.section	.rodata	#read only data section
getint: .string "%d"
getstring: .string "%s\n"
	.text	#the beginnig of the code
.globl	main	#the label "main" is used to state the initial point of this program
	.type	main, @function	# the label "main" representing the beginning of a function
main:	# the main function:
	pushq	%rbp		# save the old frame pointer
	movq	%rsp,	%rbp	# create the new frame pointer
    # first lenght (type of int)
    sub     $4,%rsp # big stack for 4 bytes
    leaq    (%rsp), %rsi # the adress rsp+4 to rsi
    movq    $getint,%rdi # %d in the function
    movq    $0, %rax 
    call    scanf # call scanf 
    movslq  (%rsp), %r8 # move the integer to registar r8
    movb    (%rsp), %r12b 

    # first string

    add     $3, %rsp # for \0
    leaq    (%rsp), %rsi # put the adress of the stack into rsi
    movb    $0, (%rsi) # put zero
    subq    %r8, %rsp # add to stack the size that needed.
    movq    $0,%rax
    movq    %rsp, %rsi # the second parament for the function %s. 
    movq    $getstring, %rdi # put the enter \n %c in rdi
    call    scanf
    dec     %rsp # for the number lenght.
    movb    %r12b,(%rsp) # put number.
    movq    %rsp,%r12 # the first string save in r10.

    # second lenght 
     sub    $4,%rsp # big stack for 4 bytes
    leaq    (%rsp), %rsi # the adress rsp+4 to rsi
    movq    $getint,%rdi # %d in the function
    movq    $0, %rax 
    call    scanf # call scanf 
    movslq  (%rsp), %r8 # move the integer to registar
    movb    (%rsp), %r13b

# second string
    add     $3, %rsp # for \0
    leaq    (%rsp), %rdi # put the adress of the stack into rsi
    movb    $0, (%rdi) # put zero
    subq    %r8, %rsp # add to stack the size that needed.
    movq    $0,%rax
    movq    %rsp, %rsi # the second parament for the function %s. 
    movq    $getstring, %rdi # put the enter \n %c in rdi
    call    scanf
    dec     %rsp # for the number lenght.
    movb    %r13b,(%rsp) # put number.
    movq    %rsp,%r13 # the second string save in r13.

    # the choise: 
     sub    $4,%rsp # big stack for 4 bytes
    leaq    (%rsp), %rsi # the adress rsp+4 to rsi
    movq    $getint,%rdi # %d in the function
    movq    $0, %rax 
    call    scanf # call scanf 
    movl    (%rsp) , %edi 
    movq    %r12, %rsi 
    movq    %r13 , %rdx 
    call    run_func
	movq	    %rbp, %rsp	# restore the old stack pointer - release all used memory.
	popq	    %rbp		# restore old frame pointer (the caller function frame)
	ret			#return to caller function (OS)
