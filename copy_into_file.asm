%macro op 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .data
    msg1 db "Error", 10
    msgl1 equ $-msg1
    msg2 db "File copy successfully", 10
    msgl2 equ $-msg2

section .bss
    fname1 resb 15	;buffer to store source file name
    fd1 resq 1		;store file desc obtained from syscall
    fname2 resb 15	;buffer to store dest file name	 
    fd2 resq 1		;store file desc obtained from syscall
    buff resb 512	;buffer for reading and writing file content
    bufflen resq 1	

section .text
    global _start

_start:
    pop r8		;pops no of arguments
    cmp r8, 3		;compares with 3 [dest file name, source file and exe file names]
    jne err

    pop r8		;dest file name popped
    pop r8		;src file name popped

    mov rsi, fname1	;points to the buffer fname1
above:
    mov al, [r8]	
    cmp al, 00		;00 marks the end of the file
    je next
    mov [rsi], al
    inc r8
    inc rsi
    jmp above

next:
    pop r8
    mov rsi, fname2

above2:
    mov al, [r8]
    cmp al, 00
    je next2
    mov [rsi], al
    inc r8
    inc rsi
    jmp above2

next2:
    op 2, fname1, 000000q, 0777q		;This opens the file specified by fname1 (source file) with the given permissions (000000q for read-only) and creates a new file descriptor. The result (file descriptor) is stored in rax, and then rax is moved to the variable [fd1].
    mov [fd1], rax

    op 0, [fd1], buff, 512		;This reads from the file represented by [fd1] (source file) into the buffer (buff) with a maximum read size of 512 bytes. The result (number of bytes read) is stored in rax, and then rax is moved to the variable [bufflen].
    mov [bufflen], rax

    op 85, fname2, 0777q, 0
    mov [fd2], rax

    op 1, [fd2], buff, [bufflen]
    op 3, [fd2], 0, 0
    op 3, [fd1], 0, 0
    op 1, 1, msg2, msgl2
    jmp end

err:
    op 1, 1, msg1, msgl1

end:
    op 60, 0, 0, 0
