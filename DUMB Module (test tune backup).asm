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
	dta $0C 						; Total Number of Songlines  
INITSPD	
	dta $08 						; Initial Module Speed 
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
	dta a(test_instrument_0) 
	dta a(pickbass_c) 
	dta a(dist_a_bell_set) 
	dta a(lead_2_pwm_set) 
	
;-----------------

;--------------------------------------------------------------------------------------------------;
;* DUMB Module Data Tables 
;--------------------------------------------------------------------------------------------------;

;* Songline Data, the length and the number of channels used are defined by the DUMB Module Header 
;* 1 byte is used for each Pattern Index Number, which may also be unique to a channel, if desired 
;* Pattern Index numbers between $00 and $FE may be used, while $FF is reserved for Empty Patterns 
;* This should make the Songline structure very flexible, hopefully 

SONGLNE 
	dta $FF,$05,$09,$07
	dta $FF,$FF,$0A,$08
	dta $FF,$07,$09,$07
	dta $FF,$08,$0A,$08

	dta $FF,$00,$02,$0B
	dta $FF,$01,$02,$0B
	dta $FF,$03,$02,$0B
	dta $FF,$04,$02,$0B
	dta $FF,$06,$02,$0B
	dta $FF,$01,$02,$0B
	dta $FF,$03,$02,$0B
	dta $FF,$04,$02,$0B

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
	dta a(PTN1_05)
	dta a(PTN1_06) 
	dta a(PTN1_07) 
	dta a(PTN1_08) 
	dta a(PTN1_09) 
	dta a(PTN1_0A) 
	dta a(PTN1_0B) 

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
	ROW A_2 $00 VF CMD8 $50 CMD0 $00 CMD4 $00 CMD5 $05 PAUSE+3 
	ROW ___ ___ v6 CMD4 $00 PAUSE+1 
	ROW C_3 $00 VF CMD4 $00 
	ROW ___ ___ v6 
	ROW B_2 $00 VF PAUSE+3
	ROW ___ ___ v6 CMD4 $00 PAUSE+1 
	ROW G_2 $00 VF CMD4 $00
	ROW ___ ___ v6 
	ROW A_2 $00 VF 
	ROW ___ ___ v6 
	ROW C_3 $00 VF 
	ROW ___ ___ v6 
	ROW B_2 $00 VF 
	ROW ___ ___ v6 
	ROW C_3 $00 VF 
	ROW B_2 $00 vF 
	ROW A_2 $00 VF PAUSE+1 
	ROW ___ ___ v6 PAUSE+1 
	ROW G_2 $00 VF PAUSE+1 
	ROW ___ ___ v6 PAUSE+1 
	ROW A_2 $00 VF PAUSE+3 
	ROW ___ ___ v6 CMD4 $00 PAUSE+1
	ROW C_3 $00 VF CMD4 $00
	ROW ___ ___ v6 
	ROW D_3 $00 VF PAUSE+1 
	ROW ___ ___ v6 PAUSE+1 
	ROW C_3 $00 VF 
	ROW B_2 $00 vF 
	ROW A_2 $00 VF 
	ROW ___ ___ v6 
	ROW G_2 $00 VF PAUSE+1 
	ROW ___ ___ v6 PAUSE+1
	ROW E_2 $00 VF PAUSE+1 
	ROW ___ ___ v6 
	ROW ___ ___ __ CMDD $00

PTN1_01 
	ROW A_2 $00 VF CMD4 $00 CMD5 $02 PAUSE+3 
	ROW ___ ___ v6 CMD4 $00 PAUSE+1 
	ROW C_3 $00 VF CMD4 $00
	ROW ___ ___ v6 
	ROW B_2 $00 VF PAUSE+3
	ROW ___ ___ v6 CMD4 $00 PAUSE+1 
	ROW G_2 $00 VF CMD4 $00
	ROW ___ ___ v6 
	ROW A_2 $00 VF 
	ROW ___ ___ v6 
	ROW C_3 $00 VF 
	ROW ___ ___ v6 
	ROW B_2 $00 VF 
	ROW ___ ___ v6 
	ROW G_2 $00 VF 
	ROW ___ ___ v6 
	ROW A_2 $00 VF PAUSE+1 
	ROW ___ ___ v6 PAUSE+1 
	ROW G_2 $00 VF PAUSE+1 
	ROW ___ ___ v6 PAUSE+1 
	ROW A_2 $00 VF PAUSE+1
	ROW ___ ___ v6 
	ROW A_2 $00 VF 
	ROW B_2 $00 VF PAUSE+1
	ROW C_3 $00 VF 
	ROW ___ ___ v6 
	ROW D_3 $00 VF PAUSE+1 
	ROW ___ ___ v6 PAUSE+1
	ROW C_3 $00 VF PAUSE+1 
	ROW E_3 $00 VF 
	ROW ___ ___ v6 
	ROW D_3 $00 VF PAUSE+1 
	ROW ___ ___ v6 
	ROW C_3 $00 VF
	ROW B_2 $00 VF PAUSE+1
	ROW G_2 $00 VF 
	ROW ___ ___ v6 CMDD $00 
	
PTN1_02 
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_1 $01 vF CMDF $08 
	ROW G_1 $01 vF CMDF $06
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_1 $01 vF CMDF $08 
	ROW G_1 $01 vF CMDF $06
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_1 $01 vF CMDF $08 
	ROW G_1 $01 vF CMDF $06
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_1 $01 vF CMDF $08 
	ROW G_1 $01 vF CMDF $06
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_1 $01 vF CMDF $08 
	ROW G_1 $01 vF CMDF $06
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_1 $01 vF CMDF $08 
	ROW G_1 $01 vF CMDF $06
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_1 $01 vF CMDF $08 
	ROW G_1 $01 vF CMDF $06
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 	

PTN1_03 
	ROW A_2 $00 VF CMD4 $00 CMD5 $06 PAUSE+3 
	ROW ___ ___ v6 CMD4 $00 PAUSE+1 
	ROW C_3 $00 VF CMD4 $00 
	ROW ___ ___ v6 
	ROW B_2 $00 VF PAUSE+3
	ROW ___ ___ v6 CMD4 $00 PAUSE+1 
	ROW G_2 $00 VF CMD4 $00
	ROW ___ ___ v6 
	ROW A_2 $00 VF 
	ROW ___ ___ v6 
	ROW C_3 $00 VF 
	ROW ___ ___ v6 
	ROW B_2 $00 VF 
	ROW ___ ___ v6 
	ROW C_3 $00 VF 
	ROW B_2 $00 vF 
	ROW A_2 $00 VF PAUSE+1 
	ROW ___ ___ v6 PAUSE+1 
	ROW G_2 $00 VF PAUSE+1 
	ROW ___ ___ v6 PAUSE+1 
	ROW A_2 $00 VF PAUSE+3 
	ROW ___ ___ v6 CMD4 $00 PAUSE+1
	ROW C_3 $00 VF CMD4 $00
	ROW ___ ___ v6 
	ROW D_3 $00 VF PAUSE+1 
	ROW ___ ___ v6 PAUSE+1 
	ROW C_3 $00 VF 
	ROW B_2 $00 vF 
	ROW A_2 $00 VF 
	ROW ___ ___ v6 
	ROW G_2 $00 VF PAUSE+1 
	ROW ___ ___ v6 PAUSE+1
	ROW E_2 $00 VF PAUSE+1 
	ROW ___ ___ v6 
	ROW ___ ___ __ CMDD $00

PTN1_04 
	ROW A_2 $00 VF CMD4 $00 CMD5 $07 PAUSE+3 
	ROW ___ ___ v6 CMD4 $00 PAUSE+1 
	ROW C_3 $00 VF CMD4 $00
	ROW ___ ___ v6 
	ROW B_2 $00 VF PAUSE+3
	ROW ___ ___ v6 CMD4 $00 PAUSE+1 
	ROW G_2 $00 VF CMD4 $00
	ROW ___ ___ v6 
	ROW A_2 $00 VF 
	ROW ___ ___ v6 
	ROW C_3 $00 VF 
	ROW ___ ___ v6 
	ROW B_2 $00 VF 
	ROW ___ ___ v6 
	ROW G_2 $00 VF 
	ROW ___ ___ v6 
	ROW A_2 $00 VF PAUSE+1 
	ROW ___ ___ v6 PAUSE+1 
	ROW G_2 $00 VF PAUSE+1 
	ROW ___ ___ v6 PAUSE+1 
	ROW A_2 $00 VF PAUSE+1
	ROW ___ ___ v6 
	ROW A_2 $00 VF 
	ROW B_2 $00 VF PAUSE+1
	ROW C_3 $00 VF 
	ROW ___ ___ v6 
	ROW D_3 $00 VF PAUSE+1 
	ROW ___ ___ v6 PAUSE+1
	ROW C_3 $00 VF PAUSE+1 
	ROW E_3 $00 VF 
	ROW ___ ___ v6 
	ROW D_3 $00 VF PAUSE+1 
	ROW ___ ___ v6 
	ROW C_3 $00 VF
	ROW B_2 $00 VF PAUSE+1
	ROW G_2 $00 VF 
	ROW ___ ___ v6 CMDD $00
	
PTN1_05
	ROW OFF ___ __ PAUSE+127 
	
PTN1_06 
	ROW A_2 $00 VF CMD0 $7C CMD4 $00 CMD5 $05 PAUSE+3 
	ROW ___ ___ v6 CMD4 $00 PAUSE+1 
	ROW C_3 $00 VF CMD4 $00 
	ROW ___ ___ v6 
	ROW B_2 $00 VF PAUSE+3
	ROW ___ ___ v6 CMD4 $00 PAUSE+1 
	ROW G_2 $00 VF CMD4 $00
	ROW ___ ___ v6 
	ROW A_2 $00 VF 
	ROW ___ ___ v6 
	ROW C_3 $00 VF 
	ROW ___ ___ v6 
	ROW B_2 $00 VF 
	ROW ___ ___ v6 
	ROW C_3 $00 VF 
	ROW B_2 $00 vF 
	ROW A_2 $00 VF PAUSE+1 
	ROW ___ ___ v6 PAUSE+1 
	ROW G_2 $00 VF PAUSE+1 
	ROW ___ ___ v6 PAUSE+1 
	ROW A_2 $00 VF PAUSE+3 
	ROW ___ ___ v6 CMD4 $00 PAUSE+1
	ROW C_3 $00 VF CMD4 $00
	ROW ___ ___ v6 
	ROW D_3 $00 VF PAUSE+1 
	ROW ___ ___ v6 PAUSE+1 
	ROW C_3 $00 VF 
	ROW B_2 $00 vF 
	ROW A_2 $00 VF 
	ROW ___ ___ v6 
	ROW G_2 $00 VF PAUSE+1 
	ROW ___ ___ v6 PAUSE+1
	ROW E_2 $00 VF PAUSE+1 
	ROW ___ ___ v6 
	ROW ___ ___ __ CMDD $00
	
PTN1_07
	ROW A_1 $00 v4 CMD8 $00 CMD0 $00 CMD5 $06 PAUSE+1
	ROW ___ ___ v5 PAUSE+1
	ROW ___ ___ v4 PAUSE+1
	ROW ___ ___ v3 PAUSE+1
	ROW ___ ___ v4 CMD8 $02 PAUSE+1
	ROW ___ ___ v3 PAUSE+1
	ROW ___ ___ v4 PAUSE+1
	ROW ___ ___ v5 PAUSE+1
	ROW C_0 $00 v4 CMD8 $00 CMD5 $05 PAUSE+1
	ROW ___ ___ v5 PAUSE+1
	ROW ___ ___ v4 PAUSE+1
	ROW ___ ___ v3 PAUSE+1
	ROW ___ ___ v4 CMD8 $02 PAUSE+1
	ROW ___ ___ v3 PAUSE+1
	ROW ___ ___ v4 PAUSE+1
	ROW ___ ___ v5 PAUSE+1
	ROW B_1 $00 v4 CMD8 $00 CMD5 $06 PAUSE+1
	ROW ___ ___ v5 PAUSE+1
	ROW ___ ___ v4 PAUSE+1
	ROW ___ ___ v3 PAUSE+1
	ROW ___ ___ v4 CMD8 $02 PAUSE+1
	ROW ___ ___ v3 PAUSE+1
	ROW ___ ___ v4 PAUSE+1
	ROW ___ ___ v5 PAUSE+1
	ROW C_0 $00 v4 CMD8 $00 CMD5 $05 PAUSE+1
	ROW ___ ___ v5 CMD8 $02 PAUSE+1
	ROW E_0 $00 v4 CMD8 $00 CMD5 $05 PAUSE+1
	ROW ___ ___ v5 CMD8 $02
	ROW ___ ___ __ CMDD $00	
	
PTN1_08
	ROW A_1 $00 v4 CMD8 $00 CMD5 $06 PAUSE+1
	ROW ___ ___ v5 PAUSE+1
	ROW ___ ___ v4 PAUSE+1
	ROW ___ ___ v3 PAUSE+1
	ROW ___ ___ v4 CMD8 $02 PAUSE+1
	ROW ___ ___ v3 PAUSE+1
	ROW ___ ___ v4 PAUSE+1
	ROW ___ ___ v5 PAUSE+1
	ROW C_0 $00 v4 CMD8 $00 CMD5 $05 PAUSE+1
	ROW ___ ___ v5 PAUSE+1
	ROW ___ ___ v4 PAUSE+1
	ROW ___ ___ v3 PAUSE+1
	ROW ___ ___ v4 CMD8 $02 PAUSE+1
	ROW ___ ___ v3 PAUSE+1
	ROW ___ ___ v4 PAUSE+1
	ROW ___ ___ v5 PAUSE+1
	ROW D_0 $00 v4 CMD8 $00 CMD5 $05 PAUSE+1
	ROW ___ ___ v5 PAUSE+1
	ROW ___ ___ v4 PAUSE+1
	ROW ___ ___ v3 PAUSE+1
	ROW ___ ___ v4 CMD8 $02 PAUSE+1
	ROW ___ ___ v3 PAUSE+1
	ROW ___ ___ v4 PAUSE+1
	ROW ___ ___ v5 PAUSE+1
	ROW A_0 $00 v4 CMD8 $00 CMD5 $05 PAUSE+1
	ROW ___ ___ v5 CMD8 $02 PAUSE+1
	ROW B_0 $00 v4 CMD8 $00 CMD5 $05 PAUSE+1
	ROW ___ ___ v5 CMD8 $02 
	ROW ___ ___ __ CMDD $00
	
PTN1_09 
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_0 $01 vF CMDF $08 
	ROW A_0 $01 vF CMDF $06
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_0 $01 vF CMDF $08 
	ROW A_0 $01 vF CMDF $06
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW C_1 $01 vF CMDF $08 
	ROW C_1 $01 vF CMDF $06
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW C_1 $01 vF CMDF $08 
	ROW C_1 $01 vF CMDF $06
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06
	ROW B_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW B_0 $01 vF CMDF $08 
	ROW B_0 $01 vF CMDF $06
	ROW B_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW B_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06
	ROW B_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW B_0 $01 vF CMDF $08 
	ROW B_0 $01 vF CMDF $06
	ROW B_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW B_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW C_1 $01 vF CMDF $08 
	ROW C_1 $01 vF CMDF $06
	ROW E_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06
	ROW E_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06

PTN1_0A 
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_0 $01 vF CMDF $08 
	ROW A_0 $01 vF CMDF $06
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_0 $01 vF CMDF $08 
	ROW A_0 $01 vF CMDF $06
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_0 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW C_1 $01 vF CMDF $08 
	ROW C_1 $01 vF CMDF $06
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW C_1 $01 vF CMDF $08 
	ROW C_1 $01 vF CMDF $06
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW C_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06
	ROW D_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW D_1 $01 vF CMDF $08 
	ROW D_1 $01 vF CMDF $06
	ROW D_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW D_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06
	ROW D_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW D_1 $01 vF CMDF $08 
	ROW D_1 $01 vF CMDF $06
	ROW D_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW D_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06
	ROW A_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06 
	ROW A_1 $01 vF CMDF $08 
	ROW A_1 $01 vF CMDF $06
	ROW B_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06
	ROW B_1 $01 vF CMDF $08 
	ROW ___ ___ __ CMDF $06
	
PTN1_0B 
	ROW A_0 $00 v4 CMD5 $06 CMD8 $00 CMD0 $00 CMD4 $00
	ROW ___ ___ __ 
	ROW A_1 $00 v4 
	ROW G_1 $00 v4 
	ROW A_0 $00 v4 
	ROW ___ ___ __ 
	ROW C_1 $00 v4  
	ROW ___ ___ __ 
	ROW A_0 $00 v4 
	ROW ___ ___ __ 
	ROW A_1 $00 v4 
	ROW G_1 $00 v4 
	ROW A_0 $00 v4 
	ROW ___ ___ __ 
	ROW C_1 $00 v4 
	ROW ___ ___ __
	ROW A_0 $00 v4 
	ROW ___ ___ __ 
	ROW A_1 $00 v4
	ROW G_1 $00 v4 
	ROW A_0 $00 v4 
	ROW ___ ___ __
	ROW C_1 $00 v4 
	ROW ___ ___ __ 
	ROW A_0 $00 v4 
	ROW ___ ___ __ 
	ROW A_1 $00 v4 
	ROW G_1 $00 v4
	ROW A_0 $00 v4  
	ROW ___ ___ __  
	ROW C_1 $00 v4 
	ROW ___ ___ __ 
	ROW A_0 $00 v4 
	ROW ___ ___ __ 
	ROW A_1 $00 v4 
	ROW G_1 $00 v4 
	ROW A_0 $00 v4 
	ROW ___ ___ __ 
	ROW C_1 $00 v4 
	ROW ___ ___ __ 
	ROW A_0 $00 v4 
	ROW ___ ___ __ 
	ROW A_1 $00 v4 
	ROW G_1 $00 v4 
	ROW A_0 $00 v4 
	ROW ___ ___ __ 
	ROW C_1 $00 v4 
	ROW ___ ___ __ 
	ROW A_0 $00 v4 
	ROW ___ ___ __
	ROW A_1 $00 v4 
	ROW G_1 $00 v4 
	ROW A_0 $00 v4 
	ROW ___ ___ __ 
	ROW C_1 $00 v4 
	ROW ___ ___ __  

;--------------------------------------------------------------------------------------------------;

;* Instrument data 

INSTDTA 
test_instrument_0
	ins 'test_instrument.dmi'
pickbass_c
	ins 'pickbass_c.dmi'
dist_a_bell_set
	ins 'dist_a_bell_set.dmi'
lead_2_pwm_set
	ins 'lead_2_pwm_set.dmi'

;-----------------

;--------------------------------------------------------------------------------------------------;
;* No extra Module data exists past this point, unless it is specified otherwise... 
;--------------------------------------------------------------------------------------------------;

ENDFILE 

;* That's all folks :D 

;----------------- 

;--------------------------------------------------------------------------------------------------;

