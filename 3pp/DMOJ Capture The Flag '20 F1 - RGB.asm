section .data
    flag db "ctf{colours_560fb7e05836e11fb24f3d6f}",10
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
