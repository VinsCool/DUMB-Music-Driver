;* Deconstructed RMT instrument in 6502 ASM 
;* by VinsCool 
;* 
;* This is intended to be used as a reference for creating the future DUMB Instrument format 
;* For now, this is used is to reconstruct instruments the same way RMT would expect them
;* 
;* RMT instruments vary greatly in size, ranging between 16 bytes (minimum) and 188 bytes (maximum) 
;* Long Envelopes and/or long Tables add up very quickly, which could eat a lot precious memory! 
;--------------------------------------------------------------------------------------------------;

;-----------------

;--------------------------------------------------------------------------------------------------;
;* Below is a dummy instrument broken down as an example 
;--------------------------------------------------------------------------------------------------;

;* Instrument Constants 

INSTRPAR	= instr_data_end - instr_data				; Size of Instrument data before Table and Envelope 
ENV_OFFSET	= instr_offsetnum_end - instr_offsetnum			; Bytes per Envelope ticks 
TOTAL_BYTES	= instr_envelope_end - instr_data			; Total number of bytes in the Instrument 

;* Instrument Table  

TBL_LENGTH	= table_of_notes_end - table_of_notes			; Table Length, min = $01, max = $20
TBL_GOTO	= table_of_notes_goto - table_of_notes			; Table Loop Point, min = $00, max = TBL_LENGTH - 1 
TBL_SPEED	= $40							; Table Speed (tspd bit 0-5) = min = $01, max = $40 
TBL_MODE	= 0							; Table Mode (tspd bit 6), 0 = Set, 1 = Add  
TBL_TYPE	= 0							; Table Type (tspd bit 7), 0 = Notes, 1 = Freqs 

;* Instrument Envelope 

ENV_LENGTH	= (instr_envelope_end - instr_envelope) / ENV_OFFSET	; Envelope Length, min = $01, max = $30
ENV_GOTO	= (instr_envelope_goto - instr_envelope) / ENV_OFFSET	; Envelope Loop point, min = $00, max = ENV_LENGTH - 1 

;* Instrument Parameters 

PAR_TSPD	= TBL_SPEED + (TBL_MODE * $40) + (TBL_TYPE * $80) - 1	; Combined values for Table Speed, Table Mode and Table Type 
PAR_AUDCTL	= $28 							; AUDCTL, any value 
PAR_VSLIDE	= $4C							; Volume Slide, any value 
PAR_VMIN	= $00 							; Volume Minimum, min = $00, max = $0F 
PAR_DELAY	= $00 							; Vibrato and Fshift delay, any value, $00 for no effect 
PAR_VIBRATO	= $00							; Vibrato, min = $00, max = $03 
PAR_FSHIFT	= $01 							; Fshift, any value 
PAR_UNUSED	= $00 							; Unused, always $00 

;* Instrument Offsets 

PTR_TLEN	= INSTRPAR + TBL_LENGTH - 1				; Offset to End of Table 
PTR_TGO		= INSTRPAR + TBL_GOTO					; Offset to Table Loop Point 
PTR_ELEN	= PTR_TLEN + (ENV_OFFSET * (ENV_LENGTH - 1)) + 1	; Offset to End of Envelope 
PTR_EGO		= PTR_TLEN + ENV_GOTO + 1				; Offset to Envelope Loop Point 

;-----------------

;* Error Handlers and Warning Messages 
;* Invalid data and/or parameters incompatible with the RMT instrument format will return an error 
;* Breaking any size limitations and/or boundaries will also return an error 
;* This was added to reduce the chances of writing garbage instruments generated using this tool 

.IF (INSTRPAR != $0C) 
	.print "WARNING: INSTRPAR = ", INSTRPAR
	.print "The value of $0C is expected for #INSTRPAR" 
.ENDIF

.IF (ENV_OFFSET != $03) 
	.print "WARNING: ENV_OFFSET = ", ENV_OFFSET
	.print "The value of $03 is expected for Bytes per Envelope ticks" 
.ENDIF

.IF (TBL_LENGTH > $20 || TBL_LENGTH < 1) 
	.print "WARNING: TBL_LENGTH = ", TBL_LENGTH
	.print "Any values between $01 and $20 are expected for Table Length" 
	.IF (TBL_LENGTH < 1)
		.print "Also, the Table Length could not be a value of 0!" 
		.ERROR "Invalid parameter"
	.ENDIF
.ENDIF

.IF (TBL_GOTO > TBL_LENGTH) 
	.print "ERROR: TBL_GOTO = ", TBL_GOTO 
	.print "The value of Table Loop Point must be lower than Table Length" 
	.ERROR "Invalid parameter"
.ENDIF

.IF (TBL_SPEED > $40 || TBL_SPEED < 1) 
	.print "WARNING: TBL_SPEED = ", TBL_SPEED
	.print "Any values between $01 and $40 are expected for Table Speed" 
	.IF (TBL_SPEED < 1)
		.print "Also, the Table Speed could not be a value of 0!" 
		.ERROR "Invalid parameter"
	.ENDIF
.ENDIF

.IF (TBL_MODE > 1) 
	.print "ERROR: TBL_MODE = ", TBL_MODE 
	.print "The value of Table Mode must be either 0 or 1" 
	.ERROR "Invalid parameter"
.ENDIF

.IF (TBL_TYPE > 1) 
	.print "ERROR: TBL_TYPE = ", TBL_TYPE 
	.print "The value of Table Type must be either 0 or 1" 
	.ERROR "Invalid parameter"
.ENDIF

.IF (ENV_LENGTH > $30 || ENV_LENGTH < 1) 
	.print "WARNING: ENV_LENGTH = ", ENV_LENGTH
	.print "Any values between $01 and $30 are expected for Envelope Length" 
	.IF (ENV_LENGTH < 1)
		.print "Also, the Envelope Length could not be a value of 0!" 
		.ERROR "Invalid parameter"
	.ENDIF
.ENDIF

.IF (ENV_GOTO > ENV_LENGTH) 
	.print "ERROR: ENV_GOTO = ", ENV_GOTO 
	.print "The value of Envelope Loop Point must be lower than Envelope Length" 
	.ERROR "Invalid parameter"
.ENDIF

.IF (PAR_VMIN > $0F) 
	.print "WARNING: PAR_VMIN = ", PAR_VMIN
	.print "Any values between $00 and $0F are expected for Volume Minimum" 
.ENDIF

.IF (PAR_VIBRATO > $03) 
	.print "WARNING: PAR_VIBRATO = ", PAR_VIBRATO
	.print "Any values between $00 and $03 are expected for Vibrato" 
.ENDIF

.IF (TOTAL_BYTES > 188 || TOTAL_BYTES < 16) 
	.print "WARNING: TOTAL_BYTES = ", TOTAL_BYTES
	.print "The RMT Instrument size is expected to be between 16 and 188 bytes" 
	.IF (TOTAL_BYTES > 256)
		.print "Also, the RMT Instrument must not use more than 256 bytes!" 
		.ERROR "Invalid parameter"
	.ELSEIF (TOTAL_BYTES < 1)
		.print "Also, the RMT Instrument must NOT be 0 bytes!" 
		.ERROR "Invalid parameter"
	.ENDIF 
.ENDIF

.IFDEF ERROR_CODE 
	.print "The error code of ", ERROR_CODE, " was encountered"
	.print "An error was encountered during the process of creating instruments"
	.print "Please verify the integrity of instrument data and parameters"
	.print "For optimal results, the RMT instrument format specifications must be respected" 
	.print " " 
.ENDIF

;-----------------

;--------------------------------------------------------------------------------------------------;
;* Instrument parameters, 12 bytes max 
;--------------------------------------------------------------------------------------------------;

;* Instrument offsets, 4 bytes

instr_data
tlen	dta PTR_TLEN 
tgo	dta PTR_TGO 
elen	dta PTR_ELEN 
ego	dta PTR_EGO 

;* Instrument bytes, 8 bytes

tspd	dta PAR_TSPD 
audctl	dta PAR_AUDCTL
vslide	dta PAR_VSLIDE
vmin	dta PAR_VMIN
delay	dta PAR_DELAY
vibrato	dta PAR_VIBRATO
fshift	dta PAR_FSHIFT
unused	dta PAR_UNUSED 
instr_data_end

;-----------------

;--------------------------------------------------------------------------------------------------;
;* Table of Notes/Freqs, 32 bytes max
;--------------------------------------------------------------------------------------------------;

table_of_notes 
table_of_notes_goto
	dta $56 
	dta $56 
	dta $56 
	dta $56  
	dta $56 
	dta $56  
	dta $56 
	dta $56  
	dta $56 
	dta $56  
	dta $56 
	dta $56  
	dta $56 
	dta $56  
	dta $56 
	dta $56  
	dta $56 
	dta $56  
	dta $56 
	dta $56  
	dta $56 
	dta $56  
	dta $56 
	dta $56  
	dta $56 
	dta $56  
	dta $56 
	dta $56  
	dta $56 
	dta $56  
	dta $56 
	dta $56 
table_of_notes_end 

;-----------------

;--------------------------------------------------------------------------------------------------;
;* Instrument Envelope, 144 bytes max 
;--------------------------------------------------------------------------------------------------;

instr_envelope 
instr_envelope_goto 
instr_offsetnum
	dta $ff,$7e,$65
instr_offsetnum_end 
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65 
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65
	dta $ff,$7e,$65 
instr_envelope_end 

;-----------------

;--------------------------------------------------------------------------------------------------;	

