SECTIOn WRAM 0

NextPipeX::
        DS 1
NextPipeIdx::
        DS 1
GeneratedHolePos::
        DS 1

SECTION ROM 0

#set HOLE_SIZE = 55 
#set NumberOfPipes = 2
#set PIPE_SPRITE_COUNT = PIPE2_START - PIPE1_START

; Load a Pointer to the top cap of the left most pipe to the HL registers
MACRO GET_LEFT_PIPE
        LD   A, [NextPipeIdx]
        XOR  1
        LD   HL, P2_L_TopCap.Y
        JR   z, .GET_LEFT_PIPE_End
        LD   HL, P1_L_TopCap.Y
    .GET_LEFT_PIPE_End:
        NOP
MEND

; Loads the value of the A register to the left and the right tile 
; Requires a temporary 16 Bit register.
MACRO LOAD_BOTH_TILES_Y %reg
        LD   [HL], A
        LD   %reg, (8*OAM_SIZE)
        ADD  HL, %reg
        LD   [HL], A
        LD   %reg, (0-(8*OAM_SIZE))
        ADD  HL, %reg
MEND

;E = xPos
GeneratePipe::
        ; Select Pipe
        LD   A, [NextPipeIdx]
        XOR  1
        LD   [NextPipeIdx], A
        LD   HL, P2_L_TopCap.Y
        JR   z, .SelctPipeEnd
        LD   HL, P1_L_TopCap.Y
    .SelctPipeEnd:
        PUSH HL                 ; Push First Addr of selected Pipe to stack
    
    ; Setup X Positions
        INC  HL                  ; Move to X Pos Struct Index
        
        LD   BC, OAM_SIZE         ; Prepare ADD HL, BC to Jump to next OAM

        LD   D, 8                 ; Loop Count:  8x Left Side
    .SetLXpos:
        LD   [HL], E
        ADD  HL, BC
        DEC  D
        JR   nz, .SetLXpos

        LD   A, E
        ADD  A, 8

        LD   D, 8
    .SetRXPos:
        LD   [HL], A
        ADD  HL, BC
        DEC  D
        JR   nz, .SetRXPos
        
        ADD  A, 8
        LD   [HL], A

    ; Setup Y Pos
        CALL GetNextRndNum
        SRL  A
        SRL  A
        ADD  A, 16      ; A Contains a Value between 16 and 79

        LD   [GeneratedHolePos], A
        POP  HL
        PUSH HL

    ; Move All Misc To Y = 0
        LD   C, 5
        LD   A, 0
        LD   DE, (3*OAM_SIZE)
    .ClearLoop:
        ADD  HL, DE
        LOAD_BOTH_TILES_Y DE

        LD   DE, OAM_SIZE
        DEC  C
        JR   nz, .ClearLoop
        LD   DE, (0-(7*OAM_SIZE))
        ADD  HL, DE

    ; Setup Caps:
        LD   A, [GeneratedHolePos]

        ; Top L+R
        LOAD_BOTH_TILES_Y DE
        LD   DE, OAM_SIZE  
        ADD  HL, DE
        ADD  A, (HOLE_SIZE)
        ; Bottom L+R
        LOAD_BOTH_TILES_Y DE
        
        LD   DE, OAM_SIZE
        ADD  HL, DE          ; Skip Floor
        LD   A, [GeneratedHolePos]
        CP   17
        JR   c, .Bottom
    ; Setup Tiles Above Top Cap
    .FillTop:
        ADD  HL, DE
        ADD  A, (0-16)
        
        LOAD_BOTH_TILES_Y BC

        CP   16
        JR   nc, .FillTop

    ; Setup Tiles Below Bottom Cap
    GeneratePipe.Bottom:

        ADD  HL, DE
        LD   A, [GeneratedHolePos]
        ADD  A, (HOLE_SIZE+16) ; Bottom Of BottomCap
        
    .BottomLoop:
        CP   (PIPE_FLOOR + 1)
        JR   nc, .SetupDeko

        LOAD_BOTH_TILES_Y BC
        ADD  A, 16
        ADD  HL, DE  ; next Tile

        CP  (PIPE_FLOOR + 1)
        JR  c, .BottomLoop
    ; Setup Deko Sprite:
    .SetupDeko:
        LD   DE, ((0-3)*OAM_SIZE)
        ADD  HL, DE
        LD   A, [HL]
        ADD  A, 2
        POP  HL
        LD   DE, (16*OAM_SIZE)
        ADD  HL, DE
        LD   [HL], A
        RET  ;


InitPipes::
        LD   A, 0
        LD   [NextPipeIdx], A

        LD   E, 120
        CALL GeneratePipe
        LD   E, (120+92)
        CALL GeneratePipe
        RET  ;

UpdatePipes::
        ; Move All Pipe Spirtes 1 px to the left:
        LD   B, (2*PIPE_SPRITE_COUNT)

        LD   DE, OAM_SIZE      ; DE = Loop Increment
        
        LD   HL, P1_L_TopCap.X    ; Pipe1 Left TopCap is the first Sprite
    .Next:
        LD   A, [HL]
        ADD  A, (0-1)
        LD   [HL], A
        ADD  HL, DE
        DEC  B
        JR   nz, .Next

        ; Check If Left Pipe was Out Of Screen:
        GET_LEFT_PIPE
        ; Move To X offset of the last sprite
        LD   DE, (1+(OAM_SIZE * (PIPE_SPRITE_COUNT - 1)))
        ADD  HL, DE
        LD   A, [HL]
        CP   0
        LD   E, 168
        CALL z, GeneratePipe

        RET  ;
