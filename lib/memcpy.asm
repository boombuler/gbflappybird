
; BC = Dest
; HL = Src
; E = Count
MACRO MemCopy8
    .mc8loop:
        LD   A, [HL++]
        LD   [BC], A
        INC  BC
        DEC  E
        JR   nz, .mc8loop
MEND

; BC = Dest
; HL = Src
; DE = Count
MACRO MemCopy16
        INC  D
    .mc16Loop:
        LD   A, [HL++]
        LD   [BC], A
        INC  BC
        DEC  E
        JR   nz, .mc16Loop
        DEC  D
        JR   nz, .mc16Loop
MEND