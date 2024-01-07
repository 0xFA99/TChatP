; rdi = fd
write_space:
    dec     rsp
    mov     byte [rsp], 32

    write   rdi, rsp, 1

    inc     rsp
    ret

; rdi = fd
write_newline:
    dec     rsp
    mov     byte [rsp], 10

    write   rdi, rsp, 1

    inc     rsp
    ret

; rdi = fd
; rsi = buf
write_cstr:
    push    rdi
    push    rsi

    mov     rdi, rsi
    call    strlen
    mov     rdx, rax

    pop     rsi
    pop     rdi

    write   rdi, rsi, rdx
    ret

; rdi = fd
; rsi = *buf
write_uint:
    test    rsi, rsi
    jz      .is_zero

    mov     rcx, 10
    mov     rax, rsi
    mov     r10, 0

.next_digit:
    test    rax, rax
    jz      .done

    mov     rdx, 0
    div     rcx
    add     rdx, '0'

    dec     rsp
    mov     byte [rsp], dl

    inc     r10
    jmp     .next_digit

.is_zero:
    dec     rsp
    mov     byte [rsp], '0'

    mov     rax, 1
    mov     rsi, rsp
    mov     rdx, 1
    syscall

    inc     rsp
    ret

.done:
    mov     rax, 1
    mov     rsi, rsp
    mov     rdx, r10
    syscall

    add     rsp, r10
    ret

