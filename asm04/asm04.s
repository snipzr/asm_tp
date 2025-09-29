section .bss
    buffer resb 16

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 16
    syscall
    mov rcx, rax
    xor rbx, rbx
    xor rdx, rdx

parse_loop:
    cmp rdx, rcx
    je conversion_done
    mov al, [buffer+rdx]
    cmp al, 10
    je conversion_done
    cmp al, '0'
    jb invalid_input
    cmp al, '9'
    ja invalid_input
    sub al, '0'
    imul rbx, rbx, 10
    add rbx, rax
    inc rdx
    jmp parse_loop

conversion_done:
    test rbx, 1
    jnz odd_number

even_number:
    mov rax, 60
    xor rdi, rdi
    syscall

odd_number:
    mov rax, 60
    mov rdi, 1
    syscall

invalid_input:
    mov rax, 60
    mov rdi, 2
    syscall
