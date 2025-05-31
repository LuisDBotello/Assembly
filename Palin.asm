.model small
.stack 100h
.data
    msgPrompt         db 13,'Ingrese un string (maximo 100 caracteres): ',10,13,'$'
    msgIsPalindrome   db 10,10,13,'Es un palindromo.$'
    separador         db 10,13,'$'
    msgNotPalindrome  db 10,13,'No es un palindromo.$'
    msgInvalidChar    db 10,13,'El string contiene caracteres no alfanumericos. Intente nuevamente.$'
    msgAgain          db 10,13,'??Desea ingresar otro string? (s/n): $'
    msgFinal          db 10,13,'Hasta luego! $'
    buffer            db 100 dup('$')
    cleanStr          db 100 dup('$') 
    cleanStrLength    db 0           
    response          db ?
    
    ;Botello Lopez Luis Daniel
    ;Garcia Felix Gilberto
    ;Beltran Camacho Moises

.code
PRINT macro msg
    mov ah, 09h
    lea dx, msg
    int 21h
endm

READ_STRING macro buffer
    mov ah, 0Ah
    lea dx, buffer
    int 21h
endm

READ_VALID_CHAR macro var
validate_char:
    mov ah, 01h
    int 21h
    mov var, al
    cmp al, '0'
    jb not_alnum
    cmp al, '9'
    jbe valid_char
    cmp al, 'A'
    jb not_alnum
    cmp al, 'Z'
    jbe valid_char
    cmp al, 'a'
    jb not_alnum
    cmp al, 'z'
    jbe valid_char

not_alnum:
    PRINT msgInvalidChar
    jmp validate_char

valid_char:
endm

EXIT macro
    mov AH, 4Ch
    int 21h
endm

main:
    mov ax, @data
    mov ds, ax

start:
    PRINT msgPrompt
    READ_STRING buffer
    call clean_and_convert_string
    PRINT separador
    call display_reversed_string
    call is_palindrome
    call mostrar_resultado
    

ask_again:
    PRINT msgAgain
    READ_VALID_CHAR response
    cmp response, 's'
    je start
    cmp response, 'S'
    je start
    cmp response, 'n'
    je fin_prog
    cmp response, 'N'
    je fin_prog
    jmp ask_again

is_palindrome PROC
    mov si, offset cleanStr
    mov cl, cleanStrLength
    dec cl                   
    mov di, si
    mov ax, cx             
    add si, ax              

check_loop:
    mov al, [di]            
    mov bl, [si]             
    cmp al, bl
    jne not_palindrome
    inc di
    dec si
    cmp di, si
    jb check_loop

is_palindrome_true:
    mov al, 1
    ret

not_palindrome:
    mov al, 0
    ret

fin_prog PROC
    PRINT msgFinal
    EXIT
    endp
is_palindrome ENDP

mostrar_resultado PROC
    cmp al, 1
    je display_palindrome
    PRINT msgNotPalindrome
    jmp ask_again
    ENDP

display_palindrome:
    PRINT msgIsPalindrome
    jmp ask_again

clean_and_convert_string PROC
    mov si, offset buffer + 2
    mov di, offset cleanStr
    mov cl, [buffer + 1]

    mov bx, 0

clean_loop:
    mov al, [si]
    
    ; Convertir min??sculas a may??sculas
    cmp al, 'a'
    jb skip_char
    cmp al, 'z'
    ja skip_char
    sub al, 20h ; Convertir a may??scula

skip_char:
    ; Verifica si el car??cter es alfanum??rico
    cmp al, '0'
    jb next_char
    cmp al, '9'
    jbe store_char
    cmp al, 'A'
    jb next_char
    cmp al, 'Z'
    jbe store_char

next_char:
    inc si
    loop clean_loop
    jmp end_clean

store_char:
    mov [di], al
    inc di
    inc bx 
    jmp next_char

end_clean:
    mov cleanStrLength, bl  
    mov byte ptr [di], '$'   
    ret
clean_and_convert_string ENDP

display_reversed_string PROC
    mov si, offset cleanStr 
    mov cl, cleanStrLength 
    mov bx, cx 
    dec bx 

reverse_loop:
    mov al, [si + bx] 
    mov dl, al
    mov ah, 02h
    int 21h 
    dec bx
    jns reverse_loop 

    mov ah, 02h
    mov dl, 10
    int 21h
    ret
display_reversed_string ENDP

end main
