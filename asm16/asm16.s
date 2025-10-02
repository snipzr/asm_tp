section .bss
    zone resb 16384



section .data
    cible db "1337"
    remplace db "H4CK"


section .text
    global _start


_start:
    cmp byte [rsp], 2
    jne fin_ko

    mov rax, 2
    mov rdi, [rsp+16]
    mov rsi, 2
    syscall
    cmp rax, 0
    jl fin_ko
    mov r12, rax

    mov rax, 0
    mov rdi, r12
    mov rsi, zone
    mov rdx, 16384
    syscall
    mov r13, rax

    mov rdi, zone
    mov rsi, cible
    mov rcx, r13
    mov rdx, 4
    call recherche_chaine

    cmp rax, 0
    je fermeture

    mov rdi, rax
    mov rsi, remplace
    mov rcx, 4
    rep movsb

    mov rax, 8
    mov rdi, r12
    xor rsi, rsi
    xor rdx, rdx
    syscall

    mov rax, 1
    mov rdi, r12
    mov rsi, zone
    mov rdx, r13
    syscall


fermeture:
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



recherche_chaine:
    sub rcx, rdx
    inc rcx
boucle_externe:
    test rcx, rcx
    jz non_trouve

    push rdi
    push rsi
    push rcx
    mov rcx, rdx
    repe cmpsb
    pop rcx
    pop rsi
    pop rdi
    je trouve

    inc rdi
    dec rcx
    jmp boucle_externe



trouve:
    mov rax, rdi
    ret



non_trouve:
    xor rax, rax
    ret
