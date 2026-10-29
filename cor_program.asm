; Certificate of Registration (COR) Program
; Architecture: x86 (Linux 32-bit int 0x80)

%macro print_string 2
    mov ecx, %1
    mov edx, %2
    call print_proc
%endmacro

%macro read_input 2
    mov ecx, %1
    mov edx, %2
    call read_proc
%endmacro

section .data
    p_status    db "Enter Enrollment Status: "
    l_status    equ $-p_status

    p_id        db "Enter Student #: "
    l_id        equ $-p_id

    p_name      db "Enter Name: "
    l_name      equ $-p_name

    p_phone     db "Enter Phone: "
    l_phone     equ $-p_phone

    p_zip       db "Enter Zip Code: "
    l_zip       equ $-p_zip

    p_college   db "Enter College: "
    l_college   equ $-p_college

    p_program   db "Enter Program: "
    l_program   equ $-p_program

    p_year      db "Enter Year Level: "
    l_year      equ $-p_year

    p_address   db "Enter Address: "
    l_address   equ $-p_address

    lbl_status  db 10, "Enrollment Status : "
    lbl_s_len   equ $-lbl_status

    lbl_id      db "Student # : "
    lbl_i_len   equ $-lbl_id

    lbl_name    db "Name : "
    lbl_n_len   equ $-lbl_name

    lbl_phone   db "Phone : "
    lbl_p_len   equ $-lbl_phone

    lbl_zip     db " Zip Code : "
    lbl_z_len   equ $-lbl_zip

    lbl_college db "College : "
    lbl_c_len   equ $-lbl_college

    lbl_prog    db " Program : "
    lbl_pr_len  equ $-lbl_prog

    lbl_year    db "Year Level : "
    lbl_y_len   equ $-lbl_year

    lbl_addr    db "Address : "
    lbl_a_len   equ $-lbl_addr

    sched_header db 10, "=================================================================================", 10
                 db "Courses    Title                               Section Units Days  Time                  Room", 10
                 db "---------------------------------------------------------------------------------", 10
    sched_h_len  equ $-sched_header

    s1  db "CCS0021    INFORMATION MANAGEMENT (LEC)        TN24    2     T     16:00:00-18:40:00     ONLINE", 10
    l1  equ $-s1
    s2  db "CCS0021L   INFORMATION MANAGEMENT (LAB)        TN24    1     F     16:00:00-18:50:00     ONLINE", 10
    l2  equ $-s2
    s3  db "CS0001     DISCRETE STRUCTURES 1               TN24    3     S/W   15:00:00-16:50:00     F710 / F710", 10
    l3  equ $-s3
    s4  db "CS0003     COMPUTER SYSTEMS & ARCHITECTURE     TN24    2     F     10:00:00-12:40:00     ONLINE", 10
    l4  equ $-s4
    s5  db "CS0003L    COMPUTER SYSTEMS & ARCHITECTURE(LAB)TN24    1     TH    10:00:00-12:50:00     E610", 10
    l5  equ $-s5
    s6  db "CS0070     OBJECT ORIENTED PROGRAMMING         TN24    2     F     07:00:00-09:40:00     ONLINE", 10
    l6  equ $-s6
    s7  db "CS0070L    OBJECT ORIENTED PROGRAMMING-LAB     TN24    1     TH    07:00:00-09:50:00     E609", 10
    l7  equ $-s7
    s8  db "GED0021    SPECIALIZED ENGLISH PROGRAM 2       TN24    3     S/W   11:00:00-12:50:00     F607 / F607", 10
    l8  equ $-s8
    s9  db "GED0075    LINEAR ALGEBRA                      TN24    3     F/T   13:00:00-14:50:00     ONLINE / ONLINE", 10
    l9  equ $-s9
    s10 db "GED0081    COLLEGE PHYSICS 1 LECTURE           TN24    2     T     07:00:00-09:40:00     ONLINE", 10
    l10 equ $-s10
    s11 db "GED0081L   COLLEGE PHYSICS 1 LABORATORY        TN24    1     S     07:00:00-09:50:00     F1003", 10
    l11 equ $-s11

    s_tot db "---------------------------------------------------------------------------------", 10
          db "TOTAL UNITS 21", 10
          db "=================================================================================", 10
    s_tot_len equ $-s_tot

    f_header db 10, "--- ASSESSMENT BREAKDOWN ---", 10
    f_h_len  equ $-f_header

    f_tui    db "Tuition Fee (21)                      : 44,268.00", 10
    f_t_len  equ $-f_tui
    f_misc   db "Miscellaneous Fee                     : 12,305.00", 10
    f_m_len  equ $-f_misc
    f_id     db "ID Validation Fee                     : 80.00", 10
    f_i_len  equ $-f_id
    f_lab1   db "ITE Computer Laboratory Fee (CCS0021) : 4,008.00", 10
    f_l1_len equ $-f_lab1
    f_lab2   db "ITE Computer Laboratory Fee (CS0003)  : 4,008.00", 10
    f_l2_len equ $-f_lab2
    f_lab3   db "ITE Computer Laboratory Fee (CS0070)  : 4,008.00", 10
    f_l3_len equ $-f_lab3
    f_sci    db "Science Lab Fee (GED0081)             : 4,104.00", 10
    f_s_len  equ $-f_sci

    f_total  db "TOTAL ASSESSMENT                      : "
    f_tot_l  equ $-f_total

    newline  db 10
    nl_len   equ $-newline

    val_tuition dd 44268
    val_misc    dd 12305
    val_id      dd 80
    val_lab1    dd 4008
    val_lab2    dd 4008
    val_lab3    dd 4008
    val_sci     dd 4104

section .bss
    b_status  resb 32
    b_id      resb 32
    b_name    resb 64
    b_phone   resb 32
    b_zip     resb 16
    b_college resb 32
    b_program resb 32
    b_year    resb 16
    b_address resb 64

    len_status  resd 1
    len_id      resd 1
    len_name    resd 1
    len_phone   resd 1
    len_zip     resd 1
    len_college resd 1
    len_program resd 1
    len_year    resd 1
    len_address resd 1

    total_fee resd 1
    out_buf   resb 32

section .text
    global _start

_start:
    ; 1. INPUT
    print_string p_status, l_status
    read_input b_status, 32
    mov [len_status], eax

    print_string p_id, l_id
    read_input b_id, 32
    mov [len_id], eax

    print_string p_name, l_name
    read_input b_name, 64
    mov [len_name], eax

    print_string p_phone, l_phone
    read_input b_phone, 32
    mov [len_phone], eax

    print_string p_zip, l_zip
    read_input b_zip, 16
    mov [len_zip], eax

    print_string p_college, l_college
    read_input b_college, 32
    mov [len_college], eax

    print_string p_program, l_program
    read_input b_program, 32
    mov [len_program], eax

    print_string p_year, l_year
    read_input b_year, 16
    mov [len_year], eax

    print_string p_address, l_address
    read_input b_address, 64
    mov [len_address], eax

    ; 2. OUTPUT STUDENT DETAILS
    print_string lbl_status, lbl_s_len
    print_string b_status, [len_status]

    print_string lbl_id, lbl_i_len
    print_string b_id, [len_id]

    print_string lbl_college, lbl_c_len
    print_string b_college, [len_college]

    print_string lbl_prog, lbl_pr_len
    print_string b_program, [len_program]

    print_string lbl_name, lbl_n_len
    print_string b_name, [len_name]

    print_string lbl_year, lbl_y_len
    print_string b_year, [len_year]

    print_string lbl_phone, lbl_p_len
    print_string b_phone, [len_phone]

    print_string lbl_zip, lbl_z_len
    print_string b_zip, [len_zip]

    print_string lbl_addr, lbl_a_len
    print_string b_address, [len_address]

    ; 3. DISPLAY SCHEDULE
    call display_schedule_proc

    ; 4. COMPUTE & PRINT FEES
    call compute_assessment_proc

    print_string f_header, f_h_len
    print_string f_tui, f_t_len
    print_string f_misc, f_m_len
    print_string f_id, f_i_len
    print_string f_lab1, f_l1_len
    print_string f_lab2, f_l2_len
    print_string f_lab3, f_l3_len
    print_string f_sci, f_s_len

    print_string f_total, f_tot_l
    mov eax, [total_fee]
    mov edi, out_buf
    call format_formatted_currency
    print_string out_buf, edx

    print_string newline, nl_len

    ; Exit Program cleanly
    mov eax, 1
    xor ebx, ebx
    int 0x80

; ==========================================================
; PROCEDURES
; ==========================================================

display_schedule_proc:
    push eax
    push ebx
    print_string sched_header, sched_h_len
    print_string s1, l1
    print_string s2, l2
    print_string s3, l3
    print_string s4, l4
    print_string s5, l5
    print_string s6, l6
    print_string s7, l7
    print_string s8, l8
    print_string s9, l9
    print_string s10, l10
    print_string s11, l11
    print_string s_tot, s_tot_len
    pop ebx
    pop eax
    ret

compute_assessment_proc:
    push eax
    mov eax, [val_tuition]
    add eax, [val_misc]
    add eax, [val_id]
    add eax, [val_lab1]
    add eax, [val_lab2]
    add eax, [val_lab3]
    add eax, [val_sci]
    mov [total_fee], eax
    pop eax
    ret

print_proc:
    push eax
    push ebx
    mov eax, 4                  ; sys_write
    mov ebx, 1                  ; stdout
    int 0x80
    pop ebx
    pop eax
    ret

read_proc:
    push ebx
    mov eax, 3                  ; sys_read
    mov ebx, 0                  ; stdin
    int 0x80
    pop ebx
    ret

; Formats integer into comma-separated currency format with .00 decimal
format_formatted_currency:
    push eax
    push ebx
    push ecx
    push esi

    mov ebx, 10
    xor ecx, ecx

.convert_loop:
    xor edx, edx
    div ebx
    add dl, '0'
    push edx
    inc ecx
    test eax, eax
    jnz .convert_loop

    mov esi, edi

    ; Thousands Part (First 2 digits: "72")
    pop eax
    mov [esi], al
    inc esi
    pop eax
    mov [esi], al
    inc esi

    ; Add Comma
    mov byte [esi], ','
    inc esi

    ; Hundreds Part (Next 3 digits: "781")
    pop eax
    mov [esi], al
    inc esi
    pop eax
    mov [esi], al
    inc esi
    pop eax
    mov [esi], al
    inc esi

    ; Add Decimal ".00"
    mov byte [esi], '.'
    inc esi
    mov byte [esi], '0'
    inc esi
    mov byte [esi], '0'
    inc esi

    mov byte [esi], 0           ; Null terminate
    mov edx, 9                  ; String length = 9 ("72,781.00")

    pop esi
    pop ecx
    pop ebx
    pop eax
    ret