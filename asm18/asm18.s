section .bss
    rbuf    resb 1024


section .data
    srvaddr:
        dw 2
        db 0x10,0x92
        db 127,0,0,1
        times 8 db 0

    tv:     dq 2
            dq 0

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

    mov     rax, 54
    mov     rdi, r12
    mov     rsi, 1
    mov     rdx, 20
    lea     r10, [rel tv]
    mov     r8, 16
    syscall

    mov     rax, 44
    mov     rdi, r12
    lea     rsi, [rel pingmsg]
    mov     rdx, pinglen
    xor     r10, r10
    lea     r8,  [rel srvaddr]
    mov     r9d, 16
    syscall

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
    js      .timeout

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


.timeout:
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

    
