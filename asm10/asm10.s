section .bss
    buffer  resb 64

section .text
    global _start



_start:
    mov     rbx, rsp
    cmp     qword [rbx], 4
    jb      bad_exit

    mov     rsi, [rbx+16]
    call    str_to_num
    mov     r12, rax

    mov     rsi, [rbx+24]
    call    str_to_num
    cmp     rax, r12
    cmovg   r12, rax

    mov     rsi, [rbx+32]
    call    str_to_num
    cmp     rax, r12
    cmovg   r12, rax

    mov     rax, r12
    lea     rsi, [rel buffer]
    call    num_to_str

    mov     rax, 1
    mov     rdi, 1
    syscall

    mov     rax, 60
    xor     rdi, rdi
    syscall



bad_exit:
    mov     rax, 60
    mov     rdi, 1
    syscall




str_to_num:
    xor     rax, rax
    mov     r8d, 1
    mov     dl, byte [rsi]
    cmp     dl, '-'
    jne     .plus_chk
    mov     r8d, -1
    inc     rsi
    jmp     .loop
.plus_chk:
    cmp     dl, '+'
    jne     .loop
    inc     rsi
.loop:
    movzx   r9d, byte [rsi]
    test    r9d, r9d
    je      .done
    sub     r9d, '0'
    imul    rax, rax, 10
    add     rax, r9
    inc     rsi
    jmp     .loop
.done:
    cmp     r8d, 1
    je      .out
    neg     rax
.out:
    ret



num_to_str:
    mov     rdi, rsi
    add     rdi, 64
    xor     rcx, rcx
    xor     r9d, r9d
    test    rax, rax
    jns     .loop2
    neg     rax
    mov     r9d, 1
.loop2:
    xor     rdx, rdx
    mov     r8, 10
    div     r8
    dec     rdi
    add     dl, '0'
    mov     [rdi], dl
    inc     rcx
    test    rax, rax
    jnz     .loop2
    test    r9d, r9d
    jz      .end
    dec     rdi
    mov     byte [rdi], '-'
    inc     rcx
.end:
    mov     byte [rdi+rcx], 10
    inc     rcx
    mov     rsi, rdi
    mov     rdx, rcx
    ret
