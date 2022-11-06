; Written by Xperiment, Nov 2022. Turorial available: https://youtu.be/0xKpHLAsj_s

; first 5 includes came from  https://www.sinclairzxworld.com/viewtopic.php?t=2186&start=40 via ByteForever

#include "zx81defs.asm"
#include "zx81rom.asm"
#include "charcodes.asm"
#include "zx81sys.asm"                ;; removed some of unneeded definitions
#include "line1.asm"

    jp demoStart

#include "XlineLib2.asm"
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

demoStart

    call xlineInit
    ; b = y
    ; c = x
    ; d = dy
    ; e = dx

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


    call transferBufferQ
    ld a, $ff
    call delay2


    call clearScreenQ
    ld c, 5 ; x
    ld b, 20 ; y
    call showPoint
    ld c, 35
    ld b, 10
    call showPoint

    ld hl, line2
    call calcLine


    call transferBufferQ
    ld a, $ff
    call delay2


    call clearScreenQ
    ld c, 5 ; x
    ld b, 10 ; y
    call showPoint
    ld c, 15
    ld b, 30
    call showPoint

    ld hl, line3
    call calcLine


    call transferBufferQ
    ld a, $ff
    call delay2


    call clearScreenQ
    ld c, 25 ; x
    ld b, 10 ; y
    call showPoint
    ld c, 5
    ld b, 20
    call showPoint


    ld hl, line4
    call calcLine


    call transferBufferQ
    ld a, $ff
    call delay2


    call clearScreenQ
    ld c, 5 ; x
    ld b, 40 ; y
    call showPoint
    ld c, 15
    ld b, 10
    call showPoint


    ld hl, line5
    call calcLine

    call transferBufferQ
    ld a, $ff
    call delay2



    jp repeat
;---------------------------------------
showPoint
    call plot

    call transferBufferQ
    ld a, $2f
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


;--------------------------------------------


#include "from_brandonw.asm"

#include "line2.asm"
#include "screenDefender16K.asm"      			; definition of the screen memory, in colapsed version for 1K
#include "endbasic.asm"
