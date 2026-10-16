section .data
    msg_name    db "What is your name? ", 0
    len_name    equ $ - msg_name

    msg_age     db "How old are you? ", 0
    len_age     equ $ - msg_age

    msg_gender  db "What is your gender? ", 0
    len_gender  equ $ - msg_gender

    lbl_hello   db "Hello ", 0
    lbl_age1    db "You are ", 0
    lbl_age2    db " years old", 10, 0
    
    out_m       db "Hello", 10, 0
    out_f       db "World", 10, 0
    out_inv     db "INVALID", 10, 0
    newline     db 10, 0

section .bss
    name    resb 64
    age     resb 16
    gender  resb 16

section .text
    global _start

_start:
    ; --- Read Name ---
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_name
    mov edx, len_name
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, name
    mov edx, 64
    int 0x80
    call fix_str

    ; --- Read Age ---
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_age
    mov edx, len_age
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, age
    mov edx, 16
    int 0x80
    call fix_str

    ; --- Read Gender ---
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_gender
    mov edx, len_gender
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, gender
    mov edx, 16
    int 0x80

    ; --- Output Hello <name> ---
    mov eax, 4
    mov ebx, 1
    mov ecx, lbl_hello
    mov edx, 6
    int 0x80

    mov eax, name
    call print_str

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; --- Output You are <age> years old ---
    mov eax, 4
    mov ebx, 1
    mov ecx, lbl_age1
    mov edx, 8
    int 0x80

    mov eax, age
    call print_str

    mov eax, 4
    mov ebx, 1
    mov ecx, lbl_age2
    mov edx, 11
    int 0x80

    ; --- Gender Check ---
    mov al, [gender]

    cmp al, 'M'
    je check_m
    cmp al, 'm'
    je check_m

    cmp al, 'F'
    je check_f
    cmp al, 'f'
    je check_f

    jmp check_inv

check_m:
    mov ecx, out_m
    mov edx, 6
    jmp print_res

check_f:
    mov ecx, out_f
    mov edx, 6
    jmp print_res

check_inv:
    mov ecx, out_inv
    mov edx, 8

print_res:
    mov eax, 4
    mov ebx, 1
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80


; --- Minimal Helper Procedures ---

; Trims newline (\n) from input
fix_str:
    mov esi, ecx
.loop:
    cmp byte [esi], 10
    je .done
    cmp byte [esi], 0
    je .done
    inc esi
    jmp .loop
.done:
    mov byte [esi], 0
    ret

; Prints a null-terminated string
print_str:
    mov ecx, eax
    mov edx, 0
.len_loop:
    cmp byte [eax + edx], 0
    je .do_print
    inc edx
    jmp .len_loop
.do_print:
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret