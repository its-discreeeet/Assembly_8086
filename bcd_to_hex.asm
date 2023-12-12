%macro op 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .bss
    num resb 6

section .data
    digit db 0
    count db 4
    temp dw 0
    msg1 db "Enter a valid BCD number", 10
    msg1len equ $ - msg1
    msg2 db "Hex equivalent number", 10
    msg2len equ $ - msg2

section .text
    global _start

_start:
    ; Display prompt for entering BCD number
    op 1, 1, msg1, msg1len

    ; Read input BCD number from the user
    op 0, 0, num, 6
    mov rsi, num

    ; Initialize variables
    mov cx, 0ah ; Multiplier for BCD conversion [multiplying with 10 cuz when we multiply, it shifts the digit to the left by 1 pos]
    mov bx, 0   ; Sum of BCD digits  [accumulates the sum of bcd digits multiplied by 10]
    mov ax, 0   ; Resulting hex number

up:
    ; Load a BCD digit from memory
    mov bl, [rsi]

    
    cmp bl, 0ah		;comparing with 10 as carry might be generated and we dont to add 30h in it then
    je skip

    ; Convert ASCII to integer and update the sum
    sub bl, 30H
    mul cx
    add ax, bx    ;this sum represents the converted hexadecimal value so far.

    ; Move to the next BCD digit
    inc rsi
    jmp up

skip:
    ; Display the hex equivalent number
    call disp

    ; Exit the program
    op 60, 0, 0, 0

disp:
    ; Save the result for later use
    mov [temp], ax

    ; Display the message for hex equivalent
    op 1, 1, msg2, msg2len

    ; Load the result back into ax
    mov ax, [temp]

nextdigit:
    ; Rotate ax to get the next nibble
    rol ax, 4

    ; Save the result for display
    mov [temp], ax

    ; Extract the lower 4 bits
    and ax, 000FH

    ; Check if the digit is 9 or less
    cmp al, 09H
    jbe down

    ; Adjust the ASCII value for A-F
    add al, 07H

down:
    ; Convert to ASCII and display the digit
    add al, 30H
    mov [digit], al
    op 1, 1, digit, 1

    ; Load the result back into ax
    mov ax, [temp]

    ; Decrease the counter
    dec byte [count]

    ; Repeat for the next digit if needed
    jnz nextdigit

    ; Return to the caller
    ret
