; initialize and begin precesses once in long mode
global init_lm

section .text
bits 64
init_lm:
    ; print `OKAY` to screen
    mov rax, 0x2f592f412f4b2f4f
    mov qword [0xb8000], rax
    hlt
