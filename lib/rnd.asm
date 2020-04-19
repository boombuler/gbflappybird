SECTION WRAM 0

RND_SEED::
DS 3

SECTION ROM 0

InitRandom::
        LD   HL, RND_SEED
        LD   A, 13
        LD   [HL++], A
        LD   A, 37
        LD   [HL++], A
        LD   A, $A3
        LD   [HL], A
        RET 

GetNextRndNum::
        LD   HL,RND_SEED
        LD   A, [HL++]
        SRA  A
        SRA  A
        SRA  A
        XOR  [HL]
        INC  HL
        RRA
        RL   [HL]
        DEC  HL
        RL   [HL]
        DEC  HL
        RL   [HL]
        LDH  A, [DIV]   ; get divider register to increase randomness
        ADD  A, [HL]
        RET             ; Random Number is now in A