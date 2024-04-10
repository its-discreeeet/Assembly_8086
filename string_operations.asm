%macro op 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .data
    msg1 db "Enter string 1:", 10
    msg1len equ $-msg1
    msg2 db "Enter string 2:", 10
    msg2len equ $-msg2
    msg3 db "Concatenated string is:"
    msg3len equ $-msg3
    msg4 db "Strings are not equal", 10
    msg4len equ $-msg4
    msg5 db "Strings are equal", 10
    msg5len equ $-msg5

section .bss
    string1 resb 25
    string2 resb 25
    string3 resb 50
    length1 resb 5
    length2 resb 5

section .text
    global _start
    _start:
        op 1, 1, msg1, msg1len
        op 0, 0, string1, 25
        dec rax
        mov [length1], rax
        op 1, 1, msg2, msg2len
        op 0, 0, string2, 25
        dec rax
        mov [length2], rax

        call str_equal
        call concat
        op 60, 0, 0, 0

    concat:
        mov rsi, string1
        mov rdi, string3
    copy1:
        mov AL, [rsi]
        mov [rdi], AL
        inc rsi
        inc rdi
        dec byte [length1]
        jnz copy1

        mov rsi, string2
    copy2:
        mov AL, [rsi]
        mov [rdi], AL
        inc rsi
        inc rdi
        dec byte [length2]
        jnz copy2

        op 1, 1, msg3, msg3len
        op 1, 1, string3, 50
        ret

    str_equal:
        mov rsi, string1
        mov rdi, string2

        mov al, [length1]
        cmp al, [length2]
        jne exit

    compareNext:
        mov al, [rsi]
        cmp al, [rdi]
        je next
        jmp exit

    next:
        inc rsi
        inc rdi
        dec byte [length1]
        jnz compareNext

        op 1, 1, msg5, msg5len
        ret

    exit:
        op 1, 1, msg4, msg4len
