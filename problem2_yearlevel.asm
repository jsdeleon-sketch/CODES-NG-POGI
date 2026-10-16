section .data
    msg_name    db "What is your name? ", 0
    len_name    equ $ - msg_name

    msg_age     db "How old are you? ", 0
    len_age     equ $ - msg_age

    msg_year    db "What is your year level? ", 0
    len_year    equ $ - msg_year

    lbl_hello   db "Hello ", 0
    lbl_age1    db "You are ", 0
    lbl_age2    db " years old", 10, 0

    out_1       db "Freshman", 10, 0
    out_2       db "Sophomore", 10, 0
    out_3       db "Junior", 10, 0
    out_4       db "Senior", 10, 0
    out_inv     db "INVALID YEAR LEVEL", 10, 0
    newline     db 10, 0

section .bss
    name    resb 64
    age     resb 16
    year    resb 16

section .text
    global _start

_start:
    ; Read Name
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

    ; Read Age
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

    ; Read Year Level
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_year
    mov edx, len_year
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, year
    mov edx, 16
    int 0x80

    ; Print "Hello <name>"
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

    ; Print "You are <age> years old"
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

    ; Year-Level Check
    mov al, [year]

    cmp al, '1'
    je yr1
    cmp al, '2'
    je yr2
    cmp al, '3'
    je yr3
    cmp al, '4'
    je yr4
    jmp yrinv

yr1:
    mov ecx, out_1
    mov edx, 9
    jmp print_res

yr2:
    mov ecx, out_2
    mov edx, 10
    jmp print_res

yr3:
    mov ecx, out_3
    mov edx, 7
    jmp print_res

yr4:
    mov ecx, out_4
    mov edx, 7
    jmp print_res

yrinv:
    mov ecx, out_inv
    mov edx, 19

print_res:
    mov eax, 4
    mov ebx, 1
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

; --- Helpers ---

fix_str:
    mov esi, ecx
.loop:
    cmp byte [esi], 10
    je .done
    cmp byte [esi], 13
    je .done
    cmp byte [esi], 0
    je .done
    inc esi
    jmp .loop
.done:
    mov byte [esi], 0
    ret

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