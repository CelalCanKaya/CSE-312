        ; 8080 assembler code
        .hexfile Factorize.hex
        .binfile Factorize.com
        ; try "hex" for downloading in hex format
        .download bin  
        .objcopy gobjcopy
        .postbuild echo "OK!"
        ;.nodump

	; OS call list
PRINT_B		equ 4
PRINT_MEM	equ 3
READ_B		equ 7
READ_MEM	equ 2
PRINT_STR	equ 1
READ_STR	equ 8

	; Position for stack pointer
stack   equ 0F000h

	org 000H
	jmp begin

	; Start of our Operating System
GTU_OS:	PUSH D
	push D
	push H
	push psw
	nop	; This is where we run our OS in C++, see the CPU8080::isSystemCall()
		; function for the detail.
	pop psw
	pop h
	pop d
	pop D
	ret
	; ---------------------------------------------------------------
	; YOU SHOULD NOT CHANGE ANYTHING ABOVE THIS LINE        

string: dw '', 00AH, 00H

begin:
	LXI SP,stack 	; always initialize the stack pointer
	MVI A, READ_B
	call GTU_OS
	MOV E, B        ; E = B
	MOV D, B        ; D = B
loop:
	MOV A, E       ; A = E
loop2:
	INR D          ; D = D + 1
	DCR D          ; D = D - 1   i did this because i need to change the flags
	JZ end         ; if D==0 jump to end
	SUB D          ; A = A - D
	JZ print       ; if A==0 jump to print
	JC dcrs        ; if A is negative jump to dcrs
	JMP loop2      ; jump to loop2
dcrs:
	DCR D          ; D=D-1
	JMP loop       ; jump to loop
print:
	MOV B, D       ; B = D
	MVI A, PRINT_B ; print the B register content to the screen
	call GTU_OS
	LXI B, string
	MVI A, PRINT_STR  ; print the string to the screen
	call GTU_OS	
	JMP dcrs        ; jump to dcrs
end:
	hlt          ; halt
	

