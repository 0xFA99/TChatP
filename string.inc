; size_t strlen(const char *s);
strlen:
    xor     rax, rax

.next_digit:
    cmp     byte [rdi], 0
    je      .return

    inc     rdi
    inc     rax
    jmp     .next_digit

.return:
    ret

