section .data
    texte db "Hello Universe!", 10
    taille equ $ - texte

section .text
    global _start

_start:
    cmp byte [rsp], 2
    jne fin_ko

    mov rax, 2
    mov rdi, [rsp+16]
    mov rsi, 65
    mov rdx, 0644o
    syscall

    cmp rax, 0
    jl fin_ko

    mov r12, rax

    mov rax, 1
    mov rdi, r12
    mov rsi, texte
    mov rdx, taille
    syscall

    mov rax, 3
    mov rdi, r12
    syscall

fin_ok:
    mov rax, 60
    xor rdi, rdi
    syscall

fin_ko:
    mov rax, 60
    mov rdi, 1
    syscall
