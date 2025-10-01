section .bss
    inbuf   resb 256
    outbuf  resb 32



section .text
    global _start



_start:
    mov     rax, 0
    mov     rdi, 0
    mov     rsi, inbuf
    mov     rdx, 256
    syscall

    xor     r8d, r8d
    xor     rcx, rcx

.count_loop:
    cmp     rcx, rax
    jge     .done_count
    movzx   edx, byte [inbuf + rcx]
    cmp     edx, 10
    je      .done_count
    cmp     dl, 'a'     ; a
    je      .inc
    cmp     dl, 'e'
    je      .inc
    cmp     dl, 'i'
    je      .inc
    cmp     dl, 'o'
    je      .inc
    cmp     dl, 'u'
    je      .inc
    cmp     dl, 'A'
    je      .inc
    cmp     dl, 'E'
    je      .inc
    cmp     dl, 'I'
    je      .inc
    cmp     dl, 'O'
    je      .inc
    cmp     dl, 'U'
    jne     .next
.inc:
    inc     r8
.next:
    inc     rcx
    jmp     .count_loop
.done_count:
    mov     rax, r8
    lea     rsi, [rel outbuf]
    call    u64_to_str_nl

    mov     rax, 1
    mov     rdi, 1
    syscall


    mov     rax, 60
    xor     rdi, rdi
    syscall



u64_to_str_nl:
    mov     rdi, rsi
    add     rdi, 32
    xor     rcx, rcx
    test    rax, rax
    jnz     .loop
    dec     rdi
    mov     byte [rdi], '0'
    mov     rcx, 1
    jmp     .finish
.loop:
    xor     rdx, rdx
    mov     r8, 10
    div     r8
    dec     rdi
    add     dl, '0'
    mov     [rdi], dl
    inc     rcx
    test    rax, rax
    jnz     .loop
.finish:
    mov     byte [rdi+rcx], 10
    inc     rcx
    mov     rsi, rdi
    mov     rdx, rcx
    ret
