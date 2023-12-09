section .data
    arr     db 1h, 3h, 6h     ; Array of hexadecimal values
    temp    dw 0              ; Temporary storage for rotated value
    num     db 0              ; Storage for ASCII representation of the sum
    count   db 4              ; Counter for the loop

section .text
    global _start

_start:
    mov al, 0      ; Initialize carry for addition
    mov ah, 0      ; Initialize sum
    mov cl, 5      ; Set counter
    mov rsi, arr   ; Set pointer to the array

up:
    add al, [rsi]  ; Add the value at the memory location pointed to by rsi to al
    jnc skip        ; Jump to skip if no carry occurred (no overflow)

    inc ah         ; Increment the sum (ah) if there was a carry

skip:
    inc rsi        ; Move to the next element in the array
    dec cl         ; Decrement the counter
    jnz up         ; Jump to up if the counter is not zero

next:
    rol ax, 4H     ; Rotate the 4-bit sum in ax to the left
    mov [temp], ax ; Store the rotated value in temp
    and ax, 000FH  ; Mask to retain only the lower 4 bits of ax
    cmp al, 9H     ; Compare the lower 4 bits with 9H
    jbe numeric    ; Jump to numeric if below or equal to 9H

    add al, 07H    ; Adjust if the value is not a numeric digit

numeric:
    add al, 30H    ; Convert the numeric value to its ASCII representation
    mov [num], al  ; Store the ASCII character in num

    mov rax, 1     ; System call number for writing to the standard output
    mov rdi, 1     ; File descriptor for standard output
    mov rsi, num   ; Pointer to the ASCII character
    mov rdx, 1     ; Number of bytes to write
    syscall        ; Trigger the system call to write the content at the memory location pointed to by rsi

    mov ax, [temp] ; Restore the rotated value from temp
    dec byte [count] ; Decrement the loop counter
    jnz next       ; Jump to next if the counter is not zero

    mov rax, 60    ; System call number for exit
    mov rdi, 0     ; Exit code
    syscall        ; Trigger the system call to exit
