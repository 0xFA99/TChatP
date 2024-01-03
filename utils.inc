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


