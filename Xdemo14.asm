; all the includes came from  https://www.sinclairzxworld.com/viewtopic.php?t=2186&start=40
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
angle2
    DEFW 0
startAngle
    DEFW 0
endAngle
    DEFW 0
incrementAngle
    DEFW 0
rotationAxis
    DEFB 0
lastPoint
    DEFW $2020
radius
    DEFB 0
angleCos
    DEFW 0


pointToRotate
    DEFW 0
pointToSave
    DEFW 0
currentPoint
    DEFB 0
pointsFrom
    DEFW 0
pointsTo
    DEFW 0


points
point0
    DEFB  0 ,  0 ,  20 , 0
point1
    DEFB  0 ,  6 ,  0 , 0
point2
    DEFB  0 ,  -6 ,  0 , 0
    DEFB  20 ,  0 ,  -20 , 0
    DEFB  -20 ,  0 ,  -20 , 0
    DEFB  10 ,  -6 ,  -20 , 0
    DEFB  -10 ,  -6 ,  -20 , 0
    DEFB  10 ,  6 ,  -20 , 0
    DEFB  -10 ,  6 ,  -20 , 0
    DEFB  -13 ,  0 ,  -20 , 0
    DEFB  13 ,  0 ,  -20 , 0
    DEFB  3 ,  3 ,  -20 , 0
    DEFB  -3 ,  3 ,  -20 , 0
    DEFB  -3 ,  -3 ,  -20 , 0
    DEFB  3 ,  -3 ,  -20 , 0
endOfPoints

pointsSafe
    DEFB  0 ,  0 ,  20 , 0
    DEFB  0 ,  6 ,  0 , 0
    DEFB  0 ,  -6 ,  0 , 0
    DEFB  20 ,  0 ,  -20 , 0
    DEFB  -20 ,  0 ,  -20 , 0
    DEFB  10 ,  -6 ,  -20 , 0
    DEFB  -10 ,  -6 ,  -20 , 0
    DEFB  10 ,  6 ,  -20 , 0
    DEFB  -10 ,  6 ,  -20 , 0
    DEFB  -13 ,  0 ,  -20 , 0
    DEFB  13 ,  0 ,  -20 , 0
    DEFB  3 ,  3 ,  -20 , 0
    DEFB  -3 ,  3 ,  -20 , 0
    DEFB  -3 ,  -3 ,  -20 , 0
    DEFB  3 ,  -3 ,  -20 , 0


pointsTemp
    DEFB  0 ,  0 ,  20 , 0
    DEFB  0 ,  6 ,  0 , 0
    DEFB  0 ,  -6 ,  0 , 0
    DEFB  20 ,  0 ,  -20 , 0
    DEFB  -20 ,  0 ,  -20 , 0
    DEFB  10 ,  -6 ,  -20 , 0
    DEFB  -10 ,  -6 ,  -20 , 0
    DEFB  10 ,  6 ,  -20 , 0
    DEFB  -10 ,  6 ,  -20 , 0
    DEFB  -13 ,  0 ,  -20 , 0
    DEFB  13 ,  0 ,  -20 , 0
    DEFB  3 ,  3 ,  -20 , 0
    DEFB  -3 ,  3 ,  -20 , 0
    DEFB  -3 ,  -3 ,  -20 , 0
    DEFB  3 ,  -3 ,  -20 , 0

connections
    DEFB  0 ,  3
    DEFB  0 ,  1
    DEFB  0 ,  2
    DEFB  0 ,  4
    DEFB  1 ,  7
    DEFB  1 ,  8
    DEFB  2 ,  5
    DEFB  2 ,  6
    DEFB  7 ,  8
    DEFB  5 ,  6
    DEFB  4 ,  8
    DEFB  4 ,  6
    DEFB  3 ,  7
    DEFB  3 ,  5
    DEFB $ff

demoStart
    call xlineInit

    call clearScreenQFast
    call transferBufferFast


    ld hl, 45
    ld (angle2), hl
    ld hl, pointsSafe
    ld (pointsFrom), hl
    ld hl, pointsTemp
    ld (pointsTo), hl
    call rotate3D

    ld hl, 0
    ld (angle2), hl
    ld hl, 10
    ld (incrementAngle), hl
    ld a, 0
    ld (rotationAxis), a
    ld hl, pointsTemp
    ld (pointsFrom), hl
    ld hl, points
    ld (pointsTo), hl

rotateLoopOuter
    ld b, 36


rotateLoop
    push bc
    call rotate3D

    call drawPolygon

    ld bc, 40
    ld (radius), bc
    ld hl, 0
    ld (startAngle), hl
    ld hl, 380
    ld (endAngle), hl
    call plotCircle

    call transferBufferFast

    pop bc
    dec b

    jp nz, rotateLoop

    ld a, (rotationAxis)
    xor 1
    ld (rotationAxis), a
    jr rotateLoopOuter



;--------------------------------
rotate3D
    ld hl,(angle2)
    ld bc, (incrementAngle)
    add hl, bc
    ld (angle2), hl
    ld bc, 90
    add hl, bc
    ld (angleCos), hl

    ld hl, (pointsFrom)
    ld a, (rotationAxis)
    bit 0, a
    jr z, noInc1
    inc hl
noInc1

    ld (pointToRotate), hl

    ld hl, (pointsTo)
    ld a, (rotationAxis)
    bit 0, a
    jr z, noInc2
    inc hl
noInc2

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
    ld hl, (angle2)
    call pointSinAngle

    ld b, a
    pop af
    sub b
    ld hl, (pointToSave)
    ld (hl), a

    ld hl, (pointToRotate)
    ld a, (hl)
    ld (point), a
    ld hl, (angle2)
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
    ld a, 9    ; HOW many points to rotate
    ld b, (hl)
    cp b
    ret z

    ld hl, (pointToRotate)
    ld bc, 4
    add hl, bc
    ld (pointToRotate), hl
    ld hl, (pointToSave)
    ld bc, 4
    add hl, bc
    ld (pointToSave), hl

    jp pointsLoop


;---------------------------------


point
    DEFB 0
pointSinAngle
    call INTSIN
    push af
    ld a, (point)
    bit 7, a
    jp z, numIsPos
    ;jp endLoop
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

    ld a, l

    ;inc hl
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

    call clearScreenQFast
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

;--------------------

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
    ld a, CENTRE
    add a, c
    ld (de), a
    inc de
    pop af
    ld (de), a
    inc de
    inc hl
    ld c, (hl)
    ld a, CENTRE
    add a, c
    ld (de), a

    ret

;------------------------------------

demoCircle

    ld hl, 20
    ld (incrementAngle), hl
    ld hl, 20
    ld (radius), hl

repeatCircle
    ld bc, 0
    push bc

repeatCircle1
    call clearScreenQ

    ld bc, 40
    ld (radius), bc
    ld hl, 0
    ld (startAngle), hl
    ld hl, 380
    ld (endAngle), hl

    call plotCircle


    pop bc
    ld (radius), bc
    inc bc
    push bc
    ld hl, 0
    ld (startAngle), hl
    ld hl, 200
    ld (endAngle), hl
    call plotCircle
    call transferBuffer



    pop bc
    ld a, c
    push bc
    cp 40
    jr nz, repeatCircle1

repeatCircle2
    call clearScreenQ

    ld bc, 40
    ld (radius), bc
    ld hl, 0
    ld (startAngle), hl
    ld hl, 380
    ld (endAngle), hl
    call plotCircle


    pop bc
    ld (radius), bc
    dec bc
    push bc
    ld hl, 180
    ld (startAngle), hl
    ld hl, 380
    ld (endAngle), hl
    call plotCircle
    call transferBufferQ



    pop bc
    ld a, c
    push bc
    cp 0
    jr nz, repeatCircle2
    pop bc
    ld bc, 40
    push bc
    jp repeatCircle

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
    call calcLineSafe
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


;--------------------------------------------


#include "from_brandonw.asm"

#include "line2.asm"
#include "screenDefender16K.asm"      			; definition of the screen memory, in colapsed version for 1K
#include "endbasic.asm"
