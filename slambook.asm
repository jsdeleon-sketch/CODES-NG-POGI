; ==============================================================================
; PROGRAM: SLAMBOOK.ASM
; DEVELOPER: JP Kyle Ahlizter S. De Leon
; EMAIL: jsdeleon@fit.edu.ph
; DESCRIPTION: Custom Slambook Application with ASCII Art & BIOS Row/Col Positioning
; ARCHITECTURE: x86 (16-bit DOS / TASM / MASM)
; ==============================================================================

.MODEL SMALL
.STACK 200h

.DATA
    ; --------------------------------------------------------------------------
    ; DETAILED ASCII ART HEADERS & BANNERS
    ; --------------------------------------------------------------------------
    ART_BANNER DB "  __________________________________________________________________________  ", 13, 10
               DB " /                                                                          \ ", 13, 10
               DB " |   ____  _      ____  _      ____   ____  ____  _     _      ____  _  _   | ", 13, 10
               DB " |  / ___)( \    / __ \/ \    / ___)\/ ___)/  _ \( \   / \    /  _ \/ \/ \  | ", 13, 10
               DB " |  \___ \/ (_/\( __  ) \/\/\ \___ \/ / _ \| / \ ) (_/\ \/\/\ | | | |   /   | ", 13, 10
               DB " |  (____/\____/ \_/\_\_/\/\_/(____/\____/|_\_/\/\____/\_/\/\_|_| |_|_|\_\  | ", 13, 10
               DB " \__________________________________________________________________________/ ", 13, 10, '$'

    ART_ABOUT   DB "  [=== ABOUT ME ===]", '$'
    ART_FIRSTS  DB "  [=== MY FIRSTS ===]", '$'
    ART_FAVES   DB "  [=== MY FAVES ===]", '$'
    ART_HOBBIES DB "  [=== HOBBIES & MEDIA ===]", '$'
    ART_FUTURE  DB "  [=== AMBITION & MOTTO ===]", '$'

    ; --------------------------------------------------------------------------
    ; USER DATA & LABELS
    ; --------------------------------------------------------------------------
    lbl_name      DB "Name           : JP Kyle Ahlizter S. De Leon", '$'
    lbl_email     DB "Email          : jsdeleon@fit.edu.ph", '$'
    lbl_web       DB "Website        : N/A", '$'

    lbl_achieve   DB "1st Achievement: Making my way to College!", '$'
    lbl_risk      DB "1st Risk       : To do anything just to pass even if it's hard.", '$'
    lbl_happy     DB "1st Happy Moment: When I had plans with my family and friends.", '$'

    lbl_color     DB "Color          : Black", '$'
    lbl_perfume   DB "Perfume        : DIOR Sauvage / YSL Myslf", '$'
    lbl_music     DB "Music / Singer : RNB / HipHop (Daniel Caesar, Frank Ocean, Drake, PND)", '$'
    lbl_song      DB "Favorite Song  : White Ferrari", '$'
    lbl_food      DB "Favorite Food  : Sisig", '$'
    lbl_weekend   DB "Weekend Activity: Basketball / Jogging", '$'

    lbl_tv        DB "TV Show / Movie: Stranger Things / MCU Movies & Spider-Man", '$'
    lbl_book      DB "Book           : Harry Potter", '$'
    lbl_celeb     DB "Celebrity Crush: Emma Watson", '$'
    lbl_role      DB "Role Model     : My Dad", '$'

    lbl_ambition  DB "Ambition       : To be a Successful Software Engineer!", '$'
    lbl_motto     DB "Motto in Life  : Onting bato, onting semento. Monumento.", '$'

    msg_press_key DB "Press any key to view the next page...", '$'
    msg_end       DB "=== END OF SLAMBOOK PROFILE. THANK YOU! ===", '$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; --------------------------------------------------------------------------
    ; PAGE 1: HEADER, ABOUT ME, MY FIRSTS & MY FAVES
    ; --------------------------------------------------------------------------
    
    ; Set 80x25 Text Mode (Mode 03h)
    MOV AH, 00H
    MOV AL, 03H
    INT 10H

    ; Clear Screen with Dark Blue/Cyan Theme
    CALL CLEAR_SCREEN

    ; Print Detailed ASCII Title Banner
    MOV DH, 0       ; Row 0
    MOV DL, 0       ; Col 0
    CALL SET_CURSOR
    LEA DX, ART_BANNER
    CALL PRINT_STRING

    ; --- SECTION 1: ABOUT ME ---
    MOV DH, 8
    MOV DL, 2
    CALL SET_CURSOR
    LEA DX, ART_ABOUT
    CALL PRINT_STRING

    MOV DH, 9
    MOV DL, 4
    CALL SET_CURSOR
    LEA DX, lbl_name
    CALL PRINT_STRING

    MOV DH, 10
    MOV DL, 4
    CALL SET_CURSOR
    LEA DX, lbl_email
    CALL PRINT_STRING

    MOV DH, 11
    MOV DL, 4
    CALL SET_CURSOR
    LEA DX, lbl_web
    CALL PRINT_STRING

    ; --- SECTION 2: MY FIRSTS ---
    MOV DH, 13
    MOV DL, 2
    CALL SET_CURSOR
    LEA DX, ART_FIRSTS
    CALL PRINT_STRING

    MOV DH, 14
    MOV DL, 4
    CALL SET_CURSOR
    LEA DX, lbl_achieve
    CALL PRINT_STRING

    MOV DH, 15
    MOV DL, 4
    CALL SET_CURSOR
    LEA DX, lbl_risk
    CALL PRINT_STRING

    MOV DH, 16
    MOV DL, 4
    CALL SET_CURSOR
    LEA DX, lbl_happy
    CALL PRINT_STRING

    ; --- SECTION 3: MY FAVES ---
    MOV DH, 18
    MOV DL, 2
    CALL SET_CURSOR
    LEA DX, ART_FAVES
    CALL PRINT_STRING

    MOV DH, 19
    MOV DL, 4
    CALL SET_CURSOR
    LEA DX, lbl_color
    CALL PRINT_STRING

    MOV DH, 20
    MOV DL, 4
    CALL SET_CURSOR
    LEA DX, lbl_perfume
    CALL PRINT_STRING

    MOV DH, 21
    MOV DL, 4
    CALL SET_CURSOR
    LEA DX, lbl_song
    CALL PRINT_STRING

    MOV DH, 22
    MOV DL, 4
    CALL SET_CURSOR
    LEA DX, lbl_food
    CALL PRINT_STRING

    ; Wait for keypress to proceed to Page 2
    MOV DH, 24
    MOV DL, 20
    CALL SET_CURSOR
    LEA DX, msg_press_key
    CALL PRINT_STRING
    MOV AH, 07H     ; Direct key input without echo
    INT 21H

    ; --------------------------------------------------------------------------
    ; PAGE 2: HOBBIES, MEDIA, AMBITION & MOTTO
    ; --------------------------------------------------------------------------
    CALL CLEAR_SCREEN

    ; Print Banner on Page 2
    MOV DH, 0
    MOV DL, 0
    CALL SET_CURSOR
    LEA DX, ART_BANNER
    CALL PRINT_STRING

    ; --- SECTION 4: HOBBIES & MEDIA ---
    MOV DH, 8
    MOV DL, 2
    CALL SET_CURSOR
    LEA DX, ART_HOBBIES
    CALL PRINT_STRING

    MOV DH, 9
    MOV DL, 4
    CALL SET_CURSOR
    LEA DX, lbl_music
    CALL PRINT_STRING

    MOV DH, 10
    MOV DL, 4
    CALL SET_CURSOR
    LEA DX, lbl_weekend
    CALL PRINT_STRING

    MOV DH, 11
    MOV DL, 4
    CALL SET_CURSOR
    LEA DX, lbl_tv
    CALL PRINT_STRING

    MOV DH, 12
    MOV DL, 4
    CALL SET_CURSOR
    LEA DX, lbl_book
    CALL PRINT_STRING

    MOV DH, 13
    MOV DL, 4
    CALL SET_CURSOR
    LEA DX, lbl_celeb
    CALL PRINT_STRING

    MOV DH, 14
    MOV DL, 4
    CALL SET_CURSOR
    LEA DX, lbl_role
    CALL PRINT_STRING

    ; --- SECTION 5: AMBITION & MOTTO ---
    MOV DH, 16
    MOV DL, 2
    CALL SET_CURSOR
    LEA DX, ART_FUTURE
    CALL PRINT_STRING

    MOV DH, 17
    MOV DL, 4
    CALL SET_CURSOR
    LEA DX, lbl_ambition
    CALL PRINT_STRING

    MOV DH, 18
    MOV DL, 4
    CALL SET_CURSOR
    LEA DX, lbl_motto
    CALL PRINT_STRING

    ; Final Page Footer
    MOV DH, 21
    MOV DL, 18
    CALL SET_CURSOR
    LEA DX, msg_end
    CALL PRINT_STRING

    ; Terminate Program
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; ------------------------------------------------------------------------------
; HELPER ROUTINES
; ------------------------------------------------------------------------------

; Sets Cursor Position using BIOS Service INT 10h, Function 02h
; Input: DH = Row Coordinate (0-24), DL = Column Coordinate (0-79)
SET_CURSOR PROC
    MOV AH, 02H
    MOV BH, 00H     ; Display Page 0
    INT 10H
    RET
SET_CURSOR ENDP

; Prints a '$'-terminated string using DOS Service INT 21h, Function 09h
PRINT_STRING PROC
    MOV AH, 09H
    INT 21H
    RET
PRINT_STRING ENDP

; Clears the screen and sets attribute using BIOS Service INT 10h, Function 06h
CLEAR_SCREEN PROC
    MOV AH, 06H
    MOV AL, 00H     ; Clear full screen area
    MOV BH, 1FH     ; White text (F) on Dark Blue background (1)
    MOV CX, 0000H   ; Top-left corner (Row 0, Col 0)
    MOV DX, 184FH   ; Bottom-right corner (Row 24, Col 79)
    INT 10H
    RET
CLEAR_SCREEN ENDP

END MAIN