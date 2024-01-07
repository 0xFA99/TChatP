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

; int strcmp(const char *s1, const char *s2);
strcmp:
    mov     rcx, 0

.next_digit:
    mov     dl, byte [rdi + rcx]
    cmp     dl, byte [rsi + rcx]
    jnbe    .bigger
    jb      .lower

    cmp     dl, 0
    je      .equal

    inc     rcx
    jmp     .next_digit

.lower:
    mov     rax, -1
    ret

.equal:
    mov     rax, 0
    ret

.bigger:
    mov     rax, 1
    ret

; String to int
; rdi = str
stoi:
    xor     rax, rax
    mov     rcx, 10
    mov     r10, 0

.next_char:
    mov     dl, byte [rdi + r10]
    test    dl, dl
    jz      .return

    sub     dl, '0'

    add     rax, rdx
    mul     rcx

    inc     r10
    jmp     .next_char

.return:
    div     rcx
    ret
