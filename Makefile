all: test

test.o: test.asm
	nasm -f elf64 test.asm
	
test: test.o
	ld -s -o test test.o
