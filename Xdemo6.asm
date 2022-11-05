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
line1
    DEFB 5, 35, 10, 20  ; x, x2, y, y2
line2
    DEFB 5, 35, 20, 10
line3
    DEFB 5, 15, 10, 30
line4
    DEFB 25, 5, 10, 20
line5
    DEFB 5, 15, 40, 10
tempY
    DEFB 0
tempY2
    DEFB 0
angle
    DEFW 0
startAngle
    DEFW 0
endAngle
    DEFW 0
incrementAngle
    DEFW 0
lastPoint
    DEFW $2020
radius
    DEFB 0

demoStart

    call xlineInit
    ; b = y
    ; c = x
    ; d = dy
    ; e = dx


    ;call transferBuffer
    ld hl, 0
    ld (startAngle), hl
    ld hl, 380
    ld (endAngle), hl
    ld hl, 20
    ld (incrementAngle), hl
    ld hl, 20
    ld (radius), hl
repeatCircle
    call clearScreenQ
    call plotCircle
    call transferBuffer
    ;ld a, $1f
    ;call delay2
    ld hl, (radius)
    inc hl
    ld (radius), hl
    ld a, l
    cp 50
    jr nz, repeatCircle
    ld hl, 20
    ld (radius), hl
    jr repeatCircle

;----------------------------
plotCircle
    ld hl, (startAngle)
    ld (angle), hl
    exx
    ld b, 1
    exx

circleLoop
    ld bc, (incrementAngle)
    ld hl, (angle)
    add hl, bc
    ld (angle), hl
    call INTSIN
    push af
    ld a, (radius)
    ld e, a
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
    ;call DispHL2


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

  ;  ld a, 25
  ;  add a, l
    pop bc
    ld c, a
    push bc
    ld l, a


    ;call DispHL3


    ;ld a, $0f
    ;call delay2
    pop bc
    ld de, (lastPoint)
    ld (lastPoint), bc

    ld hl, line1
    ld (hl), b
    inc hl
    ld (hl), d
    inc hl
    ld (hl), c
    inc hl
    ld (hl), e
    ld hl, line1
    exx
    bit 0, b
    ld b, 0
    exx
    jr  nz, skipFirstChord
    call calcLine ; plot ;showPoint
skipFirstChord
    ld hl, (angle)
    ld bc, (endAngle)
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

;-----------------------------------------

calcLine
    ; dx calc
    ld b, (hl)
    ld c, b
    inc hl
    ld a, (hl)
    ;inc hl
    sub b
    ; check for negative difference
    bit 7,a
    jr nz, calcNegDx
    ld e, a
    ; hack!
    inc hl
    ld a, (hl)
    ld (tempY), a
    inc hl
    ld a, (hl)
    ld (tempY2), a
    dec hl
    dec hl
    jr dyCalc
calcNegDx
    xor $ff
    inc a
    ld e, a
    ld c, (hl)
    ; now i also need to swap the y's!!! how?
    ; hack!
    inc hl
    ld a, (hl)
    ld (tempY2), a
    inc hl
    ld a, (hl)
    dec hl
    ld (tempY), a
    dec hl

dyCalc
    inc hl
    ld a, (tempY)
    ld b, a
    ;ld b, (hl) ;----------
    inc hl
    ld a, (tempY2)
    ;ld a, (hl) ; -----------
    ;inc hl
    sub b
    ; check for positive slope
    bit 7, a
    jr nz, calcNegDy
    ld d, a
    ld h, 0
    call isLineSteep
    ;call bresenhamLineNeg
    ret
calcNegDy
    xor $ff
    inc a
    ld d, a
    ld a, (tempY)
    ld b, a
    inc hl
    push hl
    ld h, 1 ; +ve slope !! this will mess up hl!!!
    ;ld d, 5
    ;ld e, 30
    call isLineSteep

    pop hl
    ret

;--------------------------------
isLineSteep
    ; steep line has d>e

    ld a, d
    sub e
    bit 7, a
    jr z, lineIsSteep
    call bresenhamLineNeg
    ret
lineIsSteep
    call bresenhamLineNegH
    ret
;--------------------------------



#include "from_brandonw.asm"

#include "line2.asm"
#include "screenDefender16K.asm"      			; definition of the screen memory, in colapsed version for 1K
#include "endbasic.asm"
