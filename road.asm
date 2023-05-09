%include "../include/io.mac"

struc point
    .x: resw 1
    .y: resw 1
endstruc

section .text
    global road
    extern printf

; function that calculates the distance between two points
points_distance:
    push    ebp
    mov     ebp, esp
    pusha

    mov     eax, [ebp + 8]      ; points
    mov     ebx, [ebp + 12]     ; distance

    xor     ecx, ecx            ; cleans up ecx
    xor     edx, edx            ; cleans up edx

    ; gets the first point's x
    mov     cx, word [eax + point.x]

    ; gets the second point's x
    mov     dx, word [eax + point_size + point.x]

    cmp     dx, cx              ; checks if dx > cx
    jl      change              ; if not, it will do cx - dx

    sub     dx, cx              ; does dx - cx
    cmp     dx, 0               ; checks if dx is 0
    jnz     put                 ; if it is not, the distance is found

    ; if it is, tries y

    ; gets the first point's y
    mov     cx, word [eax + point.y]

    ; gets the second point's y
    mov     dx, word [eax + point_size + point.y]

    cmp     dx, cx              ; checks if dx > cx
    jl      change              ; if not, it will do cx - dx

    sub     edx, ecx            ; does dx - cx
    jmp     put                 ; jumps over the following instructions

; does dx = cx - dx
change:
    sub     ecx, edx
    mov     edx, ecx

put:
    mov     [ebx], edx          ; puts the distance at the specified address

    popa
    leave
    ret

road:
    push    ebp
    mov     ebp, esp
    pusha

    mov     eax, [ebp + 8]      ; points
    mov     ecx, [ebp + 12]     ; len
    mov     ebx, [ebp + 16]     ; distances
   
    dec     ecx                 ; there will be len - 1 distances

lop:
    push    ebx                 ; pushes ebx onto the stack
    push    eax                 ; pushes eax onto the stack

    call    points_distance     ; calls the points_distance function
    add     esp, 8              ; readjusts esp
    add     eax, point_size     ; gets the address of the next pair of points
    add     ebx, 4              ; gets the address at which to write the
                                ; next distance
    loop    lop                 ; loops len - 1 times

    popa
    leave
    ret
