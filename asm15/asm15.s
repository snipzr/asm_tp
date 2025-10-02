section .bss
    tampon resb 5



section .data
    magic db 0x7f, "ELF"


section .text
    global _start




_start:
    cmp byte [rsp], 2
    jne fin_ko

    mov rax, 2
    mov rdi, [rsp+16]
    xor rsi, rsi
    syscall


    cmp rax, 0
    jl fin_ko
    mov r12, rax

    mov rax, 0
    mov rdi, r12
    mov rsi, tampon
    mov rdx, 5
    syscall

    mov rax, 3
    mov rdi, r12
    syscall

    mov rsi, tampon
    mov rdi, magic
    mov rcx, 4
    repe cmpsb
    jne fin_ko

    cmp byte [tampon+4], 2
    jne fin_ko




fin_ok:
    mov rax, 60
    xor rdi, rdi
    syscall




fin_ko:
    mov rax, 60
    mov rdi, 1
    syscall
