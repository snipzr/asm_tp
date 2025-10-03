section .data
    expected db "42", 0x0A
    expected_len equ $ - expected

    output db "1337", 0x0A
    output_len equ $ - output

section .bss
    input_buf resb 64

section .text
    global _start


_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, input_buf
    mov rdx, 64
    syscall
    mov rbx, rax


    mov rcx, rbx
    mov rdi, input_buf
find_nl:
    cmp rcx, 0
    je no_newline
    mov al, byte [rdi]
    cmp al, 0x0A
    je truncate
    inc rdi
    dec rcx
    jmp find_nl

truncate:
    mov byte [rdi+1], 0
    mov rbx, rdi
    sub rbx, input_buf
    add rbx, 1



no_newline:
    mov rcx, expected_len
    cmp rbx, rcx
    jne exit_error

    mov rsi, input_buf
    mov rdi, expected
    mov rcx, expected_len
    repe cmpsb
    jne exit_error



print_success:
    mov rax, 1
    mov rdi, 1
    mov rsi, output
    mov rdx, output_len
    syscall

    xor rdi, rdi
    mov rax, 60
    syscall



exit_error:
    mov rdi, 1
    mov rax, 60
    syscall
