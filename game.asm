SECTION WRAM 0
FrameNo::
    DS 1


SECTION ROM 0


NewGame::
        DI
        DISPLAY_OFF

        LD   A, 0
        LDH  [SCX], A             ; Window Scroll X = 0

        CALL InitializePalettes
        CALL CopyTilesAndOAM
        CALL InitBGMap
        CALL InitBird
        CALL InitPipes

        ; Enable Display with 16x8 Tiles.
        ; Bit 0: Background and window display on/off
        ; Bit 1: Sprite layer on/off
        ; Bit 2: Sprite size (0: 8x8, 1: 8x16)
        ; Bit 3: Background tile map select (0: $9800-$9bff, 1: $9c00-$9fff)
        ; Bit 4: Background and window tile data select (0: $8800-$97ff, 1: $8000-$8fff)
        ; Bit 5: Window display on/off
        ; Bit 6: Window tile map select (0: $9800-$9bff, 1: $9c00-$9fff)
        ; Bit 7: Display on/off
        LD   A, 0b1011_0111
        LDH  [LCDC], A

        ; Setup Window Position
        LD   A, 0
        LDH  [WX], A
        LD   A, 136
        LDH  [WY], A
        LD   A, 8
        LDH  [SCY], A ; Scroll BG

        ; Enable Vblank and LCDStat Interrupts
        LD   A, (IRQ_VBlank|IRQ_LCDStat)
        LDH  [IE], A

        LD   A, (4 * 8); Coincidence Interrupt on Line
        LDH  [LYC], A

        ; Stat Register
        ; Bit 6 - LYC=LY Coincidence Interrupt (1=Enable) (Read/Write)
        ; Bit 5 - Mode 2 OAM Interrupt         (1=Enable) (Read/Write)
        ; Bit 4 - Mode 1 V-Blank Interrupt     (1=Enable) (Read/Write)
        ; Bit 3 - Mode 0 H-Blank Interrupt     (1=Enable) (Read/Write)
        ; Bit 2 - Coincidence Flag  (0:LYC<>LY, 1:LYC=LY) (Read Only)
        ; Bit 1-0 - Mode Flag       (Mode 0-3, see below) (Read Only)
        LD   A, 0b0100_0000 ; Request Coincidence Interrupt
        LDH  [STAT], A

        ; Continue with GameLoop


GameLoop:
        EI
        CALL wait_vbl_done
        DI

        CALL HRAM_DMA               ; Copy Shadow OAM to actual OAM

        LD   HL, FrameNo
        INC  [HL]                   ; Inc the FrameNo Counter

        LD   HL, Bird.Flags
        BIT  BFL_LANDED, [HL]
        JR   nz, GameOver           ; Bird is Dead and has landed. go to game over...

        CALL UpdatePipes            ; Update Pipe Position and generate new Pipes
        CALL BirdUpdate             ; Update Bird.

        CALL CheckScore

        LD   HL, BGScroll.Bottom
        INC  [HL]
        LD   A, [FrameNo]
        AND  7                      ; <-- Cloud scroll speed
        JR   nz, .ApplyScroll

        LD   HL, BGScroll.Top
        INC  [HL]
    .ApplyScroll:
        LD   A, [ BGScroll.Top]
        LDH  [SCX], A ; Scroll BG

        JR   GameLoop


GameOver:
        ; Remove LCDStat and VBlank Interrupt
        DI 
        XOR  A
        LD   [IE], A 

        ; Apply Top Scrolling to the BG...
        LD A, [ BGScroll.Top]
        LDH [SCX], A ; Scroll BG


        JP NewGame