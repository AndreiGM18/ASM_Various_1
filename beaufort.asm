%include "../include/io.mac"

section .text
    global beaufort
    extern printf

; void beaufort(int len_plain, char *plain, int len_key, char *key, char tabula_recta[26][26], char *enc) ;
beaufort:
    push    ebp
    mov     ebp, esp
    pusha

    mov     eax, [ebp + 8]  ; len_plain
    mov     ebx, [ebp + 12] ; plain (address of first element in string)
    mov     ecx, [ebp + 16] ; len_key
    mov     edx, [ebp + 20] ; key (address of first element in matrix)
    mov     edi, [ebp + 24] ; tabula_recta
    mov     esi, [ebp + 28] ; enc

lop:
    cmp     eax, 0
    jz      end             ; the end of the loop

; pushing onto the stack to free up the registers
    push    eax
    push    ecx

; getting one char from plain and one from key
    mov     al, byte [ebx]
    mov     cl, byte [edx]

; gets the difference between the ASCII code of the chars
    sub     cl, al

    add     cl, 'A'         ; gets 'A' + the difference (which is an offset)
    cmp     cl, 'A'         ; if the offset was negative:
    jge     next            ; ignore if it was not
    add     cl, 26          ; calculates 'A' + (26 - offset)

next:
    mov     [esi], ecx      ; the encrypted char - written at the given address

; pops
    pop     ecx
    pop     eax

    inc     ebx             ; address of next char of plain
    inc     edx             ; address of next char of key
    inc     esi             ; address at which to write the next encrypted char
    dec     eax             ; --len_plain
    dec     ecx             ; --len_key

; check if len_key is 0
    cmp     ecx, 0
    jz      reset

    jmp     lop

; if len_key is 0, key and len_key are reset
reset:
    mov     ecx, [ebp + 16]
    mov     edx, [ebp + 20]
    jmp     lop

end:
    popa
    leave
    ret
