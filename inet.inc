; uint16_t htons(uint16_t hostshort);
htons:
    mov     rax, rdi
    ror     ax, 8
    ret

; TODO
; in_addr_t inet_addr(const char *cp);
; inet_addr:
