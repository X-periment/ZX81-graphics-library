; Written by Xperiment, Nov 2022. Turorial available: https://youtu.be/0xKpHLAsj_s

; first 5 includes came from  https://www.sinclairzxworld.com/viewtopic.php?t=2186&start=40 via ByteForever

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
numPointsToRotate
    DEFB 2

;
; points
; point0
;     DEFB  0 ,  0 ,  20 , 0
; point1
;     DEFB  0 ,  6 ,  0 , 0
; point2
;     DEFB  0 ,  -6 ,  0 , 0
;     DEFB  20 ,  0 ,  -20 , 0
;     DEFB  -20 ,  0 ,  -20 , 0
;     DEFB  10 ,  -6 ,  -20 , 0
;     DEFB  -10 ,  -6 ,  -20 , 0
;     DEFB  10 ,  6 ,  -20 , 0
;     DEFB  -10 ,  6 ,  -20 , 0
; faces
;     DEFB  0 ,  32 ,  0 , 0
;     DEFB  -22 ,  33 ,  11 , 0
;     DEFB  22 ,  33 ,  11 , 0
;     DEFB  -22 ,  -33 ,  11 , 0
;     DEFB  22 ,  -33 ,  11 , 0
;     DEFB  0 ,  -32 ,  0 , 0
;     DEFB  0 ,  0 ,  -48 , 0
; endOfPoints
;
; pointsSafe
;     DEFB  0 ,  0 ,  20 , 0
;     DEFB  0 ,  6 ,  0 , 0
;     DEFB  0 ,  -6 ,  0 , 0
;     DEFB  20 ,  0 ,  -20 , 0
;     DEFB  -20 ,  0 ,  -20 , 0
;     DEFB  10 ,  -6 ,  -20 , 0
;     DEFB  -10 ,  -6 ,  -20 , 0
;     DEFB  10 ,  6 ,  -20 , 0
;     DEFB  -10 ,  6 ,  -20 , 0
; facesSafe
;     DEFB  0 ,  32 ,  0 , 0
;     DEFB  -22 ,  33 ,  11 , 0
;     DEFB  22 ,  33 ,  11 , 0
;     DEFB  -22 ,  -33 ,  11 , 0
;     DEFB  22 ,  -33 ,  11 , 0
;     DEFB  0 ,  -32 ,  0 , 0
;     DEFB  0 ,  0 ,  -48 , 0
;
; pointsTemp
;     DEFB  0 ,  0 ,  20 , 0
;     DEFB  0 ,  6 ,  0 , 0
;     DEFB  0 ,  -6 ,  0 , 0
;     DEFB  20 ,  0 ,  -20 , 0
;     DEFB  -20 ,  0 ,  -20 , 0
;     DEFB  10 ,  -6 ,  -20 , 0
;     DEFB  -10 ,  -6 ,  -20 , 0
;     DEFB  10 ,  6 ,  -20 , 0
;     DEFB  -10 ,  6 ,  -20 , 0
; facesTemp
;     DEFB  0 ,  32 ,  0 , 0
;     DEFB  -22 ,  33 ,  11 , 0
;     DEFB  22 ,  33 ,  11 , 0
;     DEFB  -22 ,  -33 ,  11 , 0
;     DEFB  22 ,  -33 ,  11 , 0
;     DEFB  0 ,  -32 ,  0 , 0
;     DEFB  0 ,  0 ,  -48 , 0
;
;
; connections
;     DEFB  0 ,  3
;     DEFB  0 ,  1
;     DEFB  0 ,  2
;     DEFB  0 ,  4
;     DEFB  1 ,  7
;     DEFB  1 ,  8
;     DEFB  2 ,  5
;     DEFB  2 ,  6
;     DEFB  7 ,  8
;     DEFB  5 ,  6
;     DEFB  4 ,  8
;     DEFB  4 ,  6
;     DEFB  3 ,  7
;     DEFB  3 ,  5
;     DEFB $ff
;
; edgefaces
;     DEFB  2 ,  4
;     DEFB  1 ,  2
;     DEFB  3 ,  4
;     DEFB  1 ,  3
;     DEFB  0 ,  2
;     DEFB  0 ,  1
;     DEFB  4 ,  5
;     DEFB  3 ,  5
;     DEFB  0 ,  6
;     DEFB  5 ,  6
;     DEFB  1 ,  6
;     DEFB  3 ,  6
;     DEFB  2 ,  6
;     DEFB  6 ,  4

;-------------------------------
points
point0
    DEFB  16 ,  0 ,  16 , 0
point1
    DEFB  16 ,  0 ,  16 , 0
point2
    DEFB  -16 ,  0 ,  16 , 0
    DEFB  0 ,  -16 ,  16 , 0
    DEFB  16 ,  -16 ,  0 , 0
    DEFB  16 ,  16 ,  0 , 0
    DEFB  -16 ,  16 ,  0 , 0
    DEFB  -16 ,  -16 ,  0 , 0
    DEFB  16 ,  0 ,  -16 , 0
    DEFB  0 ,  16 ,  -16 , 0
    DEFB  -16 ,  0 ,  -16 , 0
    DEFB  0 ,  -16 ,  -16 , 0
    DEFB  1 ,  -3 ,  16 , 0
    DEFB  1 ,  3 ,  16 , 0
    DEFB  -1 ,  3 ,  16 , 0
    DEFB  -1 ,  -3 ,  16 , 0
faces
    DEFB  0 ,  0 ,  40 , 0
    DEFB  26 ,  -26 ,  26 , 0
    DEFB  26 ,  26 ,  26 , 0
    DEFB  -26 ,  26 ,  26 , 0
    DEFB  -26 ,  -26 ,  26 , 0
    DEFB  0 ,  -40 ,  0 , 0
    DEFB  40 ,  0 ,  0 , 0
    DEFB  -40 ,  0 ,  0 , 0
    DEFB  0 ,  40 ,  0 , 0
    DEFB  -26 ,  -26 ,  -26 , 0
    DEFB  26 ,  -26 ,  -26 , 0
    DEFB  26 ,  26 ,  -26 , 0
    DEFB  -26 ,  26 ,  -26 , 0
    DEFB  0 ,  0 ,  -40 , 0
endOfPoints



pointsSafe
    DEFB  16 ,  0 ,  16 , 0
    DEFB  0 ,  16 ,  16 , 0
    DEFB  -16 ,  0 ,  16 , 0
    DEFB  0 ,  -16 ,  16 , 0
    DEFB  16 ,  -16 ,  0 , 0
    DEFB  16 ,  16 ,  0 , 0
    DEFB  -16 ,  16 ,  0 , 0
    DEFB  -16 ,  -16 ,  0 , 0
    DEFB  16 ,  0 ,  -16 , 0
    DEFB  0 ,  16 ,  -16 , 0
    DEFB  -16 ,  0 ,  -16 , 0
    DEFB  0 ,  -16 ,  -16 , 0
    DEFB  1 ,  -3 ,  16 , 0
    DEFB  1 ,  3 ,  16 , 0
    DEFB  -1 ,  3 ,  16 , 0
    DEFB  -1 ,  -3 ,  16 , 0
facesSafe
    DEFB  0 ,  0 ,  40 , 0
    DEFB  26 ,  -26 ,  26 , 0
    DEFB  26 ,  26 ,  26 , 0
    DEFB  -26 ,  26 ,  26 , 0
    DEFB  -26 ,  -26 ,  26 , 0
    DEFB  0 ,  -40 ,  0 , 0
    DEFB  40 ,  0 ,  0 , 0
    DEFB  -40 ,  0 ,  0 , 0
    DEFB  0 ,  40 ,  0 , 0
    DEFB  -26 ,  -26 ,  -26 , 0
    DEFB  26 ,  -26 ,  -26 , 0
    DEFB  26 ,  26 ,  -26 , 0
    DEFB  -26 ,  26 ,  -26 , 0
    DEFB  0 ,  0 ,  -40 , 0



pointsTemp
    DEFB  16 ,  0 ,  16 , 0
    DEFB  0 ,  16 ,  16 , 0
    DEFB  -16 ,  0 ,  16 , 0
    DEFB  0 ,  -16 ,  16 , 0
    DEFB  16 ,  -16 ,  0 , 0
    DEFB  16 ,  16 ,  0 , 0
    DEFB  -16 ,  16 ,  0 , 0
    DEFB  -16 ,  -16 ,  0 , 0
    DEFB  16 ,  0 ,  -16 , 0
    DEFB  0 ,  16 ,  -16 , 0
    DEFB  -16 ,  0 ,  -16 , 0
    DEFB  0 ,  -16 ,  -16 , 0
    DEFB  1 ,  -3 ,  16 , 0
    DEFB  1 ,  3 ,  16 , 0
    DEFB  -1 ,  3 ,  16 , 0
    DEFB  -1 ,  -3 ,  16 , 0
facesTemp
    DEFB  0 ,  0 ,  40 , 0
    DEFB  26 ,  -26 ,  26 , 0
    DEFB  26 ,  26 ,  26 , 0
    DEFB  -26 ,  26 ,  26 , 0
    DEFB  -26 ,  -26 ,  26 , 0
    DEFB  0 ,  -40 ,  0 , 0
    DEFB  40 ,  0 ,  0 , 0
    DEFB  -40 ,  0 ,  0 , 0
    DEFB  0 ,  40 ,  0 , 0
    DEFB  -26 ,  -26 ,  -26 , 0
    DEFB  26 ,  -26 ,  -26 , 0
    DEFB  26 ,  26 ,  -26 , 0
    DEFB  -26 ,  26 ,  -26 , 0
    DEFB  0 ,  0 ,  -40 , 0



connections
    DEFB  0 ,  3
    DEFB  0 ,  1
    DEFB  1 ,  2
    DEFB  2 ,  3
    DEFB  3 ,  4
    DEFB  0 ,  4
    DEFB  0 ,  5
    DEFB  5 ,  1
    DEFB  1 ,  6
    DEFB  2 ,  6
    DEFB  2 ,  7
    DEFB  3 ,  7
    DEFB  8 ,  11
    DEFB  8 ,  9
    DEFB  9 ,  10
    DEFB  10 ,  11
    DEFB  4 ,  11
    DEFB  4 ,  8
    DEFB  5 ,  8
    DEFB  5 ,  9
    DEFB  6 ,  9
    DEFB  6 ,  10
    DEFB  7 ,  10
    DEFB  7 ,  11
    DEFB  12 ,  13
    DEFB  13 ,  14
    DEFB  14 ,  15
    DEFB  15 ,  12
    DEFB $ff



edgefaces
    DEFB  0 ,  1
    DEFB  0 ,  2
    DEFB  0 ,  3
    DEFB  0 ,  4
    DEFB  1 ,  5
    DEFB  1 ,  6
    DEFB  2 ,  6
    DEFB  2 ,  8
    DEFB  3 ,  8
    DEFB  3 ,  7
    DEFB  4 ,  7
    DEFB  4 ,  5
    DEFB  10 ,  13
    DEFB  11 ,  13
    DEFB  12 ,  13
    DEFB  9 ,  13
    DEFB  5 ,  10
    DEFB  6 ,  10
    DEFB  6 ,  11
    DEFB  8 ,  11
    DEFB  8 ,  12
    DEFB  7 ,  12
    DEFB  7 ,  9
    DEFB  5 ,  9
    DEFB  0 ,  0
    DEFB  0 ,  0
    DEFB  0 ,  0
    DEFB  0 ,  0
;----------------------------------

demoStart
    call xlineInit

    call clearScreenQFast
    call transferBufferFast


    ld hl, 25
    ld (angle2), hl
    ld hl, pointsSafe
    ld (pointsFrom), hl
    ld hl, pointsTemp
    ld (pointsTo), hl
    call rotate3D

    ld hl, 0
    ld (angle2), hl
    ld hl, 10  ; demo only works well for 10, 7 and 6 fail
    ld (incrementAngle), hl
    ld a, 0     ; whth this setup (xdemo15 second save, crashes if I set this to 1)
    ld (rotationAxis), a
    ld hl, pointsTemp
    ld (pointsFrom), hl
    ld hl, points
    ld (pointsTo), hl

    ld a, 30
    ld (numPointsToRotate), a

rotateLoopOuter
    ld b, 36


rotateLoop
    push bc
    call rotate3D

    call drawPolygon

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
    ld a, (numPointsToRotate)
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

    bit 7, c

    ret z

    dec a
    xor $ff

    ret
;------------------------------------
isEdgeVisible   ; max 64 faces
    ld hl, edgefaces
    ld de, (edgeIndex)
    add hl, de
    add hl, de
    ld b, 2
loopOverFaces
    ld e, (hl)   ; e is the face index
    inc hl
    push hl
    ld hl, faces
    sla e ; limits us to 64 faces
    sla e
    ld d, 0
    add hl, de
    inc hl
    inc hl ; now pointing at z component
    ld c, (hl)

    bit 7, c
    pop hl
    ret z  ; so c will be positive if edge is on a visible face

    dec b
    jr nz, loopOverFaces
    ret ; to get here c must have been negative for both the faces
;------------------------------------

edgeIndex
    DEFW 0

drawPolygon

    ld bc, 0
    ld (edgeIndex), bc
    exx
    ld hl, connections
    exx

    call clearScreenQFast
nextLine


    exx
    ld a, (hl)   ; a is first point to connect
    inc hl
    exx

    call isEdgeVisible  ; on return, c negative means don't plot
    ld hl, edgeIndex
    inc (hl)
    bit 7, c
    jr z, edgeIsVisible
    exx
    inc hl
    exx
    jr nextLine

edgeIsVisible

    ld bc, points

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
    ld a, (hl)    ; second point to connect
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
    ld a, CENTRE
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

;--------------------------------------------


#include "from_brandonw.asm"

#include "line2.asm"
#include "screenDefender16K.asm"      			; definition of the screen memory, in colapsed version for 1K
#include "endbasic.asm"
