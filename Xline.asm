; all the includes came from  https://www.sinclairzxworld.com/viewtopic.php?t=2186&start=40
#include "zx81defs.asm"
#include "zx81rom.asm"
#include "charcodes.asm"
#include "zx81sys.asm"                ;; removed some of unneeded definitions
#include "line1.asm"

    jp start

    #include "XlineBuffer16K.asm"

whereToPlot
    DEFW 0

start
    ld hl, buffer;(DF_CC)
    ld (whereToPlot), hl

    call clearScreen

    call transferBuffer

    ld hl, (whereToPlot)
    ld (hl), _A

    ld b, 0  ; row
    ld c, 2  ;column
    call plot

    ld b, 1  ; row
    ld c, 3  ;column
    call plot

    ld b, 3  ; row
    ld c, 0  ;column
    call plot
    inc b
    inc c

    call plot

loop

    call clearScreen
  ;  call transferBuffer
  ;  call delay
    ld d, 10   ; dy
    ld b, 5   ; y
    ld e, 30  ; dx
    ld c, 20   ; x


    call bresenhamLine
    call transferBuffer
    call delay

    ld d, 5   ; dy
    ld b, 5   ; y
    ld e, 30  ; dx
    ld c, 20   ; x
    ld h, 0 ; -ve slope

    call bresenhamLineNeg
    call transferBuffer
    call delay

    ; now dy is still positive, but the line will go up
    ld d, 5   ; dy
    ld b, 5   ; y
    ld e, 30  ; dx
    ld c, 20   ; x
    ld h, 1 ; +ve slope
    call bresenhamLineNeg
    call transferBuffer
    call delay

    ; now to do a steep line, swap registers used for dx and dy, & x and y
    ld d, 30   ; dy
    ld b, 5   ; y
    ld e, 5  ; dx
    ld c, 20   ; x
    ld h, 0 ; -ve slope
    call bresenhamLineNegH
    call transferBuffer
    call delay

    jp loop


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
    call plot
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
    call plot
    pop hl
    pop de
    pop af
    bit 7, a
    jr nz, negativeNegH
    bit 0, h
    jr z, pass1NegH
    dec c
    jr pass2NegH
pass1NegH
    inc c
pass2NegH
    sub d
    sub d
negativeNegH
    add a, e
    add a, e
    inc b
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

;--------------------------------------------

delay
    push bc
    ld bc, $2fff
delay_loop
    dec bc
    ld a, b
    or c
    jr nz, delay_loop
    pop bc
    ret

    ;---------------------------------------

#include "from_brandonw.asm"

#include "line2.asm"
#include "screenDefender16K.asm"      			; definition of the screen memory, in colapsed version for 1K
#include "endbasic.asm"
