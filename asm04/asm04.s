section .bss
    buffer resb 8

section .text
    global _start

_start:
    mov     rax, 0
    mov     rdi, 0
    mov     rsi, buffer
    mov     rdx, 8
    syscall

    mov     al, byte [buffer]
    sub     al, '0'
    movzx   rbx, al

    test    bl, 1
    jnz     odd_number

even_number:
    mov     rax, 60
    xor     rdi, rdi
    syscall

odd_number:
    mov     rax, 60
    mov     rdi, 1
    syscall
