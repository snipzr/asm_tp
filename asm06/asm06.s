section .bss
    outbuf  resb 64

section .text
    global _start

_start:
    mov     rbx, rsp
    cmp     qword [rbx], 3
    jb      exit_error

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

exit_error:
    mov     rax, 60
    mov     rdi, 1
    syscall

str_to_int:
    xor     rax, rax
    mov     rdx, [rsi]
    mov     dl, byte [rsi]
    mov     r8d, 1
    cmp     dl, '-'
    jne     .check_plus
    mov     r8d, -1
    inc     rsi
    jmp     .loop
.check_plus:
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
    je      .ret
    neg     rax
.ret:
    ret

int_to_str_nl:
    mov     rdi, rsi
    add     rdi, 64
    xor     rcx, rcx
    xor     r9d, r9d
    test    rax, rax
    jns     .conv
    neg     rax
    mov     r9d, 1
.conv:
    xor     rdx, rdx
    mov     r8, 10
    div     r8
    dec     rdi
    add     dl, '0'
    mov     [rdi], dl
    inc     rcx
    test    rax, rax
    jnz     .conv
    test    r9d, r9d
    jz      .finish
    dec     rdi
    mov     byte [rdi], '-'
    inc     rcx
.finish:
    mov     byte [rdi+rcx], 10
    inc     rcx
    mov     rsi, rdi
    mov     rdx, rcx
    ret
