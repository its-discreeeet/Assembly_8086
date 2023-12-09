%macro op 4
    mov rax, %1      ; Load system call number into rax
    mov rdi, %2      ; Load file descriptor into rdi
    mov rsi, %3      ; Load pointer to data into rsi
    mov rdx, %4      ; Load data length into rdx
    syscall          ; Trigger system call
%endmacro

section .data
    msg db "Sorted array is = ", 10    ; Message to be displayed
    msglen equ $ - msg                  ; Calculate message length

    arr db 05H, 0AH, 75H, 0D3H, 12H     ; Input array

section .bss
    result  resb 15                      ; Result buffer

section .text
    global _start

_start:
    mov bl, 5                           ; Number of elements in the array

loop_outer:
    mov cl, 4                           ; Number of comparisons per iteration
    mov rsi, arr                        ; Pointer to the array

up:
    mov al, byte [rsi]                  ; Load byte from memory
    cmp al, byte [rsi + 1]              ; Compare with the next byte
    jbe only_inc                        ; Jump if less than or equal (ascending order)
    xchg al, byte [rsi + 1]             ; Exchange bytes if out of order
    mov byte [rsi], al                  ; Store the exchanged value

only_inc:
    inc rsi                             ; Move to the next element
    dec cl                              ; Decrease the comparison counter
    jnz up                              ; Repeat until all comparisons are done

    dec bl                              ; Decrease the outer loop counter
    jnz loop_outer                      ; Repeat until all elements are sorted

op 1, 1, msg, msglen                    ; Print the message
mov rdi, arr                           ; Pointer to the sorted array
mov rsi, result                        ; Pointer to the result buffer
mov dl, 10                             ; Length of the data to be displayed

disp_loop1:
    mov cl, 2                           ; Number of digits to process at a time
    mov al, [rdi]                       ; Load a byte from the sorted array

againx:
    rol al, 4                            ; Rotate the bits left by 4 positions
    mov bl, al                           ; Temporary storage for later use
    and ax, 0FH                          ; Mask upper 4 bits to isolate lower 4 bits
    cmp al, 09H                          ; Compare with 9
    jbe downx                            ; Jump if below or equal
    add al, 07H                          ; Adjust for ASCII conversion

downx:
    add al, 30H                          ; Convert to ASCII
    mov byte [rsi], al                  ; Store in the result buffer
    mov al, bl                           ; Restore original value of al
    inc rsi                              ; Move to the next position in the result buffer
    dec cl                               ; Decrease the counter
    jnz againx                           ; Repeat until all digits are processed

    mov byte [rsi], 0AH                 ; Add a newline character
    inc rsi                              ; Move to the next position in the result buffer
    inc rdi                              ; Move to the next position in the sorted array
    dec dl                               ; Decrease the counter
    jnz disp_loop1                       ; Repeat until all elements are displayed

op 1, 1, result, 15                     ; Print the sorted array
op 60, 0, 0, 0                          ; Exit the program
