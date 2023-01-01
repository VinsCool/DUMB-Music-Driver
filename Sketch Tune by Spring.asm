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
	dta $02 						; Total Number of Songlines  
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
	dta a(__Instrument_0)		; nk                              
	dta a(__Instrument_1)		; Bass drum vin                   
	dta a(__Instrument_2)		; plainsqr1                       
	dta a(__Instrument_3)		; wierdbass                       
	dta a(__Instrument_4)		; noise hihat 1                   
	dta a(__Instrument_5)		; ded 	
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
	dta $00,$01,$02,$03
	dta $00,$01,$04,$02

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

	dta a(PTN1_00)
	dta a(PTN1_01) 
	dta a(PTN1_02) 
	dta a(PTN1_03) 
	dta a(PTN1_04) 

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
	ROW Fs1 $00 vE PAUSE+1
	ROW Cs2 $00 v1 PAUSE+1
	ROW F_1 $02 v1 
	ROW ___ ___ v3 
	ROW ___ ___ v5 
	ROW ___ ___ v2 
	ROW As1 $00 vE PAUSE+1 
	ROW As1 $00 v1 PAUSE+1 
	ROW F_1 $02 v1 
	ROW ___ ___ v3 
	ROW ___ ___ v5 
	ROW ___ ___ v2 
	ROW As1 $00 vE PAUSE+1 
	ROW As1 $00 v1 PAUSE+1
	ROW F_1 $02 v1 
	ROW ___ ___ v3 
	ROW ___ ___ v5 
	ROW ___ ___ v2 
	ROW As1 $00 vE PAUSE+1 
	ROW As1 $00 v1 PAUSE+1
	ROW F_1 $02 v1 
	ROW ___ ___ v3 
	ROW ___ ___ v5 
	ROW ___ ___ v2 
	ROW As1 $00 vE PAUSE+1 
	ROW As1 $00 v1 PAUSE+1
	ROW As0 $02 v1 
	ROW ___ ___ v3 
	ROW ___ ___ v5 
	ROW ___ ___ v2 
	ROW As1 $00 vE PAUSE+1 
	ROW As1 $00 v1 PAUSE+1
	ROW B_0 $02 v1 
	ROW ___ ___ v3 
	ROW ___ ___ v5 
	ROW ___ ___ v2 
	ROW As1 $00 vE PAUSE+1 
	ROW As1 $00 v1 PAUSE+1
	ROW C_1 $02 v1 
	ROW ___ ___ v3 
	ROW ___ ___ v5 
	ROW ___ ___ v2 
	ROW As1 $00 vE PAUSE+1 
	ROW As1 $00 v1 PAUSE+1
	ROW Cs1 $02 v1 
	ROW ___ ___ v3 
	ROW ___ ___ v5 
	ROW ___ ___ v2	

PTN1_01 
	ROW Cs2 $01 vD CMDF $07
	ROW ___ ___ __ CMDF $06
	ROW Cs2 $01 v1 CMDF $07
	ROW ___ ___ __ CMDF $06
	ROW Ds1 $02 v1 CMDF $07
	ROW ___ ___ v3 CMDF $06
	ROW ___ ___ v5 CMDF $07
	ROW ___ ___ v2 CMDF $06
	ROW Cs2 $01 vE CMDF $07
	ROW ___ ___ __ CMDF $06
	ROW Cs2 $01 v1 CMDF $07
	ROW ___ ___ __ CMDF $06
	ROW As0 $02 v1 CMDF $07
	ROW ___ ___ v3 CMDF $06
	ROW ___ ___ v5 CMDF $07
	ROW ___ ___ v2 CMDF $06
	ROW As1 $01 vE CMDF $07
	ROW ___ ___ __ CMDF $06
	ROW As1 $01 v1 CMDF $07
	ROW ___ ___ __ CMDF $06
	ROW Ds1 $02 v1 CMDF $07
	ROW ___ ___ v3 CMDF $06
	ROW ___ ___ v5 CMDF $07
	ROW ___ ___ v2 CMDF $06
	ROW As1 $01 vE CMDF $07
	ROW ___ ___ __ CMDF $06
	ROW As1 $01 v1 CMDF $07
	ROW ___ ___ __ CMDF $06
	ROW As0 $02 v1 CMDF $07
	ROW ___ ___ v3 CMDF $06
	ROW ___ ___ v5 CMDF $07
	ROW ___ ___ v2 CMDF $06
	ROW Cs2 $01 vE CMDF $07
	ROW ___ ___ __ CMDF $06
	ROW Cs2 $01 v1 CMDF $07
	ROW ___ ___ __ CMDF $06
	ROW Ds0 $02 v1 CMDF $07
	ROW ___ ___ v3 CMDF $06
	ROW ___ ___ v5 CMDF $07
	ROW ___ ___ v2 CMDF $06
	ROW Cs2 $01 vE CMDF $07
	ROW ___ ___ __ CMDF $06
	ROW Cs2 $01 v1 CMDF $07
	ROW ___ ___ __ CMDF $06
	ROW Fs0 $02 v1 CMDF $07
	ROW ___ ___ v3 CMDF $06
	ROW ___ ___ v5 CMDF $07
	ROW ___ ___ v2 CMDF $06
	ROW Cs2 $01 vE CMDF $07
	ROW ___ ___ __ CMDF $06
	ROW Cs2 $01 v1 CMDF $07
	ROW ___ ___ __ CMDF $06
	ROW As0 $02 v1 CMDF $07
	ROW ___ ___ v3 CMDF $06
	ROW ___ ___ v5 CMDF $07
	ROW ___ ___ v2 CMDF $06
	ROW Cs2 $01 vE CMDF $07
	ROW ___ ___ __ CMDF $06
	ROW Cs2 $01 v1 CMDF $07
	ROW ___ ___ __ CMDF $06
	ROW Gs0 $02 v1 CMDF $07
	ROW ___ ___ v3 CMDF $06
	ROW ___ ___ v5 CMDF $07
	ROW ___ ___ v2 CMDF $06
	
PTN1_02
	ROW As1 $03 vF 
	ROW Ds1 $03 vF 
	ROW Gs1 $03 vF 
	ROW As1 $03 vF PAUSE+1
	ROW Ds1 $03 vF 
	ROW As1 $03 vF PAUSE+1
	ROW F_1 $03 vF PAUSE+1
	ROW Fs1 $03 vF PAUSE+1
	ROW Fs1 $03 vF PAUSE+1
	ROW Ds1 $03 vF PAUSE+1
	ROW As1 $03 vF 
	ROW Ds1 $03 vF 
	ROW Gs1 $03 vF 
	ROW As1 $03 vF PAUSE+1
	ROW Ds1 $03 vF 
	ROW As1 $03 vF PAUSE+1 
	ROW F_1 $03 vF PAUSE+1
	ROW Ds1 $03 vF PAUSE+3
	ROW Ds1 $03 vF PAUSE+1
	ROW As1 $03 vF 
	ROW Ds1 $03 vF 
	ROW Gs1 $03 vF 
	ROW As1 $03 vF PAUSE+1
	ROW Ds1 $03 vF 
	ROW As1 $03 vF PAUSE+1
	ROW F_1 $03 vF PAUSE+1
	ROW Cs2 $03 vF PAUSE+1
	ROW Cs2 $03 vF PAUSE+1
	ROW Gs1 $03 vF PAUSE+1
	ROW Fs1 $03 vF 
	ROW F_1 $03 vF 
	ROW Ds1 $03 vF 
	ROW F_1 $03 vF PAUSE+1
	ROW As0 $03 vF 
	ROW As0 $03 vF PAUSE+3
	ROW Gs0 $03 vF PAUSE+3
	ROW Gs0 $03 vF PAUSE+1

PTN1_03
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA
	ROW Cs2 $04 vC
	ROW Cs2 $04 vB
	ROW Cs2 $04 vA

PTN1_04
	ROW F_2 $05 vF PAUSE+2
	ROW F_2 $05 v8 PAUSE+2
	ROW F_2 $05 v4 PAUSE+2
	ROW F_2 $05 v2 PAUSE+2
	ROW F_2 $05 v1 PAUSE+2
	ROW F_2 $05 v1 PAUSE+2
	ROW F_2 $05 v1 PAUSE+2
	ROW F_2 $05 v1 PAUSE+2
	ROW F_2 $05 v1 PAUSE+1
	ROW As1 $05 vF
	ROW Cs2 $05 vF
	ROW F_2 $05 vF
	ROW Fs2 $05 vF
	ROW F_2 $05 vF
	ROW Ds2 $05 vE
	ROW As2 $05 vF
	ROW Gs2 $05 vF
	ROW Ds2 $05 v7
	ROW Fs2 $05 vF
	ROW F_2 $05 vE
	ROW Ds2 $05 v4
	ROW Fs2 $05 v8
	ROW F_2 $05 v7
	ROW Ds2 $05 v2
	ROW Fs2 $05 v4
	ROW F_2 $05 v4	
	ROW Ds2 $05 v1
	ROW Fs2 $05 v2
	ROW F_2 $05 v2
	ROW C_2 $05 vF
	ROW Cs2 $05 vF
	ROW C_2 $05 vF
	ROW C_2 $05 v8
	ROW Cs2 $05 v8	
	ROW Gs1 $05 vF
	ROW C_2 $05 v4
	ROW Cs2 $05 v4	
	ROW Gs1 $05 v8
	ROW C_2 $05 v2
	ROW Cs2 $05 v2	
	ROW Gs1 $05 v4
	ROW C_2 $05 v1
	ROW Cs2 $05 v1	
	ROW Gs1 $05 v2
	ROW C_2 $05 v1
	ROW Cs2 $05 v1	
	ROW Gs1 $05 v1


;--------------------------------------------------------------------------------------------------;

;* Instrument data (TODO) 

INSTDTA 
__Instrument_0
	dta $0c,$0c,$19,$19,$00,$00,$00,$00,$00,$00,$00,$00,$00,$cc,$10,$00
	dta $66,$18,$80,$44,$10,$80,$22,$10,$80,$00,$00,$00
__Instrument_1
	dta $0c,$0c,$1f,$1f,$00,$00,$00,$00,$00,$00,$00,$00,$00,$88,$1a,$c3
	dta $88,$1a,$e0,$88,$1a,$f0,$44,$10,$06,$33,$18,$0a,$22,$18,$0a,$00
	dta $18,$00
__Instrument_2
	dta $0c,$0c,$0d,$0d,$00,$00,$00,$00,$11,$03,$00,$00,$00,$88,$0a,$00
__Instrument_3
	dta $0c,$0c,$16,$16,$00,$00,$40,$00,$00,$00,$00,$00,$00,$88,$0a,$0c
	dta $66,$0e,$00,$55,$0e,$00,$44,$0e,$00
__Instrument_4
	dta $0c,$0c,$16,$16,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$18,$00
	dta $22,$18,$01,$11,$18,$02,$00,$00,$00
__Instrument_5
	dta $0c,$0c,$46,$22,$00,$00,$00,$00,$12,$03,$00,$00,$00,$66,$18,$00
	dta $aa,$72,$20,$88,$02,$00,$88,$02,$00,$44,$02,$00,$33,$02,$00,$22
	dta $02,$00,$66,$18,$00,$11,$7a,$00,$11,$0a,$00,$11,$0a,$00,$11,$0a
	dta $00,$11,$0a,$00,$55,$18,$00,$11,$0a,$00,$11,$0a,$00,$11,$0a,$00
	dta $11,$0a,$00,$11,$0a,$00,$11,$0a,$00
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

