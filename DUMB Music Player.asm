;* --- Dumb Unless Made Better ---
;*
;* DUMB Music Player (Prototype, using a stripped down version of Simple RMT Player for now) 
;* By VinsCool 
;*
;* To build: 'mads DUMB Music Player.asm -l:ASSEMBLED/build.lst -o:ASSEMBLED/build.xex' 
;--------------------------------------------------------------------------------------------------; 

;* Build flags, they are not the requirement, and could be changed if necessary 

	OPT R- F-
	icl "atari.def"			; Missing or conflicting labels cause build errors, be extra careful! 

;--------------------------------------------------------------------------------------------------;

ZEROPAGE	equ $0000 
DRIVER		equ $0800
;PLAYER		equ $3000 
;MODULE		equ $4000 
VLINE		equ 8			; 16 is the default according to Raster's example player 
RASTERBAR	equ $69			; $69 is a nice purpleish hue 
DISPLAY 	equ $FE			; Display List indirect memory address

;--------------------------------------------------------------------------------------------------;

; initialisation of the DUMB Driver and Player's very simple interface 
 
	icl 'DUMB Music Driver.asm'	; The lovely RMT driver wannabe :D 
;	org PLAYER
PLAYER 
start       
	ldx #0				; disable playfield and the black colour value
	stx SDMCTL			; write to Shadow Direct Memory Access Control address
	jsr wait_vblank			; wait for vblank before continuing
	stx COLOR4			; Shadow COLBK (background colour)
	stx COLOR2			; Shadow COLPF2 (playfield colour 2)
	ldx #$F				; white colour value
	stx COLOR1			; Shadow COLPF1 (Playfield colour 1), font colour
	mwa #dlist SDLSTL		; Start Address of the Display List
module_init 
	jsr DUMBMUSICDRIVER		; Init returns... absolutely nothing (for now)... 
	ldy #1				; 1xVBI speed is hardcoded for the time being 
	lda tabpp-1,y			; load from the line counter spacing table
	sta acpapx2			; lines between each play
	ldx #$22			; DMA enable, normal playfield
	stx SDMCTL			; write to Shadow Direct Memory Access Control address
	ldx #60				; load into index x a 60 frames buffer
wait_init   
	jsr wait_vblank			; wait for vblank => 1 frame
	dex				; decrement index x
	bne wait_init			; repeat until x = 0, total wait time is ~1 second
	mwa #line_01 DISPLAY 
	lda >DUMBMUSICDRIVER
	ldy #10
	jsr printhex_direct	
	lda <DUMBMUSICDRIVER 
	ldy #12 
	jsr printhex_direct
	lda >PLAYER
	ldy #21
	jsr printhex_direct	
	lda <PLAYER 
	ldy #23 
	jsr printhex_direct 
	lda >MODULE
	ldy #34
	jsr printhex_direct	
	lda <MODULE
	ldy #36 
	jsr printhex_direct
	ldx #156			; default value for all regions 
	stx ppap			; value used for screen synchronisation
	sei				; Set Interrupt Disable Status
	mwa VVBLKI oldvbi		; vbi address backup
	mwa #vbi VVBLKI			; write our own vbi address to it
	mva #$40 NMIEN			; enable vbi interrupts 
wait_sync
	lda VCOUNT			; current scanline, manipulated this way stabilises the timing
	cmp #VLINE			; is it equal? 
	bne wait_sync			; nope, repeat 

;--------------------------------------------------------------------------------------------------;

; main loop, code runs from here after initialisation

loop
	ldy #RASTERBAR			; custom rasterbar colour
acpapx1
	lda spap
	ldx #0
cku	equ *-1
	bne keepup
	lda VCOUNT			; vertical line counter synchro
	tax
	sub #VLINE
lastpap	equ *-1
	scs:adc #$ff
ppap	equ *-1
	sta dpap
	stx lastpap
	lda #0
spap	equ *-1
	sub #0
dpap	equ *-1
	sta spap
	bcs acpapx1
keepup
	adc #$ff
acpapx2	equ *-1
	sta spap
	ldx #0
	scs:inx
	stx cku
play_loop
;	sty WSYNC			; horizontal sync
	sty COLBK			; background colour 
	sty POTGO			; reset paddles for counting scanlines from 0 
	jsr DUMBMUSICDRIVER+3		; DUMB_play, (setpokey + 1 play) 
	lda POKEY			; POT0 is used as a scanline counter here 
	sta SCANLINE_COUNTER 		; this value will be displayed during the next VBI 
	ldy #$00			; black colour value
	sty COLBK			; background colour
	beq loop			; unconditional

;--------------------------------------------------------------------------------------------------;

; VBI loop

vbi
	lda KBCODE			; Keyboard Code
	cmp #$1C			; ESCape key?
	bne continue			; nope => loop
stopmusic 
	jsr DUMBMUSICDRIVER+9		; DUMB_silence, stop the Driver and reset the POKEY registers 
	mwa oldvbi VVBLKI		; restore the old vbi address
	ldx #$00			; disable playfield 
	stx SDMCTL			; write to Direct Memory Access (DMA) Control register
	dex				; underflow to #$FF
	stx CH				; write to the CH register, #$FF means no key pressed
	jsr wait_vblank			; wait for vblank before continuing
	jmp (DOSVEC)			; return to DOS, or Self Test by default
continue
	jsr print_debug 		; stuff 	
return_from_vbi 
	pla				; since we're in our own vbi routine, pulling all values manually is required
	tay
	pla
	tax
	pla
	rti				; return from interrupt

;--------------------------------------------------------------------------------------------------;

; wait for vblank subroutine

wait_vblank 
	lda RTCLOK+2			; load the real time frame counter to accumulator
wait        
	cmp RTCLOK+2			; compare to itself
	beq wait			; equal means it vblank hasn't began
	rts
	
;-----------------

; Print text from data tables, useful for many things 

printinfo 
	sty charbuffer
	ldy #0
do_printinfo
        lda $ffff,x
infosrc equ *-2
	sta (DISPLAY),y
	inx
	iny 
	cpy #0
charbuffer equ *-1
	bne do_printinfo 
	rts

;-----------------

; Print hex characters for several things, useful for displaying all sort of debugging infos
	
printhex
	ldy #0
printhex_direct     ; workaround to allow being addressed with y in different subroutines
	pha
	:4 lsr @
	;beq ph1    ; comment out if you want to hide the leftmost zeroes
	tax
	lda hexchars,x
ph1	
        sta (DISPLAY),y+
	pla
	and #$f
	tax
	mva hexchars,x (DISPLAY),y
	rts
hexchars 
        dta d"0123456789ABCDEF"

;-----------------

;* Print most infos on screen

print_debug
	mwa #line_05 DISPLAY 
	
;* Global Infos 

	lda SONGNUM
	ldy #36
	jsr printhex_direct 
	lda ROWNUM 
	
	eor #$FF 
	sec  
	adc ROWMAX 
	
	ldy #76
	jsr printhex_direct
	lda SPEED
	ldy #116
	jsr printhex_direct
	lda SDW_AUDCTL
	ldy #156
	jsr printhex_direct
	lda SDW_SKCTL
	ldy #196
	jsr printhex_direct
	lda #0 
	SCANLINE_COUNTER equ *-1 
	cmp PEAK_SCANLINE 
	bcc no_cpu_pike 
	sta PEAK_SCANLINE
no_cpu_pike
	ldy #236 
	jsr printhex_direct 

;* Notes 
 
	lda VAR_NOTE+0
	ldy #13
	jsr printhex_direct
	lda VAR_NOTE+1
	ldy #17
	jsr printhex_direct
	lda VAR_NOTE+2
	ldy #21
	jsr printhex_direct
	lda VAR_NOTE+3
	ldy #25
	jsr printhex_direct 
	
;* Freqs

	lda SDW_AUDF+0
	ldy #53
	jsr printhex_direct
	lda SDW_AUDF+1
	ldy #57
	jsr printhex_direct
	lda SDW_AUDF+2
	ldy #61
	jsr printhex_direct
	lda SDW_AUDF+3
	ldy #65
	jsr printhex_direct 
	
;* Distortions

	lda SDW_AUDC+0
	and #$F0
	ldy #94
	jsr printhex_direct
	lda #0 
	sta (DISPLAY),y
	lda SDW_AUDC+1
	and #$F0
	ldy #98
	jsr printhex_direct
	lda #0 
	sta (DISPLAY),y
	lda SDW_AUDC+2
	and #$F0
	ldy #102
	jsr printhex_direct
	lda #0 
	sta (DISPLAY),y
	lda SDW_AUDC+3
	and #$F0
	ldy #106
	jsr printhex_direct 
	lda #0 
	sta (DISPLAY),y
	
;* Volumes

	lda SDW_AUDC+0
	and #$0F
	ldy #133
	jsr printhex_direct
	dey
	lda #0 
	sta (DISPLAY),y
	lda SDW_AUDC+1
	and #$0F
	ldy #137
	jsr printhex_direct
	dey
	lda #0 
	sta (DISPLAY),y
	lda SDW_AUDC+2
	and #$0F
	ldy #141
	jsr printhex_direct
	dey
	lda #0 
	sta (DISPLAY),y
	lda SDW_AUDC+3
	and #$0F
	ldy #145
	jsr printhex_direct
	dey
	lda #0 
	sta (DISPLAY),y
	
;* Pauses 
 
	lda CMD_PAUSE+0
	ldy #173
	jsr printhex_direct
	lda CMD_PAUSE+1
	ldy #177
	jsr printhex_direct
	lda CMD_PAUSE+2
	ldy #181
	jsr printhex_direct
	lda CMD_PAUSE+3
	ldy #185
	jsr printhex_direct 
	
;* Instruments 
 
	lda CMD_INSTRUMENT+0
	ldy #213
	jsr printhex_direct
	lda CMD_INSTRUMENT+1
	ldy #217
	jsr printhex_direct
	lda CMD_INSTRUMENT+2
	ldy #221
	jsr printhex_direct
	lda CMD_INSTRUMENT+3
	ldy #225
	jsr printhex_direct

	mwa #line_0C DISPLAY 
	
;* Finetunes 
 
	lda VAR_FREQ+0
	ldy #13
	jsr printhex_direct
	lda VAR_FREQ+1
	ldy #17
	jsr printhex_direct
	lda VAR_FREQ+2
	ldy #21
	jsr printhex_direct
	lda VAR_FREQ+3
	ldy #25
	jsr printhex_direct 
	
;* Peak Scanlines Count 

	lda #0 
	PEAK_SCANLINE equ *-1 
	ldy #36 
	jsr printhex_direct 

;* Vibrato Command 
 
	lda CMD_VIBRATO+0
	ldy #53
	jsr printhex_direct
	lda CMD_VIBRATO+1
	ldy #57
	jsr printhex_direct
	lda CMD_VIBRATO+2
	ldy #61
	jsr printhex_direct
	lda CMD_VIBRATO+3
	ldy #65
	jsr printhex_direct 
	
;* Vibrato Offset 
 
	lda CMD_VIBOFFSET+0
	ldy #93
	jsr printhex_direct
	lda CMD_VIBOFFSET+1
	ldy #97
	jsr printhex_direct
	lda CMD_VIBOFFSET+2
	ldy #101
	jsr printhex_direct
	lda CMD_VIBOFFSET+3
	ldy #105
	jsr printhex_direct 
	
;* Arpeggio Command
 
	lda CMD_ARPEGGIO+0
	ldy #133
	jsr printhex_direct
	lda CMD_ARPEGGIO+1
	ldy #137
	jsr printhex_direct
	lda CMD_ARPEGGIO+2
	ldy #141
	jsr printhex_direct
	lda CMD_ARPEGGIO+3
	ldy #145
	jsr printhex_direct 
	
;* Arpeggio Timer
 
	lda CMD_ARPTIMER+0
	ldy #173
	jsr printhex_direct
	dey
	lda #0 
	sta (DISPLAY),y
	lda CMD_ARPTIMER+1
	ldy #177
	jsr printhex_direct
	dey
	lda #0 
	sta (DISPLAY),y
	lda CMD_ARPTIMER+2
	ldy #181
	jsr printhex_direct
	dey
	lda #0 
	sta (DISPLAY),y
	lda CMD_ARPTIMER+3
	ldy #185
	jsr printhex_direct 
	dey
	lda #0 
	sta (DISPLAY),y
	
/*	
;* Autofilter

	lda CMD_AUTOFILTER+0
	ldy #213
	jsr printhex_direct
	lda CMD_AUTOFILTER+1
	ldy #217
	jsr printhex_direct 
*/

	rts

;-----------------

;--------------------------------------------------------------------------------------------------;

; text strings, each line holds 40 characters, line 5 is toggled with the SHIFT key 

;	dta d"|    - DUMB MUSIC DRIVER DEBUGGER -    |"

LINES 
	dta $51
	:38 dta $52
	dta $45
line_00	dta d"|  DUMB MUSIC DRIVER v0.1 BY VINSCOOL  |"
line_01	dta d"| DRIVER $???? INIT $???? MODULE $???? |"
line_02	dta d"|                                      |"
line_03	dta d"|                                      |"
line_04	dta d"|           CH1 CH2 CH3 CH4 ",$51,$52,$52,$52,$52,$52,$52,$52,$52,$52,$45,$7C
line_05	dta d"| NOTE       ??  ??  ??  ?? |ORDER  ??||"
line_06	dta d"| FREQ       ??  ??  ??  ?? |ROW    ??||"
line_07	dta d"| DISTORTION  ?   ?   ?   ? |SPEED  ??||"
line_09	dta d"| VOLUME      ?   ?   ?   ? |AUDCTL ??||"
line_0A	dta d"| PAUSE      ??  ??  ??  ?? |SKCTL  ??||"
line_0B	dta d"| INSTRUMENT ??  ??  ??  ?? |RASTER ??||"
line_0C	dta d"| FINETUNE   ??  ??  ??  ?? |PEAK   ??||"
line_0D	dta d"| VIBRATO    ??  ??  ??  ?? ",$5A,$52,$52,$52,$52,$52,$52,$52,$52,$52,$43,$7C
line_0E	dta d"| VIBOFFSET  ??  ??  ??  ??            |"
line_0F	dta d"| ARPEGGIO   ??  ??  ??  ??            |"
line_10	dta d"| ARPTIMER    ?   ?   ?   ?            |"
line_11	dta d"|                                      |"
line_12	dta d"|                                      |"
line_13	dta d"|                                      |"
line_14	dta d"|                                      |"
	dta $5A
	:38 dta $52
	dta $43
LINESEND

;--------------------------------------------------------------------------------------------------;

; Display list
	.align $100
dlist 
	dta $70,$70,$70,$70,$70,$70 		; empty lines on top of the display 
	dta $42,a(LINES)			; ANTIC mode 2, memory address set to the first line 
	:((LINESEND - LINES - 1) / 40) dta $02	; insert all the remaining lines directly below  
	dta $41,a(dlist)			; Jump and wait for vblank, return to dlist 

;--------------------------------------------------------------------------------------------------;

; line counter spacing table for instrument speed from 1 to 4

tabpp       
	dta 156,78,52,39
oldvbi	
	dta a(0)			; vbi address backup
	run start			; set the run address 
PLAYER_END

MODULE
	icl 'DUMB Module.asm'		; example DUMB Module, the ORG address could be defined anywhere 
MODULE_END 
	
;--------------------------------------------------------------------------------------------------;

; that's all :D 

