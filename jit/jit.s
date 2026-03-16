.intel_syntax noprefix
.global _start

.section .bss
    buffer: .skip 30000
    code_buf: .skip 65536
    jit_base: .skip 8
    jit_ptr: .skip 8

.section .text
_start: 
    # check argc >= 2
    mov rax, [rsp]
    cmp rax, 2
    jl .exit_error

    # sys open
    mov rdi, [rsp + 16]
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
    mov [jit_ptr], rax

    # code pointer
    lea rsi, [code_buf]
    # value pointer
    lea rdi, [buffer]

.interpreter_loop:
    mov al, [rsi]
    # exit if reached null terminator
    cmp al, 0
    je .exit

    cmp al, '+'
    je .increment

    cmp al, '-'
    je .decrement

    cmp al, '>'
    je .inc_pointer

    cmp al, '<'
    je .dec_pointer

    cmp al, '.'
    je .print_value

    cmp al, ','
    je .read_input

    inc rsi
    jmp .interpreter_loop

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall

.exit_error:
    mov rax, 60
    mov rdi, 1
    syscall

.increment:
    inc rsi
    inc byte ptr [rdi]
    jmp .interpreter_loop

.decrement:
    inc rsi
    dec byte ptr [rdi]
    jmp .interpreter_loop

.inc_pointer:
    inc rsi
    inc rdi
    jmp .interpreter_loop

.dec_pointer:
    inc rsi
    dec rdi 
    jmp .interpreter_loop

.print_value: 
    push rsi
    push rdi
    push rcx

    mov rax, 1
    lea rsi, [rdi]
    mov rdi, 1
    mov rdx, 1
    syscall

    pop rcx
    pop rdi
    pop rsi
    
    inc rsi
    jmp .interpreter_loop

.read_input:
    push rsi
    push rdi
    push rcx

    mov rsi, rdi
    mov rax, 0
    mov rdi, 0
    mov rdx, 1
    syscall

    pop rcx
    pop rdi
    pop rsi

    inc rsi
    jmp .interpreter_loop
