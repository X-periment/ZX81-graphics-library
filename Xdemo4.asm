; Written by Xperiment, Nov 2022. Turorial available: https://youtu.be/0xKpHLAsj_s

; all the includes came from  https://www.sinclairzxworld.com/viewtopic.php?t=2186&start=40 via ByteForever

#include "zx81defs.asm"
#include "zx81rom.asm"
#include "charcodes.asm"
#include "zx81sys.asm"                ;; removed some of unneeded definitions
#include "line1.asm"

    jp demoStart

#include "XlineLib.asm"
#include "XMath.asm"

angle
    DEFW 0

demoStart

    call xlineInit
    ; b = y
    ; c = x
    ; d = dy
    ; e = dx
repeatCircle
    call clearScreenQ
    call transferBuffer
    call plotCircle
    call transferBuffer
    ld a, $5f
    call delay2
    jr repeatCircle

;----------------------------
plotCircle

    ld hl, 0
    ld (angle), hl

circleLoop
    ld bc, 10
    ld hl, (angle)
    add hl, bc
    ld (angle), hl
    call INTSIN
    ld e, 40
    push af
    call mult_h_e
    pop af
    ld l, h
    ld h, 0
    bit 0, a
    ld a, 25
    jr nz, circNeg1
    add a, l
    jr circNeg2
circNeg1
    sub l
circNeg2
    ld b, a
    ld l, a
    push bc
    call DispHL2


    ld de, 90
    ld hl, (angle)
    add hl, de
    call INTSIN
    ld e, 40
    push af
    call mult_h_e
    pop af
    ld l, h
    ld h, 0

    bit 0, a
    ld a, 25
    jr nz, circNeg3
    add a, l
    jr circNeg4
circNeg3
    sub l
circNeg4


    pop bc
    ld c, a
    push bc
    ld l, a


    call DispHL3


    pop bc
    call plot

    ld hl, (angle)
    ld bc, 370
    ld a, b
    cp h
    jp nz, circleLoop
    ld a, c
    cp l
    jp nz, circleLoop

    ret


;---------------------------------------
showPoint
    call plot

    call transferBuffer
    ld a, $05
    call delay2
    ret

;--------------------------------------------


#include "from_brandonw.asm"

#include "line2.asm"
#include "screenDefender16K.asm"      			; definition of the screen memory, in colapsed version for 1K
#include "endbasic.asm"
