        ; 8080 assembler code
        .hexfile Palindrome.hex
        .binfile Palindrome.com
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

temp: dw 'IsPalindrome' 00H
pln: dw ' Palindrome', 00H
plndk: dw ' Not Palindrome', 00H

begin:
	LXI SP,stack 	; always initialize the stack pointer
	LXI B, temp
	MVI A, READ_STR  
	call GTU_OS
	MVI H, 0      ; H = 0 
	MVI L, 0      ; L = 0
	LXI D, temp   ; put the address of string in registers D and E
golast:
	LDAX D        ; A = content of the address that pointed by registers D and E
	CPI 0         ; A - 0
	JZ chk        ; A == 0 jump to chk
	INR E         ; E = E + 1
control:
	INR L         ; L = L + 1
	MOV A, L      ; L = A
	CPI 2         ; A - 2
	JZ len        ; A == 0 jump to len
	JMP golast    ; jump to golast
len:
	INR H         ; H = H + 1
	MVI L, 0      ; L = 0
	JMP golast    ; jump to golast
chk:
	MVI A, 0      ; A = 0
	CMP H         ; A - H
	JZ end2       ; A == 0 jump to end2
	DCR E         ; E = E-1
	MOV A, H      ; A = H
loop:
	LDAX B        ; A = content of the address that pointed by registers B and C
	MOV L, A      ; L = A
	LDAX D        ; A = content of the address that pointed by registers D and E
	CMP L         ; A - L
	JNZ end       ; A!=0 jump to end
	DCR H         ; H = H - 1
	JZ end2       ; jump to end2
	DCR E         ; E = E - 1
	INR C         ; C = C + 1
	JMP loop      ; jump to loop
end:
	LXI B, temp
	MVI A, PRINT_STR       ; print str
	call GTU_OS
	LXI B, plndk
	MVI A, PRINT_STR       ; print not palindrome
	call GTU_OS
	hlt
end2:
	LXI B, temp
	MVI A, PRINT_STR        ; print str
	call GTU_OS
	LXI B, pln              ; print not palindrome
	MVI A, PRINT_STR
	call GTU_OS
	hlt
