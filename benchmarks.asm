; Written by Xperiment, Nov 2022. Turorial available: https://youtu.be/0xKpHLAsj_s

; first 5 includes came from  https://www.sinclairzxworld.com/viewtopic.php?t=2186&start=40
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

    jr rotatingCube

;;;;;;;;;;;;;;;;;;;;;;;

    call clearScreenQFast
    ld bc, (FRAMES)
    push bc
    ld b, 100
timeItLoop
    push bc

    ;ld bc, $1909
    ;call plot
    ;call plotFast

    ;ld bc, $1909
    ;ld de, $021e
  ;  call bresenhamLineNeg
    ld hl, line1
    call calcLine

    ;call transferBufferFast
    pop bc
    dec b
    ;ld a, b
    ;or c
    jr nz, timeItLoop
    call transferBufferFast
    ld bc, (FRAMES)
    pop hl
    or a
    sbc hl, bc
    call DispHL3
    jp endLoop


;--------------------------

    call xlineInit

rotatingCube
    call clearScreenQFast
    call transferBuffer

    ld hl,190
    ld (angle), hl

rotateLoop

    ld hl,(angle)
    ld bc, 10
    add hl, bc
    ld (angle), hl
    ld bc, 90
    add hl, bc
    ld (angleCos), hl

    ld hl, pointsSafe
    inc hl
    ;ld bc, 4
    ;add hl, bc
    ld (pointToRotate), hl
    ld hl, points
    inc hl
    ;ld bc, 4
    ;add hl, bc
    ld (pointToSave), hl

    ld a, 0
    ld (currentPoint), a

pointsLoop

    ld hl, (pointToRotate);pointsSafe
    ld a, (hl)
    ld (point), a
    ld hl, (angleCos)
    call pointSinAngle
    push af

    ld hl, (pointToRotate);pointsSafe
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

    ld hl, (pointToRotate);pointsSafe
    ld a, (hl)
    ld (point), a
    ld hl, (angle)
    call pointSinAngle
    push af

    ld hl, (pointToRotate);pointsSafe
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
    call transferBufferFast
    ;ld a, $1f
    ;call delay2

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
    ;;ld de, (DF_CC)
    ;push bc
    ;push hl
    ;call DispHL
    ;pop hl
    ld a, l
    ;pop bc

    ;;ld hl, (DF_CC)
    inc hl
    bit 7, c
    ;;ld (hl), _PL
    ret z
    ;;ld (hl), _MI
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
    ;ld a, (connections)
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
    ;ld a, (connections)
    ld l, a
    or a
    rl l
    or a
    rl l
    add hl, bc
    ex de, hl
    pop hl

    ;ld hl, point1
    ;ld de, point2
    call pointsToLine2
    ld hl, line1
    call calcLine

    ;call transferBuffer
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
    ld a, CENTRE;30
    add a, c
    ld (de), a
    ;inc de
    inc hl
    ld c, (hl)
    ld a, CENTRE;
    add a, c
    pop hl
    push af
    ;ld (de), a

    inc de

    ;ld hl, point2
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
    ;pop bc
    ;ld bc, 0
    ;push bc

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
    call transferBuffer



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

;-------------------------------------
repeat
    call clearScreenQ

    ld c, 5 ; x
    ld b, 10 ; y
    call showPoint
    ld c, 35
    ld b, 20
    call showPoint

    ld hl, line1
    call calcLine

    push de
    push bc
    call transferBuffer
    ld a, $ff
    call delay2
    pop bc
    pop de


    call clearScreenQ
    ld c, 5 ; x
    ld b, 20 ; y
    call showPoint
    ld c, 35
    ld b, 10
    call showPoint

    ld hl, line2
    call calcLine

    ;call clearScreenQ

    push de
    push bc
    ;call bresenhamLine
    call transferBuffer
    ld a, $ff
    call delay2
    pop bc
    pop de

    call clearScreenQ
    ld c, 5 ; x
    ld b, 10 ; y
    call showPoint
    ld c, 15
    ld b, 30
    call showPoint

    ld hl, line3
    call calcLine

    ;call clearScreenQ

    push de
    push bc
    ;call bresenhamLine
    call transferBuffer
    ld a, $ff
    call delay2
    pop bc
    pop de

    call clearScreenQ
    ld c, 25 ; x
    ld b, 10 ; y
    call showPoint
    ld c, 5
    ld b, 20
    call showPoint

    ;jp repeat

    ld hl, line4
    call calcLine

    ;call clearScreenQ

    push de
    push bc
    ;call bresenhamLine
    call transferBuffer
    ld a, $ff
    call delay2
    pop bc
    pop de


    call clearScreenQ
    ld c, 5 ; x
    ld b, 40 ; y
    call showPoint
    ld c, 15
    ld b, 10
    call showPoint

    ;jp repeat

    ld hl, line5
    call calcLine

    ;call clearScreenQ

    push de
    push bc
    ;call bresenhamLine
    call transferBuffer
    ld a, $ff
    call delay2
    pop bc
    pop de


    jp repeat
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

    call clearScreenQ

    push de
    push bc
    call bresenhamLine
    ;call transferBuffer
    ;call delay
    pop bc
    pop de

    ld d, 5   ; dy
    ;ld b, 5   ; y
    ld e, 30  ; dx
    ;ld c, 20   ; x
    ld h, 0 ; -ve slope

    push de
    push bc
    call bresenhamLineNeg
    ;call transferBuffer
    ;call delay
    pop bc
    pop de
    ; now dy is still positive, but the line will go up
    ld d, 5   ; dy
    ;ld b, 5   ; y
    ld e, 30  ; dx
    ;ld c, 20   ; x
    ld h, 1 ; +ve slope
    push de
    push bc
    call bresenhamLineNeg
    ;call transferBuffer
    ;call delay
    pop bc
    pop de
    ; now to do a steep line, swap registers used for dx and dy, & x and y
    ld d, 30   ; dy
    ;ld b, 5   ; y
    ld e, 5  ; dx
    ;ld c, 20   ; x
    ld h, 0 ; -ve slope

    push de
    push bc
    call bresenhamLineNegH
    call transferBufferQ
    ;call delay
    pop bc
    pop de

    ret



;--------------------------------------------


#include "from_brandonw.asm"

#include "line2.asm"
#include "screenDefender16K.asm"      			; definition of the screen memory, in colapsed version for 1K
#include "endbasic.asm"
