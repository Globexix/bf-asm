# bf-asm

A brainfuck interpreter, JIT compiler, and AOT compiler written in x86-64 assembly (Linux).

## Usage

```bash
# Interpreter
./main -i program.bf

# JIT compiler
./main -j program.bf

# AOT compiler (emits a standalone ELF binary)
./main -a program.bf        # outputs a.out
./main -a program.bf output # outputs to custom file
```

## Building

```bash
make
```

## Execution modes

| Flag | Mode | Description |
|---|---|---|
| `-i` | Interpreter | Executes brainfuck directly |
| `-j` | JIT | Compiles to x86-64 and runs immediately |
| `-a` | AOT | Emits a standalone ELF64 executable |

## Supported instructions

| Instruction | Description |
|---|---|
| `+` | Increment current cell |
| `-` | Decrement current cell |
| `>` | Move pointer right |
| `<` | Move pointer left |
| `.` | Output current cell as ASCII |
| `,` | Read one byte from stdin |
| `[` | Jump forward if current cell is zero |
| `]` | Jump back if current cell is nonzero |
