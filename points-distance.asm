%include "../include/io.mac"

struc point
    .x: resw 1
    .y: resw 1
endstruc

section .text
    global points_distance
    extern printf

points_distance: 
    push    ebp
    mov     ebp, esp
    pusha

    mov     ebx, [ebp + 8]      ; points
    mov     eax, [ebp + 12]     ; distance

    xor     ecx, ecx            ; cleans up ecx    
    xor     edx, edx            ; cleans up edx

    ; gets the first point's x
    mov     cx, word [ebx + point.x]

    ; gets the second point's x
    mov     dx, word [ebx + point_size + point.x]

    cmp     dx, cx              ; checks if dx > cx
    jl      change              ; if not, it will do cx - dx

    sub     dx, cx              ; does dx - cx
    cmp     dx, 0               ; checks if dx is 0
    jnz     put                 ; if it is not, the distance is found

    ; if it is, tries y

    ; gets the first point's y
    mov     cx, word [ebx + point.y]

    ; gets the second point's y
    mov     dx, word [ebx + point_size + point.y]

    cmp     dx, cx              ; checks if dx > cx
    jl      change              ; if not, it will do cx - dx

    sub     edx, ecx            ; does dx - cx
    jmp     put                 ; jumps over the following instructions

; does dx = cx - dx
change:
    sub     ecx, edx
    mov     edx, ecx

put:
    mov     [eax], edx          ; puts the distance at the specified address

    popa
    leave
    ret
