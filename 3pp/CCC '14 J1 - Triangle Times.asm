section .text
global _start

_start:
    call readint
    push rax
    call readint
    push rax
    call readint
    pop rdi
    pop rbx

    ;Check error
    lea rcx, [rbx+rdi]
    add rcx, rax
    cmp rcx, 180
    jne _error

    ;Check equilateral
    cmp rax, 60
    jne _NotEquilateral
    cmp ebx, 60
    jne _NotEquilateral
    cmp ebx, 60
    je _equilateral
    _NotEquilateral:

    ;Check isosceles
    cmp rax, rbx
    je _isosceles
    cmp rax, rdi
    je _isosceles
    cmp rbx, rdi
    jne _scalene
    jmp _isosceles

    _error:
    mov rsi, Error
    mov rdx, 5
    jmp _print
    _scalene:
    mov rsi, Tri3
    mov rdx, 7
    jmp _print
    _equilateral:
    mov rsi, Tri1
    mov rdx, 11
    jmp _print
    _isosceles:
    mov rsi, Tri2
    mov rdx, 9
    jmp _print
    _print:
    mov rax, 1
    mov rdi, 1
    syscall
end:
    call flush_obuf
    mov eax, 60
    xor edi, edi
    syscall
readint:
    push rbx
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov byte [rsp+4], 0
_readint_init:
    call _read_buf
    xor ebx, ebx
    cmp al, 45
    je _readint_neg
    sub al, 48
    cmp al, 9
    ja _readint_init
    mov ebx, eax
    jmp _readint_loop_init
_readint_neg:
    mov byte [rsp+4], 1
_readint_loop_init:
    lea rsi, [rsp+12]
    xor edi, edi
_readint_loop:
    call _read_buf
    xor ecx, ecx
    mov cl, al
    cmp cl, 48
    jl _readint_done
    sub cl, 48
    lea rbx, [rbx+4*rbx]
    shl ebx, 1
    add ebx, ecx
    jmp _readint_loop
_readint_done:
    cmp byte [rsp+4], 0
    je _readint_exit
    neg ebx
_readint_exit:
    mov eax, ebx
    mov rsp, rbp
    pop rbp
    pop rbx
    ret
_read_buf:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    mov ecx, dword [rel ibuf_start]
    mov eax, dword [rel ibuf_end]
    cmp ecx, eax
    je _read_buf_extra
_read_buf_done:
    lea rcx, [rel input_buf]
    xor r11d, r11d
    mov r11d, dword [rel ibuf_start]
    add rcx, r11
    xor eax, eax
    mov al, byte [rcx]
    inc dword [rel ibuf_start]
    mov rsp, rbp
    pop rbp
    ret
_read_buf_extra:
    xor eax, eax
    xor edi, edi
    lea rsi, [rel input_buf]
    mov rdx, 8192
    syscall
    mov dword [rel ibuf_start], 0
    mov dword [rel ibuf_end], eax
    jmp _read_buf_done
flush_obuf:
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel output_buf]
    xor edx, edx
    mov edx, dword [rel obuf_start]
    syscall
    mov dword [rel obuf_start], 0
    ret
section .bss
input_buf:     resb 8192
output_buf:    resb 8192

section .data
ibuf_start:    dd 8192
ibuf_end:      dd 8192
obuf_start:    dd 0
Tri1 db "Equilateral",10,0
Tri2 db "Isosceles",10,0
Tri3 db "Scalene",10,0
Error db "Error",10,0
