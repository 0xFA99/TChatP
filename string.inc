; rdi = buf
strlen:
    xor     eax, eax

.next_digit:
    cmp     byte [rdi], 0
    je      .return

    inc     rdi
    inc     rax
    jmp     .next_digit

.return:
    ret

