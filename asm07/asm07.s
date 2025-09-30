section .bss
    inbuf   resb 64

section .text
    global _start


_start:
    mov     rax, 0
    mov     rdi, 0
    mov     rsi, inbuf
    mov     rdx, 64
    syscall

    mov     rsi, inbuf
    xor     rax, rax
    xor     r8d, r8d
.parse:
    movzx   r9d, byte [rsi]
    cmp     r9d, 10
    je      .parsed
    test    r9d, r9d
    je      .parsed
    cmp     r9d, '0'
    jb      exit_nonprime
    cmp     r9d, '9'
    ja      exit_nonprime
    imul    rax, rax, 10
    sub     r9d, '0'
    add     rax, r9
    inc     rsi
    mov     r8d, 1
    jmp     .parse





.parsed:
    test    r8d, r8d
    jz      exit_nonprime

    cmp     rax, 2
    jb      exit_nonprime
    je      exit_prime
    test    rax, 1
    jz      exit_nonprime

    mov     rdi, 3
.loop:
    mov     rbx, rdi
    imul    rbx, rbx
    cmp     rbx, rax
    ja      exit_prime
    xor     rdx, rdx
    mov     rbx, rdi
    div     rbx
    test    rdx, rdx
    jz      exit_nonprime
    add     rdi, 2
    jmp     .loop



exit_prime:
    mov     rax, 60
    xor     rdi, rdi
    syscall




exit_nonprime:
    mov     rax, 60
    mov     rdi, 1
    syscall
