SECTION WRAM 0

BGScroll.Top::
        DS 1
    .Bottom::
        DS 1

SECTION ROM 1

; Game-Background Map Consts
    ; Nothing
    #set S__ = 0 
    ; ground
    #set SXX = 1
    #set SGG = 3

    ; cloud:
    #set SC0 = 20
    #set SC1 = SC0 + 1
    #set SC2 = SC0 + 2
    #set SC3 = SC0 + 3
    #set SC4 = SC0 + 4
    #set SC5 = SC0 + 5
    #set SC6 = SC0 + 6
    #set SC7 = SC0 + 7

    #set U_S = SPRT_SCORE
    #set U_C = SPRT_SCORE + 1
    #set U_O = SPRT_SCORE + 2
    #set U_R = SPRT_SCORE + 3
    #set U_E = SPRT_SCORE + 4
    #set U__ = SPRT_SCORE + 5
    #set U00 = SPRT_SCORE + 6


INITIAL_BG_MAP::
        DB U_S,U_C,U_O,U_R,U_E,U__,U00,U00,U00,U00,SXX,SXX,SXX,SXX,SXX,SXX,SXX,SXX,SXX,SXX,SXX,SXX,SXX,SXX,SXX,SXX,SXX,SXX,SXX,SXX,SXX,SXX ; Row 0 | WND
        DB S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,SC0,SC2,SC4,SC6,S__,S__,S__,S__,S__,S__,S__ ; Row 1
        DB S__,SC0,SC2,SC4,SC6,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,SC1,SC3,SC5,SC7,S__,S__,S__,S__,S__,S__,S__ ; Row 2
        DB S__,SC1,SC3,SC5,SC7,S__,S__,S__,S__,S__,S__,S__,SC0,SC2,SC4,SC6,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__ ; Row 3
        DB S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,SC1,SC3,SC5,SC7,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__ ; Row 4
        DB S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__ ; Row 5
        DB S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__ ; Row 6
        DB S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__ ; Row 7
        DB S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__ ; Row 8
        DB S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__ ; Row 9
        DB S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__ ; Row 10
        DB S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__ ; Row 11
        DB S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__ ; Row 12
        DB S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__ ; Row 13
        DB S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__ ; Row 14
        DB S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__ ; Row 15
        DB S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__,S__ ; Row 16
        DB SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG,SGG ; Row 17
    .BGEND::
        DS 0
    #set BG_MAP_SIZE = .BGEND - INITIAL_BG_MAP


MACRO CopyBGMap %size, %target, %source, %palMap
        ; Init GB Color 
        LD   A, 1
        LDH  [VBK], A

        LD   DE, (%size + $0100)
        LD   BC, %target
        LD   HL, %source
        ; Apply Sprite Attributes for the BG Map.
    .spriteAttrLoop:
        LD   A, [HL++]
        PUSH HL
        PUSH DE
        LD   HL, %palMap
        LD   D, 0
        LD   E, A
        ADD  HL, DE
        LD   A, [HL]
        POP  DE
        POP  HL

        LD   [BC], A
        INC  BC
        DEC  E
        JR   nz, .spriteAttrLoop
        DEC  D
        JR   nz, .spriteAttrLoop
        ; Switch back to Video Memory Bank 0
        LD   A, 0
        LDH  [VBK], A


        ; Copy Tile Data
        LD   DE, (%size)
        LD   BC, %target
        LD   HL, %source

        MemCopy16

MEND




SECTION ROM 0

InitBGMap::
        CopyBGMap BG_MAP_SIZE, $9800, INITIAL_BG_MAP, BG_PALETTE_MAP
        RET