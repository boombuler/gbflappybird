MACRO RGB %r, %g, %b
        DW (%r >> 3) | ((%g >> 3) << 5) | ((%b >> 3) << 10)
MEND

; The following code was taken from the great gbdk-lib

SECTION WRAM 0

SCREEN.vbl_done::
        ds    $01        ; Is VBL interrupt finished?

SECTION ROM 0 @ $0040
        JP INTERRUPT_VBLANK

SECTION ROM 0

DISPLAY_OFF_IMPL::
        LDH  A, [LCDC]
        AND  0b1000_0000
        RET  Z                ; Return if screen is offL
    .l1:                      ; We wait for the *NEXT* VBL 
        LDH  A, [LY]
        CP   $92              ; Smaller than or equal to 0x91?
        JR   NC, .l1          ; Loop until smaller than or equal to 0x91
    .l2:
        LDH  A, [LY]
        CP   $91              ; Bigger than 0x90?
        JR   C, .l2           ; Loop until bigger than 0x90

        LDH  A, [LCDC]
        AND  0b01111111
        LDH  [LCDC], A        ; Turn off screen
        RET

MACRO DISPLAY_OFF
    CALL DISPLAY_OFF_IMPL
MEND


INTERRUPT_VBLANK::
    PUSH AF
    LD   A, 1
    LD   [SCREEN.vbl_done], A
    POP  AF
    RETI


wait_vbl_done::
        ;; Check if the screen is on
        LDH  A, [LCDC]
        ADD  A, A
        RET  NC                    ; Return if screen is off
        XOR  A
        DI
        LD  [SCREEN.vbl_done], A   ; Clear any previous sets of vbl_done
        EI
    .loop:
        HALT                       ; Wait for any interrupt
        NOP                        ; HALT sometimes skips the next instruction
        LD   A,[SCREEN.vbl_done]   ; Was it a VBlank interrupt?
        ;; Warning: we may lose a VBlank interrupt, if it occurs now
        OR   A
        JR   Z, .loop              ; No: back to sleep!

        XOR  A
        LD   [SCREEN.vbl_done],A
        RET