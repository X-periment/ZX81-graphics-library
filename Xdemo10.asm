; Written by Xperiment, Nov 2022. Turorial available: https://youtu.be/0xKpHLAsj_s

; all the includes came from  https://www.sinclairzxworld.com/viewtopic.php?t=2186&start=40 via ByteForever

#include "zx81defs.asm"
#include "zx81rom.asm"
#include "charcodes.asm"
#include "zx81sys.asm"                ;; removed some of unneeded definitions
#include "line1.asm"

#define CENTRE 24

    jp demoStart

#include "XlineLib2.asm"
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
angleCos
    DEFW 0

points
;   DEFB x, y, z (x goes left to right, y goes top to bottom)
point0
    DEFB 20, 10, 0, 0
point1
    DEFB -20, 10, 0, 0
point2
    DEFB -10, -10, 0, 0
point3
    DEFB 10, -20, 0, 0
point4
    DEFB 20, 10, 0, 0
point5
    DEFB -20, 10, 0, 0
point6
    DEFB -10, -10, 0, 0
point7
    DEFB 10, -20, 0, 0
endOfPoints

pointsSafe
;   DEFB x, y, z (x goes left to right, y goes top to bottom)
point0S
    DEFB 16, 16, 10, 0
point1S
    DEFB -16, 16, 10, 0
point2S
    DEFB -11, -16, 10, 0
point3S
    DEFB 16, -16, 10, 0
point4S
    DEFB 11, 11, -10, 0
point5S
    DEFB -11, 11, -10, 0
point6S
    DEFB -11, -11, -10, 0
point7S
    DEFB 11, -11, -10, 0

pointToRotate
    DEFW 0
pointToSave
    DEFW 0
currentPoint
    DEFB 0

connections
    DEFB 0, 1
    DEFB 1, 2
    DEFB 2, 3
    DEFB 3, 0
    DEFB 0, 4
    DEFB 1, 5
    DEFB 2, 6
    DEFB 3, 7
    DEFB 4, 5
    DEFB 5, 6
    DEFB 6, 7
    DEFB 7, 4
    DEFB $ff

demoStart

    call xlineInit
    call clearScreenQ
    call transferBufferQ

    ld hl,190
    ld (angle), hl

rotateLoop

    ld hl,(angle)
    ld bc, 5
    add hl, bc
    ld (angle), hl
    ld bc, 90
    add hl, bc
    ld (angleCos), hl

    ld hl, pointsSafe
    inc hl

    ld (pointToRotate), hl
    ld hl, points
    inc hl

    ld (pointToSave), hl

    ld a, 0
    ld (currentPoint), a

pointsLoop

    ld hl, (pointToRotate)
    ld a, (hl)
    ld (point), a
    ld hl, (angleCos)
    call pointSinAngle
    push af

    ld hl, (pointToRotate)
    inc hl
    ld a, (hl)
    ld (point), a
    ld hl, (angle)
    call pointSinAngle

    ld b, a
    pop af
    sub b
    ld hl, (pointToSave)
    ld (hl), a

    ld hl, (pointToRotate)
    ld a, (hl)
    ld (point), a
    ld hl, (angle)
    call pointSinAngle
    push af

    ld hl, (pointToRotate)
    inc hl
    ld a, (hl)
    ld (point), a
    ld hl, (angleCos)
    call pointSinAngle

    ld b, a
    pop af
    add a, b
    ld hl, (pointToSave)
    inc hl
    ld (hl), a

    ld hl, currentPoint
    inc (hl)
    ld a, 8
    ld b, (hl)
    cp b
    jr z, continue

    ld hl, (pointToRotate)
    ld bc, 4
    add hl, bc
    ld (pointToRotate), hl
    ld hl, (pointToSave)
    ld bc, 4
    add hl, bc
    ld (pointToSave), hl

    jp pointsLoop

continue

    call drawPolygon
    call transferBufferQ

    jp rotateLoop

;--------------------------------

point
    DEFB 0
pointSinAngle
    call INTSIN
    push af
    ld a, (point)
    bit 7, a
    jp z, numIsPos

    xor $ff
    inc a
    ld e, a
    ; here we know the coord is negative
    pop af  ; a here contains sign of sine theta
    bit 0, a
    ; negative = -+
    ld c, $ff
    jr z, numWasNeg
    ; positive = --
    ld c, $00
    jr numWasNeg
numIsPos
    ld e, a
    pop af  ; a here contains sign of sine theta
    bit 0, a
    ; positive = ++
    ld c, $00
    jr z, numWasNeg
    ; negative = +-
    ld c, $ff
    jr numWasNeg
numWasNeg

    call mult_h_e  ; does not clobber c

    ; now divide by $80!! (shift left and take upper byte?)
    rl l
    rl h
    ld l, h
    ld h, 0
    ld de, (DF_CC)

    ld a, l

    bit 7, c
    ret z
    dec a
    xor $ff

    ret


;------------------------------------

drawPolygon

    exx
    ld hl, connections
    exx

    call clearScreenQ
nextLine

    ld bc, points
    exx
    ld a, (hl)
    inc hl
    exx

    cp $ff
    ret z

    ld h, 0

    ld l, a
    or a
    rl l
    or a
    rl l
    add hl, bc

    push hl

    exx
    ld a, (hl)
    inc hl
    exx
    ld h, 0

    ld l, a
    or a
    rl l
    or a
    rl l
    add hl, bc
    ex de, hl
    pop hl

    call pointsToLine2
    ld hl, line1
    call calcLineSafe

    jp nextLine


;---------------------------------------

endLoop
    jr endLoop

pointsToLine
    ld hl, point1
pointsToLine2
    push de

    ld de, line1
    ld c, (hl)
    ld a, CENTRE
    add a, c
    ld (de), a

    inc hl
    ld c, (hl)
    ld a, CENTRE;
    add a, c
    pop hl
    push af

    inc de

    ld c, (hl)
    ld a, CENTRE;
    add a, c
    ld (de), a
    inc de
    pop af
    ld (de), a
    inc de
    inc hl
    ld c, (hl)
    ld a, CENTRE;
    add a, c
    ld (de), a

    ret



#include "from_brandonw.asm"

#include "line2.asm"
#include "screenDefender16K.asm"      			; definition of the screen memory, in colapsed version for 1K
#include "endbasic.asm"
