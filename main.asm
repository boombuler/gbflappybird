#CARTRIDGE.TITLE            "FLAPPYBIRD"
#CARTRIDGE.VERSION          0
#CARTRIDGE.MBC              NONE RAM
#CARTRIDGE.GBC              SUPPORTED

#INCLUDE "lib/memcpy.asm"
#include "lib/reg.asm"
#INCLUDE "lib/screen.asm"
#INCLUDE "lib/rnd.asm"

#INCLUDE "images.asm"
#INCLUDE "background.asm"
#INCLUDE "pipes.asm"
#INCLUDE "bird.asm"
#INCLUDE "game.asm"

SECTION ROM 0 @ $0048
        NOP
        JP INTERRUPT_LCDStat


SECTION ROM 0



INTERRUPT_LCDStat::
        LD   A, [BGScroll.Bottom]
        LDH  [SCX], A
        RETI

Main::
        CALL InitRandom
        CALL CopyDMAToHRam
        JP   NewGame


SECTION MAIN
        NOP
        JP   Main