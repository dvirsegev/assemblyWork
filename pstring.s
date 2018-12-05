	# dvir segev
	# 318651627
	.data
	.section	.rodata
	error:.string "invalid input!\n"
	.text	#the beginning of the code.
.globl	pstrlen # func 50
.globl replaceChar # func 51
.global pstrijcpy # func 52
.global swapCase # func 53
.global pstrijcmp # func 54
# func 50
# in rdi-the string.
pstrlen:
	pushq  	%rbp
	movq   	%rsp,%rbp  
	movb 	(%rdi) , %al
	leave
	ret
# func 51
# in rdi- the string, sil- old char, dl-new char.
replaceChar:
	pushq  %rbp
	movq   %rsp,%rbp  
	movq 	%rdi, %rcx # save the adress of rdi
	movb  (%rdi), %r8b # save the lenght of the string
	inc 	%rdi # increase by 1 the pointer
	movb 	$0, %r9b # counter to 0
	.WHILE:
		cmpb 	(%rdi), %sil # if there is a match between the old char and the string go to MATCH
		je 	.MATCH
		.CHECK:
		inc 	%rdi # increase the pointer 
		inc 	%r9b # increase the counter
		cmpb 	%r9b, %r8b # check if the counter reach the size, if it is go to end
	je 	.END
	jmp 	.WHILE 
	.MATCH:
		movb 	%dl, (%rdi)
		jmp 	.CHECK
	.END:
	movq 	%rcx, %rax
	leave
	ret

# fucn 52
# in rdi- first string, rsi- second string, dl-start index, cl - end index
pstrijcpy:
    pushq 	 %rbp
	movq 	  %rsp,%rbp  
	cmpb 	(%rsi), %dl  # if the first char is bigger then the lenght of the source
	jae 	.BIGERROR
	cmpb 	(%rsi), %cl  # if the second char is bigger then the lenght of the source
	jae 	.BIGERROR
	cmpb 	(%rdi), %dl  # if the first char is bigger then the lenght copy
	jae 	.BIGERROR
	cmpb 	(%rdi), %cl  # if the second char is bigger then the lenght of the copy
	jae 	.BIGERROR
	.ChangeString:
		movq 	%rdi, %r8 # save the register
		movb 	$0, %r9b # counter zero
		inc 	%rdi 
		inc 	%rsi 
	.Whileloop:
		cmpb 	%r9b, %dl # check if the counter is equal to char i
		je 		.Copy # if it's equal jump to copy
	.IncreaseCounter: # increase the pointer's and the counter.
		inc 	%r9b
		inc 	%rdi 
		inc 	%rsi 
		jmp 	.Whileloop
	.Copy:
		movb 	(%rsi), %r10b
		movb 	%r10b, (%rdi) # copy the letter
		cmpb 	%r9b , %cl # check if the counter  reach the limit
		je 	.EXIT # go to exit if it does.
		inc 	%r9b
		inc 	%rdi 
		inc 	%rsi 
		jmp 	.Copy
	.BIGERROR: # print error
		movq 	$0, %rax
		movq 	$error, %rdi
		call 	printf
	.EXIT:
		movq 	%r8,%rax
		leave
		ret
   
# fucn 53
# rdi - first string
swapCase:
	pushq  %rbp
	movq   %rsp,%rbp 
	movb 	(%rdi), %sil # the lenght (rsi)
	movq 	%rdi, %rcx # save the adress (rcx)
	movb 	$0, %dl # counter = 0 (rdx) 
	.CONTINIUE:
		cmpb 	%sil, %dl # if(counter == lenght)
		je 		.Finish # finish while loop
		inc 	%dl # increase counter
		inc 	%rdi # increase pointer
		cmpb 	$65, (%rdi) # if letter <'65'
		jl 		.CONTINIUE
		cmpb 	$122, (%rdi)  # if letter > '122'
		ja 		.CONTINIUE
		cmpb 	$90, (%rdi) # if letter > '90'
		ja 		.NEXT
		addb 	$32, (%rdi) 	# 32+ letter = letter
		jmp 	.CONTINIUE 
			.NEXT:
				cmpb 	$97, (%rdi)  # check if it's legal.
				jl 	.CONTINIUE
				subb 	$32, (%rdi) # letter = letter - 32 
				jmp 	.CONTINIUE
	.Finish:
		movq 	%rcx, %rax # move the adress to rax
		leave
		ret
# rdi - first, rsi- second, rdx- 3, rcx- 4, r8 - 5

# func 54
# rdi-first string, rsi-second string, dl-char startindex, cl- char endindex
pstrijcmp: 
	pushq  	%rbp
	movq   	%rsp,%rbp  
	cmpb 	(%rsi), %dl  # if the first char is bigger then the lenght of the source
	jae 	.BIGERROR2
	cmpb 	(%rsi), %cl  # if the second char is bigger then the lenght of the source
	jae 	.BIGERROR2
	cmpb 	(%rdi), %dl  # if the first char is bigger then the lenght copy
	jae 	.BIGERROR2
	cmpb 	(%rdi), %cl  # if the second char is bigger then the lenght of the copy
	jae 	.BIGERROR2
	cmpb 	%dl, %cl  # if the second char is bigger then the lenght of the copy
	jb 	.BIGERROR2
	movb 	$0, %r8b # counter 
	inc 	%rdi
	inc 	%rsi
	.WHILECMP:
 		cmpb 	%r8b, %dl # comper counter and start of the input user.
 		jne 	.CheckFInish
		.Comper:
			movb 	(%rdi), %r9b # move the letter of the first string to r9b
			cmpb 	%r9b, (%rsi) # compert the letter with the letter of rsi.
			ja 	.RETURNEG # if the letter in the second string is bigger then the first.
		.RETURN1:
			cmpb 	%r9b, (%rsi) 
			je 	.CheckEnd # if there is a equal, go to CheckEnd.
			movb 	$1, %al
			jmp 	.STOP
		.EQUAL:
			movb 	$0, %al
			jmp 	.STOP
		.RETURNEG:
			movb 	$-1, %al
			jmp 	.STOP
		.BIGERROR2:
			movq 	$0, %rax
			movq 	$error, %rdi
			call 	printf
			movb 	$-2,%al
			jmp 	.STOP 
		.CheckFInish:
			cmpb	 %r8b , %cl # if it reach to the endindex, go to Equal.
			je 	.EQUAL
			inc 	%r8b # inc counter
			inc 	%rdi # inc pointer1
			inc 	%rsi # inc pointer2
			jmp 	.WHILECMP
		.CheckEnd:
		cmpb 	%r8b , %cl # if it reach to the endindex, go to Equal.
		je 	.EQUAL
		inc 	%rdi # inc pointer1
		inc 	%rsi # inc pointer2
		jmp 	.Comper
		.STOP:
			leave
			ret