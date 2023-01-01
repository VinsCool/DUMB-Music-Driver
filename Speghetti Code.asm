
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

;* Instruments Initialisation routine, loosely inspired by original RMT driver code 

DUMB_process_instrument  
	lda CMD_INSTRUMENT,x 			; what instrument on the current row?
	bpl DUMB_process_instrument_set_new 	; if positive, initialise new instrument data immediately 
	cmp #$FF 				; is this an already initialised instrument? 
	beq DUMB_process_instrument_continue	; if yes, get the current instrument address from memory 
DUMB_skip_instrument
	rts					; else, skip this subroutine, this is most likely a disabled instrument 
DUMB_process_instrument_continue
	lda INSTR_MSB,x				; get the current instrument MSB pointer 

/*
	beq DUMB_skip_instrument		; if the value is 0, it's most likely an empty instrument, so skip it 
*/

	sta INSIDX+1				; otherwise, update the indirect address with it, and continue 
	lda INSTR_LSB,x
	sta INSIDX 
	jmp DUMB_process_instrument_immediate 	
	
DUMB_process_instrument_set_new
	asl @ 					; multiply by 2 for the address offset
	tay 					; and copy to Y for the next part 
	lda INSTTBL,y				; TODO: use Zeropage Indirect
	sta INSTR_LSB,x
	sta INSIDX
	iny					; Y = LSB offset => Y = MSB offset
	lda INSTTBL,y				; TODO: use Zeropage Indirect
	sta INSTR_MSB,x
	sta INSIDX+1
	
/*
	ldy #0					; Y = 0 
	lda (INSIDX),y 
	sta instr_notes_tbl_end,x		; notes table end 
	iny					; Y = 0 => Y = 1
	lda (INSIDX),y 
	sta instr_notes_tbl_loop,x		; notes table loop 
	iny					; Y = 1 => Y = 2
*/

////
	ldy #2
////

		
	lda (INSIDX),y 
	sta instr_freqs_tbl_end,x		; freqs table end 
	
/*
	iny					; Y = 2 => Y = 3
	lda (INSIDX),y 
	sta instr_freqs_tbl_loop,x		; freqs table loop 
	iny					; Y = 3 => Y = 4
*/

////
	ldy #4
////

	lda (INSIDX),y 
	sta instr_envelope_end,x		; envelope end
	iny					; Y = 4 => Y = 5
	lda (INSIDX),y 
	sta instr_envelope_loop,x		; envelope loop
	
/*
	iny					; Y = 5 => Y = 6
	lda (INSIDX),y 
	sta instr_notes_tbl_speed,x		; notes table speed
	sta instr_notes_tbl_speeda,x
	iny					; Y = 6 => Y = 7
	lda (INSIDX),y 
	sta instr_freqs_tbl_speed,x		; freqs table speed
	sta instr_freqs_tbl_speeda,x
	iny					; Y = 7 => Y = 8
	lda (INSIDX),y 
	sta instr_envelope_speed,x		; envelope speed
	sta instr_envelope_speeda,x
	iny					; Y = 8 => Y = 9 
*/

////
	ldy #9
////

	lda (INSIDX),y
	sta instr_volumeslidedepth,x		; instrument volume slide depth 
	iny					; Y = 9 => Y = 10
	lda (INSIDX),y

////	
	tay 
	and #$F0
	sta instr_volumemin,x			; instrument volume minimum 
	tya 
	and #$0F 
	sta instr_parameters,x			; instrument parameters	
	ldy #11 
	lda (INSIDX),y
	sta instr_audctl,x			; instrument audctl 	
////
	
/*
	pha 
	and #$F0
	sta instr_volumemin,x			; instrument volume minimum 
	pla 
	and #$0F 
	sta instr_parameters,x			; instrument parameters 
	iny					; Y = 10 => Y = 11
	lda (INSIDX),y
	sta instr_audctl,x			; instrument audctl 
*/

;-----------------

DUMB_process_instrument_retrigger 
	lda #$FF 
	sta instr_volumeslidevalue,x		; initial volume slide value 
	sta CMD_INSTRUMENT,x 			; instrument has been initialised 
	adc #1					; Carry not set when this point is reached, overflow to #0 
	sta instr_volumereachedend,x		; envelope end flag, set when it fully played once (TODO: set flag early command?) 

/*
DUMB_initialise_notes_table	
	lda instr_parameters,x 
	and #%00000100
	beq DUMB_initialise_notes_table_a
	lda #0 
	sta instr_notes_tbl_idx,x		; Table of Notes disabled 
	beq DUMB_initialise_notes_table_done 	; unconditional 
DUMB_initialise_notes_table_a	
	lda #INSTRPAR				; get the instrument table constant, defined by the number of bytes used in it 
	sta instr_notes_tbl_idx,x		; then set the notes table offset to that value for the initial position
	tay					; Y = #INSTRPAR 
	lda (INSIDX),y				; get the first value from the notes table using the offset  
DUMB_initialise_notes_table_done
	sta instr_tablenote,x			; and set value in memory, which will be used in the first frame 

DUMB_initialise_freqs_table
	lda instr_parameters,x 
	and #%00000010
	beq DUMB_initialise_freqs_table_a
	lda #0 
	sta instr_freqs_tbl_idx,x		; Table of Freqs disabled 
	beq DUMB_initialise_freqs_table_done	; unconditional 
DUMB_initialise_freqs_table_a
	ldy instr_notes_tbl_end,x		; get the notes table end offset
	iny 					; Y = instr_notes_tbl_end + 1 
	tya 
	sta instr_freqs_tbl_idx,x		; the freqs table offset is now set to the initial position in memory	
	lda (INSIDX),y				; get the first value from the freqs table using the offset  
DUMB_initialise_freqs_table_done
	sta instr_tablefreq,x			; and set value in memory, which will be used in the first frame 

DUMB_initialise_envelope 
	lda instr_parameters,x 
	and #%00001000
	beq DUMB_initialise_envelope_a
	lda #$80 				; Skip Command flag
	sta instr_tablecmd,x			; Instrument Command was disabled 
	asl @					; Overflow back to 0 
	sta instr_tablevol,x			; Envelope was disabled, so this value would never be loaded anyway 
	sta instr_tablexy,x 			; $XY doesn't really matter either if the Instrument Command is disabled
	beq DUMB_initialise_envelope_done	; unconditional 
DUMB_initialise_envelope_a
*/

	lda instr_freqs_tbl_end,x		; get the freqs table end offset
	adc #0 					; Carry set from the addition done above 
DUMB_initialise_envelope_done	
	sta instr_envelope_idx,x		; the volume envelope offset is now set to the initial position in memory 

;-----------------

;* The real shit begins here, hopefully not as awkward as RMT does it, since we finally have got the necessary data early! 

DUMB_process_instrument_immediate  

;-----------------

;* Here, we get the 3 Envelope bytes, and advance the Envelope offset by 1 tick until it reach the end, and loop 

DUMB_process_instrument_envelope  
	ldy instr_envelope_idx,x		; get the current envelope position 
	
/*
	bne DUMB_instrument_envelope_continue	; envelope will be processed for non zero offset  
	lda CMD_VOLUME,x			; if the envelope was disabled, fallback to using the channel volume directly 
	lsr @
	lsr @
	lsr @
	lsr @ 
	sta VAR_VOLUME,x 
	jmp DUMB_play_instrument_no_envelope	; envelope was skipped entirely 
*/

DUMB_instrument_envelope_continue
	lda (INSIDX),y				; volume 
	sta instr_tablevol,x			; set in memory so it could be retrieved quicker later 
	iny					; offset to get the second byte 
	lda (INSIDX),y				; command and distortion 
	sta instr_tablecmd,x			; set in memory so it could be retrieved quicker later 
	iny					; offset to get the third byte 

/*
	lda (INSIDX),y				; $XY parameter 
	sta instr_tablexy,x			; set in memory so it could be retrieved quicker later 
*/

	iny					; offset for the next envelope position  
	tya					; copy Y to Accumulator for the next instruction 
	cmp instr_envelope_end,x		; has the end of envelope been reached yet? 
	bcc DUMB_set_volume_envelope_offset	; if the value is lower, the end of the envelope hasn't been reached 
	beq DUMB_set_volume_envelope_offset	; if the value is equal, the end of the envelope won't be reached for another frame 
	lda #$80				; else, the envelope is finished, set the Negative flag to the instrument 
	sta instr_volumereachedend,x		; the volume fadeout is now initialised and will be used to process additional logic 
	lda instr_envelope_loop,x		; reload the active loop point from the volume envelope 
	
DUMB_set_volume_envelope_offset
	sta instr_envelope_idx,x		; update the volume envelope position for the next frame 

DUMB_instrument_volume_envelope 
	lda instr_volumereachedend,x		; has the instrument envelope reached the end yet? 
	bpl DUMB_instrument_envelope_done	; positive value means it hasn't, skip this block until the flag is set 
	lda CMD_VOLUME,x			; get the current volume level for the channel
	beq DUMB_instrument_envelope_done 	; if the volume level is set to 0, skip this block, no volume to process 
	cmp instr_volumemin,x			; compare the current volume level to the minimum volume in the instrument 
	beq DUMB_instrument_envelope_done	; if the values are equal, skip this block, the minimum was reached 
	bcc DUMB_instrument_envelope_done	; if the value is lower, also skip, the minimum volume was reached already 
	tay					; else, copy the volume level to Y 
	lda instr_volumeslidevalue,x		; get the volume slide level to apply 
	add instr_volumeslidedepth,x		; and add the volume slide depth to it 
	sta instr_volumeslidevalue,x		; then overwrite the slide value with the sum of the 2  
	bcc DUMB_instrument_envelope_done	; if the number didn't overflow, there is nothing else to do here, continue 
	tya					; otherwise, get the current volume level back from Y 
	sbc #$10				; and subtract #$10 from it, that corresponds to #1 in the higher 4 bits
	sta CMD_VOLUME,x 			; then, update the channel volume level using the new value, and continue 
	
DUMB_instrument_envelope_done

;-----------------

;* Get the Volume from the table, and assign the matching distortion to it 

DUMB_play_instrument 
	ldy instr_tablevol,x			; volume envelope byte + Auto AUDCTL bits 
	tya 
	and #$F0 				; keep only the high 4 bits, the Auto AUDCTL bits 
	sta instr_autoflag,x			; save for later when the AUDCTL is being processed 
	tya 
	and #$0F				; keep only the low 4 bits, the Volume at current Envelope tick 
	ora CMD_VOLUME,x			; the combined Volumes will be used as an offset 
	tay					; used to retrieve the "actual" Volume Level 
	lda volumetab,y				; from this huge ass Volume Level Table 
	sta VAR_VOLUME,x 			; save to the Volume Variable, this will be output later 
	ldy instr_tablecmd,x			; Distortion and Command and flags 
	tya 
	and #$07				; only keep the Distortion bits 
	beq DUMB_play_instrument_no_distortion
	sta CMD_DISTORTION,x 			; update the Distortion set by Row commands, Instrument parameters take priority! 
	
DUMB_play_instrument_no_distortion
	tya 
	and #$08 
	bne DUMB_play_instrument_no_audctl	; the instrument AUDCTL won't be used for this tick 
	lda instr_audctl,x			; current instrument AUDCTL
	sta CMD_AUDCTL,x			; take priority over the Pattern command
	
DUMB_play_instrument_no_audctl
	
;-----------------

DUMB_play_instrument_no_envelope

	rts

/*

;-----------------

;* Process the Table of Notes 

DUMB_instrument_notes_table 
	lda instr_notes_tbl_idx,x 		; get the current table offset
	beq DUMB_table_of_notes_disabled	; if the value is 0, Table of Notes was disabled, and must be skipped 
	lda instr_notes_tbl_speeda,x		; get the current table timer 
	bpl DUMB_instrument_notes_table_skip	; as long as the value is positive, the table offset is not updated 

DUMB_instrument_notes_table_check_offset  
	lda instr_notes_tbl_end,x		; get the current instrument table end offset, it is used to define the length of it
	cmp instr_notes_tbl_idx,x		; now compare it to the current instrument table offset 
	bne DUMB_instrument_notes_table_inc	; if not equal, skip this part and continue 
	lda instr_notes_tbl_loop,x 		; get the instrument table looping position offset 
	sta instr_notes_tbl_idx,x		; and update the instrument table offset with it 
	bne DUMB_update_notes_table_offset	; unconditional, the offset could never be 0 unless it was specifically disabled  

DUMB_instrument_notes_table_inc
	inc instr_notes_tbl_idx,x		; increment the table offset by 1

DUMB_update_notes_table_offset
	ldy instr_notes_tbl_idx,x 		; get the current table offset into Y 
	lda (INSIDX),y				; get the new value from the table within the instrument data, offset using Y 
	sta instr_tablenote,x			; finally, update the instrument table value with the new one 
	lda instr_notes_tbl_speed,x		; get the instrument table type and speed byte in the Accumulator 
	and #$3f 				; only keep the table speed value from it 

DUMB_instrument_notes_table_skip
	sub #1					; subtract 1 to the tablespeeda timer for the next frame 
	sta instr_notes_tbl_speeda,x 		; and update the value with the new one 
	
DUMB_instrument_get_note_in_table   
;	lda VAR_NOTE,x 				; otherwise, load the current note variable from memory 
;	add instr_tablenote,x 			; add the value from the note table directly to it 
;	sta VAR_NOTE,x 				; then overwrite the note variable in memory, this will be used directly later 
	
DUMB_table_of_notes_disabled 	

;-----------------

;* Process the Table of Freqs 

DUMB_instrument_freqs_table 
	lda instr_freqs_tbl_idx,x 		; get the current table offset 
	beq DUMB_table_of_freqs_disabled	; if the value is 0, Table of Freqs was disabled, and must be skipped 
	lda instr_freqs_tbl_speeda,x		; get the current table timer 
	bpl DUMB_instrument_freqs_table_skip	; as long as the value is positive, the table offset is not updated 

DUMB_instrument_freqs_table_check_offset  
	lda instr_freqs_tbl_end,x		; get the current instrument table end offset, it is used to define the length of it  
	cmp instr_freqs_tbl_idx,x		; now compare it to the current instrument table offset 
	bne DUMB_instrument_freqs_table_inc	; if not equal, skip this part and continue 
	lda instr_freqs_tbl_loop,x 		; get the instrument table looping position offset 
	sta instr_freqs_tbl_idx,x		; and update the instrument table offset with it 
	bne DUMB_update_freqs_table_offset	; unconditional, the offset could never be 0 in the current RMT instrument format 

DUMB_instrument_freqs_table_inc
	inc instr_freqs_tbl_idx,x		; increment the table offset by 1

DUMB_update_freqs_table_offset
	ldy instr_freqs_tbl_idx,x 		; get the current table offset into Y 
	lda (INSIDX),y				; get the new value from the table within the instrument data, offset using Y 
	sta instr_tablefreq,x			; finally, update the instrument table value with the new one 
	lda instr_freqs_tbl_speed,x		; get the instrument table type and speed byte in the Accumulator 
	and #$3f 				; only keep the table speed value from it 

DUMB_instrument_freqs_table_skip
	sub #1					; subtract 1 to the tablespeeda timer for the next frame 
	sta instr_freqs_tbl_speeda,x 		; and update the value with the new one 
	
DUMB_instrument_get_freq_in_table 
;	lda VAR_FREQ,x
;	add instr_tablefreq,x
;	sta VAR_FREQ,x 
	
DUMB_table_of_freqs_disabled 

;----------------- 

;* TODO: Implement a 16-bit procedure to most of the jumptable procedure, this would help adjusting parameters accordingly 

DUMB_instrument_check_cmd 
	ldy instr_tablecmd,x			; get the current instrument command and distortion byte 
	bpl DUMB_instrument_set_cmd_jumptable 	; if the value is positive, continue and process the CMD number 
	rts 					; and skip the instrument command for this tick 
	
DUMB_instrument_set_cmd_jumptable
	tya 
	and #$70 				; and keep only the bits 4 to 6 for the instrument CMD number 
	lsr @					; make a quick and dirty jump table allowing a 4 bytes index 
	lsr @
	sta jmx+1				; branch will now match the value of the Instrument Command Number 
jmx	bcc *					; each branch will end with a RTS! 
	jmp instr_cmd0
	nop
	jmp instr_cmd1
	nop
	jmp instr_cmd2
	nop
	jmp instr_cmd3
	nop
	jmp instr_cmd4
	nop
	jmp instr_cmd5
	nop
	jmp instr_cmd6
	nop
	jmp instr_cmd7

;----------------- 

;* Instrument CMD0 => Offset Basenote with $XY 

instr_cmd0
	lda instr_tablexy,x
	sta instr_noteoffset,x
	rts 
	
;-----------------

;* Instrument CMD1 => Absolute $XY Pitch 
	
instr_cmd1
	lda instr_tablexy,x
	sta ABS_FREQ_LSB,x
	sta ABS_FREQ_MSB,x
	rts
	
;-----------------

;* Instrument CMD2 => Finetune with $XY  

instr_cmd2
	lda instr_tablexy,x
	sta instr_finetune,x
	rts
	
;-----------------

;* Instrument CMD3 => Offset and Replace Basenote with $XY  
	
instr_cmd3 
	rts 					; I'm not going to waste my time with this one, fuck that lol  
	
;-----------------

;* Instrument CMD4 => Add $XY to Shiftfrq 

instr_cmd4
	rts 					; I'm not going to waste my time with this one, fuck that lol 
	
;-----------------

;* Instrument CMD5 => Set Portamento Slide and Velocity with $XY 
	
instr_cmd5 
	rts 					; I'm not going to waste my time with this one, fuck that lol 

;-----------------

;* Instrument CMD6 => Set Autofilter offset with $XY 

instr_cmd6
	lda instr_tablexy,x
	sta CMD_AUTOFILTER,x 			; take priority over the Pattern Command 
	rts
	
;-----------------

;* Instrument CMD7 => Set AUDCTL to $XY (forget about Volume Only and Two-Tone for now) 

instr_cmd7
	lda instr_tablexy,x 
	sta instr_audctl,x 
	tya 
	and #$08 
	bne instr_cmd7_no_audctl 		; if the bit is set, the instrument AUDCTL won't take priority 
	lda instr_audctl,x			; else, get the instrument AUDCTL back
	sta CMD_AUDCTL,x			; take priority over the Pattern command
instr_cmd7_no_audctl
	rts
	
*/

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

;* Get the current Pattern Row data, and process all the bytes from it to initialise Notes, Instruments, Effects, etc 
;* I decided to unroll the code from the first attempt I wrote this subroutine, it was too messy because of that 
;* FIXME: Process new Notes/Instruments/Volumes/Commands initialisation from this block specifically! 
;* FIXME: There's a lot of ambiguity related to knowing what is initialised and what is not! 

DUMB_play_next_row 
	ldx #3					; start with ch4 
DUMB_play_row_again  
	lda CMD_PAUSE,x				; is there a pause currently set for this chanel?
	beq DUMB_play_parse_row			; if Pause = #0, play like normal 
	sub #1 					; subtract from the pause command length
	sta CMD_PAUSE,x 			; and overwrite the value for the next row 
DUMB_play_skip_row_index 
	dex					; decrement the index for the next channel 
	bpl DUMB_play_row_again	
	rts 

DUMB_play_parse_row 
	tay 					; Y = 0, offset for loading new Row data, and counting how many bytes were loaded 
	lda PTNROW_LSB,x 			; get the row index pointer in memory first 
	sta ROWIDX 
	lda PTNROW_MSB,x
	sta ROWIDX+1 

DUMB_get_row_byte_vv 
	lda (ROWIDX),y 				; Byte $VV will always be the first byte loaded 
	sta CMD_FLAG,x				; this byte also contains the flags for everything that should be initialised 
	bmi DUMB_get_row_byte_tt		; if the Trigger bit is set, this is a Row Terminator, bail out of this block! 
	and #VOLUME 				; is there a new Volume level to set? 
	beq DUMB_get_row_byte_nn		; if not, the byte probably was meant to be for a Note 
	lda CMD_FLAG,x 
	and #$0F				; keep the lower 4 bits for the Volume level 
	asl @					; move the bits to the left for the Instrument Routines 
	asl @
	asl @
	asl @ 
	sta CMD_VOLUME,x			; and update the Volume level with the new value 

DUMB_get_row_byte_nn 
	lda CMD_FLAG,x				; get the Byte $VV back to the Accumulator 
	and #NOTE 				; is there a Note value to set? 
	beq DUMB_get_row_byte_ii		; if not, the byte probably was meant to be for an Instrument 
	iny					; Y = #0 -> Y = #1 	
	lda (ROWIDX),y 				; the next byte, could be anything between $NN, $II or $CC
	bmi DUMB_get_row_byte_tt		; if the Trigger bit is set, this is a Row Terminator, bail out of this block! 

	cmp #REL
	bne DUMB_get_row_byte_nn_set_note 
	dec instr_release,x 
;	lda #2 
;	sta instr_envelope_flag,x 
	bne DUMB_get_row_byte_ii 
	
DUMB_get_row_byte_nn_set_note	
	sta CMD_NOTE,x 				; set the new Note Index value for this channel 
	
DUMB_get_row_byte_ii 
	lda CMD_FLAG,x				; get the Byte $VV back to the Accumulator 
	and #INSTRUMENT				; is there an Instrument value to set? 
	beq DUMB_get_row_byte_cc		; if not, the byte probably was meant to be for an Effect Command 
	iny					; Y = #1 -> Y = #2 	
	lda (ROWIDX),y 				; the next byte, could be anything between $II or $CC
	bmi DUMB_get_row_byte_tt		; if the Trigger bit is set, this is a Row Terminator, bail out of this block!
	sta CMD_INSTRUMENT,x			; set the new Instrument Index value for this channel 

DUMB_get_row_byte_cc 
	lda #CMD_COUNTER			; The number of commands per row is variable 
	beq DUMB_get_row_byte_tt 		; #0 could also be used if no command is needed at all 
	sta TMP1				; the Effect Command count will be tracked from this variable  
	
DUMB_get_row_byte_cc_loop 
	iny					; Y = #2 -> Y = #3
	lda (ROWIDX),y 				; the next byte, could be anything between $CC and $XY 
	bmi DUMB_get_row_byte_tt		; if the Trigger bit is set, this is a Row Terminator, bail out of this block! 
	sta TMP0				; Byte $CC backup first 
	and #USE_XY				; check if there is a $XY Parameter, no parameter is same as using $00 
	bne DUMB_get_row_byte_xy 		; if the bit is set, get the $XY Parameter from the next byte 
	tya 
	pha 					; backup of Y in stack, will be picked back after the subroutine 
	ldy #0 					; assume a $XY Parameter of #0 in this case 
	beq DUMB_get_row_byte_skip_xy		; unconditional 
	
DUMB_get_row_byte_xy
	iny 					; Y = #3 -> Y = #4, and so on for as many bytes there may be... 
	tya 
	pha 					; backup of Y in stack, will be picked back after the subroutine 
	lda (ROWIDX),y 				; the next byte is $XY 
	tay 					; $XY parameter is now in Y 
DUMB_get_row_byte_skip_xy	
	lda TMP0				; reload the Byte $CC in Accumulator for the next step 
	jsr DUMB_set_effect_cmd			; go initialise the CMD, using the byte $XY when specified 
	pla	 				; get Y back from the stack once the subroutine returned	
	tay 					; and continue from here until all commands were processed 
	dec TMP1				; decrement the Effect Command count upon returning the subroutine 
	bne DUMB_get_row_byte_cc_loop		; as long as the count hasn't reached 0, repeat this block for the next command 

DUMB_get_row_byte_all_done 
	iny 					; Y = ?? -> Y = !? 
	lda (ROWIDX),y 				; the next byte MUST be a byte $TT here!
	bmi DUMB_get_row_byte_tt		; if the Trigger bit is set, this is a Row Terminator, bail out of this block! 
DUMB_get_row_byte_tt_failsafe 
	lda #0 					; else, don't take a chance, set the pause length of 0 if none was specified 
	dey 					; and adjust the count for the missing byte in this case  

DUMB_get_row_byte_tt 
	iny 					; add 1 to adjust the bytes count with Y 
	sty TMP0				; necessary for the addition 
	and #$7F				; keep only the pause length bits 
	sta CMD_PAUSE,x				; the new pause is set 
	lda PTNROW_LSB,x
	add TMP0 
	sta PTNROW_LSB,x 
	lda PTNROW_MSB,x 
	adc #0 					; carry will be added if the flag is set 
	sta PTNROW_MSB,x 
	jmp DUMB_play_skip_row_index 		; done for this row, go process the next channel 

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
	
DUMB_process_instrument_done
	
	rts 

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

;* Get the currently Songline Patterns Index and Pointers for all channels 

/*
DUMB_next_songline 
	lda SETGOTO				; is there a goto Songline flag set? 
	bmi DUMB_goto_songline			; the goto flag was set! process from there 
	inc SONGNUM				; increment the current songline number 
	lda SONGNUM 
	beq DUMB_reset_songline			; back to 0, always reset the memory addresses 
	cmp SONGMAX				; maximal number songlines 
	bne DUMB_update_songline_index 		; if not ended, update the songline index, then immediately get the new patterns data 
DUMB_reset_songline 
	mwa SONGTBL SONGIDX			; else, reset Songline Address Table to Zeropage Index to play from songline 0 again 
	lda #0 
	sta SONGNUM 
	beq DUMB_get_pattern_index 		; unconditional 
DUMB_goto_songline 
	mwa SONGTBL SONGIDX			; re-initialise Songline Address Table first  
	lda SONGNUM 				; destination songline set from a Bxy Command 
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
	lda #0 
	sta SETGOTO
	beq DUMB_get_pattern_index		; unconditional 
DUMB_update_songline_index 
	lda SONGIDX
	add #4 
	sta SONGIDX 
	bcc DUMB_get_pattern_index 
	inc SONGIDX+1 
DUMB_get_pattern_index 
	ldy #3 
DUMB_get_pattern_index_loop	
	sty TMP0  
	ldx TMP0 
	lda (SONGIDX),y 			; get pattern number for that channel 
	asl @ 
	tay  
	lda PTNTBL,y
	sta PTNROW_LSB,x 
	iny 
	lda PTNTBL,y 
	adc #0
	sta PTNROW_MSB,x 
	ldy TMP0 
	dey 
	bpl DUMB_get_pattern_index_loop
	stx CMD_PAUSE+0
	stx CMD_PAUSE+1
	stx CMD_PAUSE+2
	stx CMD_PAUSE+3
	rts 
*/

;-----------------

;--------------------------------------------------------------------------------------------------;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



