section .bss
    zone resb 1024

section .data
    saut db 10


section .text
    global _start


_start:
    cmp byte [rsp], 2
    jne fin_ko

    mov rsi, [rsp+16]
    call vers_entier
    mov r12, rax

    mov rax, 0
    mov rdi, 0
    mov rsi, zone
    mov rdx, 1024
    syscall
    mov r13, rax


    mov r14, zone
    lea r15, [zone + r13]
boucle_chiffre:
    cmp r14, r15
    jge fin_chiffre

    movzx rax, byte [r14]


    cmp al, 'a'
    jl verif_maj
    cmp al, 'z'
    jg verif_maj

    add al, r12b
    cmp al, 'z'
    jle ecrit_char
    sub al, 26
    jmp ecrit_char



verif_maj:
    cmp al, 'A'
    jl suivant
    cmp al, 'Z'
    jg suivant

    add al, r12b
    cmp al, 'Z'
    jle ecrit_char
    sub al, 26

ecrit_char:
    mov [r14], al



suivant:
    inc r14
    jmp boucle_chiffre

fin_chiffre:
    mov rax, 1
    mov rdi, 1
    mov rsi, zone
    mov rdx, r13
    syscall





fin_ok:
    mov rax, 60
    xor rdi, rdi
    syscall


fin_ko:
    mov rax, 60
    mov rdi, 1
    syscall


vers_entier:
    xor rax, rax
    xor rbx, rbx
conv_loop:
    mov bl, [rsi]
    cmp bl, 0
    je conv_done
    sub bl, '0'
    imul rax, 10
    add rax, rbx
    inc rsi
    jmp conv_loop

    
conv_done:
    ret
