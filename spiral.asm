%include "../include/io.mac"

section .text
    global spiral
    extern printf

; void spiral(int N, char *plain, int key[N][N], char *enc_string);
spiral:
    push    ebp
    mov     ebp, esp
    pusha

    mov     eax, [ebp + 8]  ; N (size of key line)
    mov     ebx, [ebp + 12] ; plain (address of first element in string)
    mov     ecx, [ebp + 16] ; key (address of first element in matrix)
    mov     edx, [ebp + 20] ; enc_string (address of first element in string)

    push    ecx             ; pushes ecx onto the stack
    mov     cl, al          ; puts N in ecx
    push    eax             ; pushes eax onto the stack
    mul     cl              ; eax = N * N

; loop that copies plain into enc_string, byte by byte
lop:
    cmp     eax, 0
    jz      next            ; done
    
    ; copying
    mov     esi, [ebx]
    mov     [edx], esi

    ; getting the next chars
    inc     ebx
    inc     edx

    dec     eax             ; --len
    jmp     lop             ; loop until len = 0

next:
    xor     esi, esi        ; cleaning up esi

    mov     edx, [ebp + 20] ; enx_string
    mov     ebx, [ebp + 12] ; plain

    ; pops
    pop     eax
    pop     ecx

    mov     edi, edx        ; enc_strin

    ; pushes
    push    ebx
    push    edx

    mov     edx, eax        ; edx = N
    
    ; eax = 4 * N
    mov     bl, 4
    mul     bl

    sub     ecx, 4          ; fixes the loop

; when going around a circular matrix, starting from the first element
; one can goes right, down, left, up in this order
; the number of elements going in one direction starts at len, theb decreases
; every time the direction is changed from right to down or from left to up
; an exception is the first right iteration (easily fixed by adding one extra
; step in the iteration at the start)

; number of elements that will be iterated through
right_prep:
    mov     esi, edx

right:
    ; no more elements in the matrix
    cmp     edx, 0
    jz      end

    ; go down
    cmp     esi, 0
    jz      down_prep

    ; iterating: a += 4 (array of ints) (along rows)
    add     ecx, 4
    dec     esi

    ; enc_string[i] = plain[i] + the element in the matrix
    ; ++i
    push    eax
    mov     eax, [ecx]
    add     [edi], eax
    pop     eax
    inc     edi

    ; loop
    jmp     right

; number of elements that will be iterated through
; this number now decreases
down_prep:
    dec     edx
    mov     esi, edx

down:
    ; no more elements in the matrix
    cmp     edx, 0
    jz      end

    ; go left
    cmp     esi, 0
    jz      left_prep

    ; iterating: a += 4 * N (array of ints) (along columns)
    add     ecx, eax
    dec     esi

    ; enc_string[i] = plain[i] + the element in the matrix
    ; ++i
    push    eax
    mov     eax, [ecx]
    add     [edi], eax
    pop     eax
    inc     edi

    ; loop
    jmp     down

; number of elements that will be iterated through
left_prep:
    mov     esi, edx

left:
    ; no more elements in the matrix
    cmp     edx, 0
    jz      end

    ; go up
    cmp     esi, 0
    jz      up_prep

    ; iterating: a -= 4 (array of ints) (along rows)
    sub     ecx, 4
    dec     esi

    ; enc_string[i] = plain[i] + the element in the matrix
    ; ++i
    push    eax
    mov     eax, [ecx]
    add     [edi], eax
    pop     eax
    inc     edi

    ; loop
    jmp     left

; number of elements that will be iterated through
; this number now decreases
up_prep:
    dec     edx
    mov     esi, edx

up:
    ; no more elements in the matrix
    cmp     edx, 0
    jz      end

    ; go right
    cmp     esi, 0
    jz      right_prep

    ; iterating: a -= 4 * N (array of ints) (along columns)
    sub     ecx, eax
    dec     esi

    ; enc_string[i] = plain[i] + the element in the matrix
    ; ++i
    push    eax
    mov     eax, [ecx]
    add     [edi], eax
    pop     eax
    inc     edi

    ; loop
    jmp     up

end:
    ; pops
    pop     edx
    pop     ebx

    popa
    leave
    ret
