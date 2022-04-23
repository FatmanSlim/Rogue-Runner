; Following the Edventure Assembler tutorial
; to program a Roguelike game on the Atari 8bit
; Graphics test

	org $2000	

screen  = $4000  ; Screen buffer
charset = $5000  ; Character Set
pmg     = $6000  ; Player Missile Data

	setup_screen()
	setup_colours()	
	;load_gfx()
	mva #>charset CHBAS
	clear_pmg()
	load_pmg()
	setup_pmg()
	display_map()
	
	jmp *
	
	icl 'hardware.asm'
	icl 'dlist.asm'
	icl 'gfx.asm'
	icl 'pmgdata.asm'
	
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
	mva #title_colour PCOLR0
	mva #title_colour PCOLR1
	mva #title_colour PCOLR2	
	mva #title_colour PCOLR3
	
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
	sta pmg_m4,x
	sta pmg_p0,x
	sta pmg_p1,x
	sta pmg_p2,x
	sta pmg_p3,x
	dex
	bne loop
	rts
	.endp

* --------------------------------------- *
* Proc: load_pmg                          *
* Load PMG Graphics                       *
* --------------------------------------- *
.proc load_pmg
pmg_m4 = pmg + $300
pmg_p0 = pmg + $400
pmg_p1 = pmg + $500
pmg_p2 = pmg + $600
pmg_p3 = pmg + $700	
	
	ldx #0
loop
	mva pmgdata,x pmg_m4+70,x
	mva pmgdata+68,x pmg_p0+70,x
	mva pmgdata+136,x pmg_p1+70,x
	mva pmgdata+204,x pmg_p2+70,x
	mva pmgdata+272,x pmg_p3+70,x
	inx
	cpx #68
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
	mva #3 GRACTL    ; Enable PMG
	mva #33 GRPRIOR   ; Give players priority and enables overlapping colors
	lda #108
	sta HPOSM3
	lda #110
	sta HPOSM2
	lda #112
	sta HPOSP0
	lda #120
	sta HPOSP1
	lda #128
	sta HPOSP2
	lda #136
	sta HPOSP3
	lda #144
	sta HPOSM1
	lda #146
	sta HPOSM0
	rts
	.endp

* --------------------------------------- *
* Proc: display_map                       *
* Displays the current map                *
* --------------------------------------- *
.proc display_map
	ldy #0
loop
	mva map,y screen,y
	mva map+80,y screen+80,y
	mva map+160,y screen+160,y
	mva map+240,y screen+240,y
	mva map+320,y screen+320,y
	mva map+400,y screen+400,y
	mva map+480,y screen+480,y
	mva map+560,y screen+560,y
	mva map+640,y screen+640,y
	mva map+720,y screen+720,y
	mva map+800,y screen+800,y
	mva map+880,y screen+880,y

	iny
	cpy #80
	bne loop
	rts

map
	.byte 0,0,0,0,0,0,0,0,0,0,12,13,4,62,65,66,4,85,89,90,95,96,100,66,4,62,65,66,12,13,0,0,0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0,0,0,12,13,63,64,67,68,86,87,91,3,3,97,101,102,63,64,67,68,12,13,0,0,0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0,0,0,8,9,69,70,73,74,86,87,91,92,98,97,101,102,69,70,73,74,8,9,0,0,0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0,0,0,10,11,71,72,75,76,86,88,93,94,94,99,103,102,71,72,75,76,10,11,0,0,0,0,0,0,0,0,0,0
	.byte 4,5,120,121,4,5,244,245,4,5,10,11,77,78,81,82,232,236,236,236,236,236,236,233,77,78,81,82,10,11,4,5,244,245,4,5,120,121,4,5
	.byte 6,7,122,123,6,7,246,247,6,7,10,11,79,80,83,84,238,128,128,128,128,128,128,239,79,80,83,84,10,11,6,7,246,247,6,7,122,123,6,7
	.byte 0,1,0,1,0,1,0,1,0,1,0,1,0,1,232,236,240,128,0,0,0,0,128,241,236,233,0,1,0,1,0,1,0,1,0,1,0,1,0,1
	.byte 1,0,1,0,1,0,1,0,1,0,1,0,1,0,238,128,128,128,0,0,0,0,128,128,128,239,1,0,1,0,1,0,1,0,1,0,1,0,1,0
	.byte 236,236,236,236,236,236,236,236,236,236,236,236,236,236,240,128,0,0,0,0,0,0,0,0,128,241,236,236,236,236,236,236,236,236,236,236,236,236,236,236
	.byte 237,237,237,237,237,237,242,243,237,237,237,237,237,237,242,128,0,0,0,0,0,0,0,0,128,243,237,237,237,237,237,237,242,243,237,237,237,237,237,237
	.byte 0,1,0,1,0,1,238,239,0,1,0,1,0,1,238,128,128,128,0,0,0,0,128,128,128,239,0,1,0,1,0,1,238,239,0,1,0,1,0,1
	.byte 1,0,1,0,1,0,238,239,1,0,1,0,1,0,234,237,242,128,0,0,0,0,128,243,237,235,1,0,1,0,1,0,238,239,1,0,1,0,1,0
	.byte 12,13,4,5,4,5,30,31,4,5,4,5,12,13,0,1,238,128,128,128,128,128,128,239,0,1,12,13,4,5,4,5,238,239,4,5,4,5,12,13
	.byte 12,13,6,7,6,7,32,33,6,7,6,7,12,13,1,0,234,237,237,237,237,237,237,235,1,0,12,13,6,7,6,7,234,235,6,7,6,7,12,13
	.byte 12,13,24,25,24,25,24,25,24,25,24,25,14,15,12,13,4,5,4,5,4,5,4,5,12,13,17,18,54,55,27,28,27,28,27,28,58,59,12,13
	.byte 12,13,24,26,24,26,24,26,24,26,24,26,10,16,12,13,6,7,6,7,6,7,6,7,12,13,19,11,56,57,1,29,1,29,1,29,60,61,12,13
	.byte 12,13,24,25,54,55,24,25,24,25,38,39,24,25,12,13,20,21,20,21,20,21,20,21,8,9,27,28,46,47,50,51,46,47,50,51,46,47,12,13
	.byte 12,13,24,26,56,57,24,26,24,26,40,41,24,26,12,13,22,23,22,23,22,23,22,23,10,11,1,29,48,49,52,53,48,49,52,53,48,49,12,13
	.byte 12,13,24,25,24,25,24,25,58,59,24,25,24,25,34,35,20,21,20,21,42,43,20,21,20,21,27,28,50,51,46,47,124,125,46,47,38,39,12,13
	.byte 12,13,24,26,24,26,24,26,60,61,24,26,24,26,36,37,22,23,22,23,44,45,22,23,22,23,1,29,52,53,48,49,126,127,48,49,40,41,12,13
	.byte 8,9,4,5,12,13,24,25,24,25,24,25,24,25,12,13,20,21,20,21,20,21,20,21,12,13,27,28,46,47,50,51,46,47,12,13,4,5,8,9
	.byte 10,11,6,7,12,13,24,26,24,26,24,26,24,26,12,13,22,23,22,23,22,23,22,23,12,13,1,29,48,49,52,53,48,49,12,13,6,7,10,11
	.byte 0,0,0,0,8,9,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,4,5,8,9,0,0,0,0
	.byte 0,0,0,0,10,11,6,7,6,7,6,7,6,7,6,7,6,7,6,7,6,7,6,7,6,7,6,7,6,7,6,7,6,7,10,11,0,0,0,0









	

	.endp

	
