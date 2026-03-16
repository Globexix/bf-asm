# hex-lookup reference
# as -o opcodes.o opcodes.s && objdump -d ops.o -M intel
.intel_syntax noprefix
inc rdi               # >
dec rdi               # <
inc byte ptr [rdi]    # +
dec byte ptr [rdi]    # -
