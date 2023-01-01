;* --- Dumb Unless Made Better ---
;*
;* DUMB Music Driver - Prototype 2 
;* By VinsCool 
;* 
;* Some inspiration was taken from Raster Music Tracker's original driver, mainly for familiarity 
;--------------------------------------------------------------------------------------------------; 

		icl 'DUMB Module.inc' 		;* MADS Assembly Macros and Module Format Definitions  

;-----------------

;* Global Variables, anything that is directly used by the music driver 

		org ZEROPAGE+$80 
DUMBZPG 
SONGNUM 	org *+1
SONGMAX 	org *+1
ROWNUM		org *+1
ROWMAX		org *+1
TIMER		org *+1
SPEED		org *+1
VTIMER		org *+1 
VSPEED		org *+1
TMP0		org *+1 
TMP1		org *+1 
;* 11 bytes 

;-----------------

;* Indirect Memory Address Pointers used for parsing the Module data 

SONGIDX		org *+2				;* Current Songline Index 
PTNIDX		org *+2				;* Current Pattern Index 
ROWIDX		org *+2				;* Current Row Index 
INSIDX		org *+2				;* Current Instrument Index 
FREQIDX		org *+2 			;* Current Tuning Table Index 
;* 10 bytes 

;-----------------

;* Temporary Variables, used to process Effect Commands and Instruments Commands 

VAR_NOTE	org *+4
VAR_FREQ	org *+4
VAR_VOLUME	org *+4 
DUMBZPGEND
;* 12 bytes 

;-----------------

;* Shadow POKEY registers, buffered during playback, and copied to the actual POKEY the next frame 

SDW_POKEY
SDW_AUDF	org *+4
SDW_AUDC	org *+4 
SDW_AUDCTL	org *+1 
SDW_SKCTL	org *+1  
;* 10 bytes 

;-----------------

;--------------------------------------------------------------------------------------------------;

;* Start of DUMB jump table... 

	org DRIVER 
DUMBMUSICDRIVER
	jmp DUMB_init				;* Must be run first, to clear memory and initialise the player... 
	jmp DUMB_play				;* One play per call. SetPokey is executed first, then the player routines are processed 
	jmp DUMB_continue			;* Similar to DUMB_play, but SetPokey is skipped very useful for playing simple things.
	jmp DUMB_silence			;* Run this to stop the driver, and reset all POKEY registers to 0 
	jmp setpokeyfull 			;* Copy the buffered POKEY bytes to into the real ones 

;-----------------

;--------------------------------------------------------------------------------------------------;

;* Clear all Module Variables in memory first

DUMB_init
	jsr DUMB_silence 			; clear the POKEY registers first
	lda #0
	ldx #DUMBZPGEND - DUMBZPG		; number of zeropage bytes used 
DUMB_init_loop 
	sta DUMBZPG,x 				; clear all the zeropage bytes 
	dex 
	bpl DUMB_init_loop 			; continue until everything was cleared 
	ldx #DUMB_VARIABLES_END - DUMB_VARIABLES; number of driver variables used 
DUMB_init_loop_2 
	sta DUMB_VARIABLES,x 			; clear all the driver variable  
	dex 
	bpl DUMB_init_loop_2 			; continue until everything was cleared 
DUMB_begin 
	lda MAXTLEN 				; Initialise the Maximal Pattern Length value from the module 
	sta ROWNUM				; Set the maximal number of rows per patterns 
	sta ROWMAX				; Set to backup memory, so it could be reloaded quickly between patterns 
	lda SONGLEN				; Initialise the maximal number of songlines in song 
	sta SONGMAX				; Set to backup memory, so it could be compared directly to current songline number 
	lda INITSPD				; Initialise song speed defined in the module 
	sta TIMER 				; Set to current pattern as the initial speed value to count from (in ticks) 
	sta SPEED 				; Set to backup memory, so it could be reloaded quickly between patterns 
	lda VBISPD				; Initialise the xVBI speed defined in the module 
	sta VTIMER 				; Set to current xVBI speed used in the song, and should not change during the playback 
	sta VSPEED 				; Set to backup memory, so it could be reloaded quickly between patterns 
	dec CMD_NOTE+0 				; Disable notes, they should only play if valid data is loaded into them first 
	dec CMD_NOTE+1 
	dec CMD_NOTE+2 
	dec CMD_NOTE+3 
	jmp DUMB_play_songline_reset 

;-----------------

;--------------------------------------------------------------------------------------------------;

;* Mute and Reset the POKEY registers, processed using the setpokeyfull routine below 

DUMB_silence 
	lda #0 
	ldy #8					; 4 AUDF, 4 AUDC and 1 AUDCTL to reset 
DUMB_silence_loop	
	sta SDW_POKEY,y	
	dey
	bpl DUMB_silence_loop 			; continue until all bytes were written 
	lda #3
	sta SDW_SKCTL				; Normal SKCTL register state 

;-----------------

;* Setpokey, intended for double buffering the POKEY register bytes for timing and cosmetic purposes 

setpokeyfull
	lda SDW_SKCTL+0 			; to initialise the SKCTL register, could be omitted unless the Two-Tone Filter is used 
	sta $D20F 
setpokey
	ldy SDW_AUDCTL+0			; normal routine otherwise, skipping 2 instructions if desired 
	lda SDW_AUDF+0
	ldx SDW_AUDC+0
	sta $D200
	stx $D201
	lda SDW_AUDF+1
	ldx SDW_AUDC+1
	sta $D202
	stx $D203
	lda SDW_AUDF+2
	ldx SDW_AUDC+2
	sta $D204
	stx $D205
	lda SDW_AUDF+3
	ldx SDW_AUDC+3
	sta $D206
	stx $D207
	sty $D208
	rts 

;-----------------

;--------------------------------------------------------------------------------------------------;

;* Main routine for the DUMB Music Driver, for typical music playback, call at least once per VBI 
;* Be sure to call DUMB_init first to initialise everything in memory, and every time new music data is loaded 
;* Attempting to execute DUMB_play without initialisation may corrupt memory and/or use garbage data as music data! 

DUMB_play
	jsr setpokeyfull 			; update the POKEY with the last buffered registers data 
	dec TIMER 				; decrement 1 unit of the pause timer 
	beq DUMB_play_row			; once the Pause timer reaches 0, process the next row
	jmp DUMB_continue			; if the Pause has not yet been finished, the next row won't play for this frame 

DUMB_play_row 
	lda SPEED 				; reload the song speed from memory 
	sta TIMER				; and reset the timer for the next row 
	dec ROWNUM				; decrement the rows counter 
	bne DUMB_play_advance 			; if not yet 0, the pattern is not finished, play the next row 
	lda ROWMAX				; get the maximal pattern length defined 
	sta ROWNUM 				; reset the Row count 
	
DUMB_play_songline
	inc SONGNUM				; increment the current songline number 
	lda SONGNUM 
	cmp SONGMAX				; maximal number songlines 
	bne DUMB_play_pattern	 		; if not ended, update the songline index, then immediately get the new patterns data 
	
DUMB_play_songline_reset
	mwa SONGTBL SONGIDX			; re-initialise Songline Address Table first 
	lda #0 
	sta SONGNUM 				; reset the Songline count
	beq DUMB_get_pattern_index		; unconditional 

DUMB_play_pattern	
	lda SONGIDX 				; Songline Index LSB 
	adc #4					; Carry is clear 
	sta SONGIDX 
	bcc DUMB_get_pattern_index 
	inc SONGIDX+1 
	
DUMB_get_pattern_index 
	ldx #3					; start with ch4 

DUMB_get_pattern_index_loop
	txa 
	tay 
	lda (SONGIDX),y 			; get pattern number for that channel 
	asl @ 
	tay  
	lda PTNTBL,y 
	sta PTNROW_LSB,x 
	iny 
	lda PTNTBL,y 
	adc #0
	sta PTNROW_MSB,x 
	lda #0 
	sta CMD_PAUSE,x 
	dex 
	bpl DUMB_get_pattern_index_loop 

DUMB_play_advance   
	ldx #3					; start with ch4 

DUMB_play_row_again  
	ldy CMD_PAUSE,x				; is there a pause currently set for this channel?
	beq DUMB_play_parse_row			; if Y = 0, play like normal, the Row Pause is finished 
	dec CMD_PAUSE,x 			; else, decrement the value currently in memory by 1 
	jmp DUMB_play_skip_row_index 

DUMB_play_parse_row 
	lda PTNROW_LSB,x 			; get the row index pointer in memory first 
	sta ROWIDX 
	lda PTNROW_MSB,x
	sta ROWIDX+1 

DUMB_get_row_byte_parameter  
	lda (ROWIDX),y 				; Parameter Byte will always be the first byte loaded 
	beq DUMB_play_skip_row_index		; if the byte is $00, the row is skipped immediately, due to being a Terminator Byte!  
	bpl DUMB_get_row_byte_note	 	; if the Trigger bit is not set, continue with the remaining bits 
	and #$7F				; else, keep the lower 7 bits 
	sta CMD_PAUSE,x				; and use them to set the new pause length directly 
	bpl DUMB_get_row_byte_advance_pointer	; unconditional 

DUMB_get_row_byte_note 
	sta TMP0 				; put in the temporary memory first 
	asl TMP0 				; initial offset, bit 7 is already clear 
	bpl DUMB_get_row_byte_instrument 
	iny 
	lda (ROWIDX),y 
	bmi DUMB_get_row_byte_note_cmd		; if the value is negative, continue below, this is a Note Stop command 
	cmp #REL 
	bcc DUMB_get_row_byte_note_no_cmd 
	dec instr_release,x 
	bne DUMB_get_row_byte_instrument
	
DUMB_get_row_byte_note_cmd
	jsr DUMB_process_note_stop		; this is a Note Stop command, clear some variables before continuing 
	beq DUMB_get_row_byte_instrument

DUMB_get_row_byte_note_no_cmd	
	sta CMD_NOTE,x 				; set the new Note value for this channel 

DUMB_get_row_byte_instrument
	asl TMP0 
	bpl DUMB_get_row_byte_volume 
	iny 
	lda (ROWIDX),y 
	sta CMD_INSTRUMENT,x			; set the new Instrument value for this channel 

DUMB_get_row_byte_volume
	asl TMP0 
	bpl DUMB_get_row_byte_cmd1
	iny 
	lda (ROWIDX),y 
	sta CMD_VOLUME,x			; set the new Volume value for this channel 

DUMB_get_row_byte_cmd1
	asl TMP0 
	bpl DUMB_get_row_byte_cmd2
	jsr DUMB_set_effect_cmd			; initialise the Effect Command 
	ldy TMP1 				; reload the Y offset, then continue

DUMB_get_row_byte_cmd2
	asl TMP0 
	bpl DUMB_get_row_byte_cmd3
	jsr DUMB_set_effect_cmd			; initialise the Effect Command 
	ldy TMP1 				; reload the Y offset, then continue

DUMB_get_row_byte_cmd3
	asl TMP0 
	bpl DUMB_get_row_byte_cmd4
	jsr DUMB_set_effect_cmd			; initialise the Effect Command 
	ldy TMP1 				; reload the Y offset, then continue	

DUMB_get_row_byte_cmd4
	asl TMP0 
	bpl DUMB_get_row_byte_advance_pointer 
	jsr DUMB_set_effect_cmd			; initialise the Effect Command 
	ldy TMP1 				; reload the Y offset, then continue

DUMB_get_row_byte_advance_pointer 
	tya 
	sec					; set Carry manually to add 1 on top of the addition below, save 1 INY instruction  
	adc PTNROW_LSB,x 
	sta PTNROW_LSB,x 
	bcc DUMB_play_skip_row_index 
	inc PTNROW_MSB,x 

DUMB_play_skip_row_index 
	dex					; decrement the index for the next channel 
	bmi DUMB_continue
	jmp DUMB_play_row_again			; continue until all channels were processed 

;-----------------

;--------------------------------------------------------------------------------------------------; 

;* Secondary routine for the DUMB Music Driver, for processing music data in memory, such as instruments or effect commands 
;* This point is automatically reached when DUMB_play is called first, since it is the direct continuation of it 
;* Useful for playing sound effects using Instrument data, using a method very similar to one used by RMT 
;* Processed data for Note, Pitch, Volume, etc, will then be used for buffering the Shadow POKEY registers accordingly 
;* If DUMB_play isn't used for music playback, setpokey or setpokeyfull must be called manually, or when it is appropriate 
;* Otherwise, nothing will be written to the actual POKEY registers, which would result in nothing being output!

DUMB_continue 
	ldx #3					; start with ch4 

DUMB_play_next_channel 
	lda CMD_NOTE,x 				; first, get the Note command currently in memory  
	bmi DUMB_continue_advance 		; if the negative flag is set, skip this channel, there is nothing to play
	sta VAR_NOTE,x 				; overwrite the Temporary Note Variable, since it may be edited before it is output 
	lda #0 
	sta VAR_FREQ,x 
	jsr DUMB_process_instrument 		; run the Instrument Routine if a valid note was read, in this case 

DUMB_process_commands 
	lda CMD_ARPEGGIO,x			; is Arpeggio used? this will be the starting point for Note offset 
	beq DUMB_process_commands_no_arps 	; in this case, the value will be #0, so this would work just fine 
	dec CMD_ARPTIMER,x 			; decrement the active Arpeggio timer 
	bpl DUMB_process_arpeggio_continue 	; if positive, get the next entry from the arpeggio table 
	lda #2					; else, the arpeggio timer must be reset 
	sta CMD_ARPTIMER,x 			; for 2 notes 
	lda #0 					; due to the way this is tangled, load #0 here for the Note offset 
	bpl DUMB_process_commands_no_arps 	; unconditional 
	
DUMB_process_arpeggio_continue 
	txa 					; get the channel number 
	asl @ 					; multiply it by 2
	add CMD_ARPTIMER,x			; add the Arpeggio Timer as an offset 
	tay 					; copy to Y 
	lda ARPTBL,y 				; and fetch the note currently in the Arpeggio table 
	
DUMB_process_commands_no_arps
	add VAR_NOTE,x 				; add the current note to the value in the table 
	sta VAR_NOTE,x				; and overwrite it, so it could be played for the next part as intended 
	lda CMD_VIBRATO,x 			; is Vibrato used? this will be the starting point for Freq offset 
	beq DUMB_process_commands_no_vib	; in this case, the value will be #0, so this would work just fine 
	ldy CMD_VIBOFFSET,x			; get the current vibrato table offset in Y 
	lda vibtabnext,y			; now get the next vibrato table offset
	sta CMD_VIBOFFSET,x			; and update the value in memory with it for the next frame 
	lda vib0,y 				; add the value from the Vibrato table to it

DUMB_process_commands_no_vib
	add CMD_FINETUNE,x 			; add the Finetune value to it 
	add VAR_FREQ,x				; add the current Freq variable to it, if an instrument Command edited it already (FIXME) 
	sta VAR_FREQ,x 				; save the Freq variable for later 

DUMB_continue_advance 
	dex					; decrement the index for the next channel 
	bpl DUMB_play_next_channel 		; process all channels that way, until X overflows to #$FF 
	jmp DUMB_play_buffer_registers 		; now process all the data from every channels after everything was done 

;-----------------

;--------------------------------------------------------------------------------------------------; 

;* Process the Note currently in memory 

DUMB_process_note_stop 
	lda #0 
	sta SDW_AUDF,x 				; reset channel AUDF 
	sta SDW_AUDC,x				; reset channel AUDC	
	sta CMD_AUDCTL,x 			; reset channel AUDCTL  
	sta CMD_VOLUME,x 			; reset channel Volume 
	sta CMD_VIBRATO,x 			; reset vibrato command 
	sta CMD_ARPEGGIO,x 			; reset arpeggio command 
	sta CMD_FINETUNE,x 			; reset finetune command 
	rts

;--------------------------------------------------------------------------------------------------;

;* An attempt at implementing effect commands... 
;* A will hold the $CC byte, and will be used to set the desired command in the Channel indexed by X
;* Y may hold the $XY Parameter for the Command using it, otherwise, #0 is assumed 

DUMB_set_effect_cmd
	iny 
	lda (ROWIDX),y 				; Effect Command value 
	pha 					; quick backup in the Stack 
	iny 
	lda (ROWIDX),y 				; $XY Parameter value
	sty TMP1 				; backup of the Y offset 
	tay 					; copy the $XY parameter to Y 
	pla 					; get the Effect Command value back from the Stack 
	and #$0F				; only keep the command index number using the lowest 4 bits 
	asl @					; make a quick and dirty jump table allowing a 4 bytes index 
	asl @ 
	sta c_index+1				; branch will now match the value of the Effect Command Index Number 
c_index	bne * 					; also, all jumps will end with a RTS! 
	jmp DUMB_set_effect_cmd_0xy
	nop 
	jmp DUMB_set_effect_cmd_1xy 
	nop 
	jmp DUMB_set_effect_cmd_2xy 
	nop
	jmp DUMB_set_effect_cmd_3xy 
	nop
	jmp DUMB_set_effect_cmd_4xy 
	nop
	jmp DUMB_set_effect_cmd_5xy 
	nop
	jmp DUMB_set_effect_cmd_6xy 
	nop
	jmp DUMB_set_effect_cmd_7xy 
	nop
	jmp DUMB_set_effect_cmd_8xy 
	nop
	jmp DUMB_set_effect_cmd_9xy 
	nop
	jmp DUMB_set_effect_cmd_Axy 
	nop
	jmp DUMB_set_effect_cmd_Bxy 
	nop
	jmp DUMB_set_effect_cmd_Cxy 
	nop
	jmp DUMB_set_effect_cmd_Dxy 
	nop
	jmp DUMB_set_effect_cmd_Exy 
	nop
	jmp DUMB_set_effect_cmd_Fxy 
	nop

;-----------------

DUMB_set_effect_cmd_0xy 			; Arpeggio Command => 0 = Basenote, x = Basenote + x, y = Basenote + y
	lda #0					; initial timer, offset by 2 so the first frame is the original note 
	sta CMD_ARPTIMER,x			; if $XY = $00, the Arpeggio command will be skipped entirely  
	tya					; get the $XY parameter from Y 
	sta CMD_ARPEGGIO,x			; the command has been written to the channel variable 
	txa 
	asl @ 
	tay 
DUMB_set_arpeggio_y
	lda CMD_ARPEGGIO,x
	and #$0F				; only keep the low 4 bits to get the parameter y 
	sta ARPTBL,y 
	iny 
DUMB_set_arpeggio_x 
	lda CMD_ARPEGGIO,x
	lsr @					; else, use the parameter x and offset the note once the high 4 bits are shifted 
	lsr @
	lsr @
	lsr @ 
	sta ARPTBL,y 
	rts 

;-----------------
	
DUMB_set_effect_cmd_1xy 			; Pitch Slide Up

	rts 
	
;-----------------
	
DUMB_set_effect_cmd_2xy 			; Pitch Slide Down

	rts 
	
;-----------------
	
DUMB_set_effect_cmd_3xy 			; Portamento 

	rts 
	
;-----------------
	
DUMB_set_effect_cmd_4xy 			; Vibrato 
	tya 
	sta CMD_VIBRATO,x			; save the Vibrato parameter to fetch it when needed
	lda vibtabbeg,y				; then get the initial Vibrato offset from the table 
	sta CMD_VIBOFFSET,x			; and overwrite the previous value using it 
	rts 
	
;-----------------
	
DUMB_set_effect_cmd_5xy 			; Set Distortion $0Y 
	tya 
	and #$0E 				; ignore Bit 0 
	sta CMD_DISTORTION,x 			; overwrite the Distortion used for this channel 
	rts 

;-----------------

DUMB_set_effect_cmd_6xy				; Set Autofilter Offset $XY 

	rts
	
;-----------------
	
DUMB_set_effect_cmd_7xy 			; Tremolo 

	rts 
	
;-----------------
	
DUMB_set_effect_cmd_8xy 			; Set AUDCTL (TODO: Add checks to only let valid channels use specific modes) 
	tya 
	sta CMD_AUDCTL,x 
	rts 
	
;-----------------
	
DUMB_set_effect_cmd_9xy 			; Finetune $XY 
	tya 
	sta CMD_FINETUNE,x
	rts 
	
;-----------------
	
DUMB_set_effect_cmd_Axy 			; Volume Fade 

	rts 
	
;-----------------
	
DUMB_set_effect_cmd_Bxy 			; Go to Songline $XY 
	mwa SONGTBL SONGIDX			; re-initialise Songline Address Table first 
	tya
	sta SONGNUM				; new Songline destination set 
	asl @ 
	bcc no_inc_1 
	inc SONGIDX+1
no_inc_1
	asl @
	bcc no_inc_2 
	inc SONGIDX+1
no_inc_2
	adc SONGIDX 
	sta SONGIDX 
	bcc no_inc_3
	inc SONGIDX+1
no_inc_3 
	lda #1 
	sta ROWNUM				; next row will be 0, triggering the next songline
	rts 
	
;-----------------
	
DUMB_set_effect_cmd_Cxy 			; UNDEFINED 

	rts 
	
;-----------------
	
DUMB_set_effect_cmd_Dxy 			; End Pattern 
	lda #1 
	sta ROWNUM				; next row will be 0, triggering the next songline
	rts 
	
;-----------------
	
DUMB_set_effect_cmd_Exy 			; UNDEFINED 

	rts 
	
;-----------------
	
DUMB_set_effect_cmd_Fxy 			; Set Speed $XY 
	sty TIMER				; reset the speed timer with its value before decay
	sty SPEED				; overwrite the speed value currently set 
	rts 

;-----------------

;--------------------------------------------------------------------------------------------------; 

;* This subroutine will assign the correct tuning tables to each channels based on the Distortion, Command and AUDCTL bits 

DUMB_play_buffer_registers 
	lda CMD_AUDCTL+0			; merge the Channel AUDCTL values for the actual AUDCTL register 
	ora CMD_AUDCTL+1
	ora CMD_AUDCTL+2
	ora CMD_AUDCTL+3
	sta SDW_AUDCTL+0
	ldx #3					; once again, start from the channel 4, Y is still free to use here! 
DUMB_play_buffer_registers_continue 
	lda CMD_NOTE,x 				; is there a note intended to be played for this channel?
	bpl DUMB_play_buffer_process_audc	; if the value is positive, continue below channels jumptable process  
DUMB_play_buffer_registers_next 
	dex 					; decrement the channel index 
	bpl DUMB_play_buffer_registers_continue	; continue until all channels were processed 
	rts 					; finished, all the POKEY registers were updated 

;-----------------

DUMB_play_buffer_process_audc
	ldy CMD_DISTORTION,x			; current POKEY distortion set to be used 
	lda DISTORTIONS,y			; get the Distortion using the value offset from the command as well 
	ora VAR_VOLUME,x			; apply the Pattern Volume directly to it 
	sta SDW_AUDC,x 				; write directly to the AUDC Byte
	txa					; transfer X to Accumulator 
	asl @					; make a quick and dirty jump table allowing a 2 bytes index 
	sta d_index+1				; branch will match the AUDCTL stuff relative to the channel being used! 
d_index	bne * 
	bcc DUMB_play_buffer_registers_ch1
	bcc DUMB_play_buffer_registers_ch2
	bcc DUMB_play_buffer_registers_ch3
	bcc DUMB_play_buffer_registers_ch4

;-----------------

DUMB_play_buffer_registers_ch1
	lda instr_autoflag,x			; get the instrument Autoflag value 
	and #%01000000 
	beq DUMB_play_buffer_registers_ch1_a	; if the Auto179mhz flag is not set, ignore this step 
	lda SDW_AUDCTL+0 			; get the current AUDCTL value from memory 
	ora #$40				; apply the value for 1.79mhz in CH1 to it 
	sta SDW_AUDCTL+0			; overwrite the AUDCTL with the updated value 
;	bne DUMB_play_buffer_process_audf_179mhz
	
DUMB_play_buffer_registers_ch1_a 
	lda instr_autoflag,x			; get the instrument Autoflag value 
	and #%00100000 
	beq DUMB_play_buffer_registers_ch1_b	; if the Autofilter flag is not set, ignore this step 
	lda SDW_AUDCTL+0 			; get the current AUDCTL value from memory 
	ora #$04				; apply the value for Filter in CH1 to it 
	sta SDW_AUDCTL+0			; overwrite the AUDCTL with the updated value 

DUMB_play_buffer_registers_ch1_b
	lda SDW_AUDCTL+0 			; get the current AUDCTL value from memory 
	and #$41				; 1.79mhz and/or 15khz mode in CH1? 
	beq DUMB_play_buffer_process_audf	; if the value is 0, it's neither of them 
	and #$40				; 1.79mhz mode in CH1? 
	beq DUMB_play_buffer_process_audf_15khz	; if the value is 0, it's 15khz mode 
	bne DUMB_play_buffer_process_audf_179mhz; otherwise it's 1.79mhz mode 

;-----------------

DUMB_play_buffer_registers_ch2
	lda instr_autoflag,x			; get the instrument Autoflag value 
	bpl DUMB_play_buffer_registers_ch2_a	; if the Auto16-bit flag is not set, ignore this step 
	lda SDW_AUDCTL+0 			; get the current AUDCTL value from memory 
	ora #$50				; apply the value for 16-bit in CH2 to it 
	sta SDW_AUDCTL+0			; overwrite the AUDCTL with the updated value 	
;	jmp DUMB_play_buffer_process_audf_16bit	; finish with the 16-bit procedure without further checks! 

DUMB_play_buffer_registers_ch2_a 
	lda instr_autoflag,x			; get the instrument Autoflag value 
	and #%00100000 
	beq DUMB_play_buffer_registers_ch2_b	; if the Autofilter flag is not set, ignore this step 
	lda SDW_AUDCTL+0 			; get the current AUDCTL value from memory 
	ora #$02				; apply the value for Filter in CH2 to it 
	sta SDW_AUDCTL+0			; overwrite the AUDCTL with the updated value 

DUMB_play_buffer_registers_ch2_b
	lda SDW_AUDCTL+0 			; get the current AUDCTL value from memory 
	and #$51				; 16-bit and/or 15khz mode in CH2? 
	beq DUMB_play_buffer_process_audf	; if the value is 0, it's neither of them 
	and #$50				; 16-bit mode in CH2? 
	beq DUMB_play_buffer_process_audf_15khz	; if the value is 0, it's 15khz mode 
	cmp #$50				; is it REALLY 16-bit mode in CH2? 
	bcc DUMB_play_buffer_process_audf	; if the value is lower, it is NOT! 
	jmp DUMB_play_buffer_process_audf_16bit	; otherwise, finish with the 16-bit procedure 

;-----------------

DUMB_play_buffer_registers_ch3
	lda instr_autoflag,x			; get the instrument Autoflag value 
	and #%01000000 
	beq DUMB_play_buffer_registers_ch3_a	; if the Auto179mhz flag is not set, ignore this step 
	lda SDW_AUDCTL+0 			; get the current AUDCTL value from memory 
	ora #$20				; apply the value for 1.79mhz in CH3 to it 
	sta SDW_AUDCTL+0			; overwrite the AUDCTL with the updated value 
	bne DUMB_play_buffer_process_audf_179mhz
DUMB_play_buffer_registers_ch3_a 
	lda SDW_AUDCTL+0 			; get the current AUDCTL value from memory 
	and #$21				; 1.79mhz and/or 15khz mode in CH3? 
	beq DUMB_play_buffer_process_audf	; if the value is 0, it's neither of them 
	and #$20				; 1.79mhz mode in CH3? 
	beq DUMB_play_buffer_process_audf_15khz	; if the value is 0, it's 15khz mode 
	bne DUMB_play_buffer_process_audf_179mhz; otherwise it's 1.79mhz mode 

;-----------------

DUMB_play_buffer_registers_ch4
	lda instr_autoflag,x			; get the instrument Autoflag value 
	bpl DUMB_play_buffer_registers_ch4_a	; if the Auto16-bit flag is not set, ignore this step 
	lda SDW_AUDCTL+0 			; get the current AUDCTL value from memory 
	ora #$28				; apply the value for 16-bit in CH4 to it 
	sta SDW_AUDCTL+0			; overwrite the AUDCTL with the updated value 	
	jmp DUMB_play_buffer_process_audf_16bit	; finish with the 16-bit procedure without further checks!
DUMB_play_buffer_registers_ch4_a
	lda SDW_AUDCTL+0 			; get the current AUDCTL value from memory 
	and #$29				; 16-bit and/or 15khz mode in CH4? 
	beq DUMB_play_buffer_process_audf	; if the value is 0, it's neither of them 
	and #$28				; 16-bit mode in CH4? 
	beq DUMB_play_buffer_process_audf_15khz	; if the value is 0, it's 15khz mode 
	cmp #$28				; is it REALLY 16-bit mode in CH4? 
	bcc DUMB_play_buffer_process_audf	; if the value is lower, it is NOT! 
	jmp DUMB_play_buffer_process_audf_16bit	; otherwise, finish with the 16-bit procedure 

;-----------------

;* Final AUDF output done here

DUMB_play_buffer_process_audf_179mhz 		; 1.79mhz mode  
	lda FREQ179MHZ,y			; get the lookup table LSB assigned to the Distortion 
	sta FREQIDX 				; set the LSB to use for the index 
	iny 
	lda FREQ179MHZ,y			; get the lookup table MSB assigned to the Distortion 
	bne DUMB_play_buffer_process_audf_a	; unconditional 
DUMB_play_buffer_process_audf_15khz 		; 15khz mode 
	lda FREQ15KHZ,y				; get the lookup table LSB assigned to the Distortion 
	sta FREQIDX 				; set the LSB to use for the index 
	iny 
	lda FREQ15KHZ,y				; get the lookup table MSB assigned to the Distortion 
	bne DUMB_play_buffer_process_audf_a	; unconditional 
DUMB_play_buffer_process_audf 			; 64khz mode, default 
	lda FREQ64KHZ,y				; get the lookup table LSB assigned to the Distortion 
	sta FREQIDX 				; set the LSB to use for the index 
	iny 
	lda FREQ64KHZ,y				; get the lookup table MSB assigned to the Distortion 
DUMB_play_buffer_process_audf_a
	sta FREQIDX+1				; set the MSB to use for the index 

DUMB_play_buffer_process_audf_note
	ldy VAR_NOTE,x 				; fetch the note currently in memory 
	bmi DUMB_play_buffer_process_audf_done_a
	lda (FREQIDX),y 			; get the note byte from the tuning table 
	ldy VAR_FREQ,x				; get the detune offset from memory, and branch depending on the sign it uses
	bmi DUMB_subtract_freq			; it's a negative value to process, ranging between #$80 and #$FF 

DUMB_add_freq
	add VAR_FREQ,x				; add the detune offset directly to it 
	bcc DUMB_play_buffer_process_audf_done	; if the value did not overflow, there is nothing else to do 
	lda #$FF 				; else, use #$FF as the maximum value 
	bcs DUMB_play_buffer_process_audf_done	; unconditional 
	
DUMB_subtract_freq  
	sta TMP0				; for reference purpose after the addition 
	add VAR_FREQ,x				; add the detune offset directly to it 
	cmp TMP0 				; compare to the previous value just in case 
	bcc DUMB_play_buffer_process_audf_done	; if the value did not overflow, there is nothing else to do
	lda #0	 				; else, use #0 as the maximum value 
	
DUMB_play_buffer_process_audf_done
	sta SDW_AUDF,x 				; write directly to the AUDF Byte 

DUMB_play_buffer_process_audf_done_a
	jmp DUMB_play_buffer_registers_next 	; once this is done, process the next channel 

;-----------------
	
;* Final AUDF output done here (16-bit) 

DUMB_play_buffer_process_audf_16bit 
	lda FREQ16BIT,y				; get the lookup table LSB assigned to the Distortion 
	sta FREQIDX 				; set the LSB to use for the index 
	iny 
	lda FREQ16BIT,y				; get the lookup table MSB assigned to the Distortion 
	sta FREQIDX+1				; set the MSB to use for the index
	ldy VAR_NOTE,x 				; fetch the note currently in memory 
	lda (FREQIDX),y 			; get the note byte from the tuning table 
	sta SDW_AUDF,x 				; write the 16-bit MSB to the AUDF early 
	lda FREQIDX 				; get the indirect address LSB
	adc #96					; the 16-bit MSB table is always 96 bytes away from the 16-bit LSB table
	sta FREQIDX 				; by adding 96 to the indirect address, it will be correctly offset 
	lda FREQIDX+1				; get the indirect address MSB 
	adc #0					; carry will be added automatically to adjust the address MSB 
	sta FREQIDX+1				; the indirect address MSB is now overwritten the same way 
	lda (FREQIDX),y 			; get the note byte from the tuning table 
	ldy VAR_FREQ,x				; get the detune offset from memory, and branch depending on the sign it uses
	bmi DUMB_subtract_freq_16bit		; it's a negative value to process, ranging between #$80 and #$FF 

DUMB_add_freq_16bit
	add VAR_FREQ,x				; add the detune offset directly to it 
	bcc DUMB_audf_16bit_done		; if the value did not overflow, there is nothing else to do 
	inc SDW_AUDF,x				; else, increment the 16-bit MSB by 1 
	bcs DUMB_audf_16bit_done		; unconditional 
	
DUMB_subtract_freq_16bit  
	sta TMP0				; for reference purpose after the addition 
	add VAR_FREQ,x				; add the detune offset directly to it 
	cmp TMP0 				; compare to the previous value just in case 
	bcc DUMB_audf_16bit_done		; if the value did not overflow, there is nothing else to do
	dec SDW_AUDF,x				; else, decrement the 16-bit MSB by 1 

DUMB_audf_16bit_done 
	dex 					; dex early! 
	sta SDW_AUDF,x 				; write the 16-bit LSB to the AUDF directly  
	lda #0 
	sta SDW_AUDC,x				; since we're in 16-bit mode, the next channel is muted 
	jmp DUMB_play_buffer_registers_next 	; once this is done, process the next channel 

;-----------------

;--------------------------------------------------------------------------------------------------; 

;* Instrument initialisation and playback routine
;* This was previously based on the original RMT Instrument routine, but this is no longer the case 
;* No code was borrowed for this attempt, only the design is loosely inspired by the Famitracker Instrument Structure
;* The routine itself however is made of original code written from scratch, which is also still work in progress 

DUMB_process_instrument 
	lda CMD_INSTRUMENT,x 			; is there an Instrument already used in the current Channel? 
	bpl DUMB_process_instrument_immediate	; if yes, process its data immediately 
	and #INSTRESET				; else, clear the bit used to define the request for Instrument Initialisation 
	sta CMD_INSTRUMENT,x			; then, overwrite the value currently in memory with this one 
	lda #0 					; #0 will reset variables, except for the Envelope/Table offsets, managed differently 
	sta instr_envelope_flag,x		; reset the Volume Envelope flag 
	sta instr_distaudctl_flag,x		; reset the Distortion and AUDCTL Envelope flag 
	sta instr_notes_tbl_flag,x		; reset the Notes Table flag 
	sta instr_freqs_tbl_flag,x 		; reset the Freqs Table flag 
	sta instr_cmd_flag,x			; reset the Commands Table flag 
	sta instr_release,x 			; the Release flag should also be reset when a new Instrument is used 
	sta instr_tablenote,x 			; reset the Note Table variable 
	sta instr_tablefreq,x 			; reset the Freq Table variable 
	lda CMD_INSTRUMENT,x 			; the instrument is now ready to use, but first, make sure to load its value again 
DUMB_process_instrument_immediate  
	asl @ 					; multiply the value by 2 to get the correct Instrument Address Table offset 
	tay 					; copy the value to Y for the next step 
	lda INSTTBL,y 				; get the Instrument Address LSB 
	sta INSIDX				; write it to the Instrument Index LSB 
	iny 
	lda INSTTBL,y 				; get the Instrument Address MSB 
	sta INSIDX+1 				; write it to the Instrument Index MSB 

;-----------------

;* Process the Volume Envelope 

DUMB_process_volume_envelope 
	ldy #0 					; Y = 0 
	lda (INSIDX),y 				; Instrument Volume Envelope Pointer 
	bmi DUMB_process_volume_envelope_done	; if the bit 7 is set, there is no Envelope, skip this part 
	asl @					; multiply by 2 for the address offset 
	tay 
	lda INSTENV,y 				; get the Volume Envelope address 
	sta PTNIDX 				; and write it to the Pattern Index Indirect address to get actual data 
	iny 
	lda INSTENV,y
	sta PTNIDX+1 

DUMB_process_volume_envelope_start 
	ldy instr_envelope_flag,x 
	bne DUMB_process_volume_envelope_sustain; if Y isn't 0, it's already initialised  
	lda #4 					; 4 bytes are used to set up Envelopes and Tables, this value is a constant  
	sta instr_envelope_idx,x		; initial Envelope offset, for the Start offset 
	lda (PTNIDX),y				; verify the Envelope parameters first thing first 
	sta instr_envelope_mode,x		; save this variable for later use if needed while we're here 
	bpl DUMB_process_volume_envelope_good 	; a positive value means there is also a Sustain offset to set up 
	ldy #3 					; otherwise, just get the Envelope End offset position 
	bne DUMB_process_volume_envelope_not_sus; there is no sustain, hijack the Release branch to finish setting this up 

DUMB_process_volume_envelope_good
	lda #2					; this will be used for the Envelope End offset 
	sta instr_envelope_flag,x 		; initial Envelope flag, for the Sustain offset 
	tay 					; overwrite Y to make sure it's using the same offset 

DUMB_process_volume_envelope_sustain 
	lda instr_envelope_mode,x		; is there a Sustain and/or Release to use? 
	bmi DUMB_process_volume_envelope_end	; if the value is negative, there is no Sustain, skip ahead directly 
	lda instr_release,x			; is the Release flag set? Sustain will be skipped in this case 
	bne DUMB_process_volume_envelope_release; if the value is not 0, it is most likely set to Release  
	lda (PTNIDX),y 				; get the Envelope Sustain offset for its End position 
	cmp instr_envelope_idx,x 		; compare to the Envelope offset position currently in use 
	beq DUMB_process_volume_envelope_offset	; if the value is equal, the End position was reached 
	bcs DUMB_process_volume_envelope_fetch	; else, the End position was not reached yet, it couldn't be overshot 
	
DUMB_process_volume_envelope_release 
	cpy #3 					; was Release initialised already? 
	bcs DUMB_process_volume_envelope_end	; if the value is equal or above, it already was, continue 
	ldy #2					; else, get the Release Start offset position into Y 
	lda (PTNIDX),y 				; get the Start position for the Release offset 
	sta instr_envelope_idx,x 		; update the Envelope offset position with this value 
	iny					; increment Y to be on the correct offset 

DUMB_process_volume_envelope_not_sus
	tya 					; then pass it to the Accumulator 
	sta instr_envelope_flag,x 		; update the Envelope flag for the Envelope End offset  	
	
DUMB_process_volume_envelope_end
	lda (PTNIDX),y 				; get the Envelope Release offset for either its Start position
	cmp instr_envelope_idx,x 		; compare to the Envelope offset position currently in use 
	beq DUMB_process_volume_envelope_done	; if the value is equal, the End position was reached 
	bcs DUMB_process_volume_envelope_fetch	; else, the End position was not reached yet, it couldn't be overshot 

DUMB_process_volume_envelope_offset 	
	dey 					; decrement Y to get the correct Sustain offset 
	lda (PTNIDX),y 				; get the Start position for the Sustain offset 
	sta instr_envelope_idx,x 		; update the Envelope offset position with this value 

DUMB_process_volume_envelope_fetch 
	ldy instr_envelope_idx,x		; get the Envelope offset position in Y, which will then be used to fetch values to use  
	inc instr_envelope_idx,x		; increment the Envelope offset position early once this is done

DUMB_process_volume_envelope_finalise 
	lda (PTNIDX),y 				; get the Volume from the Envelope at current offset position 
	and #$0F				; keep only the low 4 bits, just in case there is Stereo Volume data 
	ora CMD_VOLUME,x			; merge with the Pattern Volume 
	tay 					; the combined values will be used as an offset in the Volume Level table
	lda volumetab,y				; retrieve the "actual" Volume Level to use using the combined value 
	sta VAR_VOLUME,x 			; save to the Volume Variable, this will be output when the Distortion bits are merged 

DUMB_process_volume_envelope_done 

;-----------------

;* Process the Distortion and AUDCTL Envelope 

DUMB_process_audctl_envelope 
	ldy #1 					; Y = 1 
	lda (INSIDX),y 				; Instrument Distortion/AUDCTL Envelope Pointer 
	bmi DUMB_process_audctl_envelope_done	; if the bit 7 is set, there is no Envelope, skip this part 
	asl @					; multiply by 2 for the address offset 
	tay 
	lda INSTAUD,y 				; get the Distortion/AUDCTL Envelope address 
	sta PTNIDX 				; and write it to the Pattern Index Indirect address to get actual data 
	iny 
	lda INSTAUD,y
	sta PTNIDX+1 

DUMB_process_audctl_envelope_start 
	ldy instr_distaudctl_flag,x 
	bne DUMB_process_audctl_envelope_sustain; if Y isn't 0, it's already initialised  
	lda #4 					; 4 bytes are used to set up Envelopes and Tables, this value is a constant  
	sta instr_distaudctl_idx,x		; initial Envelope offset, for the Start offset 
	lda (PTNIDX),y				; verify the Envelope parameters first thing first 
	sta instr_distaudctl_mode,x		; save this variable for later use if needed while we're here 
	bpl DUMB_process_audctl_envelope_good 	; a positive value means there is also a Sustain offset to set up 
	ldy #3 					; otherwise, just get the Envelope End offset position 
	bne DUMB_process_audctl_envelope_not_sus; there is no sustain, hijack the Release branch to finish setting this up 

DUMB_process_audctl_envelope_good
	lda #2					; this will be used for the Envelope End offset 
	sta instr_distaudctl_flag,x 		; initial Envelope flag, for the Sustain offset 
	tay 					; overwrite Y to make sure it's using the same offset 

DUMB_process_audctl_envelope_sustain 
	lda instr_distaudctl_mode,x		; is there a Sustain and/or Release to use? 
	bmi DUMB_process_audctl_envelope_end	; if the value is negative, there is no Sustain, skip ahead directly
	lda instr_release,x			; is the Release flag set? Sustain will be skipped in this case 
	bne DUMB_process_audctl_envelope_release; if the value is not 0, it is most likely set to Release  
	lda (PTNIDX),y 				; get the Envelope Sustain offset for its End position 
	cmp instr_distaudctl_idx,x 		; compare to the Envelope offset position currently in use 
	beq DUMB_process_audctl_envelope_offset	; if the value is equal, the End position was reached 
	bcs DUMB_process_audctl_envelope_fetch	; else, the End position was not reached yet, it couldn't be overshot 
	
DUMB_process_audctl_envelope_release 
	cpy #3 					; was Release initialised already? 
	bcs DUMB_process_audctl_envelope_end	; if the value is equal or above, it already was, continue 
	ldy #2					; else, get the Release Start offset position into Y 
	lda (PTNIDX),y 				; get the Start position for the Release offset 
	sta instr_distaudctl_idx,x 		; update the Envelope offset position with this value 
	iny					; increment Y to be on the correct offset 

DUMB_process_audctl_envelope_not_sus
	tya 					; then pass it to the Accumulator 
	sta instr_distaudctl_flag,x 		; update the Envelope flag for the Envelope End offset  	
	
DUMB_process_audctl_envelope_end
	lda (PTNIDX),y 				; get the Envelope Release offset for either its Start position
	cmp instr_distaudctl_idx,x 		; compare to the Envelope offset position currently in use 
	beq DUMB_process_audctl_envelope_done	; if the value is equal, the End position was reached 
	bcs DUMB_process_audctl_envelope_fetch	; else, the End position was not reached yet, it couldn't be overshot 

DUMB_process_audctl_envelope_offset 	
	dey 					; decrement Y to get the correct Sustain offset 
	lda (PTNIDX),y 				; get the Start position for the Sustain offset 
	sta instr_distaudctl_idx,x 		; update the Envelope offset position with this value 

DUMB_process_audctl_envelope_fetch 
	ldy instr_distaudctl_idx,x		; get the Envelope offset position in Y, which will then be used to fetch values to use  
	inc instr_distaudctl_idx,x		; increment the Envelope offset position early once this is done

DUMB_process_audctl_envelope_finalise 
	lda (PTNIDX),y 				; get the Distortion and AUDCTL from the Envelope at current offset position 
	tay 	
	and #$F0 				; keep only the high 4 bits, the Auto AUDCTL bits 
	sta instr_autoflag,x			; save for later when the AUDCTL is being processed 
	tya 
	and #$0E 
	sta CMD_DISTORTION,x 			; update the Distortion set by Row commands, Instrument parameters take priority! 

DUMB_process_audctl_envelope_done
	
;----------------- 

;* Process the Notes Table Envelope 

DUMB_process_notes_table 
	ldy #2 					; Y = 2 
	lda (INSIDX),y 				; Instrument Notes Table Pointer 
	bmi DUMB_process_notes_table_done	; if the bit 7 is set, there is no Table, skip this part  
	asl @					; multiply by 2 for the address offset 
	tay 
	lda INSTNOT,y 				; get the Notes Table address 
	sta PTNIDX 				; and write it to the Pattern Index Indirect address to get actual data 
	iny 
	lda INSTNOT,y
	sta PTNIDX+1 

DUMB_process_notes_table_start 
	ldy instr_notes_tbl_flag,x 
	bne DUMB_process_notes_table_sustain	; if Y isn't 0, it's already initialised  
	lda #4 					; 4 bytes are used to set up Envelopes and Tables, this value is a constant  
	sta instr_notes_tbl_idx,x		; initial Envelope offset, for the Start offset 
	lda (PTNIDX),y				; verify the Envelope parameters first thing first 
	sta instr_notes_tbl_mode,x		; save this variable for later use if needed while we're here 
	bpl DUMB_process_notes_table_good 	; a positive value means there is also a Sustain offset to set up 
	ldy #3 					; otherwise, just get the Envelope End offset position 
	bne DUMB_process_notes_table_not_sus	; there is no sustain, hijack the Release branch to finish setting this up 

DUMB_process_notes_table_good
	lda #2					; this will be used for the Envelope End offset 
	sta instr_notes_tbl_flag,x 		; initial Envelope flag, for the Sustain offset 
	tay 					; overwrite Y to make sure it's using the same offset 

DUMB_process_notes_table_sustain 
	lda instr_notes_tbl_mode,x		; is there a Sustain and/or Release to use? 
	bmi DUMB_process_notes_table_end	; if the value is negative, there is no Sustain, skip ahead directly
	lda instr_release,x			; is the Release flag set? Sustain will be skipped in this case 
	bne DUMB_process_notes_table_release	; if the value is not 0, it is most likely set to Release  
	lda (PTNIDX),y 				; get the Envelope Sustain offset for its End position 
	cmp instr_notes_tbl_idx,x 		; compare to the Envelope offset position currently in use 
	beq DUMB_process_notes_table_offset	; if the value is equal, the End position was reached 
	bcs DUMB_process_notes_table_fetch	; else, the End position was not reached yet, it couldn't be overshot 
	
DUMB_process_notes_table_release 
	cpy #3 					; was Release initialised already? 
	bcs DUMB_process_notes_table_end	; if the value is equal or above, it already was, continue 
	ldy #2					; else, get the Release Start offset position into Y 
	lda (PTNIDX),y 				; get the Start position for the Release offset 
	sta instr_notes_tbl_idx,x 		; update the Envelope offset position with this value 
	iny					; increment Y to be on the correct offset 

DUMB_process_notes_table_not_sus
	tya 					; then pass it to the Accumulator 
	sta instr_notes_tbl_flag,x 		; update the Envelope flag for the Envelope End offset  	
	
DUMB_process_notes_table_end
	lda (PTNIDX),y 				; get the Envelope Release offset for either its Start position
	cmp instr_notes_tbl_idx,x 		; compare to the Envelope offset position currently in use 
	beq DUMB_process_notes_table_clear	; if the value is equal, the End position was reached 
	bcs DUMB_process_notes_table_fetch	; else, the End position was not reached yet, it couldn't be overshot 
	
DUMB_process_notes_table_clear 
	lda instr_notes_tbl_mode,x 
	and #%11111110 
	sta instr_notes_tbl_mode,x		; the Table Mode won't stick after the envelope ended with this quick and dirty patch 
	lda #0 
	beq DUMB_process_notes_table_cleared	; unconditional, the Table value will also be set to 0 from here 

DUMB_process_notes_table_offset 	
	dey 					; decrement Y to get the correct Sustain offset 
	lda (PTNIDX),y 				; get the Start position for the Sustain offset 
	sta instr_notes_tbl_idx,x 		; update the Envelope offset position with this value 

DUMB_process_notes_table_fetch 
	ldy instr_notes_tbl_idx,x		; get the Envelope offset position in Y, which will then be used to fetch values to use  
	inc instr_notes_tbl_idx,x		; increment the Envelope offset position early once this is done

DUMB_process_notes_table_finalise 
	lda instr_notes_tbl_mode,x 
	and #%00000001 
	beq DUMB_process_notes_table_finalise_a ; addition will be done from #0, which would be the same as a loading the value 
	lda instr_tablenote,x 
	
DUMB_process_notes_table_finalise_a	
	clc 
	adc (PTNIDX),y 				; get the Freq from the table at current offset position 

DUMB_process_notes_table_cleared
	sta instr_tablenote,x 

DUMB_process_notes_table_done

;----------------- 

;* Process the Freqs Table Envelope 
	
DUMB_process_freqs_table 
	ldy #3 					; Y = 3 
	lda (INSIDX),y 				; Instrument Freqs Table Pointer 
	bmi DUMB_process_freqs_table_done 	; if the bit 7 is set, there is no Table, skip this part 
	asl @					; multiply by 2 for the address offset 
	tay 
	lda INSTFRE,y 				; get the Freqs Table address 
	sta PTNIDX 				; and write it to the Pattern Index Indirect address to get actual data 
	iny 
	lda INSTFRE,y
	sta PTNIDX+1  

DUMB_process_freqs_table_start 
	ldy instr_freqs_tbl_flag,x 
	bne DUMB_process_freqs_table_sustain	; if Y isn't 0, it's already initialised  
	lda #4 					; 4 bytes are used to set up Envelopes and Tables, this value is a constant  
	sta instr_freqs_tbl_idx,x		; initial Envelope offset, for the Start offset 
	lda (PTNIDX),y				; verify the Envelope parameters first thing first 
	sta instr_freqs_tbl_mode,x		; save this variable for later use if needed while we're here 
	bpl DUMB_process_freqs_table_good 	; a positive value means there is also a Sustain offset to set up 
	ldy #3 					; otherwise, just get the Envelope End offset position 
	bne DUMB_process_freqs_table_not_sus	; there is no sustain, hijack the Release branch to finish setting this up 

DUMB_process_freqs_table_good
	lda #2					; this will be used for the Envelope End offset 
	sta instr_freqs_tbl_flag,x 		; initial Envelope flag, for the Sustain offset 
	tay 					; overwrite Y to make sure it's using the same offset 

DUMB_process_freqs_table_sustain 
	lda instr_freqs_tbl_mode,x		; is there a Sustain and/or Release to use? 
	bmi DUMB_process_freqs_table_end	; if the value is negative, there is no Sustain, skip ahead directly
	lda instr_release,x			; is the Release flag set? Sustain will be skipped in this case 
	bne DUMB_process_freqs_table_release	; if the value is not 0, it is most likely set to Release  
	lda (PTNIDX),y 				; get the Envelope Sustain offset for its End position 
	cmp instr_freqs_tbl_idx,x 		; compare to the Envelope offset position currently in use 
	beq DUMB_process_freqs_table_offset	; if the value is equal, the End position was reached 
	bcs DUMB_process_freqs_table_fetch	; else, the End position was not reached yet, it couldn't be overshot 
	
DUMB_process_freqs_table_release 
	cpy #3 					; was Release initialised already? 
	bcs DUMB_process_freqs_table_end	; if the value is equal or above, it already was, continue 
	ldy #2					; else, get the Release Start offset position into Y 
	lda (PTNIDX),y 				; get the Start position for the Release offset 
	sta instr_freqs_tbl_idx,x 		; update the Envelope offset position with this value 
	iny					; increment Y to be on the correct offset 

DUMB_process_freqs_table_not_sus	
	tya 					; then pass it to the Accumulator 
	sta instr_freqs_tbl_flag,x 		; update the Envelope flag for the Envelope End offset  	
	
DUMB_process_freqs_table_end
	lda (PTNIDX),y 				; get the Envelope Release offset for either its Start position
	cmp instr_freqs_tbl_idx,x 		; compare to the Envelope offset position currently in use 
	beq DUMB_process_freqs_table_clear	; if the value is equal, the End position was reached 
	bcs DUMB_process_freqs_table_fetch	; else, the End position was not reached yet, it couldn't be overshot 
	
DUMB_process_freqs_table_clear 
	lda instr_freqs_tbl_mode,x 
	and #%11111110 
	sta instr_freqs_tbl_mode,x		; the Table Mode won't stick after the envelope ended with this quick and dirty patch 
	lda #0 
	beq DUMB_process_freqs_table_cleared	; unconditional, the Table value will also be set to 0 from here 

DUMB_process_freqs_table_offset 	
	dey 					; decrement Y to get the correct Sustain offset 
	lda (PTNIDX),y 				; get the Start position for the Sustain offset 
	sta instr_freqs_tbl_idx,x 		; update the Envelope offset position with this value 

DUMB_process_freqs_table_fetch 
	ldy instr_freqs_tbl_idx,x		; get the Envelope offset position in Y, which will then be used to fetch values to use  
	inc instr_freqs_tbl_idx,x		; increment the Envelope offset position early once this is done

DUMB_process_freqs_table_finalise 
	lda instr_freqs_tbl_mode,x 
	and #%00000001 
	beq DUMB_process_freqs_table_finalise_a ; addition will be done from #0, which would be the same as a loading the value 
	lda instr_tablefreq,x 
	
DUMB_process_freqs_table_finalise_a	
	clc 
	adc (PTNIDX),y 				; get the Freq from the table at current offset position 
	
DUMB_process_freqs_table_cleared
	sta instr_tablefreq,x 

DUMB_process_freqs_table_done 

;----------------- 

;* Process the Commands Table Envelope 

DUMB_process_commands_table 
	ldy #4 					; Y = 4 
	lda (INSIDX),y 				; Instrument Commands Table Pointer 
	bpl DUMB_process_commands_table_a 
	jmp DUMB_process_commands_table_done	; if the bit 7 is set, there is no Envelope, skip this part 

DUMB_process_commands_table_a
	asl @					; multiply by 2 for the address offset 
	tay 
	lda INSTCMD,y 				; get the Commands Table address 
	sta PTNIDX 				; and write it to the Pattern Index Indirect address to get actual data 
	iny 
	lda INSTCMD,y
	sta PTNIDX+1 

DUMB_process_commands_table_start 
	ldy instr_cmd_flag,x 
	bne DUMB_process_commands_table_sustain	; if Y isn't 0, it's already initialised  
	lda #4 					; 4 bytes are used to set up Envelopes and Tables, this value is a constant  
	sta instr_cmd_idx,x			; initial Envelope offset, for the Start offset 
	lda (PTNIDX),y				; verify the Envelope parameters first thing first 
	sta instr_cmd_mode,x			; save this variable for later use if needed while we're here 
	bpl DUMB_process_commands_table_good 	; a positive value means there is also a Sustain offset to set up 
	ldy #3 					; otherwise, just get the Envelope End offset position 
	bne DUMB_process_commands_table_not_sus; there is no sustain, hijack the Release branch to finish setting this up 

DUMB_process_commands_table_good
	lda #2					; this will be used for the Envelope End offset 
	sta instr_cmd_flag,x 			; initial Envelope flag, for the Sustain offset 
	tay 					; overwrite Y to make sure it's using the same offset 

DUMB_process_commands_table_sustain 
	lda instr_cmd_mode,x			; is there a Sustain and/or Release to use? 
	bmi DUMB_process_commands_table_end	; if the value is negative, there is no Sustain, skip ahead directly 
	lda instr_release,x			; is the Release flag set? Sustain will be skipped in this case 
	bne DUMB_process_commands_table_release	; if the value is not 0, it is most likely set to Release  
	lda (PTNIDX),y 				; get the Envelope Sustain offset for its End position 
	cmp instr_cmd_idx,x 			; compare to the Envelope offset position currently in use 
	beq DUMB_process_commands_table_offset	; if the value is equal, the End position was reached 
	bcs DUMB_process_commands_table_fetch	; else, the End position was not reached yet, it couldn't be overshot 
	
DUMB_process_commands_table_release 
	cpy #3 					; was Release initialised already? 
	bcs DUMB_process_commands_table_end	; if the value is equal or above, it already was, continue 
	ldy #2					; else, get the Release Start offset position into Y 
	lda (PTNIDX),y 				; get the Start position for the Release offset 
	sta instr_cmd_idx,x 			; update the Envelope offset position with this value 
	iny					; increment Y to be on the correct offset 

DUMB_process_commands_table_not_sus
	tya 					; then pass it to the Accumulator 
	sta instr_cmd_flag,x 			; update the Envelope flag for the Envelope End offset  	
	
DUMB_process_commands_table_end
	lda (PTNIDX),y 				; get the Envelope Release offset for either its Start position
	cmp instr_cmd_idx,x 			; compare to the Envelope offset position currently in use 
	beq DUMB_process_commands_table_done	; if the value is equal, the End position was reached 
	bcs DUMB_process_commands_table_fetch	; else, the End position was not reached yet, it couldn't be overshot 

DUMB_process_commands_table_offset 	
	dey 					; decrement Y to get the correct Sustain offset 
	lda (PTNIDX),y 				; get the Start position for the Sustain offset 
	sta instr_cmd_idx,x 			; update the Envelope offset position with this value 

DUMB_process_commands_table_fetch 
	ldy instr_cmd_idx,x			; get the Envelope offset position in Y, which will then be used to fetch values to use  
	inc instr_cmd_idx,x			; increment the Envelope offset position early once this is done
	inc instr_cmd_idx,x			; increment again since there are 2 bytes to process 

DUMB_process_commands_table_finalise  
	lda (PTNIDX),y 				; get the Command from the Envelope at current offset position 
	pha 
	iny 
	lda (PTNIDX),y 				; get the $XY Parameter from the Envelope at current offset position 
	tay 
	pla 
	beq DUMB_process_commands_table_zero
	bmi DUMB_process_commands_table_bit7 
	sta TMP0 
	lda #%01000000
	and TMP0 
	bne DUMB_process_commands_table_bit6 
	lda #%00100000
	and TMP0 
	bne DUMB_process_commands_table_bit5
	lda #%00010000
	and TMP0 
	bne DUMB_process_commands_table_bit4 
	lda #%00001000
	and TMP0 
	bne DUMB_process_commands_table_bit3 
	lda #%00000100
	and TMP0 
	bne DUMB_process_commands_table_bit2 
	lda #%00000010
	and TMP0 
	bne DUMB_process_commands_table_bit1
	lda #%00000001
	and TMP0 
	beq DUMB_process_commands_table_done	 
	
DUMB_process_commands_table_bit0

	bcs DUMB_process_commands_table_done 

DUMB_process_commands_table_bit1  
	tya 
	sta VAR_FREQ,x 
	bcs DUMB_process_commands_table_done 

DUMB_process_commands_table_bit2

	bcs DUMB_process_commands_table_done 

DUMB_process_commands_table_bit3

	bcs DUMB_process_commands_table_done 

DUMB_process_commands_table_bit4

	bcs DUMB_process_commands_table_done 

DUMB_process_commands_table_bit5

	bcs DUMB_process_commands_table_done 

DUMB_process_commands_table_bit6

	bcs DUMB_process_commands_table_done 
	
DUMB_process_commands_table_bit7 
	tya 
	sta SDW_AUDF,x 
	lda #$FF 
	bmi DUMB_process_commands_table_ff		; unconditional 

DUMB_process_commands_table_zero
	tya 
	clc 
	adc VAR_NOTE,x 

DUMB_process_commands_table_ff 
	sta VAR_NOTE,x

DUMB_process_commands_table_done 

;-----------------
	
DUMB_process_instrument_done
	
	rts

;-----------------

;--------------------------------------------------------------------------------------------------;

;* Tuning tables could just be dropped here I suppose...
;* These were generated using DUMB Soundchip Toolbox with the -bruteforce and -precision 0.0001 parameters 
;* Also, the A-4 tuning of 444.8958Hz was used in NTSC, equivalent PAL tables will use 440.8375Hz instead 

;	.align $100				; probably not necessary anymore... 
	icl 'DUMB Data.asm'

;-----------------

;--------------------------------------------------------------------------------------------------;

