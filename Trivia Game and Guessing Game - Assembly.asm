.MODEL small
.STACK 100h
.386
.data

    ;##########################################################################################################################
    ;################################################  MENU VARIABLES  ########################################################
    ;##########################################################################################################################

    menu_msg db         'CPE 412 - 8086 MASM Assembly Games','$'
    menu_dev db         'Prepared by DAISY MARIE P BERNANTE','$'
    menu_instruct db    'SELECT A GAME','$'
    menu_game1 db       ' TRIVIA GAME - "PRESS 1"','$'
    menu_game2 db       'GUESSING GAME - "PRESS 2"','$'
    menu_exit db        'EXIT DOSBOX - "PRESS 3"','$'

    menu_key db 0

    ;##########################################################################################################################
    ;###############################################  TRIVIA VARIABLES  ######################################################
    ;##########################################################################################################################

    trivia_menu db       '      WELCOME TO TRIVIA GAME','$'
    trivia_key1 db       '     PRESS "SPACE" TO PROCEED!','$'
    trivia_key2 db       '        PRESS "1" TO RETURN','$'
    trivia_key3 db       '      PRESS "1" TO PLAY AGAIN','$'
    
    trivia1 db           'What is the smallest unit of data','$'
    trivia2 db           '          in a computer?','$'

    trivia3 db           'What programming language shares its','$'
    trivia4 db           ' name with an island in Indonesia?','$'

    trivia5 db           '  What type of computer memory is','$'
    trivia6 db           'non-volatile and can be electrically','$'
    trivia7 db           '     erased and reprogrammed?','$'

    trivia8 db           'Which company introduced the first','$'
    trivia9 db           '        personal computer?','$'

    trivia10 db          'Preferred language for AI and ML?','$'

    answer1 db 'BIT', 50-($-answer1) dup ('$')
    answer2 db 'JAVA', 50-($-answer2) dup ('$')
    answer3 db 'FLASH', 50-($-answer3) dup ('$')
    answer4 db 'IBM', 50-($-answer4) dup ('$')
    answer5 db 'PYTHON', 50-($-answer5) dup ('$')

    answer_msg db 'Your Answer: ','$'
    correct_ans db 'Your answer is Correct','$'
    mistake_ans db 'Your answer is Mistake','$'

    game_greet db 'CONGRATS! YOU FINISH THE TRIVIA GAME','$'

    key_trivia db 0

    trivia_answer label byte
    maxlen db 50
    actlen db ?
    kybd db 51 dup ('$')

    ;##########################################################################################################################
    ;############################################  GUESSING GAME VARIABLES  ###################################################
    ;##########################################################################################################################

    number      db  169d    ;variable 'number' stores the random value
 
    ;declarations used to add LineBreak to strings
    CR          equ 13d
    LF          equ 10d
 
    ;String messages used through the application
    prompt      db  CR, LF,'Please enter a valid number : $'
    lessMsg     db  CR, LF,'Value if Less ','$'
    moreMsg     db  CR, LF,'Value is More ', '$'
    equalMsg    db  CR, LF,'You have made fine Guess!', '$'
    overflowMsg db  CR, LF,'Error - Number out of range!', '$'
    retry       db  CR, LF,'Retry [y/n] ? ' ,'$'
 
    guess       db  0d      ;variable user to store value user entered
    errorChk    db  0d      ;variable user to check if entered value is in range
 
    param       label Byte

.code
MAIN proc near
    mov ax, @data
	mov ds, ax
    
    call clear_screen
    Call video_mode

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 5 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
	lea dx, menu_msg
	int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 7 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
	lea dx, menu_dev
	int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 11 		; ROW
    mov dl, 13 		; COLUMN
    int 10h

    mov ah, 09h
	lea dx, menu_instruct
	int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 15 		; ROW
    mov dl, 7 		; COLUMN
    int 10h

    mov ah, 09h
	lea dx, menu_game1
	int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 17 		; ROW
    mov dl, 7 		; COLUMN
    int 10h

    mov ah, 09h
	lea dx, menu_game2
	int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 19 		; ROW
    mov dl, 8 		; COLUMN
    int 10h

    mov ah, 09h
	lea dx, menu_exit
	int 21h

    mov ah, 00h
    int 16h
    mov menu_key, al

    cmp menu_key, '1'
    je PLAY_TRIVIA
    cmp menu_key, '2'
    je PLAY_GUESS
    cmp menu_key, '3'
    je EXIT_DOSBOX

    cmp menu_key, '1'
    jne MENU_INVALID_KEY
    cmp menu_key, '2'
    jne MENU_INVALID_KEY
    cmp menu_key, '3'
    jne MENU_INVALID_KEY

PLAY_TRIVIA:
    JMP TRIVIA_START

PLAY_GUESS:
    call clear_screen
    call video_mode
    call GUESS_START
    jmp MAIN

EXIT_DOSBOX:
    call exit_program

MENU_INVALID_KEY:
    jmp MAIN

    ;##########################################################################################################################
    ;################################################  TRIVIA PROCEDURE  ######################################################
    ;##########################################################################################################################

TRIVIA_START:
    call clear_screen
    call video_mode

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 5 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia_menu
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 8 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia_key1
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 10 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia_key2
    int 21h

    mov ah, 00h
    int 16h
    mov key_trivia, al

    cmp key_trivia, '1'
    je TRIVIA_RETMENU
    cmp key_trivia, ' '
    je TRIVIA_PLAY

    cmp key_trivia, '1'
    jne TRIVIA_AGAIN
    cmp key_trivia, ' '
    jne TRIVIA_AGAIN

TRIVIA_AGAIN:
    jmp TRIVIA_START

TRIVIA_RETMENU:
    jmp MAIN

TRIVIA_PLAY:
    CALL clear_screen
    CALL video_mode

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 5 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia1
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 7 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia2
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 12 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, answer_msg
    int 21h

    mov ah, 0ah
    lea dx, trivia_answer
    int 21h

    lea si, [kybd]
    lea di, [answer1]
    mov ch, 00h
    mov cl, actlen

    jmp COMP_1

MISTAKE_1:
    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 16 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, mistake_ans
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 18 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia_key1
    int 21h

    mov ah, 00h
    int 16h
    mov key_trivia, al

    cmp key_trivia, ' '
    je LEVEL_1_RET
    cmp key_trivia, ' '
    jne MISTAKE_1

LEVEL_1_RET:
    jmp TRIVIA_PLAY

COMP_1:
    mov ah, [si]
	mov al, [di]
	cmp ah, al      ; comparison section
	jne MISTAKE_1
	inc si
	inc di
	loop COMP_1

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 16 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, correct_ans
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 18 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia_key1
    int 21h

    mov ah, 00h
    int 16h
    mov key_trivia, al

    cmp key_trivia, ' '
    je LEVEL_2
    cmp key_trivia, ' '
    jne COMP_1

LEVEL_2:
    CALL clear_screen
    CALL video_mode

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 5 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia3
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 7 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia4
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 12 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, answer_msg
    int 21h

    mov ah, 0ah
    lea dx, trivia_answer
    int 21h

    lea si, [kybd]
    lea di, [answer2]
    mov ch, 00h
    mov cl, actlen

    jmp COMP_2

MISTAKE_2:
    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 16 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, mistake_ans
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 18 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia_key1
    int 21h

    mov ah, 00h
    int 16h
    mov key_trivia, al

    cmp key_trivia, ' '
    je LEVEL_2_RET
    cmp key_trivia, ' '
    jne MISTAKE_2

LEVEL_2_RET:
    jmp LEVEL_2

COMP_2:
    mov ah, [si]
	mov al, [di]
	cmp ah, al      ; comparison section
	jne MISTAKE_2
	inc si
	inc di
	loop COMP_2

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 16 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, correct_ans
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 18 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia_key1
    int 21h

    mov ah, 00h
    int 16h
    mov key_trivia, al

    cmp key_trivia, ' '
    je LEVEL_3
    cmp key_trivia, ' '
    jne COMP_2

LEVEL_3:
    CALL clear_screen
    CALL video_mode

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 5 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia5
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 7 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia6
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 9 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia7
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 12 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, answer_msg
    int 21h

    mov ah, 0ah
    lea dx, trivia_answer
    int 21h

    lea si, [kybd]
    lea di, [answer3]
    mov ch, 00h
    mov cl, actlen

    jmp COMP_3

MISTAKE_3:
    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 16 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, mistake_ans
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 18 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia_key1
    int 21h

    mov ah, 00h
    int 16h
    mov key_trivia, al

    cmp key_trivia, ' '
    je LEVEL_3_RET
    cmp key_trivia, ' '
    jne MISTAKE_3

LEVEL_3_RET:
    jmp LEVEL_3

COMP_3:
    mov ah, [si]
	mov al, [di]
	cmp ah, al      ; comparison section
	jne MISTAKE_3
	inc si
	inc di
	loop COMP_3

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 16 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, correct_ans
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 18 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia_key1
    int 21h

    mov ah, 00h
    int 16h
    mov key_trivia, al

    cmp key_trivia, ' '
    je LEVEL_4
    cmp key_trivia, ' '
    jne COMP_3

LEVEL_4:
    CALL clear_screen
    CALL video_mode

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 5 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia8
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 7 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia9
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 12 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, answer_msg
    int 21h

    mov ah, 0ah
    lea dx, trivia_answer
    int 21h

    lea si, [kybd]
    lea di, [answer4]
    mov ch, 00h
    mov cl, actlen

    jmp COMP_4

MISTAKE_4:
    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 16 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, mistake_ans
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 18 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia_key1
    int 21h

    mov ah, 00h
    int 16h
    mov key_trivia, al

    cmp key_trivia, ' '
    je LEVEL_4_RET
    cmp key_trivia, ' '
    jne MISTAKE_4

LEVEL_4_RET:
    jmp LEVEL_4

COMP_4:
    mov ah, [si]
	mov al, [di]
	cmp ah, al      ; comparison section
	jne MISTAKE_4
	inc si
	inc di
	loop COMP_4

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 16 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, correct_ans
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 18 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia_key1
    int 21h

    mov ah, 00h
    int 16h
    mov key_trivia, al

    cmp key_trivia, ' '
    je LEVEL_5
    cmp key_trivia, ' '
    jne COMP_4

LEVEL_5:
    CALL clear_screen
    CALL video_mode

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 7 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia10
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 12 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, answer_msg
    int 21h

    mov ah, 0ah
    lea dx, trivia_answer
    int 21h

    lea si, [kybd]
    lea di, [answer5]
    mov ch, 00h
    mov cl, actlen

    jmp COMP_5

MISTAKE_5:
    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 16 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, mistake_ans
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 18 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia_key1
    int 21h

    mov ah, 00h
    int 16h
    mov key_trivia, al

    cmp key_trivia, ' '
    je LEVEL_5_RET
    cmp key_trivia, ' '
    jne MISTAKE_5

LEVEL_5_RET:
    jmp LEVEL_5

COMP_5:
    mov ah, [si]
	mov al, [di]
	cmp ah, al      ; comparison section
	jne MISTAKE_5
	inc si
	inc di
	loop COMP_5

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 16 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, correct_ans
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 18 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia_key1
    int 21h

    mov ah, 00h
    int 16h
    mov key_trivia, al

    cmp key_trivia, ' '
    je GAME_DONE
    cmp key_trivia, ' '
    jne COMP_5

GAME_DONE:
    CALL clear_screen
    CALL video_mode

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 7 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, game_greet
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 12 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia_key1
    int 21h

    mov ah, 02h		; set cursor
	mov bh, 00h		; PAGE NUMBER
    mov dh, 14 		; ROW
    mov dl, 3 		; COLUMN
    int 10h

    mov ah, 09h
    lea dx, trivia_key2
    int 21h

    mov ah, 00h
    int 16h
    mov key_trivia, al

    cmp key_trivia, ' '
    je RET_MAIN
    cmp key_trivia, '1'
    je RET_PLAY

    cmp key_trivia, ' '
    jne NOT_EQU
    cmp key_trivia, '1'
    jne NOT_EQU

RET_MAIN:
    jmp MAIN

RET_PLAY:
    jmp TRIVIA_PLAY

NOT_EQU:
    jmp GAME_DONE

    ;##########################################################################################################################
    ;################################################  GUESS PROCEDURE  #######################################################
    ;##########################################################################################################################

GUESS_START:
start:
 
    ; --- BEGIN resting all registers and variables to 0h
    MOV ax, 0h
    MOV bx, 0h
    MOV cx, 0h
    MOV dx, 0h
 
    MOV BX, OFFSET guess    ; get address of 'guess' variable in BX.
    MOV BYTE PTR [BX], 0d   ; set 'guess' to 0 (decimal)
 
    MOV BX, OFFSET errorChk ; get address of 'errorChk' variable in BX.
    MOV BYTE PTR [BX], 0d   ; set 'errorChk' to 0 (decimal)
    ; --- END resting
 
    MOV ax, @data           ; get address of data to AX
    MOV ds, ax              ; set 'data segment' to value of AX which is 'address of data'
    MOV dx, offset prompt   ; load address of 'prompt' message to DX
 
    MOV ah, 9h              ; Write string to STDOUT (for DOS interrupt)
    INT 21h                 ; DOS INT 21h (DOS interrupt)
 
    MOV cl, 0h              ; set CL to 0  (Counter)
    MOV dx, 0h              ; set DX to 0  (Data register used to store user input)
 
; -- BEGIN reading user input
while:
 
    CMP     cl, 5d          ; compare CL with 10d (5 is the maximum number of digits allowed)
    JG      endwhile        ; IF CL > 5 then JUMP to 'endwhile' label
 
    MOV     ah, 1h          ; Read character from STDIN into AL (for DOS interrupt)
    INT     21h             ; DOS INT 21h (DOS interrupt)
 
    CMP     al, 0Dh         ; compare read value with 0Dh which is ASCII code for ENTER key
    JE      endwhile        ; IF AL = 0Dh, Enter key pressed, JUMP to 'endwhile'
 
    SUB     al, 30h         ; Substract 30h from input ASCII value to get actual number. (Because ASCII 30h = number '0')
    MOV     dl, al          ; Move input value to DL
    PUSH    dx              ; Push DL into stack, to get it read to read next input
    INC     cl              ; Increment CL (Counter)
 
    JMP while               ; JUMP back to label 'while' if reached
 
endwhile:
; -- END reading user input
 
    DEC cl                  ; decrement CL by one to reduce increament made in last iteration
 
    CMP cl, 02h             ; compare CL with 02, because only 3 numbers can be accepted as IN RANGE
    JG  overflow            ; IF CL (number of input characters) is greater than 3 JUMP to 'overflow' label
 
    MOV BX, OFFSET errorChk ; get address of 'errorChk' variable in BX.
    MOV BYTE PTR [BX], cl   ; set 'errorChk' to value of CL
 
    MOV cl, 0h              ; set CL to 0, because counter is used in next section again
 
; -- BEGIN processing user input
 
; -- Create actual NUMERIC representation of
;--   number read from user as three characters
while2:
 
    CMP cl,errorChk
    JG endwhile2
 
    POP dx                  ; POP DX value stored in stack, (from least-significant-digit to most-significant-digit)
 
    MOV ch, 0h              ; clear CH which is used in inner loop as counter
    MOV al, 1d              ; initially set AL to 1   (decimal)
    MOV dh, 10d             ; set DH to 10  (decimal)
 
 ; -- BEGIN loop to create power of 10 for related possition of digit
 ; --  IF CL is 2
 ; --   1st loop will produce  10^0
 ; --   2nd loop will produce  10^1
 ; --   3rd loop will produce  10^2
 while3:
 
    CMP ch, cl              ; compare CH with CL
    JGE endwhile3           ; IF CH >= CL, JUMP to 'endwhile3
 
    MUL dh                  ; AX = AL * DH whis is = to (AL * 10)
 
    INC ch                  ; increment CH
    JMP while3
 
 endwhile3:
 ; -- END power calculation loop
 
    ; now AL contains 10^0, 10^1 or 10^2 depending on the value of CL
 
    MUL dl                  ; AX = AL * DL, which is actual positional value of number
 
    JO  overflow            ; If there is an overflow JUMP to 'overflow'label (for values above 300)
 
    MOV dl, al              ; move restlt of multiplication to DL
    ADD dl, guess           ; add result (actual positional value of number) to value in 'guess' variable
 
    JC  overflow            ; If there is an overflow JUMP to 'overflow'label (for values above 255 to 300)
 
    MOV BX, OFFSET guess    ; get address of 'guess' variable in BX.
    MOV BYTE PTR [BX], dl   ; set 'errorChk' to value of DL
 
    INC cl                  ; increment CL counter
 
    JMP while2              ; JUMP back to label 'while2'
 
endwhile2:
; -- END processing user input
 
    MOV ax, @data           ; get address of data to AX
    MOV ds, ax              ; set 'data segment' to value of AX which is 'address of data'
 
    MOV dl, number          ; load original 'number' to DL
    MOV dh, guess           ; load guessed 'number' to DH
 
    CMP dh, dl              ; compare DH and DL (DH - DL)
 
    JC greater              ; if DH (GUESS) > DL (NUMBER) cmparision will cause a Carry. Becaus of that if carry has been occured print that 'number is more'
    JE equal                ; IF DH (GUESS) = DL (NUMBER) print that guess is correct
    JG lower                ; IF DH (GUESS) < DL (NUMBER) print that number is less
 
equal:
 
    MOV dx, offset equalMsg ; load address of 'equalMsg' message to DX
    MOV ah, 9h              ; Write string to STDOUT (for DOS interrupt)
    INT 21h                 ; DOS INT 21h (DOS interrupt)
    JMP exit                ; JUMP to end of the program
 
greater:
 
    MOV dx, offset moreMsg  ; load address of 'moreMsg' message to DX
    MOV ah, 9h              ; Write string to STDOUT (for DOS interrupt)
    INT 21h                 ; DOS INT 21h (DOS interrupt)
    JMP start               ; JUMP to beginning of the program
 
lower:
 
    MOV dx, offset lessMsg  ; load address of 'lessMsg' message to DX
    MOV ah, 9h              ; Write string to STDOUT (for DOS interrupt)
    INT 21h                 ; DOS INT 21h (DOS interrupt)
    JMP start               ; JUMP to beginning of the program
 
overflow:
 
    MOV dx, offset overflowMsg ; load address of 'overflowMsg' message to DX
    MOV ah, 9h              ; Write string to STDOUT (for DOS interrupt)
    INT 21h                 ; DOS INT 21h (DOS interrupt)
    JMP start               ; JUMP to beginning of the program

exit: 
; -- Ask user if he needs to try again if guess was successful
retry_while:
    MOV dx, offset retry    ; load address of 'prompt' message to DX
    MOV ah, 9h              ; Write string to STDOUT (for DOS interrupt)
    INT 21h                 ; DOS INT 21h (DOS interrupt)
 
    MOV ah, 1h              ; Read character from STDIN into AL (for DOS interrupt)
    INT 21h                 ; DOS INT 21h (DOS interrupt)

    CMP al, 6Eh             ; check if input is 'n'
    JE return_to_DOS        ; call 'return_to_DOS' label is input is 'n'
 
    CMP al, 79h             ; check if input is 'y'
    JE restart              ; call 'restart' label is input is 'y' ..
                            ;   "JE start" is not used because it is translated as NOP by emu8086
 
    JMP retry_while         ; if input is neither 'y' nor 'n' re-ask the same question
 
retry_endwhile:
restart:
    JMP start               ; JUMP to begining of program

return_to_DOS:
    jmp MAIN

    ;##########################################################################################################################
    ;#################################################  MENU FUNCTIONS  #######################################################
    ;##########################################################################################################################

    clear_screen proc near
		mov ah, 06h
		mov al, 0
		mov bh, 07h
		mov cx, 0
		mov dx, 184fh
		int 10h
		RET
	clear_screen endp

	exit_program proc near
		mov ah, 00h
		mov al, 02h
		int 10h

		mov ah, 4Ch
		int 21h
	exit_program endp

	video_mode proc near
		mov ah, 00h
		mov al, 13h     ; video mode
		int 10h

   		mov ah, 0bh
		mov bh, 00h		 ; page number
		mov bl, 00h		 ; background color
		int 10h
		RET
	video_mode endp

MAIN endp
end MAIN