        ; 8080 assembler code
        .hexfile ShowPrimes.hex
        .binfile ShowPrimes.com
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

string: dw ' - Prime', 00AH, 00H
newline: dw '', 00AH, 00H

begin:
	LXI SP,stack 	; always initialize the stack pointer
	MVI B, 1	; init B with 1
	MVI A, PRINT_B	; Print the B reg content
	call GTU_OS
	LXI B, newline	
	MVI A, PRINT_STR	; Print the new line
	call GTU_OS
init:
	MVI H, 2	; init H with 2
	MVI C, 2	; init C with 2
	MOV A, H    ; A = H
	CPI 2		; A-2
	JZ pri  	; go to pri if A-2==0
loop:
	SUB C       ; A=A-C
	JZ notpri   ; go to notpri if A-C==0
	JC incr     ; go to incr if A is negative
	JMP loop    ; jump to loop
incr:
	INR C       ; C=C+1
	MOV A, H    ; A = H
	CPI 255     ; A-255
	JZ end      ; go to end if A-255==0
	CMP C       ; A-C
	JZ pri      ; go to pri if A-C==0
	JMP loop	; jump to loop
pri:	
	MOV B, H           ; B = H
	MVI A, PRINT_B     ; print the B register content to the screen
	call GTU_OS
	LXI B, string
	MVI A, PRINT_STR   ; print the string to the screen
	call GTU_OS
	INR H              ; H = H + 1
	MOV A, H           ; A = H
	MVI C, 2           ; C = 2
	JMP loop           ; jump to loop
notpri:
	MOV B, H           ; B = H
	MVI A, PRINT_B     ; print the B register content to the screen
	call GTU_OS
	LXI B, newline
	MVI A, PRINT_STR   ; print the newline to the screen
	call GTU_OS
	INR H              ; H = H + 1
	MOV A, H           ; A = H
	MVI C, 2           ; C = 2
	JMP loop           ; jump to loop
end:
	MVI B, 255         ; B = 255
	MVI A, PRINT_B	   ; print the B register content to the screen
	call GTU_OS
	hlt                ; halt

	

