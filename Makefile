AS = as
LD = ld

OBJS = main.o \
    	interpreter/interpreter.o \
        jit/jit.o \
        aot/aot.o \
        aot/elf_data.o

TARGET = main

all: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) $(OBJS) -o $@

main.o: main.s
	$(AS) -o main.o main.s

interpreter/interpreter.o: interpreter/interpreter.s
	$(AS) -o interpreter/interpreter.o interpreter/interpreter.s

jit/jit.o: jit/jit.s
	$(AS) -o jit/jit.o jit/jit.s

aot/aot.o: aot/aot.s
	$(AS) -o aot/aot.o aot/aot.s

aot/elf_data.o: aot/elf_data.s
	$(AS) -o aot/elf_data.o aot/elf_data.s

clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: all clean