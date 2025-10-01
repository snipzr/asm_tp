section .bss
    zone resb 1024

section .text
    global _start



_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, zone
    mov rdx, 1024
    syscall

    mov r12, rax
    test r12, r12
    jz fin_ok
    
    dec r12
nettoie_fin:
    cmp r12, 0
    jl fin_ok
    mov al, [zone+r12]
    cmp al, 10
    je saute_caract
    cmp al, 13
    je saute_caract
    jmp verif_init
saute_caract:
    dec r12
    jmp nettoie_fin



verif_init:
    mov rsi, zone
    mov rdi, zone
    add rdi, r12




boucle_verif:
    cmp rsi, rdi
    jge fin_ok

    mov al, [rsi]
    mov bl, [rdi]
    cmp al, bl
    jne fin_ko

    inc rsi
    dec rdi
    jmp boucle_verif

fin_ok:
    mov rax, 60
    xor rdi, rdi
    syscall



fin_ko:
    mov rax, 60
    mov rdi, 1
    syscall
