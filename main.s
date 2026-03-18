.intel_syntax noprefix
.global _start
.extern bf_interpreter
.extern bf_jit

.section .bss
    buffer: .skip 30000
    code_buf: .skip 65536
    jit_base: .skip 8

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
    # -j: jit
    cmp word ptr [rsi], 0x6A2D
    je .call_jit

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall

.call_interpreter:
    mov rdi, [rsp + 24]
    call .load_file

    call bf_interpreter
    test rax, rax
    jnz .exit_engine_error

    jmp .exit

.call_jit:
    mov rdi, [rsp + 24]
    call .load_file

    # allocate RWX memory
    mov rax, 9
    mov rdi, 0
    mov rsi, 65536
    mov rdx, 7
    mov r10, 0x22
    mov r8, -1
    mov r9, 0
    syscall

    cmp rax, 0
    jl .exit_error

    mov [jit_base], rax
    # code pointer
    lea rsi, [code_buf]
    # value pointer
    lea rdi, [buffer]
    # jit pointer
    mov r12, rax
    
    mov r13, [jit_base]
    
    call bf_jit
    test rax, rax
    jnz .exit_engine_error

    jmp .exit

.load_file:
    # sys open
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

    ret


.exit_error:
    mov rax, 60
    mov rdi, 2
    syscall

.exit_engine_error:
    mov rdi, rax
    mov rax, 60
    syscall
    