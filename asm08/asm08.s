section .bss
    outbuf  resb 64

section .text
    global _start

_start:
    mov     rbx, rsp
    cmp     qword [rbx], 2
    jb      exit_error

    mov     rsi, [rbx+16]
    call    str_to_int
    mov     rdi, rax

    xor     rax, rax
    mov     rcx, 1
.sum_loop:
    cmp     rcx, rdi
    jge     .done
    add     rax, rcx
    inc     rcx
    jmp     .sum_loop
.done:
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
    xor     rcx, rcx
.loop:
    movzx   rdx, byte [rsi+rcx]
    test    rdx, rdx
    je      .done
    sub     rdx, '0'
    imul    rax, rax, 10
    add     rax, rdx
    inc     rcx
    jmp     .loop
.done:
    ret

int_to_str_nl:
    mov     rdi, rsi
    add     rdi, 64
    xor     rcx, rcx
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
    mov     byte [rdi+rcx], 10
    inc     rcx
    mov     rsi, rdi
    mov     rdx, rcx
    ret
