section .bss
    rbuf    resb 1024
    pfd     resb 8         


section .data
    srvaddr:
        dw 2
        db 0x10,0x92
        db 127,0,0,1
        times 8 db 0

    pingmsg db "ping",10
    pinglen equ $ - pingmsg

    prefix  db 'message: "',0
    prelen  equ $ - prefix
    suffix  db '"',10
    sufllen equ $ - suffix

    to_msg  db 'Timeout: no response from server',10
    to_len  equ $ - to_msg



section .text
    global _start


_start:
    mov     rax, 41
    mov     rdi, 2
    mov     rsi, 2
    xor     rdx, rdx
    syscall
    mov     r12, rax

    mov     rax, 44
    mov     rdi, r12
    lea     rsi, [rel pingmsg]
    mov     rdx, pinglen
    xor     r10, r10
    lea     r8,  [rel srvaddr]
    mov     r9d, 16
    syscall

    mov     dword [pfd+0], r12d
    mov     word  [pfd+4], 1
    mov     word  [pfd+6], 0

    mov     rax, 7
    lea     rdi, [rel pfd]
    mov     rsi, 1
    mov     rdx, 2000
    syscall
    cmp     rax, 0
    jle     no_reply


    mov     rax, 45
    mov     rdi, r12
    lea     rsi, [rel rbuf]
    mov     rdx, 1024
    xor     r10, r10
    xor     r8,  r8
    xor     r9,  r9
    syscall
    mov     r13, rax
    test    r13, r13
    jle     no_reply


    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [rel prefix]
    mov     rdx, prelen
    syscall

    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [rel rbuf]
    mov     rdx, r13
    syscall

    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [rel suffix]
    mov     rdx, sufllen
    syscall


    mov     rax, 3
    mov     rdi, r12
    syscall

    mov     rax, 60
    xor     rdi, rdi
    syscall



no_reply:
    ; message de timeout, close + exit(1)
    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [rel to_msg]
    mov     rdx, to_len
    syscall

    mov     rax, 3
    mov     rdi, r12
    syscall

    mov     rax, 60
    mov     rdi, 1
    syscall
