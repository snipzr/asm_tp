section .bss
    outbuf  resb 64

section .text
    global _start

_start:
    mov     rbx, rsp
    mov     rsi, [rbx+16]
    call    str_to_int
    mov     r12, rax

    mov     rsi, [rbx+24]
    call    str_to_int
    add     rax, r12

    lea     rsi, [rel outbuf]
    call    int_to_str_nl

    mov     rax, 1
    mov     rdi, 1
    syscall

    mov     rax, 60
    xor     rdi, rdi
    syscall

str_to_int:
    xor     rax, rax
    xor     rcx, rcx
.s_loop:
    movzx   rdx, byte [rsi+rcx]
    test    rdx, rdx
    je      .s_done
    sub     rdx, '0'
    imul    rax, rax, 10
    add     rax, rdx
    inc     rcx
    jmp     .s_loop
.s_done:
    ret

int_to_str_nl:
    mov     rdi, rsi
    add     rdi, 64
    xor     rcx, rcx
.i_loop:
    xor     rdx, rdx
    mov     r8, 10
    div     r8
    dec     rdi
    add     dl, '0'
    mov     [rdi], dl
    inc     rcx
    test    rax, rax
    jnz     .i_loop
    mov     byte [rdi+rcx], 10
    inc     rcx
    mov     rsi, rdi
    mov     rdx, rcx
    ret
    