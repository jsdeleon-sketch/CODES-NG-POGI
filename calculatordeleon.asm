section .data
    ; ANSI Escape Sequence to clear screen and reset cursor to top-left
    clear_screen_cmd db 27, '[2J', 27, '[H', 0
    clear_screen_len equ $ - clear_screen_cmd

    menu db "----------------------------------", 0xA
         db "MENU", 0xA
         db "[A]dd", 0xA
         db "[S]ubtract", 0xA
         db "[M]ultiply", 0xA
         db "[D]ivide", 0xA
         db "----------------------------------", 0xA, 0
    menu_len equ $ - menu

    msg_choice      db "Enter your choice: ", 0
    msg_choice_len  equ $ - msg_choice

    msg_num1        db "Enter first number: ", 0
    msg_num1_len    equ $ - msg_num1

    msg_num2        db "Enter second number: ", 0
    msg_num2_len    equ $ - msg_num2

    msg_sum         db "The sum is ", 0
    msg_sum_len     equ $ - msg_sum

    msg_diff        db "The difference is ", 0
    msg_diff_len    equ $ - msg_diff

    msg_prod        db "The product is ", 0
    msg_prod_len    equ $ - msg_prod

    msg_quot        db "The quotient is ", 0
    msg_quot_len    equ $ - msg_quot

    msg_again       db "Do you want to try again (Y/N): ", 0
    msg_again_len   equ $ - msg_again

    newline         db 0xA
    div_zero_msg    db "Error: Division by zero!", 0xA
    div_zero_len    equ $ - div_zero_msg

section .bss
    choice  resb 2       ; Buffer for menu selection
    buffer  resb 10      ; Input/output conversion buffer
    again   resb 2       ; Buffer for try again response
    num1    resd 1       ; First operand (supports two+ digits)
    num2    resd 1       ; Second operand (supports two+ digits)
    result  resd 1       ; Calculation result

section .text
    global _start

_start:
menu_loop:
    ; 1. Clear Screen
    mov eax, 4                  ; sys_write
    mov ebx, 1                  ; stdout
    mov ecx, clear_screen_cmd   ; ANSI clear command string
    mov edx, clear_screen_len   ; length
    int 0x80

    ; 2. Print Menu
    mov eax, 4
    mov ebx, 1
    mov ecx, menu
    mov edx, menu_len
    int 0x80

    ; 3. Prompt & Read Choice
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_choice
    mov edx, msg_choice_len
    int 0x80

    mov eax, 3                  ; sys_read
    mov ebx, 0                  ; stdin
    mov ecx, choice
    mov edx, 2
    int 0x80

    ; 4. Prompt & Read First Number
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_num1
    mov edx, msg_num1_len
    int 0x80

    call read_number
    mov [num1], eax

    ; 5. Prompt & Read Second Number
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_num2
    mov edx, msg_num2_len
    int 0x80

    call read_number
    mov [num2], eax

    ; 6. Evaluate Choice & Jump
    mov al, [choice]
    cmp al, 'A'
    je  do_add
    cmp al, 'a'
    je  do_add

    cmp al, 'S'
    je  do_sub
    cmp al, 's'
    je  do_sub

    cmp al, 'M'
    je  do_mul
    cmp al, 'm'
    je  do_mul

    cmp al, 'D'
    je  do_div
    cmp al, 'd'
    je  do_div

    jmp ask_again

; --- Operations ---

do_add:
    mov eax, [num1]
    add eax, [num2]
    mov [result], eax

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_sum
    mov edx, msg_sum_len
    int 0x80
    jmp print_res

do_sub:
    mov eax, [num1]
    sub eax, [num2]
    mov [result], eax

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_diff
    mov edx, msg_diff_len
    int 0x80
    jmp print_res

do_mul:
    mov eax, [num1]
    mov ebx, [num2]
    imul eax, ebx
    mov [result], eax

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_prod
    mov edx, msg_prod_len
    int 0x80
    jmp print_res

do_div:
    mov ebx, [num2]
    cmp ebx, 0
    je  err_div_zero

    mov eax, [num1]
    xor edx, edx
    div ebx
    mov [result], eax

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_quot
    mov edx, msg_quot_len
    int 0x80
    jmp print_res

err_div_zero:
    mov eax, 4
    mov ebx, 1
    mov ecx, div_zero_msg
    mov edx, div_zero_len
    int 0x80
    jmp ask_again

print_res:
    mov eax, [result]
    call print_number

    ; Newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

ask_again:
    ; Prompt try again
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_again
    mov edx, msg_again_len
    int 0x80

    ; Read Y/N decision
    mov eax, 3
    mov ebx, 0
    mov ecx, again
    mov edx, 2
    int 0x80

    mov al, [again]
    cmp al, 'Y'
    je  menu_loop
    cmp al, 'y'
    je  menu_loop

    ; Exit Program cleanly
    mov eax, 1          ; sys_exit
    xor ebx, ebx
    int 0x80

; --- Helper Routines ---

read_number:
    mov eax, 3          ; sys_read
    mov ebx, 0          ; stdin
    mov ecx, buffer
    mov edx, 10
    int 0x80

    xor eax, eax        ; Number accumulator = 0
    mov esi, buffer
.convert_loop:
    mov bl, [esi]
    cmp bl, 0xA         ; Stop on newline
    je  .done
    cmp bl, '0'
    jl  .done
    cmp bl, '9'
    jg  .done

    sub bl, '0'         ; ASCII to integer
    mov bh, 0
    imul eax, 10        ; Shift decimal left by 1 place
    add eax, ebx        ; Add current digit

    inc esi
    jmp .convert_loop
.done:
    ret

print_number:
    mov ecx, buffer + 9
    mov byte [ecx], 0   ; Null termination
    mov ebx, 10
.convert:
    xor edx, edx
    div ebx             ; Divide EAX by 10 (Remainder in EDX)
    add dl, '0'         ; Integer digit to ASCII
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz .convert

    ; Print conversion output
    mov eax, buffer + 9
    sub eax, ecx

    mov edx, eax        ; Length
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    int 0x80
    ret