;; Errors
;;  1 - No MultiBoot
;;  2 - No CPUID
global start    ; Point of Entry for korn

section .text
bits 32

; The entry point of the Omega kernel
start:
  ; Position the stack pointer in .bss
  mov esp, stack_top

  call  initialize

  ; Print OK in the VGA buffer
  mov dword [0xb8000], 0x2f4b2f4f
  hlt


initialize:
  call boot_check

boot_check:
  call check_multiboot
  call check_cpuid
  call check_long_mode


;Verify multiboot by looking for the magic number in eax
check_multiboot:
  cmp eax, 0x36d76289
  jne .no_multiboot
  ret

;Respond to a failure to verify a multiboot boot loader
no_multiboot:
  mov al, "1"
  jmp error
  ret

; Check if CPUID is supported by attempting to flip the ID bit (bit 21)
; in the FLAGS register. If we can flip it, CPUID is available.
check_cpuid:

  ; Copy FLAGS in to EAX via stack
  pushfd
  pop eax

  ; Copy to ECX as well for comparing later on
  mov ecx, eax

  ; Flip the ID bit
  xor eax, 1 << 21

  ; Copy EAX to FLAGS via the stack
  push eax
  popfd

  ; Copy FLAGS back to EAX (with the flipped bit if CPUID is supported)
  pushfd
  pop eax

  ; Restore FLAGS from the old version stored in ECX (i.e. flipping the
  ; ID bit back if it was ever flipped).
  push ecx
  popfd

  ; Compare EAX and ECX. If they are equal then that means the bit
  ; wasn't flipped, and CPUID isn't supported.
  cmp eax, ecx
  je .no_cpuid
  ret
.no_cpuid:
  mov al, "2"
  jmp error

; Check for LM and error if not
check_long_mode:
    ; test if extended processor info in available
    mov eax, 0x80000000    ; implicit argument for cpuid
    cpuid                  ; get highest supported argument
    cmp eax, 0x80000001    ; it needs to be at least 0x80000001
    jb .no_long_mode       ; if it's less, the CPU is too old for long mode

    ; use extended info to test if long mode is available
    mov eax, 0x80000001    ; argument for extended processor info
    cpuid                  ; returns various feature bits in ecx and edx
    test edx, 1 << 29      ; test if the LM-bit is set in the D-register
    jz .no_long_mode       ; If it's not set, there is no long mode
    ret
.no_long_mode:
    mov al, "2"
    jmp error

; Prints an error (ERR: al) in white text with a red background
error:
      mov dword [0xb8000], 0x4f524f45
      mov dword [0xb8004], 0x4f3a4f52
      mov dword [0xb8008], 0x4f204f20
      mov byte  [0xb800a], al
      hlt



; Reserve space for the stack
.bss:
stack_bottom:
  resb 64
stack_top:
