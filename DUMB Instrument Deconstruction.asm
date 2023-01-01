;* Deconstructed DUMB instrument in 6502 ASM 
;* by VinsCool 
;* 
;* This is intended to be used with DUMB Music Driver, as an alternative to the RMT driver 
;* It is worth mentioning that most of this design is WIP 
;* Things are very likely to be changed later for X or Y reason, there's no rush for optimisations yet! 
;--------------------------------------------------------------------------------------------------;

;* Volume Constants 

v0	= $00
v1	= $01
v2	= $02
v3	= $03
v4	= $04
v5	= $05
v6	= $06
v7	= $07
v8	= $08
v9	= $09
vA	= $0A
vB	= $0B
vC	= $0C
vD	= $0D
vE	= $0E
vF	= $0F

;* Distortion Constants 

DIST_0	= $01
DIST_2	= $02 
DIST_4	= $03 
DIST_8	= $04 
DIST_A	= $05 
DIST_C	= $06 
DIST_E	= $07 
NO_DIST	= $00 

;* Command Constants 

CMD_0	= $00
CMD_1	= $10 
CMD_2	= $20
CMD_3	= $30
CMD_4	= $40
CMD_5	= $50
CMD_6	= $60
CMD_7	= $70 
NO_CMD	= %10000000 
NO_AUD	= %00001000

;* Auto AUDCTL Constants 

A15KHZ	= %00010000 
FILTER	= %00100000 
A179MHZ	= %01000000 
A16BIT	= %10000000 

;-----------------

;* TODO: Make a better macro for creating Instrument Data by hand a lot easier! 

.MACRO	ENV [vol, dist, cmd, xy, param] 
	.IF (:vol > $FF) 
		.BYTE $00,$00,$00	; Missing parameter, Empty Envelope tick is assumed  
		
	.ELSEIF (:dist > $FF)
		.BYTE :vol
		.BYTE $00
		.BYTE $00 

	.ELSEIF (:cmd > $FF)
		.BYTE :vol
		.BYTE :dist
		.BYTE $00

	.ELSEIF (:xy > $FF)
		.BYTE :vol
		.BYTE :dist + :cmd
		.BYTE $00 
		
	.ELSEIF (:param > $FF)
		.BYTE :vol
		.BYTE :dist + :cmd
		.BYTE :xy 

	.ELSE 
		.BYTE :vol + :param 
		.BYTE :dist + :cmd 
		.BYTE :xy 
			
	.ENDIF	

.ENDM

;-----------------

;* Instrument Constants 

INSTRPAR	= instr_data_end - instr_data 

/*
TOTAL_BYTES	= freqs_table_end - instr_data 
*/

ENV_OFFSET	= 2				; envelope_offset_end - envelope_offset 

/*
;* Notes Table  

NOT_LENGTH	= notes_table_end - notes_table 
NOT_GOTO	= notes_table_goto - notes_table 
NOT_SPEED	= $01
NOT_MODE	= 0 
NOT_TYPE	= 0 

;* Freqs Table  

FRQ_LENGTH	= freqs_table_end - freqs_table 
FRQ_GOTO	= freqs_table_goto - freqs_table 
FRQ_SPEED	= $01
FRQ_MODE	= 0 
FRQ_TYPE	= 0 

;* Volume and Command Envelope 

ENV_LENGTH	= (envelope_end - envelope) / ENV_OFFSET 
ENV_GOTO	= (envelope_goto - envelope) / ENV_OFFSET 
ENV_SPEED	= $01 

;* Instrument Parameters 

PTR_NLEN	= INSTRPAR + NOT_LENGTH - 1 
PTR_NGO		= INSTRPAR + NOT_GOTO 
PTR_FLEN	= PTR_NLEN + FRQ_LENGTH 
PTR_FGO		= PTR_NLEN + FRQ_GOTO + 1 
PTR_ELEN	= PTR_FLEN + (ENV_OFFSET * (ENV_LENGTH - 1)) + 1 
PTR_EGO		= PTR_FLEN + (ENV_OFFSET * (ENV_GOTO)) + 1
PAR_NSPD	= NOT_SPEED + (NOT_MODE * $40) + (NOT_TYPE * $80) - 1 
PAR_FSPD	= FRQ_SPEED + (FRQ_MODE * $40) + (FRQ_TYPE * $80) - 1 
PAR_ESPD	= ENV_SPEED - 1 
PAR_VSLIDE	= $08 
PAR_VMIN	= $00 + %00000110
PAR_AUDCTL	= $00 
*/

;-----------------

;--------------------------------------------------------------------------------------------------;
;* Instrument Parameters 
;* Size: 4 bytes per instrument, which will also be a constant, to make instruments easier to index, up to 64 instruments 
;* 
;* The bytes will be used only once per initialisation, but may be reloaded when needed  
;* 4 bytes will be used for the data pointers, from which 4 * 3 bytes (12 bytes) will be used the Envelope/Table Parameters 
;*
;-----------------
;* In order, the Pointer bytes will be used for: Volume Envelope, Distortion/AUDCTL Table, Notes Table and Freqs Table 
;* Each ones of these will make use of a constant memory address to data, so it would be impossible to mixup by accident 
;* Address Tables will be defined at Assembly time, since it will be variable, and will then be part of the Module Header 
;* 
;* Envelope/Table Pointer Structure: 
;* [ BYTE 1 ] [ BYTE 2 ] [ BYTE 3 ] [ BYTE 4 ] 
;*  TPPPPPPP   TPPPPPPP   TPPPPPPP   TPPPPPPP
;* 
;* All 4 Pointer bytes will be used the same way, which is really straightforward: 
;* 
;* [ Byte 1-4 ] 
;* Bits 0-6 -> Pointer to Envelope/Table Address 
;* Bit 7 -> Trigger Bit, which will define if either ones of Envelope/Table is used, or not 
;-----------------
;* Due to the 3 parameter bytes, the maximum length is limited to 61 bytes, to fill up the 64 bytes allocated for it 
;* A constant of #3 must be added to each ones of the Envelope offsets to adjust it to its true offset 
;* Essentially, if the value of #5 is used as the Envelope End offset, #8 will be used in the data itself 
;* 
;* Envelope/Table Data Structure: 
;* [ BYTE 1 ] [ BYTE 2 ] [ BYTE 3 ] ... [ BYTE 4 ] [ BYTE 5 ] ... [ BYTE 61]  
;*  SROOOOOO   --OOOOOO   --OOOOOO  ...  ENV_DATA   ENV_DATA  ...  ENV_DATA 
;* 
;* The 4 Envelope/Table Parameters will be split between 3 bytes each: 
;* 
;* [ Byte 1 ] 
;* Bits 0-5 -> Envelope Length, the Envelope Start is always #$00, and the Envelope End could be as large as #$3F 
;* Bit 6 -> if Release is used or not 
;* Bit 7 -> if Sustain is used or not 
;* 
;* [ Byte 2 ] 
;* Bits 0-5 -> Sustain Start offset, ending with either the Envelope End offset, or the Release Start offset 
;* Bits 6-7 -> Spare Bits, or Mode Bits, depending on which one of the Envelope/Table is used 
;* 
;* [ Byte 3 ] 
;* Bits 0-5 -> Release Start offset, always ending with Envelope End offset 
;* Bits 6-7 -> Spare Bits, or Mode Bits, depending on which one of the Envelope/Table is used 
;--------------------------------------------------------------------------------------------------;

	org $0000	; This is necessary to be able to assemble anything at all 
	opt h-		; This lets me assemble data without making it executable as well 

instr_data

/*
nlen	dta PTR_NLEN	; Offset to End of Table of Notes && Offset to Start of Table of Freqs
ngo	dta PTR_NGO	; Offset to Loop Point of Table of Notes

flen	dta PTR_FLEN	; Offset to End of Table of Freqs && Offset to Start of Envelope 
fgo	dta PTR_FGO	; Offset to Loop Point of Table of Freqs

elen	dta PTR_ELEN	; Offset to End of Envelope && End of Instrument 
ego	dta PTR_EGO 	; Offset to Loop Point of Envelope 

nspd	dta PAR_NSPD	; Table of Notes Speed (bits 0-5), Mode (bit 6), and Type (bit 7) 
fspd	dta PAR_FSPD 	; Table of Freqs Speed (bits 0-5), Mode (bit 6), and Type (bit 7) 
espd	dta PAR_ESPD	; Envelope Speed (bit 0-5), and Mode (bit 7) 

vslide	dta PAR_VSLIDE	; Volume Slide Velocity 
vmin	dta PAR_VMIN	; Instrument Parameters (bits 0-3), Volume Minimum (bits 4-7) 
audctl	dta PAR_AUDCTL	; AUDCTL 
*/

instr_data_end

;-----------------

;--------------------------------------------------------------------------------------------------;
;* Table of Notes 
;* Size: 0 to 64 bytes, 1 byte per tick 
;* 
;* The Table of Notes will be disabled if the size is defined to be 0, and skipped in the DUMB routines 
;* PAR_NSPD defines Speed (bits 0-5), Mode (Set or Add, bit 6), and Type (Relative or Absolute, bit 7)
;--------------------------------------------------------------------------------------------------;

/*
notes_table 
notes_table_goto
	dta $00
notes_table_end 
*/

;-----------------

;--------------------------------------------------------------------------------------------------;
;* Table of Freqs 
;* Size: 0 to 64 bytes, 1 byte per tick 
;* 
;* The Table of Freqs will be disabled if the size is defined to be 0, and skipped in the DUMB routines 
;* PAR_FSPD defines Speed (bits 0-5), Mode (Set or Add, bit 6), and Type (Relative or Absolute, bit 7)
;--------------------------------------------------------------------------------------------------;

/*
freqs_table 
freqs_table_goto 
	dta $00
freqs_table_end 
*/

;-----------------

;--------------------------------------------------------------------------------------------------;
;* Volume Envelope 
;* Size: 0 to 61 + 3 bytes (64 bytes), 1 byte per tick 
;* 
;* 
;* The Volume Envelope itself will use up to 61 bytes, which will be used for the following parameters:  
;* 
;* [ Volume ] 
;* Bits 0-3 -> Volume Level at Envelope Tick Position 
;* Bits 4-7 -> Spare Bits, but this might just become the same as RMT's "Stereo Volume" bits later 
;* 
;* Below is a mockup of what it would look like when used: 
;* 
;* 		__________________________________ 
;* 		|-_                              | 
;* 		|  -_                            | 
;* 		|    -_                          | 
;* 		|      -_                        | 
;* 		|        -_         _-_          | 
;* 		|          -_     _-   -_   _    | 
;* 		|            -_ _-       -_- -_  | 
;* 		|              -               -_| 
;* 		---------------------------------- 
;*    ENVELOPE:	|    AD-13    [    S-14    ] R-5 | 
;*      VOLUME:	|FEDCBA98765432123456765432343210|  
;* 		----------------------------------
;* 
;--------------------------------------------------------------------------------------------------;


;--------------------------------------------------------------------------------------------------;
;* Byte 2: Distortion (bits 0-2), AutoTwoTone (bit 3), Auto15khz (bit 4), AutoFilter (bit 5), Auto179mhz (bit 6), Auto16bit (bit 7) 
;* 
;*  DISTORTION:	|8AAAAAAAAAAAAAAAAAAAAAAAAAA8AAAA| 
;*      FILTER:	|.*******************************| 
;*      16-BIT:	|................................| 
;*     1.79MHZ:	|*...............................| 
;*       15KHZ:	|................................| 
;* 		----------------------------------
;* 
;--------------------------------------------------------------------------------------------------;

envelope_start 

envelope_sustain

envelope_release
	
envelope_end 

;-----------------

;--------------------------------------------------------------------------------------------------;	

