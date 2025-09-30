section .text
    global _start

_start:
    mov rbx, rsp
    mov rax, [rbx]
    cmp rax, 2
    jne exit_error

    mov rsi, [rbx + 16]
    xor rcx, rcx
count_loop:
    cmp byte [rsi + rcx], 0
    je count_done
    inc rcx
    jmp count_loop
count_done:
    mov rax, 1
    mov rdi, 1
    mov rdx, rcx
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall
