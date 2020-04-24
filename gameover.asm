SECTION ROM 1

GameOverTiles::
#INCLUDE "images/gameover.inc"
    .Score::
#INCLUDE "images/gameover_score.inc"
    
    .Bird::
        DS 16    ; Bird Sprite must be a multiple of 2
#INCLUDE "images/gameover_bird.inc"
    .End::
        DS 0
    

GameOverMap::
#INCLUDE "images/gameover_map.inc"
    .End::
        DS 0

GameOverPalettes::
    #SET PCloud = 0
        RGB $FF, $FF, $FF
        RGB $E3, $E7, $FF
        RGB $7D, $86, $C7
        RGB $24, $31, $9F
    #SET PPole = 1
        RGB $C5, $CC, $DE
        RGB $32, $87, $42
        RGB $98, $9D, $AB
        RGB $7D, $9C, $FF
    #SET PSign = 2
        RGB $FF, $FF, $FF
        RGB $ED, $ED, $1F
        RGB $30, $62, $30
        RGB $7D, $9C, $FF
    #set PFloor = 3
        RGB $FF, $FF, $FF
        RGB $32, $87, $42
        RGB $54, $BA, $67
        RGB $0F, $42, $19
    #set PScore = 4
        RGB $FF, $FF, $FF
        RGB $FF, $FF, $FF
        RGB $30, $62, $30
        RGB $FF, $FF, $FF
    .End::
        DS 0
#set GameOverPalettesSize = GameOverPalettes.End - GameOverPalettes



GameOverPaletteMap::
        DB PCloud, PFloor, PCloud, PCloud, PFloor, PCloud, PCloud, PCloud, PCloud, PSign,  PSign,  PSign,  PCloud, PCloud, PSign,  PSign ; $00 - $0F
        DB PSign,  PPole,  PPole,  PSign,  PSign,  PSign,  PSign,  PSign,  PSign,  PSign,  PSign,  PSign,  PSign,  PSign,  PSign,  PSign ; $10 - $1F
        DB PSign,  PSign,  PSign,  PSign,  PSign,  PSign,  PSign,  PSign,  PSign,  PSign,  PSign,  PSign,  PSign                         ; $20 - $2C
        
        ;  2D:  S  2E:  C  2F:  O  30:  R  31:  E  32:  :  33:  0  34:  1  35:  2  36:  3  37:  4  38:  5, 39:  6  3A:  7  3B:  8  3C  9
        DB PScore, PScore, PScore, PScore, PScore, PScore, PScore, PScore, PScore, PScore, PScore, PScore, PScore, PScore, PScore, PScore

GAMEOVER_OAM::
        DB $78, $88, $3E, $00
        DB $78, $90, $40, $00
    .End::
        DS 0

GAMEOVER_ANI::
        DB $40, $40, $40, $40, $42
    .End::
        DS 0

SECTION WRAM 0
GAMEOVER_FRAME::
        DS 1

SECTION ROM 0

GameOver::
    
        ; Remove LCDStat and VBlank Interrupt
        DI 
        XOR  A
        LD   [IE], A 
        LDH  [SCX], A ; Scroll BG
        LDH  [SCY], A ; Scroll BG
        LD   [GAMEOVER_FRAME], A
        DISPLAY_OFF
        
GameOver_CopyTiles:
        LD   DE, (GameOverTiles.End - GameOverTiles)
        LD   BC, $8000
        LD   HL, GameOverTiles
        MemCopy16

GameOver_InitPalettes:
        LD   A, $E4
        LDH  [BGP],  A     ; Set BG Pal 
        LDH  [OBP0], A     ; Set Object Pal 0
        LDH  [OBP1], A     ; Set Object Pal 1

        ; GBC Background Palettes
        LD   A, $80
        LDH  [BGPI], A
        LDH  [OBPI], A

        LD   HL, OBJ_PALETTES
        LD   B, (4*2)
    .OBPLoop:
        LD   A, [HL++]
        LDH  [OBPD], A
        DEC  B
        JR   nz, .OBPLoop

        LD   HL, GameOverPalettes
        LD   B, GameOverPalettesSize
    .BGPLoop:
        LD   A, [HL++]
        LDH  [BGPD], A
        DEC  B
        JR   nz, .BGPLoop


GameOver_CopyMap:

        CopyBGMap (GameOverMap.End - GameOverMap), $9800, GameOverMap, GameOverPaletteMap

GameOver_SpriteLayer:
        LD   HL, $FE00
        XOR  A
        LD   B, 40
        LD   DE, 4
    .Loop:
        LD   [HL], A
        ADD  HL, DE
        DEC  B
        JR nz, .Loop

        LD   BC, $FE00
        LD   HL, GAMEOVER_OAM
        LD   E, (GAMEOVER_OAM.End - GAMEOVER_OAM)
        MemCopy8
       


GameOver_ShowScore:
        DrawScore $33, $98AB

        ; Enable Display with 16x8 Tiles.
        ; Bit 0: Background and window display on/off
        ; Bit 1: Sprite layer on/off
        ; Bit 2: Sprite size (0: 8x8, 1: 8x16)
        ; Bit 3: Background tile map select (0: $9800-$9bff, 1: $9c00-$9fff)
        ; Bit 4: Background and window tile data select (0: $8800-$97ff, 1: $8000-$8fff)
        ; Bit 5: Window display on/off
        ; Bit 6: Window tile map select (0: $9800-$9bff, 1: $9c00-$9fff)
        ; Bit 7: Display on/off
        LD   A, 0b1001_0111
        LDH  [LCDC], A


        LD   A, IRQ_VBlank
        LDH  [IE], A

    .Loop:
        EI
        CALL wait_vbl_done
        DI

    ; check Input
        LD   A, 0b0001_0000
        LD   [JOYP], A 
        LD   A,[JOYP]
        LD   A,[JOYP]
        BIT 3, A
        JP z, NewGame

    ; Inc Frame Counter
        LD   HL, FrameNo
        INC  [HL]                   ; Inc the FrameNo Counter

        LD   A, [HL]
        AND 7
        JR nz, .Loop

        LD HL, GAMEOVER_FRAME
        INC [HL]
        LD A, [HL]
        CP (GAMEOVER_ANI.End - GAMEOVER_ANI)
        JR nz, .SetImg

        XOR A
        LD [HL], A

    .SetImg:
        LD D, 0
        LD E, A
        LD HL, GAMEOVER_ANI
        ADD HL, DE
        LD A, [HL]
        LD [$FE00+4+2], A

        JP .Loop