section .data
    msgGuess db 'Advinhe o numero: '
    lenGuess equ $ - msgGuess

    msgNumGreater db 'O numero inserido e maior que o numero secreto', 0xA
    lenNumGreater equ $ - msgNumGreater

    msgNumSmaller db 'O numero inserido e menor que o numero secreto', 0xA
    lenNumSmaller equ $ - msgNumSmaller

    msgWin db 'Voce acertou', 0xA
    lenWin equ $ - msgWin

section .bss
    userNum resb 0x3
    secretNum resb 0x3



section .text
    global _start

    _start:

    gameLoop:
        call generateNum

        mov eax, 0x4
        mov ebx, 0x1
        mov ecx, msgGuess
        mov edx, lenGuess
        int 0x80

        mov eax, 0x3
        mov ebx, 0x0
        mov ecx, userNum
        mov edx, 0x3
        int 0x80

        call convert


    convert:
        lea esi, [userNum]
        mov ecx, 0x2
        call stringToInt
        call verify


    stringToInt:
        xor ebx, ebx

        .nextDigit:
            movzx eax, byte[esi]
            inc esi
            sub al, '0'
            imul ebx, 0xA
            add ebx, eax
            loop .nextDigit
        ret

    verify:
        cmp DWORD[secretNum], ebx
        je youWin

        cmp DWORD[secretNum], eax
        jg greater

        mov ecx, msgNumSmaller
        mov edx, lenNumSmaller
        mov eax, 0x4
        mov ebx, 0x1
        int 0x80

        jmp gameLoop

    greater:
        mov ecx, msgNumGreater
        mov edx, lenNumGreater
        mov eax, 0x4
        mov ebx, 0x1
        int 0x80

        jmp gameLoop

    youWin:
        mov ecx, msgWin
        mov edx, lenWin
        mov eax, 0x4
        mov ebx, 0x1
        int 0x80

        jmp finish

    generateNum:
        mov ah, 0x0
        int 1ah
        
        mov ax, dx
        mov dx, 0x0
        mov bx, 0xA
        div bx
        mov byte[secretNum], al
        ret

    finish:
        mov eax, 0x1
        xor ebx, ebx
        int 0x80
