all: cmp

cmp.o: cmp.asm
	nasm -f elf64 cmp.asm
	
cmp: cmp.o
	ld -s -o cmp cmp.o
