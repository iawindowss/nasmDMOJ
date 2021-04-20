section .data
    flag db "ctf{qu3ry_string_cr3d3nti4ls_4r3_sad}",10
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
