section .data
    flag db "ctf{insp3ct_3lement_is_aw3some_fb5a9}",10
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
