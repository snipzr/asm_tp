section .data
    success_msg db "1337", 10
    success_len equ $ - success_msg

section .text
    global _start

_start:
    mov rbx, rsp
    mov rax, [rbx]
    cmp rax, 2
    jne terminate_error

    mov rsi, [rbx+16]
    mov al, byte [rsi]
    cmp al, '4'
    jne terminate_error
    mov al, byte [rsi+1]
    cmp al, '2'
    jne terminate_error
    mov al, byte [rsi+2]
    cmp al, 0
    jne terminate_error

print_and_exit:
    mov rax, 1
    mov rdi, 1
    mov rdx, success_len
    mov rsi, success_msg
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

terminate_error:
    mov rax, 60
    mov rdi, 1
    syscall
