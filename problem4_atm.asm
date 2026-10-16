section .data
    msg_name    db "Enter account name: ", 0
    len_name    equ $ - msg_name

    msg_pin     db "Enter PIN: ", 0
    len_pin     equ $ - msg_pin

    msg_wdraw   db "Enter withdrawal amount: ", 0
    len_wdraw   equ $ - msg_wdraw

    lbl_acc_ok  db "ACCESS GRANTED", 10, 0
    len_acc_ok  equ $ - lbl_acc_ok

    lbl_acc_den db "ACCESS DENIED", 10, 0
    len_acc_den equ $ - lbl_acc_den

    lbl_bal     db "Current Balance: PHP 10000", 10, 0
    len_bal     equ $ - lbl_bal

    lbl_success db "WITHDRAWAL SUCCESSFUL", 10, 0
    len_success equ $ - lbl_success

    lbl_amt_w   db "Amount Withdrawn: PHP ", 0
    lbl_rem_b   db "Remaining Balance: PHP ", 0

    err_inv     db "INVALID AMOUNT", 10, 0
    len_err_inv equ $ - err_inv

    err_funds   db "INSUFFICIENT FUNDS", 10, 0
    len_err_f   equ $ - err_funds

    err_mult    db "AMOUNT MUST BE A MULTIPLE OF 100", 10, 0
    len_err_m   equ $ - err_mult

    newline     db 10, 0
    balance     dd 10000

section .bss
    name_buf    resb 64
    pin_buf     resb 16
    amt_buf     resb 16
    out_num_buf resb 16

section .text
    global _start

_start:
    ; --- 1. Read Account Name ---
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_name
    mov edx, len_name
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, name_buf
    mov edx, 64
    int 0x80
    call fix_str

    ; --- 2. Read PIN ---
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_pin
    mov edx, len_pin
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, pin_buf
    mov edx, 16
    int 0x80
    call fix_str

    ; --- 3. Validate PIN ("1234") ---
    mov esi, pin_buf
    cmp byte [esi], '1'
    jne pin_fail
    cmp byte [esi+1], '2'
    jne pin_fail
    cmp byte [esi+2], '3'
    jne pin_fail
    cmp byte [esi+3], '4'
    jne pin_fail
    cmp byte [esi+4], 0
    jne pin_fail

    ; --- 4. Access Granted & Show Balance ---
    mov eax, 4
    mov ebx, 1
    mov ecx, lbl_acc_ok
    mov edx, len_acc_ok
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, lbl_bal
    mov edx, len_bal
    int 0x80

    ; --- 5. Prompt Withdrawal Amount ---
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_wdraw
    mov edx, len_wdraw
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, amt_buf
    mov edx, 16
    int 0x80
    call fix_str

    ; --- 6. Parse Amount String to Integer ---
    mov esi, amt_buf
    call parse_int
    cmp edx, -1
    je err_invalid_amt

    ; --- 7. Validation Checklist ---
    ; Check 1: Amount <= 0
    cmp eax, 0
    jle err_invalid_amt

    ; Check 2: Amount > Balance
    cmp eax, [balance]
    jg err_insufficient

    ; Check 3: Multiple of 100 (amount % 100 == 0)
    push eax
    xor edx, edx
    mov ebx, 100
    div ebx
    cmp edx, 0
    pop eax
    jne err_not_multiple

    ; --- 8. Perform Withdrawal ---
    mov ebx, [balance]
    sub ebx, eax
    mov [balance], ebx          ; New balance = balance - amount

    ; Print "WITHDRAWAL SUCCESSFUL"
    push eax                    ; save amount
    mov eax, 4
    mov ebx, 1
    mov ecx, lbl_success
    mov edx, len_success
    int 0x80

    ; Print "Amount Withdrawn: PHP <amount>"
    mov eax, 4
    mov ebx, 1
    mov ecx, lbl_amt_w
    mov edx, 22
    int 0x80

    pop eax                     ; restore amount
    call print_int

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Print "Remaining Balance: PHP <balance>"
    mov eax, 4
    mov ebx, 1
    mov ecx, lbl_rem_b
    mov edx, 23
    int 0x80

    mov eax, [balance]
    call print_int

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    jmp exit_prog

; --- Error Branching ---
pin_fail:
    mov eax, 4
    mov ebx, 1
    mov ecx, lbl_acc_den
    mov edx, len_acc_den
    int 0x80
    jmp exit_prog

err_invalid_amt:
    mov eax, 4
    mov ebx, 1
    mov ecx, err_inv
    mov edx, len_err_inv
    int 0x80
    jmp exit_prog

err_insufficient:
    mov eax, 4
    mov ebx, 1
    mov ecx, err_funds
    mov edx, len_err_f
    int 0x80
    jmp exit_prog

err_not_multiple:
    mov eax, 4
    mov ebx, 1
    mov ecx, err_mult
    mov edx, len_err_m
    int 0x80

exit_prog:
    mov eax, 1
    xor ebx, ebx
    int 0x80


; ==============================================================================
; Helper Routines
; ==============================================================================

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

print_int:
    push eax
    push ebx
    push ecx
    push edx

    mov ecx, out_num_buf + 15
    mov byte [ecx], 0
    mov ebx, 10

.convert_loop:
    xor edx, edx
    div ebx
    add dl, '0'
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz .convert_loop

    ; Print converted number
    mov eax, ecx
    call print_str

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

print_str:
    push eax
    push ebx
    push ecx
    push edx

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

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret