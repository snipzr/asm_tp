section .bss
    buffer resb 32

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 32
    syscall
    mov rcx, rax
    xor rbx, rbx
    xor rdx, rdx
    mov r8, 0

parse_loop:
    cmp rdx, rcx
    je conversion_done
    mov al, [buffer+rdx]
    cmp al, 10
    je conversion_done
    cmp rdx, 0
    jne not_first_char
    cmp al, '-'
    jne not_first_char
    mov r8, 1
    inc rdx
    jmp parse_loop

not_first_char:
    cmp al, '0'
    jb invalid_input
    cmp al, '9'
    ja invalid_input
    sub al, '0'
    movzx rax, al
    imul rbx, rbx, 10
    add rbx, rax
    cmp rbx, 0x7FFFFFFF
    jg invalid_input
    inc rdx
    jmp parse_loop

conversion_done:
    cmp r8, 0
    je check_parity
    neg rbx

check_parity:
    test rbx, 1
    jz even_number

odd_number:
    mov rax, 60
    mov rdi, 1
    syscall

even_number:
    mov rax, 60
    xor rdi, rdi
    syscall

invalid_input:
    mov rax, 60
    mov rdi, 2
    syscall
