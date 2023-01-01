;* --- Dumb Unless Made Better ---
;*
;* DUMB Module Format - Prototype 2 
;* By VinsCool 
;* 
;* Inspired by the Raster Music Tracker Module Format, created by Raster/CPU
;* I've learned how to code with your work, Raster, thank you for everything, and Rest in Peace! 
;* 
;* This is work in progress, so this file WILL be changed very often! 
;* Many things will be tweaked for as often as is may be necessary
;* The Module data will be thoroughly designed, in order to make the format as flexible as possible 
;*  
;* Let's begin the Dumb Module construction now shall we! 
;--------------------------------------------------------------------------------------------------;

;-----------------

;--------------------------------------------------------------------------------------------------;
;* DUMB Module Header  
;--------------------------------------------------------------------------------------------------;

;* The DUMB Module format begins with a relatively simple header structure 
;* All Module parameters will be defined here, as well as additional file metadata, if desired (maybe) 
;* At the moment, most of this is unfinished, many ambitious goals that may need to be toned down as well 
;* Most of the ideas so far are meant to be used for making the DUMB Module format as flexible as possible 
;* Several things may be tweaked, removed, or changed entirely, so the header structure may change very often 

	org MODULE 						; The module address could be set anywhere  
DUMB	
	dta d"DUMB"						; 4 bytes identifier 
VERSION	
	dta $00							; Module version number 
REGION	
	dta $01							; Module Region ($00 for PAL, $01 for NTSC) 
MAXTLEN	
	dta $40							; Maximal pattern length 
SONGLEN 
	dta $10 						; Total Number of Songlines  
INITSPD	
	dta $06 						; Initial Module Speed 
VBISPD	
	dta $01							; xVBI Speed, up to $0F maximum, high speeds need more CPU cycles 
UNUSED	
	dta $00,$00,$00,$00,$00,$00 				; Unused/Reserved bytes, for a total of 16 bytes (not needed here) 
	
;-----------------

;--------------------------------------------------------------------------------------------------;
;* DUMB Module Address Tables  
;--------------------------------------------------------------------------------------------------;

;* Songline Address Table, for all channels used in a DUMB Module 
;* There is no hard limitation regarding how many channels may be used in a module 
;* This would allow very flexible adjustments if for example a project used only 3 channels 
;* In this case, there would be no use for a 4th channel, which may save a significant amount of memory 

SONGTBL	
	dta a(SONGLNE) 

;-----------------

;* Pattern Address Tables, for all channels used in a DUMB Module 
;* Each channel may be assigned to its own table, if desired 
;* There is no hard limitation regarding how the Pattern data is shared across channels either 

PTNLSB	
	dta <PATTCH1 
	dta <PATTCH2 
	dta <PATTCH3 
	dta <PATTCH4 

PTNMSB	
	dta >PATTCH1 
	dta >PATTCH2 
	dta >PATTCH3 
	dta >PATTCH4 

;-----------------

;* Instrument Address Tables, for all channels used in a DUMB Module 
;* TODO: There is no Instrument support yet 

INSTTBL 
	dta a(__Instrument_0)		; Instrument 01                   
	dta a(__Instrument_1)		; Instrument 05                   
	dta a(__Instrument_2)		; Instrument 00                   
	dta a(__Instrument_3)		; Snare drum                      
	dta a(__Instrument_4)		; Instrument 01                   
	dta a(__Instrument_5)		; Instrument 00                   
	dta a(__Instrument_6)		; Instrument 0B                   
	dta a(__Instrument_7)		; Instrument 00                   
	dta a(__Instrument_8)		; Instrument 00                   
	dta a(__Instrument_9)		; Instrument 00                   
	dta a(__Instrument_10)		; Instrument 00                   
	dta a(__Instrument_11)		; Instrument 00                   
	dta a(__Instrument_12)		; Instrument 00
	
	dta a(__Instrument_13)		; pickbass ch3 dist C 
	
;-----------------

;--------------------------------------------------------------------------------------------------;
;* DUMB Module Data Tables 
;--------------------------------------------------------------------------------------------------;

;* Songline Data, the length and the number of channels used are defined by the DUMB Module Header 
;* 1 byte is used for each Pattern Index Number, which may also be unique to a channel, if desired 
;* Pattern Index numbers between $00 and $FE may be used, while $FF is reserved for Empty Patterns 
;* This should make the Songline structure very flexible, hopefully 

SONGLNE 
	dta $00,$01,$02,$FF
	dta $03,$04,$05,$FF
	dta $00,$06,$07,$FF 
	dta $08,$09,$05,$FF
	dta $0A,$0B,$0C,$FF
	dta $0D,$0E,$0F,$FF
	dta $10,$06,$07,$FF
	dta $11,$09,$05,$FF
	dta $12,$06,$07,$FF
	dta $13,$09,$05,$FF
	dta $14,$15,$16,$FF
	dta $17,$18,$19,$FF
	dta $1A,$1B,$1C,$FF
	dta $1D,$1E,$1F,$FF
	dta $00,$06,$20,$FF
	dta $03,$09,$05,$21 

;-----------------

;--------------------------------------------------------------------------------------------------;

;* Pattern pointers to Rows, always starting from the first row for each ones of them 
;* All the memory addresses used for patterns may be shared across channels, if desired 
;* This is designed with the format flexibility in mind, both small and large tables could be used 
 
PATTCH1

;-----------------	

PATTCH2 

;-----------------
	
PATTCH3	

;-----------------
	
PATTCH4	

;-----------------

	dta a(PTN1_00),a(PTN1_01),a(PTN1_02),a(PTN1_03),a(PTN1_04),a(PTN1_05),a(PTN1_06),a(PTN1_07) 
	dta a(PTN1_08),a(PTN1_09),a(PTN1_0A),a(PTN1_0B),a(PTN1_0C),a(PTN1_0D),a(PTN1_0E),a(PTN1_0F) 
	dta a(PTN1_10),a(PTN1_11),a(PTN1_12),a(PTN1_13),a(PTN1_14),a(PTN1_15),a(PTN1_16),a(PTN1_17) 
	dta a(PTN1_18),a(PTN1_19),a(PTN1_1A),a(PTN1_1B),a(PTN1_1C),a(PTN1_1D),a(PTN1_1E),a(PTN1_1F) 
	dta a(PTN1_20),a(PTN1_21) 

;--------------------------------------------------------------------------------------------------;

;* Row data used in patterns, indexed using the Pattern pointers 
;* The current format is not quite optimised at the moment, but it will become as flexible as possible 
;* Due to the way Patterns are constructed, "jumping" to a specific Row Number is not yet possible, unfortunately 
;* This may or may not be addressed in a future format revision, since this really isn't a big problem anyway 
;* Other than that, there is no hard limit related to the pattern length, unlike the RMT Module format 
;* The number of bytes per pattern is not technically limited, but the actual pattern length is capped at 256 Rows 
;* 256 Rows is be more than enough anyway, that was chosen only because that's also the highest number a single byte could count 

PTN1 
	
;-----------------

PTN2

;-----------------

PTN3 

;-----------------

PTN4 

;-----------------

PTN1_00 
	ROW E_1 $02 vF CMDF $06 PAUSE+11
	ROW F_1 $02 vF PAUSE+3 
	ROW G_1 $02 vF PAUSE+11 
	ROW C_2 $02 vF PAUSE+3
	ROW C_2 $02 vF PAUSE+3 
	ROW As1 $02 vF PAUSE+1
	ROW A_1 $02 vF PAUSE+1
	ROW As1 $02 vF PAUSE+23 

PTN1_01
	ROW ___ ___ __ PAUSE+2
	ROW E_1 $02 v7 PAUSE+11
	ROW F_1 $02 v7 PAUSE+3 
	ROW G_1 $02 v7 PAUSE+11 
	ROW C_2 $02 v7 PAUSE+3
	ROW C_2 $02 v7 PAUSE+3 
	ROW As1 $02 v7 PAUSE+1
	ROW A_1 $02 v7 PAUSE+1
	ROW As1 $02 v7 PAUSE+21

PTN1_02
	ROW C_1 $05 vF 
	ROW ___ ___ v6 
	ROW E_1 $05 vF 
	ROW C_1 $05 v7 
	ROW G_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW G_1 $05 v7
	ROW C_2 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW C_2 $05 v7
	ROW G_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW G_1 $05 v7 
	ROW C_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW C_1 $05 v7 
	ROW G_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW G_1 $05 v7
	ROW C_2 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW C_2 $05 v7
	ROW G_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW G_1 $05 v7 
	ROW As0 $05 vF 
	ROW E_1 $05 v7 
	ROW D_1 $05 vF 
	ROW As0 $05 v7 
	ROW F_1 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW F_1 $05 v7
	ROW As1 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW As1 $05 v7
	ROW F_1 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW F_1 $05 v7 
	ROW As0 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW As0 $05 v7 
	ROW F_1 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW F_1 $05 v7
	ROW As1 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW As1 $05 v7
	ROW F_1 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW F_1 $05 v7

PTN1_03 
	ROW As1 $02 vF PAUSE+3 
	ROW A_1 $02 vF PAUSE+1 
	ROW G_1 $02 vF PAUSE+1 
	ROW F_1 $02 vF PAUSE+15
	ROW G_1 $02 vF PAUSE+3
	ROW F_1 $02 vF PAUSE+3
	ROW E_1 $02 vF PAUSE+1 
	ROW F_1 $02 vF PAUSE+1 
	ROW G_1 $02 vF PAUSE+27 

PTN1_04
	ROW ___ ___ __ PAUSE+2
	ROW As1 $02 v7 PAUSE+3 
	ROW A_1 $02 v7 PAUSE+1 
	ROW G_1 $02 v7 PAUSE+1 
	ROW F_1 $02 v7 PAUSE+15
	ROW G_1 $02 v7 PAUSE+3
	ROW F_1 $02 v7 PAUSE+3
	ROW E_1 $02 v7 PAUSE+1 
	ROW F_1 $02 v7 PAUSE+1 
	ROW G_1 $02 v7 PAUSE+25

PTN1_05
	ROW F_0 $05 vF 
	ROW D_1 $05 v7 
	ROW A_0 $05 vF 
	ROW F_0 $05 v7 
	ROW C_1 $05 vF 
	ROW A_0 $05 v7 
	ROW A_0 $05 vF 
	ROW C_1 $05 v7
	ROW F_1 $05 vF 
	ROW A_0 $05 v7 
	ROW A_0 $05 vF 
	ROW F_1 $05 v7
	ROW C_1 $05 vF 
	ROW A_0 $05 v7 
	ROW A_0 $05 vF 
	ROW C_1 $05 v7
	ROW F_0 $05 vF 
	ROW A_0 $05 v7 
	ROW A_0 $05 vF 
	ROW F_0 $05 v7 
	ROW C_1 $05 vF 
	ROW A_0 $05 v7 
	ROW A_0 $05 vF 
	ROW C_1 $05 v7
	ROW F_1 $05 vF 
	ROW A_0 $05 v7 
	ROW A_0 $05 vF 
	ROW F_1 $05 v7
	ROW C_1 $05 vF 
	ROW A_0 $05 v7 
	ROW A_0 $05 vF 
	ROW C_1 $05 v7 
	ROW C_1 $05 vF 
	ROW A_0 $05 v7 
	ROW E_1 $05 vF 
	ROW C_1 $05 v7 
	ROW G_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW G_1 $05 v7
	ROW C_2 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW C_2 $05 v7
	ROW G_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW G_1 $05 v7 
	ROW C_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW C_1 $05 v7 
	ROW G_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW G_1 $05 v7
	ROW C_2 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW C_2 $05 v7
	ROW G_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW G_1 $05 v7 

PTN1_06
	ROW C_2 $04 vF PAUSE+1
	ROW C_2 $04 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+3
	ROW G_1 $04 vF PAUSE+1
	ROW G_1 $04 vF PAUSE+1
	ROW C_2 $04 vF PAUSE+1
	ROW C_2 $04 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+7
	ROW As1 $04 vF PAUSE+1
	ROW As1 $04 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+3
	ROW F_1 $04 vF PAUSE+1
	ROW F_1 $04 vF PAUSE+1
	ROW As1 $04 vF PAUSE+1
	ROW As1 $04 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+1

PTN1_07	
	ROW C_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW C_1 $05 v7 
	ROW G_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW G_1 $05 v7
	ROW C_2 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW C_2 $05 v7
	ROW G_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW G_1 $05 v7 
	ROW C_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW C_1 $05 v7 
	ROW G_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW G_1 $05 v7
	ROW C_2 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW C_2 $05 v7
	ROW G_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW G_1 $05 v7 
	ROW As0 $05 vF 
	ROW E_1 $05 v7 
	ROW D_1 $05 vF 
	ROW As0 $05 v7 
	ROW F_1 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW F_1 $05 v7
	ROW As1 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW As1 $05 v7
	ROW F_1 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW F_1 $05 v7 
	ROW As0 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW As0 $05 v7 
	ROW F_1 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW F_1 $05 v7
	ROW As1 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW As1 $05 v7
	ROW F_1 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW F_1 $05 v7

PTN1_08
	ROW D_2 $02 vF PAUSE+3
	ROW C_2 $02 vF PAUSE+1
	ROW As1 $02 vF PAUSE+1
	ROW A_1 $02 vF PAUSE+15
	ROW C_2 $02 vF PAUSE+5
	ROW D_2 $02 vF PAUSE+1
	ROW C_2 $02 vF PAUSE+31

PTN1_09	
	ROW F_1 $00 vF PAUSE+1
	ROW F_1 $00 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+3
	ROW C_1 $00 vF PAUSE+1
	ROW C_1 $00 vF PAUSE+1
	ROW F_1 $00 vF PAUSE+1
	ROW F_1 $00 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+7
	ROW C_2 $00 vF PAUSE+1
	ROW C_2 $00 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+3
	ROW G_1 $00 vF PAUSE+1
	ROW G_1 $00 vF PAUSE+1
	ROW C_2 $00 vF PAUSE+1
	ROW C_2 $00 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+1

PTN1_0A
	ROW A_1 $0C vF PAUSE+1
	ROW E_1 $0C vF
	ROW A_1 $0C v7
	ROW A_1 $0C vF
	ROW E_1 $0C v7
	ROW B_1 $0C vF
	ROW A_1 $0C v7
	ROW C_2 $0C vF
	ROW B_1 $0C v7
	ROW C_2 $0C vF
	ROW C_2 $0C v7
	ROW B_1 $0C vF
	ROW C_2 $0C v7
	ROW A_1 $0C vF
	ROW B_1 $0C v7
	ROW C_2 $0C vF
	ROW A_1 $0C v7
	ROW C_1 $01 vF
	ROW C_2 $0C v7
	ROW A_1 $0C v3 PAUSE+1 
	ROW D_2 $0C vF PAUSE+1 
	ROW C_2 $0C vF 
	ROW D_2 $0C v7 PAUSE+1 
	ROW C_2 $0C v7 
	ROW B_1 $0C vF
	ROW ___ ___ v2 
	ROW C_2 $0C vF 
	ROW B_1 $0C v7 	
	ROW A_1 $0C vF
	ROW C_2 $0C v7
	ROW C_1 $01 vF
	ROW A_1 $0C v7	
	ROW C_2 $0C v3 PAUSE+1
	ROW A_1 $0C v3 PAUSE+1
	ROW C_1 $01 vF PAUSE+3
	ROW B_1 $0C vF
	ROW ___ ___ v2 
	ROW C_2 $0C vF 
	ROW B_1 $0C v7	
	ROW A_1 $0C vF
	ROW C_2 $0C v7
	ROW C_1 $01 vF
	ROW A_1 $0C v7	
	ROW C_2 $0C v3 PAUSE+1
	ROW A_1 $0C v3 PAUSE+1	
	ROW C_1 $01 vF PAUSE+6
	ROW C_1 $01 v8

PTN1_0B
	ROW A_1 $00 vF PAUSE+1 
	ROW A_1 $00 vF PAUSE+2
	ROW C_1 $01 v8 PAUSE+1 
	ROW C_1 $01 v8 
	ROW C_1 $03 vF PAUSE+2
	ROW C_1 $01 v8 
	ROW E_1 $00 vF PAUSE+1 
	ROW E_1 $00 vF PAUSE+1
	ROW A_1 $00 vF PAUSE+1 
	ROW A_1 $00 vF PAUSE+1
	ROW C_0 $01 vF 
	ROW C_1 $01 v8 PAUSE+1
	ROW C_1 $01 v8 
	ROW C_1 $03 vF PAUSE+1
	ROW C_1 $01 vF 
	ROW C_1 $01 v8 PAUSE+1
	ROW C_1 $01 v8 PAUSE+1
	ROW C_1 $01 v8
	ROW F_1 $00 vF PAUSE+1 
	ROW F_1 $00 vF PAUSE+1	
	ROW C_1 $01 vF 
	ROW C_1 $01 v8
	ROW C_1 $01 vF 
	ROW C_1 $01 v8
	ROW C_1 $03 vF PAUSE+1
	ROW C_1 $01 vF 
	ROW C_1 $01 v8	
	ROW C_1 $00 vF PAUSE+1 
	ROW C_1 $00 vF PAUSE+1 
	ROW F_1 $00 vF PAUSE+1 
	ROW F_1 $00 vF PAUSE+1
	ROW C_1 $01 vF 
	ROW C_1 $01 v8
	ROW C_1 $01 vF 
	ROW C_1 $01 v8 
	ROW C_1 $03 vF PAUSE+1	
	ROW C_1 $01 vF 
	ROW C_1 $01 v8
	ROW C_1 $01 vF 
	ROW C_1 $01 v8	
	ROW C_1 $03 vF PAUSE+1	

PTN1_0C
	ROW A_0 $07 vF PAUSE+11 
	ROW B_0 $08 vF PAUSE+3 
	ROW A_0 $07 vF PAUSE+11 
	ROW B_0 $08 vF PAUSE+1	
	ROW A_0 $07 vF PAUSE+1	
	ROW F_0 $0A vF PAUSE+11 
	ROW G_0 $0A vF PAUSE+3 
	ROW F_0 $0A vF PAUSE+15 

PTN1_0D
	ROW D_2 $0C vF PAUSE+1 
	ROW A_1 $0C vF
	ROW D_2 $0C v7
	ROW D_2 $0C vF
	ROW A_1 $0C v7
	ROW E_2 $0C vF
	ROW D_2 $0C v7
	ROW F_2 $0C vF
	ROW E_2 $0C v7
	ROW F_2 $0C vF
	ROW F_2 $0C v7
	ROW E_2 $0C vF
	ROW F_2 $0C v7
	ROW F_2 $0C vF
	ROW E_2 $0C v7
	ROW D_2 $0C vF
	ROW F_2 $0C v7
	ROW C_1 $01 vF
	ROW D_2 $0C v7
	ROW F_2 $0C v3 PAUSE+1
	ROW D_2 $0C v3 PAUSE+1
	ROW C_1 $01 vF
	ROW C_1 $01 v8 PAUSE+2
	ROW C_2 $0C vF
	ROW ___ ___ v2
	ROW D_2 $0C vF
	ROW C_2 $0C v7
	ROW B_1 $0C vF
	ROW D_2 $0C v7
	ROW C_1 $01 vF
	ROW B_1 $0C v7
	ROW D_2 $0C v3 PAUSE+1
	ROW B_1 $0C v3 PAUSE+1
	ROW C_1 $01 vF
	ROW C_1 $01 v8 PAUSE+2
	ROW A_1 $0C vF
	ROW C_1 $01 v8
	ROW B_1 $0C vF
	ROW A_1 $0C v7
	ROW G_1 $0C vF
	ROW B_1 $0C v7
	ROW C_1 $01 vF
	ROW G_1 $0C v7
	ROW B_1 $0C v3 PAUSE+1
	ROW G_1 $0C v3 PAUSE+1
	ROW C_1 $03 vF PAUSE+1
	ROW C_1 $01 vF 
	ROW C_1 $01 v8 PAUSE+2
	ROW C_1 $01 vF 
	ROW C_1 $01 v8

PTN1_0E
	ROW D_2 $00 vF PAUSE+1 
	ROW D_2 $00 vF PAUSE+2
	ROW C_1 $01 v8 PAUSE+1 
	ROW C_1 $01 v8 
	ROW C_1 $03 vF PAUSE+2
	ROW C_1 $01 v8 
	ROW A_1 $00 vF PAUSE+1 
	ROW A_1 $00 vF PAUSE+1
	ROW D_2 $00 vF PAUSE+1 
	ROW D_2 $00 vF PAUSE+1
	ROW C_1 $01 vF 
	ROW C_1 $01 v8 
	ROW C_1 $01 vF 
	ROW C_1 $01 v8 
	ROW C_1 $03 vF PAUSE+1 
	ROW C_1 $01 vF 
	ROW C_1 $01 v8 PAUSE+1
	ROW C_1 $01 v8 PAUSE+1
	ROW C_1 $01 v8
	ROW G_1 $00 vF PAUSE+1 
	ROW G_1 $00 vF PAUSE+1	
	ROW C_1 $01 vF 
	ROW C_1 $01 v8
	ROW C_1 $01 vF 
	ROW C_1 $01 v8
	ROW C_1 $03 vF PAUSE+1
	ROW C_1 $01 vF 
	ROW C_1 $01 v8
	ROW D_1 $00 vF PAUSE+1 
	ROW D_1 $00 vF PAUSE+1 
	ROW G_1 $00 vF PAUSE+1 
	ROW G_1 $00 vF PAUSE+1
	ROW C_1 $01 vF 
	ROW C_1 $01 v8
	ROW C_1 $01 vF 
	ROW C_1 $01 v8 
	ROW B_1 $00 vF PAUSE+1 
	ROW B_1 $00 vF PAUSE+1
	ROW C_1 $01 vF 
	ROW C_1 $01 v8	
	ROW C_1 $03 vF PAUSE+1

PTN1_0F
	ROW A_0 $09 vF PAUSE+11 
	ROW B_0 $09 vF PAUSE+3 
	ROW A_0 $09 vF PAUSE+11 
	ROW A_0 $0B vF PAUSE+1	
	ROW F_0 $0A vF PAUSE+1	
	ROW G_0 $0A vF PAUSE+11 
	ROW A_0 $07 vF PAUSE+3 
	ROW C_1 $0A vF PAUSE+5 
	ROW B_0 $08 vF PAUSE+1 
	ROW A_0 $07 vF PAUSE+3 
	ROW G_0 $0A vF PAUSE+3 

PTN1_10
	ROW C_1 $06 vF PAUSE+31
	ROW As0 $06 vF PAUSE+31

PTN1_11
	ROW A_0 $06 vF PAUSE+23
	ROW As0 $06 vF PAUSE+3
	ROW A_0 $06 vF PAUSE+3
	ROW G_0 $06 vF PAUSE+31

PTN1_12
	ROW C_1 $06 vF PAUSE+31
	ROW D_1 $06 vF PAUSE+31
	
PTN1_13
	ROW F_1 $06 vF PAUSE+23
	ROW C_1 $06 vF PAUSE+5 
	ROW D_1 $06 vF PAUSE+1
	ROW C_1 $06 vF PAUSE+31
	
PTN1_14
	ROW E_1 $06 vF PAUSE+55
	ROW F_1 $06 vF PAUSE+5
	ROW G_1 $06 vF PAUSE+1
	
PTN1_15 
	ROW A_1 $00 vF PAUSE+1
	ROW A_1 $00 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+3
	ROW G_1 $00 vF PAUSE+1
	ROW G_1 $00 vF PAUSE+1
	ROW A_1 $00 vF PAUSE+1
	ROW A_1 $00 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+7
	ROW A_1 $00 vF PAUSE+1
	ROW A_1 $00 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+3
	ROW G_1 $00 vF PAUSE+1
	ROW G_1 $00 vF PAUSE+1
	ROW A_1 $00 vF PAUSE+1
	ROW A_1 $00 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+1
	
PTN1_16 
	ROW E_1 $05 vF
	ROW ___ ___ v4 
	ROW A_1 $05 vF
	ROW E_1 $05 v7
	ROW C_2 $05 vF
	ROW A_1 $05 v7
	ROW D_2 $05 vF
	ROW C_2 $05 v7
	ROW E_2 $05 vF
	ROW D_2 $05 v7
	ROW F_2 $05 vF
	ROW E_2 $05 v7
	ROW E_2 $05 vF
	ROW F_2 $05 v7
	ROW D_2 $05 vF
	ROW E_2 $05 v7
	ROW C_2 $05 vF
	ROW D_2 $05 v7
	ROW D_2 $05 vF
	ROW C_2 $05 v7
	ROW C_2 $05 vF
	ROW D_2 $05 v7
	ROW B_1 $05 vF
	ROW C_2 $05 v7
	ROW A_1 $05 vF
	ROW B_1 $05 v7
	ROW B_1 $05 vF
	ROW A_1 $05 v7
	ROW C_2 $05 vF
	ROW B_1 $05 v7
	ROW A_1 $05 vF
	ROW C_2 $05 v7
	ROW E_1 $05 vF
	ROW A_1 $05 v7
	ROW A_1 $05 vF
	ROW E_1 $05 v7
	ROW C_2 $05 vF
	ROW A_1 $05 v7
	ROW D_2 $05 vF
	ROW C_2 $05 v7
	ROW E_2 $05 vF
	ROW D_2 $05 v7
	ROW F_2 $05 vF
	ROW E_2 $05 v7
	ROW E_2 $05 vF
	ROW F_2 $05 v7
	ROW D_2 $05 vF
	ROW E_2 $05 v7
	ROW C_2 $05 vF
	ROW D_2 $05 v7
	ROW D_2 $05 vF
	ROW C_2 $05 v7
	ROW C_2 $05 vF
	ROW D_2 $05 v7
	ROW B_1 $05 vF
	ROW C_2 $05 v7
	ROW A_1 $05 vF
	ROW B_1 $05 v7
	ROW B_1 $05 vF
	ROW A_1 $05 v7
	ROW C_2 $05 vF
	ROW B_1 $05 v7
	ROW A_1 $05 vF
	ROW C_2 $05 v7
	
PTN1_17
	ROW F_1 $06 vF PAUSE+55
	ROW F_1 $06 vF PAUSE+5 
	ROW E_1 $06 vF PAUSE+1
	
PTN1_18 
	ROW F_1 $00 vF PAUSE+1
	ROW F_1 $00 vF PAUSE+5
	ROW Gs0 $03 vF PAUSE+3
	ROW E_1 $00 vF PAUSE+1
	ROW E_1 $00 vF PAUSE+1
	ROW F_1 $00 vF PAUSE+1
	ROW F_1 $00 vF PAUSE+5
	ROW Gs0 $03 vF PAUSE+7
	ROW F_1 $00 vF PAUSE+1
	ROW F_1 $00 vF PAUSE+5
	ROW Gs0 $03 vF PAUSE+3
	ROW E_1 $00 vF PAUSE+1
	ROW E_1 $00 vF PAUSE+1
	ROW F_1 $00 vF PAUSE+1
	ROW F_1 $00 vF PAUSE+5
	ROW Gs0 $03 vF PAUSE+5
	ROW Gs0 $03 vF PAUSE+1
	
PTN1_19 
	ROW C_1 $05 vF
	ROW A_1 $05 v7
	ROW F_1 $05 vF
	ROW C_1 $05 v7
	ROW A_1 $05 vF
	ROW F_1 $05 v7
	ROW B_1 $05 vF
	ROW A_1 $05 v7
	ROW C_2 $05 vF
	ROW B_1 $05 v7
	ROW D_2 $05 vF
	ROW C_2 $05 v7
	ROW C_2 $05 vF
	ROW D_2 $05 v7
	ROW B_1 $05 vF
	ROW C_2 $05 v7
	ROW A_1 $05 vF
	ROW B_1 $05 v7
	ROW B_1 $05 vF
	ROW A_1 $05 v7
	ROW A_1 $05 vF
	ROW B_1 $05 v7
	ROW G_1 $05 vF
	ROW A_1 $05 v7
	ROW F_1 $05 vF
	ROW G_1 $05 v7
	ROW G_1 $05 vF
	ROW F_1 $05 v7
	ROW A_1 $05 vF
	ROW G_1 $05 v7
	ROW F_1 $05 vF
	ROW A_1 $05 v7
	ROW C_1 $05 vF
	ROW F_1 $05 v7
	ROW F_1 $05 vF
	ROW C_1 $05 v7
	ROW A_1 $05 vF
	ROW F_1 $05 v7
	ROW B_1 $05 vF
	ROW A_1 $05 v7
	ROW C_2 $05 vF
	ROW B_1 $05 v7
	ROW D_2 $05 vF
	ROW C_2 $05 v7
	ROW C_2 $05 vF
	ROW D_2 $05 v7
	ROW B_1 $05 vF
	ROW C_2 $05 v7
	ROW A_1 $05 vF
	ROW B_1 $05 v7
	ROW B_1 $05 vF
	ROW A_1 $05 v7
	ROW A_1 $05 vF
	ROW B_1 $05 v7
	ROW G_1 $05 vF
	ROW A_1 $05 v7
	ROW F_1 $05 vF
	ROW G_1 $05 v7
	ROW G_1 $05 vF
	ROW F_1 $05 v7
	ROW A_1 $05 vF
	ROW G_1 $05 v7
	ROW F_1 $05 vF
	ROW A_1 $05 v7

PTN1_1A
	ROW D_1 $06 vF PAUSE+55
	ROW C_1 $06 vF PAUSE+3
	ROW D_1 $06 vF PAUSE+3
	
PTN1_1B
	ROW D_2 $00 vF PAUSE+1
	ROW D_2 $00 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+3 
	ROW A_1 $00 vF PAUSE+1
	ROW A_1 $00 vF PAUSE+1
	ROW D_2 $00 vF PAUSE+1
	ROW D_2 $00 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+7 
	ROW D_2 $00 vF PAUSE+1
	ROW D_2 $00 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+3
	ROW A_1 $00 vF PAUSE+1
	ROW A_1 $00 vF PAUSE+1
	ROW D_2 $00 vF PAUSE+1
	ROW D_2 $00 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+1 
	
PTN1_1C 
	ROW A_1 $05 vF
	ROW F_1 $05 v7
	ROW D_2 $05 vF
	ROW A_1 $05 v7
	ROW E_2 $05 vF
	ROW D_2 $05 v7
	ROW F_2 $05 vF
	ROW E_2 $05 v7
	ROW G_2 $05 vF
	ROW F_2 $05 v7
	ROW A_2 $05 vF
	ROW G_2 $05 v7
	ROW G_2 $05 vF
	ROW A_2 $05 v7
	ROW F_2 $05 vF
	ROW G_2 $05 v7
	ROW E_2 $05 vF
	ROW F_2 $05 v7
	ROW F_2 $05 vF
	ROW E_2 $05 v7
	ROW E_2 $05 vF
	ROW F_2 $05 v7
	ROW D_2 $05 vF
	ROW E_2 $05 v7
	ROW C_2 $05 vF
	ROW D_2 $05 v7
	ROW D_2 $05 vF
	ROW C_2 $05 v7
	ROW C_2 $05 vF
	ROW D_2 $05 v7
	ROW B_1 $05 vF
	ROW C_2 $05 v7
	ROW A_1 $05 vF
	ROW B_1 $05 v7
	ROW D_2 $05 vF
	ROW A_1 $05 v7
	ROW E_2 $05 vF
	ROW D_2 $05 v7
	ROW F_2 $05 vF
	ROW E_2 $05 v7
	ROW G_2 $05 vF
	ROW F_2 $05 v7
	ROW A_2 $05 vF
	ROW G_2 $05 v7
	ROW G_2 $05 vF
	ROW A_2 $05 v7
	ROW F_2 $05 vF
	ROW G_2 $05 v7
	ROW E_2 $05 vF
	ROW F_2 $05 v7
	ROW F_2 $05 vF
	ROW E_2 $05 v7
	ROW E_2 $05 vF
	ROW F_2 $05 v7
	ROW D_2 $05 vF
	ROW E_2 $05 v7
	ROW C_2 $05 vF
	ROW D_2 $05 v7
	ROW D_2 $05 vF
	ROW C_2 $05 v7
	ROW C_2 $05 vF
	ROW D_2 $05 v7
	ROW B_1 $05 vF
	ROW C_2 $05 v7

PTN1_1D
	ROW B_0 $06 vF PAUSE+63
	
PTN1_1E
	ROW G_2 $00 vF PAUSE+1
	ROW G_2 $00 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+3 
	ROW D_2 $00 vF PAUSE+1
	ROW D_2 $00 vF PAUSE+1
	ROW G_2 $00 vF PAUSE+1
	ROW G_2 $00 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+7 
	ROW G_2 $00 vF PAUSE+1
	ROW G_2 $00 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+3
	ROW D_2 $00 vF PAUSE+1
	ROW D_2 $00 vF PAUSE+1
	ROW G_2 $00 vF PAUSE+1
	ROW G_2 $00 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+5
	ROW C_1 $03 vF PAUSE+1
	
PTN1_1F 
	ROW D_1 $05 vF
	ROW B_1 $05 v7
	ROW G_1 $05 vF
	ROW D_1 $05 v7
	ROW B_1 $05 vF
	ROW G_1 $05 v7
	ROW C_2 $05 vF
	ROW B_1 $05 v7
	ROW D_2 $05 vF
	ROW C_2 $05 v7
	ROW E_2 $05 vF
	ROW D_2 $05 v7
	ROW D_2 $05 vF
	ROW E_2 $05 v7
	ROW C_2 $05 vF
	ROW D_2 $05 v7
	ROW B_1 $05 vF
	ROW C_2 $05 v7
	ROW C_2 $05 vF
	ROW B_1 $05 v7
	ROW B_1 $05 vF
	ROW C_2 $05 v7
	ROW A_1 $05 vF
	ROW B_1 $05 v7
	ROW G_1 $05 vF
	ROW A_1 $05 v7
	ROW A_1 $05 vF
	ROW G_1 $05 v7
	ROW B_1 $05 vF
	ROW A_1 $05 v7
	ROW G_1 $05 vF
	ROW B_1 $05 v7
	ROW D_1 $05 vF
	ROW G_1 $05 v7
	ROW G_1 $05 vF
	ROW D_1 $05 v7
	ROW B_1 $05 vF
	ROW G_1 $05 v7
	ROW C_2 $05 vF
	ROW B_1 $05 v7
	ROW D_2 $05 vF
	ROW C_2 $05 v7
	ROW E_2 $05 vF
	ROW D_2 $05 v7
	ROW D_2 $05 vF
	ROW E_2 $05 v7
	ROW C_2 $05 vF
	ROW D_2 $05 v7
	ROW B_1 $05 vF
	ROW C_2 $05 v7
	ROW C_2 $05 vF
	ROW B_1 $05 v7
	ROW B_1 $05 vF
	ROW C_2 $05 v7
	ROW A_1 $05 vF
	ROW B_1 $05 v7
	ROW G_1 $05 vF
	ROW A_1 $05 v7
	ROW A_1 $05 vF
	ROW G_1 $05 v7
	ROW B_1 $05 vF
	ROW A_1 $05 v7
	ROW G_1 $05 vF
	ROW B_1 $05 v7
	
PTN1_20
	ROW C_1 $05 vF 
	ROW G_1 $05 v7 
	ROW E_1 $05 vF 
	ROW C_1 $05 v7 
	ROW G_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW G_1 $05 v7
	ROW C_2 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW C_2 $05 v7
	ROW G_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW G_1 $05 v7 
	ROW C_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW C_1 $05 v7 
	ROW G_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW G_1 $05 v7
	ROW C_2 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW C_2 $05 v7
	ROW G_1 $05 vF 
	ROW E_1 $05 v7 
	ROW E_1 $05 vF 
	ROW G_1 $05 v7 
	ROW As0 $05 vF 
	ROW E_1 $05 v7 
	ROW D_1 $05 vF 
	ROW As0 $05 v7 
	ROW F_1 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW F_1 $05 v7
	ROW As1 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW As1 $05 v7
	ROW F_1 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW F_1 $05 v7 
	ROW As0 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW As0 $05 v7 
	ROW F_1 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW F_1 $05 v7
	ROW As1 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW As1 $05 v7
	ROW F_1 $05 vF 
	ROW D_1 $05 v7 
	ROW D_1 $05 vF 
	ROW F_1 $05 v7
	
PTN1_21
	ROW ___ ___ __ PAUSE+62
	ROW ___ ___ __ CMDB $02 

;--------------------------------------------------------------------------------------------------;

;* Instrument data (TODO) 

INSTDTA 
__Instrument_0
	dta $0c,$0c,$0d,$0d,$00,$00,$ff,$00,$00,$00,$00,$00,$00,$88,$0e,$00
__Instrument_1
	dta $0c,$0c,$10,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$18,$01
	dta $00,$00,$00
__Instrument_2
	dta $15,$0c,$19,$19,$80,$00,$28,$00,$00,$00,$00,$00,$00,$00,$01,$02
	dta $01,$00,$00,$ff,$fe,$ff,$66,$0a,$0c,$66,$0a,$00
__Instrument_3
	dta $0c,$0c,$16,$16,$00,$00,$ff,$00,$00,$00,$00,$00,$00,$88,$18,$02
	dta $99,$1a,$a7,$88,$1a,$b8,$66,$18,$03
__Instrument_4
	dta $0c,$0c,$10,$10,$00,$00,$ff,$00,$00,$00,$00,$00,$00,$55,$18,$01
	dta $77,$0e,$00
__Instrument_5
	dta $0c,$0c,$10,$10,$00,$00,$a0,$00,$00,$00,$00,$00,$00,$44,$18,$02
	dta $44,$0a,$00
__Instrument_6
	dta $29,$1f,$30,$30,$80,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00
	dta $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	dta $00,$01,$02,$01,$00,$00,$ff,$fe,$fe,$ff,$22,$0a,$00,$44,$0a,$00
	dta $55,$0a,$00
__Instrument_7
	dta $0f,$0c,$13,$13,$01,$00,$30,$00,$00,$00,$00,$00,$00,$03,$07,$03
	dta $33,$0a,$0c,$55,$0a,$0c
__Instrument_8
	dta $0f,$0c,$13,$13,$01,$00,$30,$00,$00,$00,$00,$00,$00,$03,$06,$03
	dta $33,$0a,$0c,$55,$0a,$0c
__Instrument_9
	dta $0f,$0c,$13,$13,$01,$00,$30,$00,$00,$00,$00,$00,$00,$03,$08,$03
	dta $33,$0a,$0c,$55,$0a,$0c
__Instrument_10
	dta $0f,$0c,$13,$13,$01,$00,$30,$00,$00,$00,$00,$00,$00,$04,$07,$04
	dta $33,$0a,$0c,$55,$0a,$0c
__Instrument_11
	dta $0f,$0c,$13,$13,$01,$00,$30,$00,$00,$00,$00,$00,$00,$03,$07,$03
	dta $33,$0a,$0c,$55,$0a,$0c
__Instrument_12
	dta $0c,$0c,$10,$10,$00,$00,$a0,$00,$00,$00,$00,$00,$00,$55,$18,$02
	dta $77,$0a,$00
__Instrument_13
	dta $0c,$0c,$19,$19,$00,$20,$ff,$50,$00,$00,$00,$00,$00,$ff,$10,$00
	dta $ff,$7c,$00,$88,$0c,$00,$66,$0c,$00,$66,$0c,$00

;-----------------

;--------------------------------------------------------------------------------------------------;
;* No extra Module data exists past this point, unless it is specified otherwise... 
;--------------------------------------------------------------------------------------------------;

ENDFILE 

;* That's all folks :D 

;----------------- 

;--------------------------------------------------------------------------------------------------;

