%include "../include/io.mac"

section .text
    global simple
    extern printf

simple:
    push    ebp
    mov     ebp, esp
    pusha

    mov     ecx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; plain
    mov     edi, [ebp + 16] ; enc_string
    mov     edx, [ebp + 20] ; step

lop:
    xor     eax, eax        ; cleans up eax

    mov     al, byte [esi]  ; puts the first char of plain in al

    add     al, dl          ; adds the step to the char

    cmp     al, 'Z'         ; checks if (the ASCII code of the char) is greater
                            ; than (the ASCII code of) 'Z'
    jle     set             ; if it is, it ignores the following instructions

                            ; if it is not, then:
    sub     al, dl          ; resets the char by subtracting step
    sub     al, 26          ; subtracts 26 from the char
    add     al, dl          ; adds the step back to the char, only this time
                            ; it is guaranteed to be less than 'Z'

; puts each encrypted char in the destination string
set:
    mov     [edi], eax      ; puts the encrypted char at the specified address

    inc     esi             ; goes to the next char's address
    inc     edi             ; goes to the next address at which to write

    loop    lop             ; loops until ecx (len of plain) is 0

    popa
    leave
    ret
