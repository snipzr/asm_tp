section .bss
    zone resb 1024

section .data
    saut db 10

section .text
    global _start



_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, zone
    mov rdx, 1024
    syscall

    mov r12, rax
    dec r12

    mov rsi, zone
    mov rdi, zone
    add rdi, r12
    dec rdi




loop_rev:
    cmp rsi, rdi
    jge fin_rev

    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al

    inc rsi
    dec rdi
    jmp loop_rev



fin_rev:
    mov rax, 1
    mov rdi, 1
    mov rsi, zone
    mov rdx, r12
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, saut
    mov rdx, 1
    syscall


bye:
    mov rax, 60
    xor rdi, rdi
    syscall
