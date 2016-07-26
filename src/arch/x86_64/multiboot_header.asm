section .multiboot_header
header_start:
dd 0xE85250D6                       ; MultiBoot Magic Number
dd 0                                ; Architecture - i386
dd header_end - header_start        ; Header Size Checksum

dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start))

; insert optional multiboot tags here

; required end tag
dw 0    ; type
dw 0    ; flags
dd 8    ; size
header_end:
