%include "../include/io.mac"

section .text
    global is_square
    extern printf

; function that checks if a number is a perfect square
check:
    push    ebp
    mov     ebp, esp
    pusha

    xor     eax, eax            ; cleans up eax
    xor     edx, edx            ; cleans up edx

    mov     ebx, [ebp + 8]      ; dist
    mov     ecx, [ebp + 12]     ; sq

    mov     edx, 0              ; dl is initialized as 0 (the number x)

; searches for a number x so that x^2 == dist
looop:
    xor     eax, eax            ; cleans up eax
    mov     al, dl              ; al = dl 
    mul     al                  ; al = al * al = dl * dl (x^2)
    cmp     eax, [ebx]          ; compares x
    je      true_lop            ; if x^2 == dist
    jg      false_lop           ; if x^2 > dist
    inc     edx                 ; ++x
    jmp     looop               ; loops until x^2 >= dist

; the distance is a perfect square
true_lop:
    mov     dword [ecx], 1      ; marks it as true
    jmp     end_check

; the distance is not a perfect square
false_lop:
    mov     dword [ecx], 0      ; marks it as false

end_check:
    mov     eax, [ecx]          ; puts whether the distance is a perfect square
                                ; at the specified addres
    popa
    leave
    ret

is_square:
    push    ebp
    mov     ebp, esp
    pusha

    mov     ebx, [ebp + 8]      ; dist
    mov     eax, [ebp + 12]     ; nr
    mov     ecx, [ebp + 16]     ; sq

; loop that goes through nr distances and checks if they are a perfect square
lop:
    cmp     eax, 0
    jz      end                 ; the end of the loop

; calling the function check(dist, is_it_true)
    push    ecx
    push    ebx
    call    check
    add     esp, 8

    add     ebx, 4              ; gets the address of the next distance
    add     ecx, 4              ; gets the address at which to write 1 or 0
    dec     eax                 ; --nr
    jmp     lop

end:
    popa
    leave
    ret
