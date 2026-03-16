.intel_syntax noprefix
.global _start

.section .rodata
    # Hello World!
    code: .ascii "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."
    .byte 0

.section .bss
    buffer: .skip 30000

.section .text
_start: 
    # code pointer
    # load adress of 'code' into rsi
    lea rsi, [code]

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

    inc rsi
    jmp .interpreter_loop

.exit:
    # print buffer to debug with strace ./brainfuck 
    mov rax, 1          
    mov rdi, 1         
    lea rsi, [buffer]
    mov rdx, 30000      
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

.increment:
    inc rsi
    inc byte ptr [rdi]
    jmp .interpreter_loop

.decrement:
    inc rsi
    dec byte ptr [rdi]
    jmp .interpreter_loop
