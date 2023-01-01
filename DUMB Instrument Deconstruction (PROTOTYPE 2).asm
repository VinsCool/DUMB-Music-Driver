;* Deconstructed DUMB instrument in 6502 ASM 
;* by VinsCool 
;* 
;* This is intended to be used with DUMB Music Driver, as an alternative to the RMT driver 
;* The instrument format is also very similar to help maintain some backwards compatibility 
;* 
;* Instruments vary greatly in size, ranging between 16 bytes (minimum) and 256 bytes (maximum) 
;* Long Envelopes and/or long Tables add up very quickly, which could eat a lot precious memory! 
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

;--------------------------------------------------------------------------------------------------;
;* DUMB Instrument Format Ideas (WIP): 
;* 
;* Tables could be separated from each others, including their own Speed Timer when used 
;* Envelope and Table could be skipped, and missing data could fallback to using Pattern data directly 
;* Each ones of the Envelopes and Tables could use up to 48 ticks, everything is now equal!
;* Volume Envelopes could possibly Sustain and have Release triggered with a Note Release Command in patterns 
;* Any unused data will simply be ignored, and optimally, stripped away when it is possible 
;* Offsets could act as a trigger for using a Table and/or and Envelope: 0 would skip using it entirely 
;* Move Autofilter to bit 0, and replace Portamento with Auto16-bit on bit 7, leaving Distortion 6 free 
;* Add a Speed parameter to the Envelope, so it could be stretched and/or adjusted to Tables 
;* Add a Retrigger command for Instruments, and skip initialising a new instrument for Legato effect! 
;--------------------------------------------------------------------------------------------------;

;* Instrument Constants 

INSTRPAR	= instr_data_end - instr_data 
TOTAL_BYTES	= freqs_table_end - instr_data 
ENV_OFFSET	= 3				; envelope_offset_end - envelope_offset 

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

;-----------------

;--------------------------------------------------------------------------------------------------;
;* Instrument Parameters 
;* Size: 0 to 16 bytes, except that it is impossible to create a 0 byte Instrument! 
;* 
;* The bytes will be used only once per initialisation, but may be reloaded when needed 
;--------------------------------------------------------------------------------------------------;

	org $0000	; This is necessary to be able to assemble anything at all 
	opt h-		; This lets me assemble data without making it executable as well 

instr_data
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
instr_data_end

;-----------------

;--------------------------------------------------------------------------------------------------;
;* Table of Notes 
;* Size: 0 to 48 bytes, 1 byte per tick 
;* 
;* The Table of Notes will be disabled if the size is defined to be 0, and skipped in the DUMB routines 
;* PAR_NSPD defines Speed (bits 0-5), Mode (Set or Add, bit 6), and Type (Relative or Absolute, bit 7)
;--------------------------------------------------------------------------------------------------;

notes_table 
;	dta $00
;	dta $01 
notes_table_goto
;	dta $00
notes_table_end 

;-----------------

;--------------------------------------------------------------------------------------------------;
;* Table of Freqs 
;* Size: 0 to 48 bytes, 1 byte per tick 
;* 
;* The Table of Freqs will be disabled if the size is defined to be 0, and skipped in the DUMB routines 
;* PAR_FSPD defines Speed (bits 0-5), Mode (Set or Add, bit 6), and Type (Relative or Absolute, bit 7)
;--------------------------------------------------------------------------------------------------;

freqs_table 
freqs_table_goto 
;	dta $00
freqs_table_end 

;-----------------

;--------------------------------------------------------------------------------------------------;
;* Volume and Command Envelope 
;* Size: 0 to 144 (3 * 48) bytes max, 3 bytes per tick 
;* 
;* The Envelope will be disabled if the size is defined to be 0, and skipped in the DUMB routines 
;* PAR_ESPD defines Speed (bits 0-5), and Mode (Sustain or Release, bit 7) 
;* PAR_VMIN defines Volume Minimum (bits 4-7) 
;* 
;* Byte 1: Volume (bits 0-3), Auto15khz (bit 4), AutoFilter (bit 5), Auto179mhz (bit 6), Auto16bit (bit 7) 
;* Byte 2: Distortion (bits 0-2), Use AUDCTL (bit 3), Command (bits 4-6), Skip Command (bit 7) 
;* Byte 3: $XY Parameter, may also be ignored if the is no need for a parameter 
;* 
;* If the Skip Command bit is set in any of the Envelope Tick, the Command and Parameter will be ignored 
;* 
;* List of Commands: 
;* 
;* CMD0: Note Offset => May be combined to Table of Notes if Relative Mode is used 
;* CMD1: Absolute Freq => Will always take priority over Tables, 16-bit mode isn't fully compatible since 2 bytes are needed 
;* CMD2: Finetune => May be combined to Table of Freqs if Relative Mode is used 
;* CMD3: Unused 
;* CMD4: Unused 
;* CMD5: AutoTwoTone Offset => This parameter is ignored unless the AutoTwoTone bit is set 
;* CMD6: Autofilter Offset => This parameter is ignored unless the Autofilter bit is set 
;* CMD7: AUDCTL => Overwrite the AUDCTL parameter in the active instrument, may be reset if a Retrigger command is used 
;* 
;* It is worth mentioning that most of this design is WIP 
;* Things are very likely to be changed later for X or Y reason, there's no rush for optimisations yet! 
;--------------------------------------------------------------------------------------------------;

envelope 
	ENV v2 DIST_8 CMD_1 $00 A16BIT
	ENV v3 DIST_2 NO_CMD $00 A16BIT
	ENV v4 DIST_A CMD_2 $01 A16BIT
	ENV v5 DIST_A NO_CMD $00 A16BIT
	ENV v4 DIST_A NO_CMD $00 A16BIT
	ENV v4 DIST_A NO_CMD $00 A16BIT
envelope_goto	
	ENV v5 DIST_A NO_CMD $00 A16BIT
envelope_end 

;-----------------

;--------------------------------------------------------------------------------------------------;	

