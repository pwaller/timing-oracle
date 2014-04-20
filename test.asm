section .data

_time_upper:
     times 8 db 0
_time_lower:
     times 8 db 0

_buffer:
     times 128 db 0

_hello_world:
     db 'hello world.', 0
_newline:
     db 10

section .text
global _start

%assign SYS_WRITE 1
%assign SYS_EXIT 60
%assign SYS_GETTIMEOFDAY 96

%assign STDOUT_FD 1

_start:
    ; db 0xcc
    ; mov rax, _newline

    ; xor r9, r9
    mov rax, [rsp+16]
    mov bl, [rax]
    movzx rbx, bl
    mov r9, rbx

    mov rax, _buffer
    mov [rax], byte bl

    mov rbx, 1
    call print_cstring


    mov rsi, 0
    mov rdi, _time_upper
    mov rax, SYS_GETTIMEOFDAY
    syscall
    mov r15, qword [_time_lower]
    mov r14, qword [_time_upper]

    call read_timestamp
    push rax

    xor rax, rax
    mov rdx, 0x1000000
    
_loop:
    cmp rax, r9
    dec rdx
    jnz _loop

_done:
    call read_timestamp
    push rax

    mov rsi, 0
    mov rdi, _time_upper
    mov rax, SYS_GETTIMEOFDAY
    syscall
    mov r13, qword [_time_lower]
    mov r12, qword [_time_upper]

    ; elapsed = end - start
    sub r13, r15
    jnc _next_word
    ; There was a carry, so we've wrapped around.
    ; Add 1e6 to make everything right.
    add r13, 1000000
    stc ; set carry
_next_word:
    sbb r12, r14

    ;https://en.wikipedia.org/wiki/Carry_flag#Carry_flag_vs._Borrow_flag

    ; _no_carry:

    mov rdi, r12
    mov rsi, _buffer + 16
    call itoa

    mov byte [rax+1], '.'

    mov rbx, 0
    ; mov rbx, 1
    call print_cstring

    mov rax, r13
    call print_number

    call read_timestamp
    call print_number

    call read_timestamp
    call print_number

    pop rax
    pop rbx
    sub rax, rbx
    call print_number


_exit:
    mov rax, SYS_EXIT
    syscall 

; returns current timestamp counter in rax
read_timestamp:
    rdtsc
    shl rdx, 32
    or rax, rdx
    ret

; prints the number at rax
print_number:
    mov rdi, rax
    mov rsi, _buffer + 16
    call itoa

    mov rbx, 1
    call print_cstring
    ret


strlen:
    push r8
    mov r8, rax
    xor rax, rax
    dec rax

_find_null:
    inc rax
    cmp byte [r8+rax], 0
    jne _find_null

    pop r8
    ret

; input
;   rax: address of string
;   rbx: whether to print a newline
print_cstring:
    mov r8, rax

    call strlen

    mov rdx, rax
    mov rsi, r8
    mov rdi, STDOUT_FD
    mov rax, SYS_WRITE
    syscall
    
    cmp rbx, 0
    je _no_newline

    mov rdx, 1 
    mov rsi, _newline
    mov rdi, STDOUT_FD 
    mov rax, SYS_WRITE 
    syscall

_no_newline:
    ret

; input
;   rdi: integer
;   rsi: address of *last* byte in input buffer
; returns:
;   rax: address of *first* byte of target string 
itoa:
    mov byte [rsi], 0
    mov r9, 0
    cmp rdi, 0
    jge _input_positive
    ; neg rdi
    ; mov r9, 1

_input_positive:
    mov rax, rdi
    mov r8, 10

_next_digit:
    xor rdx, rdx
    div r8
    dec rsi
    add dl, 0x30
    mov byte [rsi], dl

    cmp rax, 0
    jne _next_digit

    cmp r9, 1
    jne _itoa_done
    dec rsi
    ; It's negative, insert a '-'
    mov byte [rsi], 0x2d

_itoa_done:
    ; return the first address of string
    mov rax, rsi
    ret

