global _start

section       .text
_start:


; execve("/bin/sh", NULL, NULL)
; push arguments and command string to stack and make the syscall
        xor eax,eax     ;clear eax
        push eax        ;push to stack for NULL termination of command string
        push 0x68732f2f ;push "hs//" to stack
        push 0x6e69622f ;push "nib/" to stack
        mov ebx, esp    ;top of stack points to command string, put it into ebx
        mov ecx, eax    ;fill first NULL argument for execve
        mov edx, eax    ;full second NULL argument for execve
        mov al, 11      ;prepare execve syscall
        int 0x80        ;make execve syscall = spawn shell


