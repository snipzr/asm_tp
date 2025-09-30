section .bss
    outbuf  resb 128

section .text
    global _start





_start:
    mov     rbx, rsp
    cmp     qword [rbx], 2
    jb      exit_error

    mov     rsi, [rbx+16]
    mov     al, byte [rsi]
    cmp     al, '-'
    jne     .no_flag

    mov     rsi, [rbx+24]
    call    str_to_int
    lea     rsi, [rel outbuf]
    call    to_binary
    jmp     print_and_exit

.no_flag:
    call    str_to_int
    lea     rsi, [rel outbuf]
    call    to_hex

print_and_exit:
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
    mov     rsi, [rbx+16]
    mov     al, byte [rsi]
    cmp     al, '-'
    jne     .skip_flag
    mov     rsi, [rbx+24]
.skip_flag:
    xor     rax, rax
.loop:
    movzx   rdx, byte [rsi]
    test    rdx, rdx
    je      .done
    sub     rdx, '0'
    imul    rax, rax, 10
    add     rax, rdx
    inc     rsi
    jmp     .loop
.done:
    ret





to_hex:
    mov     rdi, rsi
    add     rdi, 128
    xor     rcx, rcx
.loop_h:
    xor     rdx, rdx
    mov     r8, 16
    div     r8
    dec     rdi
    cmp     dl, 9
    jg      .letter
    add     dl, '0'
    jmp     .store
.letter:
    add     dl, 'A'-10
.store:
    mov     [rdi], dl
    inc     rcx
    test    rax, rax
    jnz     .loop_h
    mov     byte [rdi+rcx], 10
    inc     rcx
    mov     rsi, rdi
    mov     rdx, rcx
    ret

to_binary:
    mov     rdi, rsi
    add     rdi, 128
    xor     rcx, rcx
.loop_b:
    xor     rdx, rdx
    mov     r8, 2
    div     r8
    dec     rdi
    add     dl, '0'
    mov     [rdi], dl
    inc     rcx
    test    rax, rax
    jnz     .loop_b
    mov     byte [rdi+rcx], 10
    inc     rcx
    mov     rsi, rdi
    mov     rdx, rcx
    ret
