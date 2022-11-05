; Written by Xperiment, Nov 2022. Turorial available: https://youtu.be/0xKpHLAsj_s

; all the includes came from  https://www.sinclairzxworld.com/viewtopic.php?t=2186&start=40 via ByteForever

#include "zx81defs.asm"
#include "zx81rom.asm"
#include "charcodes.asm"
#include "zx81sys.asm"                ;; removed some of unneeded definitions
#include "line1.asm"

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

points
;   DEFB x, y, z (x goes left to right, y goes top to bottom)
point0
    DEFB 10, 10, 0, 0
point1
    DEFB -10, 10, 0, 0
point2
    DEFB -10, -10, 0, 0
point3
    DEFB 10, -20, 0, 0
endOfPoints

connections
    DEFB 0, 1
    DEFB 1, 2
    DEFB 2, 3
    DEFB 3, 0
    DEFB $ff

demoStart

    call xlineInit
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
    jr z, endLoop

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

    call transferBufferQ
    jp nextLine

;------------------------------

endLoop
    jr endLoop

;-----------------------

pointsToLine
    ld hl, point1
pointsToLine2
    push de

    ld de, line1
    ld c, (hl)
    ld a, 30
    add a, c
    ld (de), a

    inc hl
    ld c, (hl)
    ld a, 30
    add a, c
    pop hl
    push af


    inc de

    ld c, (hl)
    ld a, 30
    add a, c
    ld (de), a
    inc de
    pop af
    ld (de), a
    inc de
    inc hl
    ld c, (hl)
    ld a, 30
    add a, c
    ld (de), a

    ret

;---------------------------------------
; showPoint
;     call plot
;
;     call transferBuffer
;     ld a, $05
;     call delay2
;     ret

;-----------------------------------------





#include "from_brandonw.asm"

#include "line2.asm"
#include "screenDefender16K.asm"      			; definition of the screen memory, in colapsed version for 1K
#include "endbasic.asm"
