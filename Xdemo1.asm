; Written by Xperiment, Nov 2022. Turorial available: https://youtu.be/0xKpHLAsj_s

; all the includes came from  https://www.sinclairzxworld.com/viewtopic.php?t=2186&start=40 via ByteForever

#include "zx81defs.asm"
#include "zx81rom.asm"
#include "charcodes.asm"
#include "zx81sys.asm"                ;; removed some of unneeded definitions
#include "line1.asm"

    jp demoStart

#include "XlineLib2.asm"

demoStart

    call xlineInit
    ld b, 5   ; y
    ld c, 20   ; x

demoLoop
    call drawShape
    ld a, 1
    call delay2
    dec c
    jr nz, demoLoop

demoLoop2
    call drawShape
    ld a, 1
    call delay2
    inc c

    ld a, 20
    cp c
    jr nz, demoLoop2

    jr demoLoop


drawShape

    ld d, 10   ; dy
    ld e, 30  ; dx

    call clearScreenQFast

    push bc
    call bresenhamLineNeg
    pop bc

    ; call transferBufferQ
    ; ld a, $2f
    ; call delay2

    ld d, 5   ; dy
    ld e, 30  ; dx
    ld h, 0 ; -ve slope

    push bc
    call bresenhamLineNeg
    pop bc

    ; now dy is still positive, but the line will go up
    ld d, 5   ; dy
    ld e, 30  ; dx
    ld h, 1 ; +ve slope

    push bc
    call bresenhamLineNeg
    pop bc

    ; now to do a steep line
    ld d, 30   ; dy
    ld e, 5  ; dx
    ld h, 0 ; -ve slope

    push bc
    call bresenhamLineNegH
    call transferBufferFast

    pop bc


    ret



;--------------------------------------------


#include "from_brandonw.asm"

#include "line2.asm"
#include "screenDefender16K.asm"      			; definition of the screen memory, in colapsed version for 1K
#include "endbasic.asm"
