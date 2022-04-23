; Following the Edventure Assembler tutorial
; to program a Roguelike game on the Atari 8bit
; Episode 8 Player-Missile Graphics

	org $2000	

screen   = $4000  ; Screen buffer
charset  = $5000  ; Character Set
pmg      = $6000  ; Player Missile Data
tiles    = $7000  ; Tile Character Index

	setup_screen()
	setup_colours()	
	;load_gfx()
	mva #>charset CHBAS
	clear_pmg()
	load_pmg()
	setup_pmg()
	;load_tiledata()
	display_map()
	
	jmp *
	
	icl 'hardware.asm'
	icl 'dlist.asm'
	icl 'gfx.asm'
	icl 'pmgdata.asm'
	icl 'tiledata.asm'
	
* --------------------------------------- *
* Proc: setup_colours                     *
* Sets up colours                         *
* --------------------------------------- *
.proc setup_colours
med_gray = $06
lt_gray = $0A
sap_green = $C2
dark_sienna = $F2
midnight_black = $00
phthalo_blue = $74
mountain_mx = $E0
titanium_white = $0D
vandyke_brown = $F8
title_colour = $92

	; Character Set Colours
	mva #med_gray COLOR0        ; %01
	mva #lt_gray COLOR1         ; %10
	mva #dark_sienna COLOR2     ; %11
	mva #sap_green COLOR3       ; %11 (inverse)
	mva #midnight_black COLOR4  ; %00

	; Player-Missile Colours
	mva #vandyke_brown PCOLR0
	mva #phthalo_blue PCOLR1
	mva #mountain_mx PCOLR2	
	mva #titanium_white PCOLR3
	
	rts
	.endp
		
* --------------------------------------- *
* Proc: clear_pmg                         *
* Clears memory for Player-Missile GFX    *
* --------------------------------------- *
.proc clear_pmg
pmg_m4 = pmg + $300
pmg_p0 = pmg + $400
pmg_p1 = pmg + $500
pmg_p2 = pmg + $600
pmg_p3 = pmg + $700	
	
	ldx #$F0
	lda #0
	
loop
	dex
	sta pmg_m4,x
	sta pmg_p0,x
	sta pmg_p1,x
	sta pmg_p2,x
	sta pmg_p3,x
	bne loop
	rts
	.endp

* --------------------------------------- *
* Proc: load_pmg                          *
* Load PMG Graphics                       *
* --------------------------------------- *
.proc load_pmg
;pmg_m4 = pmg + $300
pmg_p0 = pmg + $400
pmg_p1 = pmg + $500
pmg_p2 = pmg + $600
pmg_p3 = pmg + $700	
	
	ldx #0
loop
	mva pmgdata,x pmg_p0+69,x
	mva pmgdata+64,x pmg_p0+99,x
	mva pmgdata,x pmg_p0+129,x
	mva pmgdata,x+128 pmg_p0+160,x
	mva pmgdata,x pmg_p0+190,x
	mva pmgdata+16,x pmg_p1+69,x
	mva pmgdata+80,x pmg_p1+99,x
	mva pmgdata+16,x pmg_p1+129,x
	mva pmgdata+144,x pmg_p1+160,x
	mva pmgdata+16,x pmg_p1+190,x
	mva pmgdata+32,x pmg_p2+69,x
	mva pmgdata+96,x pmg_p2+99,x
	mva pmgdata+32,x pmg_p2+129,x
	mva pmgdata+160,x pmg_p2+160,x
	mva pmgdata+32,x pmg_p2+190,x
	mva pmgdata+48,x pmg_p3+69,x
	mva pmgdata+112,x pmg_p3+99,x
	mva pmgdata+48,x pmg_p3+129,x
	mva pmgdata+176,x pmg_p3+160,x
	mva pmgdata+48,x pmg_p3+190,x
	inx
	cpx #16
	bne loop
	rts
	.endp
	
* --------------------------------------- *
* Proc: setup_pmg                         *
* Sets up Player-Missile Geaphics System  *
* --------------------------------------- *
.proc setup_pmg
	mva #>pmg PMBASE
	mva #62 SDMCTL   ; Single Line resolution	
	mva #3 GRACTL    ; Enable PMG 3
	mva #33 GRPRIOR   ; Give players priority and enables overlapping colors
	lda #124
	sta HPOSP0
	sta HPOSP1
	sta HPOSP2
	sta HPOSP3
	rts
	.endp
	
* --------------------------------------- *
* Macro: blit_row                         *
* Copies one line of map to screen        *
* --------------------------------------- *
	
.macro blit_row map, screen, tiles
	ldx #0
	ldy #0
loop
	txa
	pha
	lda :map,x
	asl
	asl
	tax
	lda :tiles,x
	sta :screen,y
	lda :tiles+2,x
	sta :screen+40,y
	inx
	iny
	lda :tiles,x
	sta :screen,y
	lda :tiles+2,x
	sta :screen+40,y
	iny
	pla
	tax
	inx
	cpx #20
	bne loop
	.endm
	
* --------------------------------------- *
* Proc: display_map                       *
* Displays the current map                *
* --------------------------------------- *
.proc display_map
	blit_row map, screen, tiles
	blit_row map+20, screen+80, tiles
	blit_row map+40, screen+160, tiles
	blit_row map+60, screen+240, tiles
	blit_row map+80, screen+320, tiles
	blit_row map+100, screen+400, tiles
	blit_row map+120, screen+480, tiles
	blit_row map+140, screen+560, tiles
	blit_row map+160, screen+640, tiles
	blit_row map+180, screen+720, tiles
	blit_row map+200, screen+800, tiles
	blit_row map+220, screen+880, tiles
	rts

map
.byte 0,0,0,0,0,13,9,9,32,34,36,38,9,9,14,0,0,0,0,0
.byte 0,0,0,0,0,12,62,62,33,35,37,39,62,62,12,0,0,0,0,0
.byte 9,9,9,9,9,14,6,6,6,6,6,6,6,6,13,9,9,9,9,9
.byte 6,6,6,6,6,6,5,5,5,5,5,5,5,5,6,6,6,6,6,6
.byte 5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5
.byte 5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5
.byte 12,9,9,16,9,9,12,5,5,5,5,5,5,12,9,9,17,9,9,12
.byte 12,16,16,16,16,16,13,12,9,9,9,9,12,14,17,17,17,17,17,12
.byte 12,16,16,16,16,16,16,10,15,15,15,15,10,17,17,17,17,17,17,12
.byte 12,16,16,16,16,16,16,15,15,15,15,15,15,17,17,17,17,17,17,12
.byte 10,9,12,16,16,16,16,12,15,15,15,15,12,17,17,17,17,12,9,10
.byte 0,0,10,9,9,9,9,9,9,9,9,9,9,9,9,9,9,10,0,0

;.byte 0,0,0,0,0,0,0,0,0,0,14,15,4,5,4,5,4,85,89,90,95,96,100,66,4,5,4,5,17,18,0,0,0,0,0,0,0,0,0,0
;.byte 0,0,0,0,0,0,0,0,0,0,10,16,6,7,6,7,86,87,91,3,3,97,101,102,6,7,6,7,19,11,0,0,0,0,0,0,0,0,0,0
;.byte 0,0,0,0,0,0,0,0,0,0,12,13,6,7,6,7,86,87,91,92,98,97,101,102,6,7,6,7,12,13,0,0,0,0,0,0,0,0,0,0
;.byte 0,0,0,0,0,0,0,0,0,0,12,13,6,7,6,7,86,88,93,94,94,99,103,102,6,7,6,7,12,13,0,0,0,0,0,0,0,0,0,0
;.byte 4,5,4,5,4,5,4,5,4,5,17,18,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,14,15,4,5,4,5,4,5,4,5,4,5
;.byte 6,7,6,7,6,7,6,7,6,7,19,11,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,10,16,6,7,6,7,6,7,6,7,6,7
;.byte 0,1,0,1,0,1,0,1,0,1,0,1,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,1,0,1,0,1,0,1,0,1,0,1
;.byte 1,0,1,0,1,0,1,0,1,0,1,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,1,0,1,0,1,0,1,0,1,0,1,0
;.byte 0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2
;.byte 2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0
;.byte 0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2
;.byte 2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0,2,0
;.byte 12,13,4,5,4,5,24,25,4,5,4,5,12,13,0,2,0,2,0,2,0,2,0,2,0,2,12,13,4,5,4,5,27,28,4,5,4,5,12,13
;.byte 12,13,6,7,6,7,24,26,6,7,6,7,12,13,2,0,2,0,2,0,2,0,2,0,2,0,12,13,6,7,6,7,1,29,6,7,6,7,12,13
;.byte 12,13,24,25,24,25,24,25,24,25,24,25,14,15,12,13,4,5,4,5,4,5,4,5,12,13,17,18,27,28,27,28,27,28,27,28,27,28,12,13
;.byte 12,13,24,26,24,26,24,26,24,26,24,26,10,16,12,13,6,7,6,7,6,7,6,7,12,13,19,11,1,29,1,29,1,29,1,29,1,29,12,13
;.byte 12,13,24,25,24,25,24,25,24,25,24,25,24,25,8,9,20,21,20,21,20,21,20,21,8,9,27,28,27,28,27,28,27,28,27,28,27,28,12,13
;.byte 12,13,24,26,24,26,24,26,24,26,24,26,24,26,10,11,22,23,22,23,22,23,22,23,10,11,1,29,1,29,1,29,1,29,1,29,1,29,12,13
;.byte 12,13,24,25,24,25,24,25,24,25,24,25,24,25,20,21,20,21,20,21,20,21,20,21,20,21,27,28,27,28,27,28,27,28,27,28,27,28,12,13
;.byte 12,13,24,26,24,26,24,26,24,26,24,26,24,26,22,23,22,23,22,23,22,23,22,23,22,23,1,29,1,29,1,29,1,29,1,29,1,29,12,13
;.byte 8,9,4,5,12,13,24,25,24,25,24,25,24,25,12,13,20,21,20,21,20,21,20,21,12,13,27,28,27,28,27,28,27,28,12,13,4,5,8,9
;.byte 10,11,6,7,12,13,24,26,24,26,24,26,24,26,12,13,22,23,22,23,22,23,22,23,12,13,1,29,1,29,1,29,1,29,12,13,6,7,10,11
;.byte 0,0,0,0,8,9,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,8,9,0,0,0,0
;.byte 0,0,0,0,10,11,6,7,6,7,6,7,6,7,6,7,6,7,6,7,6,7,6,7,6,7,6,7,6,7,6,7,6,7,10,11,0,0,0,0
	.endp

	
