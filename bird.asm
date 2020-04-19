SECTION WRAM 0

Bird.Ticks::
        ds  $01
    .Frame::
        ds  $01
    .Speed::
        ds $01
    .Flags::
        ds $01

        #set BFL_DEAD    = 0
        #set BFL_LANDED  = 1
        #set BFL_KeyDown = 2

SCORE::
        ds 2    ; 2 Bytes BCD Coded


SECTION ROM 0


#set MinGravUpd = 1
#set MaxGravUpd = 5
#set MaxNegSpeed = 12
#set BirdTickFreq = 4
#set BirdFrames = 4

BIRD_FRAMES::
        db BIRD_FRAME1, BIRD_FRAME2, BIRD_FRAME1, BIRD_FRAME3

InitBird::
        LD   A, BirdTickFreq
        LD   [Bird.Ticks], A

        XOR  A
        LD   HL, SCORE
        LD   [HL++], A
        LD   [HL], A
        LD   [Bird.Flags], A
        LD   [Bird.Frame], A
        LD   [Bird.Speed], A
        RET


KillBird:: 
        LD   A, (0-MaxNegSpeed)
        LD   [Bird.Speed], A
        LD   A, [Bird.Flags]
        OR   (1<<BFL_DEAD)
        LD   [Bird.Flags], A
        
        ; Flip Sprites
        LD   A, [BirdL.Flags]
        OR   0b0100_0000
        LD   [BirdL.Flags], A
        LD   [BirdR.Flags], A
        LD   A, (BIRD_FRAME3 + 2) ; Load dead eyes.
        LD   [BirdR.Tile], A
        RET


BirdUpdate::
    ; Check Input
        LD   A, 0b0001_0000
        LD   [JOYP], A 
        LD   A,[JOYP]
        LD   A,[JOYP]
        CPL
        AND  1
        SLA  A
        SLA  A
        LD   B, A
        LD   A, [Bird.Flags]
        AND  (~(1 << BFL_KeyDown))
        OR   B
        LD   [Bird.Flags], A

    .UpdateAnimation:
        ; Update Animation
        LD   HL, Bird.Ticks
        DEC  [HL]
        JR   nz, .EveryFrame
        LD   [HL], (BirdTickFreq-1)

        LD   HL, Bird.Flags
        BIT  (BFL_DEAD), [HL]
        JR   nz, .EveryFrame


        LD   HL, Bird.Frame
        INC  [HL]
        LD   A, [HL]
        CP   (BirdFrames)
        JR   nz, .ChangeImg
    .ResetAnimation:
        XOR  A
        LD   [HL], A

    .ChangeImg:
        JR   z, .EveryFrame
        LD   HL, BIRD_FRAMES
        LD   B, 0
        LD   C, A
        ADD  HL, BC
        LD   A, [HL]
        LD   [BirdL.Tile], A

    .EveryFrame:
        LD   A, [Bird.Ticks]
        AND  1
        RET  z   ; Skip every 2nd frame

    ; Apply Gravity
        LD   HL, Bird.Speed
        INC  [HL]

        LD   HL, Bird.Flags
        BIT  BFL_DEAD, [HL]
        JR   nz, .MoveDead
        ; Bird is not dead, check collisions and input

        CALL CheckCollision

        LD   HL, Bird.Flags

        BIT  BFL_KeyDown, [HL]
        JR   z , .MoveY

    .Jump:
        LD   A, [Bird.Speed]
        ADD  A, (0-3)
        LD   [Bird.Speed], A

        CALL GetNextRndNum  ; Call GetNextRndNum each frame a button is pressed, to increase randomness.
        
        JR .MoveY

    .MoveDead:
        BIT  BFL_LANDED, [HL] ; check Landed.
        JR   nz, .MoveY
        LD   HL, BirdL.X
        INC  [HL]
        LD   HL, BirdR.X
        INC  [HL]
    .MoveY:
        ; Bird.y += Bird.Speed / 4;
        LD   A, [Bird.Speed]
        SRA  A
        SRA  A
        LD   B, A
        LD   A, [BirdL.Y]
        ADD  A, B

        ; Check Top Edge
        ;if (Bird.y < 16) {
        ;       Bird.y = 16;
        ;       Bird.Speed = 0;
        ;}
        CP   16
        JR   nc, .CheckFloor 
        XOR  A
        LD   [Bird.Speed], A
        LD   A, 16

    .CheckFloor:
        CP   (PIPE_FLOOR + 2)
        JR   c, .UpdateSpriteY

        LD   A, (1<<BFL_LANDED)
        LD   [Bird.Flags], A
        CALL KillBird

        LD   A,  (PIPE_FLOOR + 2)

    .UpdateSpriteY:
        LD   [BirdL.Y], A
        LD   [BirdR.Y], A

    .CheckMaxGrav:
        LD   A, [Bird.Speed]
        BIT  7, A
        RET  z       ; Non Negative Number...

        CPL
        ADD  A, 1

        CP   MaxNegSpeed
        RET  c

        LD   A, (0-MaxNegSpeed)
        LD   [Bird.Speed], A

        RET ;


CheckScore::
        LD   HL, Bird.Flags
        BIT  BFL_DEAD, [HL]
        RET  nz

        LD   A, [NextPipeIdx]
        XOR  1
        LD   HL, P2_L_TopCap.X
        JR   z, .GetLeftPipeEnd
        LD   HL, P1_L_TopCap.X
    .GetLeftPipeEnd:
        LD   A, [HL]  ; A = Pipe.X
        CP   (InitialBirdLeft - 16)

        RET  nz

    .IncreaseScore:
        LD   HL, SCORE
        LD   A, [HL]
        ADD  A, 1
        DAA
        LD   [HL++], A
        JR   nc, .Digit_Ones

        LD   A, [HL]
        ADC  A, 0
        DAA
        LD   [HL], A

        #set WindowMapStart = $9800
        #set FirstDigit = WindowMapStart + 6
    ; Update Window Map.
    .Digit_Hundreds:
        AND  $0F
        ADD  A, (SPRT_SCORE+6)
        LD   [FirstDigit+1], A
    .Digit_Thousands:
        LD   A, [HL]
        SWAP A
        AND  $0F
        ADD  A, (SPRT_SCORE+6)
        LD   [FirstDigit], A
    .Digit_Ones:
        DEC  HL
        LD   A, [HL]
        AND  $0F
        ADD  A, (SPRT_SCORE+6)
        LD   [FirstDigit+3], A
    .Digit_Tens:
        LD   A, [HL]
        SWAP A
        AND  $0F
        ADD  A, (SPRT_SCORE+6)
        LD   [FirstDigit+2], A
        RET  ;


CheckCollision::
        ; Fail :=
        ;    (bird.x + 16)  >= LP.x && (bird.x <= (LP.x + 16) &&
        ;    (((bird.y+2) <= (TC.y + 16) || ((bird.y+14) >= (TC.Y + HOLE)
        GET_LEFT_PIPE
        ; HL Contains Pointer To Left-TopCap of the Leftmost Pipe
        ; So lets first check the Y constraint because HL is already on Y
        LD   A, [HL++]
        ADD  A, 16
        LD   D, A

        LD   A, [BirdL.Y]
        ADD  A, 2

        CP   D
        JR   c, .CheckX

        ADD  A, 12 ; A = Bird.Y + 14 (2 were already added above...)
        LD   B, A

        LD   A, D
        ADD  A, (HOLE_SIZE - 16 - 1)
        CP   B
        RET  nc

    .CheckX:
        LD   B, [HL] ; B = TopCap.X
        LD   A, [BirdL.X]
        ADD  A, 15
        CP   B
        RET  c

        ;(bird.x <= (LP.x + 16)
        LD   A, [BirdL.X]
        LD   C, A
        LD   A, B
        ADD  A, 16
        CP   C

        RET  c

        CALL KillBird
        RET ;