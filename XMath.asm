;https://www.cpcwiki.eu/index.php/Programming:Sin/Cos_calculation

;Input: HL = angle in degree (0-360°)

;Output: HL = SIN(HL) * 32767, A = sign flag (0 if positive, &FF if negative)


INTSIN	LD BC, 360
LOOP1	BIT 7, H	;angle positive?
	JR Z, LOOP2	;-> yes, ok
	ADD HL, BC	;else add 360
	JR LOOP1	;repeat until H>0

LOOP2	OR A		;reset carry
	SBC HL, BC	;angle - 360
	JR NC, LOOP2	;->ok if >=0
	ADD HL, BC	;else correct value

	LD E, L		;angle to DE
	LD D, H
	LD BC, 90
	XOR A		;sign flag = 0
	SBC HL, BC	;angle < 90?
	JR NC, TEST2	;-> no
	EX DE, HL	;else HL = angle
	JR GETTAB	;get table value

TEST2	SBC HL, BC	;angle < 180?
	JR NC, TEST3	;-> no
	LD HL, 180	;else HL =
	OR A		;180 - angle
	SBC HL, DE
	JR GETTAB	;get table value

TEST3	DEC A		;sign flag &FF
	SBC HL, BC	;angle < 270?
	JR NC, TEST4	;-> no
	EX DE, HL	;else HL =
	OR A		;clear carry
	SBC HL, BC	;angle - 180
	SBC HL, BC
	JR GETTAB	;get table value

TEST4	LD HL, 360	;if angle >=270
	SBC HL, DE	;HL = 360 - angle

GETTAB	ADD HL, HL	;angle * 2
	LD DE, SINTAB	;+ start table
	ADD HL, DE	;= tableaddress
	LD E, (HL)	;lowbyte to E
	INC HL
	LD D, (HL)	;highbyte to D
	EX DE, HL	;result to HL
	RET

;*****
;Sinustable for angles between 0..90 degrees
;*****
;Values*32767

SINTAB
DEFW 0,572,1144,1715,2286
DEFW 2856,3425,3993,4560,5126
DEFW 5690,6252,6813,7371,7927
DEFW 8481,9032,9580,10126,10668
DEFW 11207,11743,12275,12803,13328
DEFW 13848,14364,14876,15383,15886
DEFW 16384,16876,17364,17846,18323
DEFW 18794,19260,19720,20173,20621
DEFW 21062,21497,21925,22347,22762
DEFW 23170,23571,23964,24351,24730
DEFW 25101,25465,25821,26169,26509
DEFW 26841,27165,27481,27788,28087
DEFW 28377,28659,28932,29196,29451
DEFW 29697,29934,30162,30381,30591
DEFW 30791,30982,31163,31335,31498
DEFW 31650,31794,31927,32051,32165
DEFW 32269,32364,32448,32523,32587
DEFW 32642,32687,32722,32747,32762
DEFW 32767


;---------------------------------------------
