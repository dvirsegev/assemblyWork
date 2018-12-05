# dvir segev
# 318651627
	.data
	#This is a simple program that calculates stuff
	.section	.rodata			#read only data section.
  getint: .string "%d"
  getchar: .string "%c"
  casestring: .string "%c %c"
  error: .string "invalid option!\n" #string for error
  case50: .string "first pstring length: %d, second pstring length: %d\n"
  case51: .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
  case53: .string "length: %d, string: %s\n"
  case54: .string "compare result: %d\n"
  .align  8	# we want all data to be save in an address that divise with their size.	
	.SWITCHCASE:
  .quad .RETLEN # Case 50: loc_A
    .quad .REPLACE # Case 51:
    .quad .COPY # Case 52: 
    .quad .SWAP # Case 53:
    .quad .STRCMP # case 54:
    .quad .L9 # case 55 and above:

	.text	#the beginnig of the code
.globl	run_func	#the label "run_func" is used to state the initial point of this program
	.type	run_func, @function	# the label "run_func" representing the beginning of a function

 # in rdi-the number we choose of switch case.
 # in rsi and rdx, the first and second string with their lenght.
run_func:	# the run_func function:
  pushq     %rbp
  movq      %rsp,%rbp  
  leal    - 50(%edi),%ecx # y = x-50  x= the number we choose
  cmpl      $4,%ecx               # Compare y:4
  ja        .L9                   # if this above 4, jump to the end.
  jmp *.SWITCHCASE(,%ecx,8)


# Case 50
.RETLEN:
  movq    %rsi, %rdi # move the first pstring to the first par.
  call    pstrlen     # calling the function pstrlen
  movzbl  %al, %r8d # extend the byte to double-word in regiester
  movq    %rdx, %rdi  # move the second pstring to the first par. 
  call    pstrlen     # calling the function pstrlen
  movzbl  %al, %r9d # extend the byte to double-word in regiester
  movl    %r8d, %esi  # move to parm. register
  movl    %r9d, %edx  # move to parm. register
  movq    $case50, %rdi
  movq	  $0,%rax
  call    printf  
  jmp     .ENDFUNC                   # Goto done

# Case 51
.REPLACE:
  pushq   %rsi  # save the first str                       # loc_B:
  pushq   %rdx  # save the second str
  sub   $1, %rsp # grow the stack by one
  leaq  (%rsp), %rsi # put the adress of the stack into rsi
  movq  $0,%rax
  movq  $getchar, %rdi # put the enter \n %c in rdi
  call  scanf 

  sub   $2, %rsp # grow the stack by 3 byts.
  leaq  1(%rsp),%rsi # first char
  # movq $0,%rdx # get the space bar
  leaq  (%rsp), %rdx # second char
  movq   $0, %rax
  movq  $casestring, %rdi 
  call  scanf
  movb  (%rsp),%dl # move the sec char to dl
  movb  1(%rsp),%sil  # move the fir char to sil
  movq  11(%rsp), %rdi # put the first string in rdi
  call  replaceChar

  movq  3(%rsp),%rdi  # put the second str in the rdi
  movq  %rax, %r10 # put the result in the stack
  movb  (%rsp),%dl # move the sec char to dl
  movb  1(%rsp),%sil  # move the fir char to sil
  call  replaceChar
  movb  (%rsp),%dl # move the sec char to dl
  movb  1(%rsp),%sil  # move the fir char to sil
  movq  $case51, %rdi
  movq  %rax, %r8
  movq  %r10, %rcx # put the result in rcx
  inc   %r8 # inc pointer string.
  inc   %rcx # inc pointer string.
  movq  $0, %rax
  call  printf
  jmp   .ENDFUNC

# Case 52
.COPY: 
  pushq  %rsi # save first string
  pushq   %rdx # save second string 
  subq  $8,%rsp # down the rsp by 8 byts.
  leaq  4(%rsp), %rsi # place the first number in %rsi 
  movq  $getint , %rdi # call %d in %rdi
  movq  $0, %rax  
  call  scanf
  movq  %rsp, %rsi # seoncd number in the stack
  movq  $getint , %rdi # call %d in %rdi
  movq  $0, %rax
  call  scanf                              
  movb  (%rsp) , %cl # move the sec number to rcx
  movb  4(%rsp) , %dl # move the first number to rdx
  movq  8(%rsp), %rsi # move the second string to rsi
  movq  16(%rsp), %rdi # move the first string to rdi
  call  pstrijcpy 
  movzbl (%rax) , %esi # move the case53 to esi
  inc   %rax # skip the lenght
  movq  %rax, %rdx # mov the result the rdx
  movq  $case53, %rdi 
  movq  $0, %rax 
  call  printf
  movq  8(%rsp), %r9
  movzbl (%r9), %esi
  movq  %r9,%rdx # mov the second string to rdx
  inc   %rdx  
  movq  $0, %rax 
  movq  $case53, %rdi 
  call  printf
  jmp   .ENDFUNC


# Case 53
.SWAP:                      
  movq   %rsi, %rdi
  pushq  %rdx
  call  swapCase
  movzbl (%rax) , %esi # move the case53 to esi 
  movq  $case53, %rdi # the string of printf
  inc   %rax
  movq  %rax, %rdx # the string move to rdx
  movq  $0, %rax
  call  printf
  popq   %rdi
  call  swapCase
  movzbl (%rax) , %esi # move the case53 to esi 
  movq  $case53, %rdi # the string of printf
  inc   %rax
  movq  %rax, %rdx # the string move to rdx
  movq  $0, %rax
  call  printf
  jmp   .ENDFUNC

# case 54
.STRCMP: 
  pushq   %rsi # save first string
  pushq   %rdx # save second string 
  subq  $8,%rsp # down the rsp by 8 byts.
  leaq  4(%rsp), %rsi # place the first number in %rsi 
  movq  $getint , %rdi # call %d in %rdi
  movq  $0, %rax  
  call  scanf
  movq  %rsp, %rsi # seoncd number in the stack
  movq  $getint , %rdi # call %d in %rdi
  movq  $0, %rax
  call  scanf
  movb  (%rsp) , %cl # move the sec number to rcx
  movb  4(%rsp) , %dl # move the first number to rdx
  movq  8(%rsp), %rsi # move the second string to rsi
  movq  16(%rsp), %rdi # move the first string to rdi
  call  pstrijcmp
  movsbl %al, %esi
  movq  $0, %rax
  movq  $case54, %rdi  
  call  printf                              
  jmp   .ENDFUNC

# error input
.L9:
 movq   $error, %rdi
 movq   $0, %rax 
 call   printf
 
 .ENDFUNC:
leave
 ret
 # rdi - first, rsi- second, rdx- 3, rcx- 4, r8 - 5