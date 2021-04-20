# nasmDMOJ

This is not for cheating but rather a way for me to document answers I have submitted on dmoj
All code is written in NASM64 and was tested on a system running Arch linux.

### To compile use the following command

name = file name with out extention

`nasm -f elf64 $name.asm -o $name.o && ld $name.o -o $name`
