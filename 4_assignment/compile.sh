#!/bin/bash
cp $1.nasm ./$1.nasm.copy

echo '[+] Assembling with Nasm ... '
nasm -f elf32 -o $1.o $1.nasm

echo '[+] Linking ...'
ld -m elf_i386 -o $1 $1.o

echo '[+] Done!'

