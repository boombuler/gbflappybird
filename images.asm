SECTION WRAM 0 @ $CF00

#set OAM_SIZE = 4
#set OAM_COUNT = 0

MACRO DIM_OAM %name 
    #set OAM_COUNT = OAM_COUNT + 1

    %name.Y:: 
            ds $01
         .X:: 
            ds $01
         .Tile:: 
            ds $01
         .Flags:: 
            ds $01
MEND

; Allocate Bird Object-Attributes
DIM_OAM BirdL
DIM_OAM BirdR


; Allocate Pipe Object-Attributes
#set PIPE1_START = OAM_COUNT
    DIM_OAM P1_L_TopCap
    DIM_OAM P1_L_BottomCap
    DIM_OAM P1_L_Floor
    DIM_OAM P1_L_Part0
    DIM_OAM P1_L_Part1
    DIM_OAM P1_L_Part2
    DIM_OAM P1_L_Part3
    DIM_OAM P1_L_Part4
    DIM_OAM P1_R_TopCap
    DIM_OAM P1_R_BottomCap
    DIM_OAM P1_R_Floor
    DIM_OAM P1_R_Part0
    DIM_OAM P1_R_Part1
    DIM_OAM P1_R_Part2
    DIM_OAM P1_R_Part3
    DIM_OAM P1_R_Part4
    DIM_OAM P1_Deko

#set PIPE2_START = OAM_COUNT
    DIM_OAM P2_L_TopCap
    DIM_OAM P2_L_BottomCap
    DIM_OAM P2_L_Floor
    DIM_OAM P2_L_Part0
    DIM_OAM P2_L_Part1
    DIM_OAM P2_L_Part2
    DIM_OAM P2_L_Part3
    DIM_OAM P2_L_Part4
    DIM_OAM P2_R_TopCap
    DIM_OAM P2_R_BottomCap
    DIM_OAM P2_R_Floor
    DIM_OAM P2_R_Part0
    DIM_OAM P2_R_Part1
    DIM_OAM P2_R_Part2
    DIM_OAM P2_R_Part3
    DIM_OAM P2_R_Part4
    DIM_OAM P2_Deko

ds 160-(OAM_SIZE * OAM_COUNT)


SECTION ROM 0


BG_PALETTES::
    #set BGP_Cloud = 0
        RGB $ff, $ff, $ff
        RGB $e3, $e7, $ff
        RGB $7d, $86, $c7
        RGB $24, $31, $9f

    #set BGP_Floor = 1
        RGB $ff, $ff, $ff
        RGB $54, $ba, $67
        RGB $32, $87, $42
        RGB $0f, $42, $19

    #set BGP_Pipe = 2
        RGB $ff, $ff, $ff
        RGB $54, $ba, $67
        RGB $32, $87, $42
        RGB $0f, $42, $19

    #set BGP_SCORE = 3
        RGB $0f, $42, $19
        RGB $8c, $f5, $9f
        RGB $0f, $42, $19
        RGB $0f, $42, $19
    .BGEND::
        DS 0
#set BG_PAL_SIZE = .BGEND - BG_PALETTES

OBJ_PALETTES::
    #set OBJP_Bird = 0
        RGB $ff, $ff, $ff
        RGB $de, $84, $1d
        RGB $ed, $ed, $1f
        RGB $5e, $0b, $0b

    #set OBJP_PIPE = 1
        RGB $FF, $FF, $FF
        RGB $8f, $7e, $5a
        RGB $85, $6b, $4a
        RGB $69, $4c, $21

    #set OBJ_PIPE_DEKO = 2
        RGB $FF, $FF, $FF
        RGB $85, $6b, $4a
        RGB $40, $ac, $33
        RGB $69, $4c, $21
    .OBJEND::
        DS 0
#set OBJ_PAL_SIZE = .OBJEND - OBJ_PALETTES



BG_PALETTE_MAP::
    DB BGP_Floor;  0: Empty
    DB BGP_Floor;  1: Black
    DB BGP_Floor;  2: Floor
    DB BGP_Floor;  3: EMPTY
    DB BGP_SCORE, BGP_SCORE, BGP_SCORE, BGP_SCORE, BGP_SCORE
    DB BGP_SCORE, BGP_SCORE, BGP_SCORE, BGP_SCORE, BGP_SCORE
    DB BGP_SCORE, BGP_SCORE
    ; 3-10: Cloud
    DB BGP_Cloud, BGP_Cloud, BGP_Cloud, BGP_Cloud, BGP_Cloud, BGP_Cloud 


SPRITE_GROUND:
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00    ; 0
DB $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff    ; 1
DB $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff    ; -- EMPTY
; Floor. Tile 2
#include "images/floor.inc"

#set SPRT_SCORE = 4
; 16 Tiles: Score:0123456789
#include "images/score.inc"

CLOUD:
; 8 Tiles: 18 - 27
#include "images/cloud.inc"

SPRITE_PIPE:
#set PIPE_SPRITE1 = 28
; 18 Tiles: 28 - 45
#include "images/log.inc"

SPRITE_BIRD:
#set BIRD_FRAME1 = 46
#set BIRD_FRAME2 = BIRD_FRAME1 + 4
#set BIRD_FRAME3 = BIRD_FRAME2 + 4
; 4 Tiles x 3 Frames
#include "images/bird.inc"



INITIAL_OAM:
; Initial Bird Position:
    #set InitialBirdTop = 40
    #set InitialBirdLeft = 40
        DB  (InitialBirdTop), (InitialBirdLeft+0), (BIRD_FRAME1 + 0), OBJP_Bird  ; Bird L
        DB  (InitialBirdTop), (InitialBirdLeft+8), (BIRD_FRAME1 + 2), OBJP_Bird  ; Bird R

#set PIPE_FLOOR = 133
        DB 0, 0, (PIPE_SPRITE1+4), OBJP_PIPE ; P1_L_TopCap
        DB 0, 0, (PIPE_SPRITE1+0), OBJP_PIPE ; P1_L_BottomCap
        DB PIPE_FLOOR, 0, (PIPE_SPRITE1+4), OBJP_PIPE; P1_L_Floor
        DB 0, 0, (PIPE_SPRITE1+2), OBJP_PIPE; P1_L_Part0
        DB 0, 0, (PIPE_SPRITE1+2), OBJP_PIPE; P1_L_Part1
        DB 0, 0, (PIPE_SPRITE1+2), OBJP_PIPE; P1_L_Part2
        DB 0, 0, (PIPE_SPRITE1+2), OBJP_PIPE; P1_L_Part3
        DB 0, 0, (PIPE_SPRITE1+2), OBJP_PIPE; P1_L_Part4
        DB 0, 0, (PIPE_SPRITE1+10), OBJP_PIPE ; P1_R_TopCap
        DB 0, 0, (PIPE_SPRITE1+ 6), OBJP_PIPE ; P1_R_BottomCap
        DB PIPE_FLOOR, 0, (PIPE_SPRITE1+10), OBJP_PIPE ; P1_R_Floor
        DB 0, 0, (PIPE_SPRITE1+ 8), OBJP_PIPE; P1_R_Part0
        DB 0, 0, (PIPE_SPRITE1+ 8), OBJP_PIPE; P1_R_Part1
        DB 0, 0, (PIPE_SPRITE1+ 8), OBJP_PIPE; P1_R_Part2
        DB 0, 0, (PIPE_SPRITE1+ 8), OBJP_PIPE; P1_R_Part3
        DB 0, 0, (PIPE_SPRITE1+ 8), OBJP_PIPE; P1_R_Part4
        DB 0, 0, (PIPE_SPRITE1+12), OBJ_PIPE_DEKO; P1_Deko


        DB 0, 0, (PIPE_SPRITE1+4), OBJP_PIPE ; P2_L_TopCap
        DB 0, 0, (PIPE_SPRITE1+0), OBJP_PIPE ; P2_L_BottomCap
        DB PIPE_FLOOR, 0, (PIPE_SPRITE1+4), OBJP_PIPE; P2_L_Floor
        DB 0, 0, (PIPE_SPRITE1+2), OBJP_PIPE; P2_L_Part0
        DB 0, 0, (PIPE_SPRITE1+2), OBJP_PIPE; P2_L_Part1
        DB 0, 0, (PIPE_SPRITE1+2), OBJP_PIPE; P2_L_Part2
        DB 0, 0, (PIPE_SPRITE1+2), OBJP_PIPE; P2_L_Part3
        DB 0, 0, (PIPE_SPRITE1+2), OBJP_PIPE; P2_L_Part4
        DB 0, 0, (PIPE_SPRITE1+10), OBJP_PIPE ; P2_R_TopCap
        DB 0, 0, (PIPE_SPRITE1+6), OBJP_PIPE ; P2_R_BottomCap
        DB PIPE_FLOOR, 0, (PIPE_SPRITE1+10), OBJP_PIPE; P2_R_Floor
        DB 0, 0, (PIPE_SPRITE1+8), OBJP_PIPE; P2_R_Part0
        DB 0, 0, (PIPE_SPRITE1+8), OBJP_PIPE; P2_R_Part1
        DB 0, 0, (PIPE_SPRITE1+8), OBJP_PIPE; P2_R_Part2
        DB 0, 0, (PIPE_SPRITE1+8), OBJP_PIPE; P2_R_Part3
        DB 0, 0, (PIPE_SPRITE1+8), OBJP_PIPE; P2_R_Part4
        DB 0, 0, (PIPE_SPRITE1+14), OBJ_PIPE_DEKO; P2_Deko


        DS (40 - OAM_COUNT) * OAM_SIZE

InitializePalettes::
        LD   A, $E4
        LDH  [BGP],  A     ; Set BG Pal 
        LDH  [OBP0], A     ; Set Object Pal 0
        LDH  [OBP1], A     ; Set Object Pal 1

        ; GBC Background Palettes
        LD   A, $80
        LDH  [OBPI], A
        LDH  [BGPI], A

        LD   HL, BG_PALETTES
        LD   B, BG_PAL_SIZE
    .BGPLoop:
        LD   A, [HL++]
        LDH  [BGPD], A
        DEC  B
        JR   nz, .BGPLoop

        ; GBC Object Palettes
        LD   HL, OBJ_PALETTES
        LD   B, OBJ_PAL_SIZE

    .OBPLoop:
        LD   A, [HL++]
        LDH  [OBPD], A
        DEC  B
        JR   nz, .OBPLoop

        RET  ;

CopyTilesAndOAM::
        LD   DE, (INITIAL_OAM-SPRITE_GROUND)
        LD   BC, $8000
        LD   HL, SPRITE_GROUND

        MemCopy16

        LD   E, 160

        LD   BC, $CF00
        LD   HL, INITIAL_OAM
        
        MemCopy8

        RET


start_DMA:
        LD   A, $CF
        LDH  [$FF46], A
        ; DMA transfer begins, we need to wait 160 microseconds while it transfers
        ; the following loop takes exactly that long
        LD   A, $28
    .loop:
        DEC  A
        JR   nz, .loop
        RET  ;

CopyDMAToHRam::
        LD   E, (CopyDMAToHRam - start_DMA)
        LD   HL, start_DMA
        LD   BC, HRAM_DMA

        MemCopy8
        RET
