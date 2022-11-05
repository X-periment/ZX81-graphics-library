;;  Written by Xperiment Nov 2022. Turorial available: https://youtu.be/0xKpHLAsj_s

#include "XlineBuffer16K.asm"

whereToPlot
DEFW 0

xlineInit
    ld hl, buffer;(DF_CC)
    ld (whereToPlot), hl
    ret

bresenhamLine  ; https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
    ld l, e
    or a
    ld a, d
    rl a
    sub e
lineLoop
    push af
    push de
    push hl
    call plot
    pop hl
    pop de
    pop af
    bit 7, a
    jr nz, negative
    inc b
    sub e
    sub e
negative
    add a, d
    add a, d
    inc c
    dec l
    jr nz, lineLoop
    ret

;-------------------------------
; here dy is going to take us up not down
; d = dy
; b = y
; e = dx
; c = x
; h = 0 -> down gentle h = 1 - > up gentle
bresenhamLineNeg  ; https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
    ld l, e
    or a
    ld a, d
    rl a
    sub e
lineLoopNeg
    push af
    push de
    push hl
    call plotFast
    pop hl
    pop de
    pop af
    bit 7, a
    jr nz, negativeNeg
    bit 0, h
    jr z, pass1Neg
    dec b
    jr pass2Neg
pass1Neg
    inc b
pass2Neg
    sub e
    sub e
negativeNeg
    add a, d
    add a, d
    inc c
    dec l
    jr nz, lineLoopNeg
    ret

;-----------------------------------
; d = dy
; b = y
; e = dx
; c = x
; h = 0 -> down gentle h = 1 - > up gentle
bresenhamLineNegH  ; https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
    ld l, d
    or a
    ld a, e
    rl a
    sub d
lineLoopNegH
    push af
    push de
    push hl
    call plotFast
    pop hl
    pop de
    pop af
    bit 7, a
    jr nz, negativeNegH
    bit 0, h
    jr z, pass1NegH
    inc c;dec c
    jr pass2NegH
pass1NegH
    inc c
pass2NegH
    sub d
    sub d
negativeNegH
    add a, e
    add a, e
    bit 0, h
    jr z, pass3H
    dec b; inc b  ; here is the issue perhaps, y is increasing, but we need it to decrease. x is also going in the wrong direction!
    jr pass4H
pass3H
    inc b
pass4H
    dec l
    jr nz, lineLoopNegH
    ret


;------------------------------------

plot
    push bc
    ld d, 1
    or a
    rr b
    jr nc, plotPass2
    ld d, 4
plotPass2
    or a
    rr c
    jr nc, plotPass1
    or a
    rl d

plotPass1
    push de
    ld hl, (whereToPlot)
    or a
    ld e, b
    ld d, 0
    rl e
    rl d
    rl e
    rl d
    rl e
    rl d
    rl e
    rl d
    rl e
    rl d
    ld a, b
    add a, e
    ld e, a
    add hl, de
    ld b, 0
    add hl, bc
    pop de
    ld b, (hl)
    call charToVal
    ld a, b
    or d
    ld d, a
    call valToChar
    ld (hl),  d
    pop bc
    ret


;------------------------------------

plotFast
    push bc
    ld d, 1
    ;or a
    ;rr b
    sra b
    jr nc, plotPass2Fast
    ld d, 4
plotPass2Fast
    ;or a
    ;rr c
    sra c
    jr nc, plotPass1Fast
    ;or a
    ;rl d
    sla d

plotPass1Fast
    push de

    ;or a
    ;ld e, b
    ;ld d, 0
    ld l, b
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl
    ;rl e
    ; sla e  ; sla does not pick up the carry
    ; rl d
    ; rl e
    ; rl d
    ; rl e
    ; rl d
    ; rl e
    ; rl d
    ; rl e
    ; rl d
    ex de, hl
    ld a, b
    add a, e
    ld e, a
    ld hl, (whereToPlot)
    add hl, de
    ld b, 0
    add hl, bc
    pop de
    ld b, (hl)
    bit 7, b
    call nz, charToValFast
    ld a, b
    or d
    ld d, a
    bit 3, d
    call nz, valToCharFast
    ld (hl),  d
    pop bc
    ret

;---------------------------------------------

charToValFast ; b is the char code on entry
; bug:: this fails to reset bit 7! and the rr would just hide the carry again!
    ;bit 7, b
    ;ret z
    res 7, b
    ld a, 15
    sub b
    ld b, a
    ret

valToCharFast
    ;bit 3, d
    ;ret z
    ;res 3, d
    ld a, 15
    sub d
    ld d, a
    set 7, d
    ret
    ;---------------------------------------------

charToVal ; b is the char code on entry
; bug:: this fails to reset bit 7! and the rr would just hide the carry again!
    bit 7, b
    ret z
    res 7, b
    ld a, 15
    sub b
    ld b, a
    ret

valToChar
    bit 3, d
    ret z
    ;res 3, d
    ld a, 15
    sub d
    ld d, a
    set 7, d
    ret
;---------------------------------------

clearScreen
    ld c, 24
    ld hl, (whereToPlot)
clearLoopOuter
    ld b, 32
clearLoop
    ld (hl), 0
    inc hl
    djnz clearLoop
    inc hl
    dec c
    jr nz, clearLoopOuter
    ret

;---------------------------------------

clearScreenFast
    ld a, 24
    ld hl, (whereToPlot)
    ld de, (whereToPlot)
    inc de
clearLoopOuterFast
    ;ld b, 32
    ld bc, 31
clearLoopFast
    ld (hl), 0
    ldir

    inc hl
    inc de
    inc hl
    inc de
    dec a
    jr nz, clearLoopOuterFast
    ret

;----------------------------------------------
clearScreenQFast
    push de
    push bc
    call clearScreenFast

    pop bc
    pop de
    ret

;----------------------------------------------
clearScreenQ
    push de
    push bc
    call clearScreenFast

    pop bc
    pop de
    ret
;-----------------------------------------------
transferBufferQ
    push de
    push bc
    call transferBufferFast
    pop bc
    pop de
    ret
;-----------------------------------------------

transferBuffer
    ld c, 24
    ld hl, (DF_CC)
    ld de, (whereToPlot)
bufferLoopOuter
    ld b, 32
bufferLoop
    ld a, (de)
    ld (hl), a
    inc hl
    inc de
    djnz bufferLoop
    inc hl
    inc de
    dec c
    jr nz, bufferLoopOuter
    ret

;-----------------------------------------------

transferBufferFast
    ld a, 24

    ld de, (DF_CC)
    ld hl, (whereToPlot)
bufferLoopOuterFast
    ld bc, 32
    ldir

    inc hl
    inc de
    dec a
    jr nz, bufferLoopOuterFast
    ret

;--------------------------------------------

delay2
    push bc
    ld b, a
    ld c, $ff
delay_loop
    dec bc
    ld a, b
    or c
    jr nz, delay_loop
    pop bc
    ret

;---------------------------------------

tempYS
    DEFB 0
tempYS2
    DEFB 0
calcLineSafe
    ; dx calc
    ld b, (hl)
    ld c, b
    inc hl
    ld a, (hl)
    ;inc hl
    sub b
    ld d, a ; store to check later for length zero lines
    ; check for negative difference
    bit 7,a
    jr nz, calcNegDxS
    ld e, a
    ; hack!
    inc hl
    ld a, (hl)
    ld (tempYS), a
    inc hl
    ld a, (hl)
    ld (tempYS2), a
    dec hl
    dec hl
    jr dyCalcS
calcNegDxS
    xor $ff
    inc a
    ld e, a
    ld c, (hl)
    ; now i also need to swap the y's!!! how?
    ; hack!
    inc hl
    ld a, (hl)
    ld (tempYS2), a
    inc hl
    ld a, (hl)
    dec hl
    ld (tempYS), a
    dec hl

dyCalcS
    inc hl
    ld a, (tempYS)
    ld b, a
    ;ld b, (hl) ;----------
    inc hl
    ld a, (tempYS2)
    ;ld a, (hl) ; -----------
    ;inc hl
    sub b
    ; check for zero length lines
    push af
    or d
    jr nz, lineHasLengthS
    pop af
    ret
lineHasLengthS
    pop af
    ; check for positive slope
    bit 7, a
    jr nz, calcNegDyS
    ld d, a
    ld h, 0
    call isLineSteepS
    ;call bresenhamLineNeg
    ret
calcNegDyS
    xor $ff
    inc a
    ld d, a
    ld a, (tempYS)
    ld b, a
    inc hl
    push hl
    ld h, 1 ; +ve slope !! this will mess up hl!!!
    ;ld d, 5
    ;ld e, 30
    call isLineSteepS

    pop hl
    ret

;--------------------------------
isLineSteepS
    ; steep line has d>e

    ld a, d
    sub e
    bit 7, a
    jr z, lineIsSteepS
    call bresenhamLineNeg
    ret
lineIsSteepS
    call bresenhamLineNegH
    ret
;--------------------------------
