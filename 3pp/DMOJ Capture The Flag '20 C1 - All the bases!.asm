section .data
    flag db "ctf{all_the_b4ses_4c7128eea55675dd43}",10
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
