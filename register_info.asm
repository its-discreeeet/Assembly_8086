%macro op 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .data
    msg1 db "Base Address: ", 10
    msgl1 equ $-msg1

    msg2 db "Offset: ", 10
    msgl2 equ $-msg2

    msg3 db "Global Descriptor Table Register", 10
    msgl3 equ $-msg3

    msg4 db "Interrupt Descriptor Table Register", 10
    msgl4 equ $-msg4

    msg5 db "Local Descriptor Table Register", 10
    msgl5 equ $-msg5

    msg6 db "Task Register", 10
    msgl6 equ $-msg6

    msg7 db "Machine Status Word", 10
    msgl7 equ $-msg7

    newl db 10

section .bss
    gdtr resq 1
    gdtlimit resw 1
    idtr resq 1
    idtlimit resw 1
    ldtr resw 1
    tr resw 1
    msw resw 1
    temp64 resq 1
    temp16 resw 1
    asc resb 1

section .text
    global _start

_start:
  	

    op 1, 1, newl, 1		;display newline character
    op 1, 1, msg2, msgl2	
    mov rsi, gdtlimit
    mov rax, [rsi]
    call display16		;calls the display16 procedure to convert and display the GDT limit in a readable format.
    op 1, 1, newl, 1

    op 1, 1, msg4, msgl4
    op 1, 1, newl, 1
    op 1, 1, msg1, msgl1
    mov rsi, idtr
    sidt [rsi]
    mov rax, [rsi]
    call display64

    op 1, 1, newl, 1
    op 1, 1, msg2, msgl2
    mov rsi, idtlimit
    mov rax, [rsi]
    call display16
    op 1, 1, newl, 1

    op 1, 1, msg5, msgl5
    op 1, 1, newl, 1
    op 1, 1, msg1, msgl1
    mov rsi, ldtr
    sldt [rsi]
    mov rax, [rsi]
    call display16
    op 1, 1, newl, 1

    op 1, 1, msg6, msgl6
    op 1, 1, newl, 1
    op 1, 1, msg1, msgl1
    mov rsi, tr
    str [rsi]
    mov rax, [rsi]
    call display16

    op 1, 1, newl, 1

    op 1, 1, msg7, msgl7
    op 1, 1, newl, 1
    op 1, 1, msg1, msgl1
    mov rsi, msw
    smsw [rsi]
    mov rax, [rsi]
    call display64
    op 1, 1, newl, 1

    op 60, 0, 0, 0

display64:
    mov bp, 16			;loop counter
again1:
    rol rax, 4
    mov [temp64], rax
    and rax, 0FH
    cmp rax, 09H
    jbe skip64
    add al, 07H
skip64:
    add al, 30H
    mov [asc], al
    op 1, 1, asc, 1

    mov rax, [temp64]
    dec bp
    jnz again1
    ret

display16:
    mov bp, 4
again2:
    rol rax, 4
    mov [temp16], rax
    and rax, 0FH
    cmp rax, 09H
    jbe skip16
    add al, 07H
skip16:
    add al, 30H
    mov [asc], al
    op 1, 1, asc, 1
    mov rax, [temp16]
    dec bp
    jnz again2
    ret
