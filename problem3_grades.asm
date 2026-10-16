section .data
    msg_name    db "Enter student name: ", 0
    len_name    equ $ - msg_name

    msg_id      db "Enter student ID: ", 0
    len_id      equ $ - msg_id

    msg_grade   db "Enter grade: ", 0
    len_grade   equ $ - msg_grade

    lbl_name    db "Student Name: ", 0
    lbl_id      db "Student ID: ", 0
    lbl_grade   db "Grade: ", 0
    lbl_class   db "Classification: ", 0

    out_exc     db "Excellent", 10, 0
    out_vgood   db "Very Good", 10, 0
    out_good    db "Good", 10, 0
    out_pass    db "Passed", 10, 0
    out_fail    db "Failed", 10, 0
    out_inv     db "INVALID GRADE", 10, 0
    newline     db 10, 0

section .bss
    name    resb 64
    id      resb 32
    grade_s resb 16
    grade_i resd 1

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

    ; Read Student ID (stored as string to preserve leading zeros)
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_id
    mov edx, len_id
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, id
    mov edx, 32
    int 0x80
    call fix_str

    ; Read Grade
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_grade
    mov edx, len_grade
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, grade_s
    mov edx, 16
    int 0x80
    call fix_str

    ; Print Student Details
    mov eax, 4
    mov ebx, 1
    mov ecx, lbl_name
    mov edx, 14
    int 0x80

    mov eax, name
    call print_str

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, lbl_id
    mov edx, 12
    int 0x80

    mov eax, id
    call print_str

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, lbl_grade
    mov edx, 7
    int 0x80

    mov eax, grade_s
    call print_str

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, lbl_class
    mov edx, 16
    int 0x80

    ; Convert grade string to integer & validate numeric
    mov esi, grade_s
    call parse_int
    cmp edx, -1
    je .invalid

    mov [grade_i], eax
    mov eax, [grade_i]

    ; Grade range evaluation (0 to 100)
    cmp eax, 0
    jl .invalid
    cmp eax, 100
    jg .invalid

    cmp eax, 90
    jge .excellent
    cmp eax, 85
    jge .vgood
    cmp eax, 80
    jge .good
    cmp eax, 75
    jge .passed
    jmp .failed

.excellent:
    mov ecx, out_exc
    mov edx, 10
    jmp print_res

.vgood:
    mov ecx, out_vgood
    mov edx, 10
    jmp print_res

.good:
    mov ecx, out_good
    mov edx, 5
    jmp print_res

.passed:
    mov ecx, out_pass
    mov edx, 7
    jmp print_res

.failed:
    mov ecx, out_fail
    mov edx, 7
    jmp print_res

.invalid:
    mov ecx, out_inv
    mov edx, 14

print_res:
    mov eax, 4
    mov ebx, 1
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80


; --- Helpers ---

; Convert ASCII string to integer (Returns value in EAX, set EDX = -1 if nonnumeric)
parse_int:
    xor eax, eax
    xor ecx, ecx
    xor edx, edx

    cmp byte [esi], 0
    je .bad

.parse_loop:
    mov cl, [esi]
    cmp cl, 0
    je .done
    
    cmp cl, '0'
    jl .bad
    cmp cl, '9'
    jg .bad

    sub cl, '0'
    imul eax, eax, 10
    add eax, ecx
    inc esi
    jmp .parse_loop

.bad:
    mov edx, -1
.done:
    ret

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