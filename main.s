.intel_syntax noprefix
.global _start
.extern bf_interpreter

.section .bss
    buffer: .skip 30000
    code_buf: .skip 65536

.section .text
_start: 
    # check argc >= 3
    mov rax, [rsp]
    cmp rax, 3
    jl .exit_error

    mov rsi, [rsp + 16]
    # -i: interpreter
    cmp word ptr [rsi], 0x692d
    je .call_interpreter

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall

.call_interpreter:
    # sys open
    mov rdi, [rsp + 24]
    mov rax, 2
    xor rsi, rsi
    xor rdx, rdx
    syscall

    cmp rax, 0
    jl .exit_error
    # save fd
    mov r8, rax

    # sys read
    mov rdi, r8 # fd
    mov rax, 0
    lea rsi, [code_buf]
    mov rdx, 65536
    syscall

    # sys close
    mov rdi, r8 # fd
    mov rax, 3
    syscall


    # code pointer
    lea rsi, [code_buf]
    # value pointer
    lea rdi, [buffer]

    call bf_interpreter
    test rax, rax
    jnz .exit_engine_error

    jmp .exit


.exit_error:
    mov rax, 60
    mov rdi, 1
    syscall

.exit_engine_error:
    mov rdi, rax
    mov rax, 60
    syscall
    