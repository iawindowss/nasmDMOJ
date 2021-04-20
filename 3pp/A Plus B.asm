section .text
global _start

_start:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    call readint
        mov rcx, rax
loop1   push rcx
        call readint
        push rax
        call readint
        pop rbx
        add rax, rbx
        mov rdi, rax
        call printint
        call newline
        pop rcx
        loop loop1
    call end
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
printint:
    push rbp
    mov rbp, rsp
    sub rsp, 20
    cmp edi, 0
    je _printint_zero
    mov qword [rsp+8], 0
    mov dword [rsp+16], 0
    mov r8, rsp
    add r8, 20
    xor r11, r11
    cmp edi, 0
    jg _printint_loop_cond
    inc r11
    neg edi
    jmp _printint_loop_cond
_printint_loop:
    mov edx, edi
    movsxd rax, edx
    imul rax, rax, 1717986919
    shr rax, 34
    mov ecx, edx
    shr ecx, 31
    sub eax, ecx
    mov edi, eax
    shl eax, 2
    add eax, edi
    add eax, eax
    sub edx, eax
    add dl, 48
    mov byte [r8], dl
    dec r8
_printint_loop_cond:
    cmp edi, 0
    jne _printint_loop
_printint_done:
    cmp r11, 0
    je _printint_pos
    mov byte [r8], 45
    dec r8
_printint_pos:
    lea rsi, [rsp+20]
    lea rdi, [r8+1]
    sub rsi, r8
    call _write_buf
    mov rsp, rbp
    pop rbp
    ret
_printint_zero:
    mov byte [rsp+2], 48
    mov rsi, 1
    lea rdi, [rsp+2]
    call _write_buf
    mov rsp, rbp
    pop rbp
    ret
newline:
    push rbp
    mov rbp, rsp
    sub rsp, 4
    mov byte [rsp], 10
    mov esi, 1
    lea rdi, [rsp]
    call _write_buf
    mov rsp, rbp
    pop rbp
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
_write_buf:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    mov ecx, dword [rel obuf_start]
    add ecx, esi
    mov r8, rdi
    xor r9d, r9d
    mov r9d, esi
    cmp ecx, 8192
    jl _write_buf_l2_init
    call flush_obuf
_write_buf_l2_init:
    xor ecx, ecx
    lea rax, [rel output_buf]
    xor r11d, r11d
    mov r11d, dword [rel obuf_start]
    add rax, r11
    jmp _write_buf_l2_cond
_write_buf_l2:
    mov r11b, byte [r8]
    mov byte [rax], r11b
    inc ecx
    inc rax
    inc r8
_write_buf_l2_cond:
    cmp ecx, r9d
    jne _write_buf_l2
_write_buf_done:
    add dword [obuf_start], r9d
    mov rsp, rbp
    pop rbp
    ret
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
