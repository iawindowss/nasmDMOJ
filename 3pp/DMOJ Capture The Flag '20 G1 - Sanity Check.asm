section .data
    flag db "ctf{096058ecec0caff7865d13a6169b5b34}",10
section .text
    global _start
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, flag
    mov rdx, 37
    syscall
 
    mov rax, 60
    mov rdi, 0
    syscall
