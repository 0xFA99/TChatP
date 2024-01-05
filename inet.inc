; uint16_t htons(uint16_t hostshort);
htons:
    movzx   eax, word [rdi]
    ror     ax, 8
    ret
