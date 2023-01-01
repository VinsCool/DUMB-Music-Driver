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

;	org MODULE 						; The module address could be set anywhere  
DUMB	
	dta d"DUMB"						; 4 bytes identifier 
VERSION	
	dta $00							; Module version number 
REGION	
	dta $01							; Module Region ($00 for PAL, $01 for NTSC) 
MAXTLEN	
	dta $20							; Maximal pattern length 
SONGLEN 
	dta [SONGLNE_END - SONGLNE] / 4				; Total Number of Songlines 
INITSPD	
	dta $08 						; Initial Module Speed 
VBISPD	
	dta $01							; xVBI Speed, up to $0F maximum, high speeds need more CPU cycles 
	
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

INSTTBL 
	dta a(test_instrument_0) 
	
INSTENV
	dta a(test_envelope_0) 

INSTAUD
	dta a(test_distortion_0) 
	
INSTNOT
	dta a(test_notes_0) 

INSTFRE
	dta a(test_freqs_0) 
	
;-----------------

;--------------------------------------------------------------------------------------------------;
;* DUMB Module Data Tables 
;--------------------------------------------------------------------------------------------------;

;* Songline Data, the length and the number of channels used are defined by the DUMB Module Header 
;* 1 byte is used for each Pattern Index Number, which may also be unique to a channel, if desired 
;* Pattern Index numbers between $00 and $FE may be used, while $FF is reserved for Empty Patterns 
;* This should make the Songline structure very flexible, hopefully 

SONGLNE 
	dta $00,$01,$01,$01 
	dta $01,$00,$FF,$FF
	dta $FF,$01,$00,$FF
	dta $FF,$FF,$01,$00
	
	dta $00,$01,$02,$01 
	dta $01,$00,$01,$02
	dta $00,$01,$02,$01 
	dta $01,$00,$01,$02
	
	dta $00,$01,$04,$01 
	dta $01,$00,$01,$04
	dta $00,$01,$04,$01 
	dta $01,$00,$01,$04
	
	dta $00,$00,$02,$03 
	dta $00,$00,$03,$02
	dta $00,$00,$02,$03 
	dta $00,$00,$03,$02

SONGLNE_END

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

;-----------------

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
	ROW B_2 $00 vF CMD5 $05 CMD8 $00 CMDF $06
	ROW PAUSE+1  
	ROW REL 
	ROW E_3 $00 vF
	ROW REL 
	ROW E_3 $00 vF
	ROW Ds3 $00 vF 
	ROW Cs3 $00 vF
	ROW PAUSE+1   
	ROW REL 
	ROW Cs3 $00 vF
	ROW REL 
	ROW Cs3 $00 vF
	ROW B_2 $00 vF 
	ROW Fs3 $00 vF 
	ROW PAUSE+1 
	ROW REL 
	ROW Fs3 $00 vF
	ROW REL 
	ROW Gs3 $00 vF
	ROW Fs3 $00 vF 
	ROW E_3 $00 vF
	ROW PAUSE+1 
	ROW REL 
	ROW E_3 $00 vF
	ROW REL 
	ROW Fs3 $00 vF
	ROW Ds3 $00 vF 
	
PTN1_01
	ROW REL 
	ROW PAUSE+1 
	ROW OFF 
	END_PATTERN 
	
PTN1_02 
	ROW B_2 $00 vF CMD5 $05 CMD8 $00 CMD9 $FF 
	ROW PAUSE+1  
	ROW REL 
	ROW E_3 $00 vF 
	ROW REL 
	ROW E_3 $00 vF
	ROW Ds3 $00 vF 
	ROW Cs3 $00 vF
	ROW PAUSE+1   
	ROW REL 
	ROW Cs3 $00 vF
	ROW REL 
	ROW Cs3 $00 vF
	ROW B_2 $00 vF 
	ROW Fs3 $00 vF 
	ROW PAUSE+1 
	ROW REL 
	ROW Fs3 $00 vF
	ROW REL 
	ROW Gs3 $00 vF
	ROW Fs3 $00 vF 
	ROW E_3 $00 vF
	ROW PAUSE+1 
	ROW REL 
	ROW E_3 $00 vF
	ROW REL 
	ROW Fs3 $00 vF
	ROW Ds3 $00 vF
	
PTN1_03 
	ROW B_2 $00 vF CMD5 $05 CMD8 $06 CMD9 $FF 
	ROW PAUSE+1  
	ROW REL 
	ROW E_3 $00 vF 
	ROW REL 
	ROW E_3 $00 vF
	ROW Ds3 $00 vF 
	ROW Cs3 $00 vF
	ROW PAUSE+1   
	ROW REL 
	ROW Cs3 $00 vF
	ROW REL 
	ROW Cs3 $00 vF
	ROW B_2 $00 vF 
	ROW Fs3 $00 vF 
	ROW PAUSE+1 
	ROW REL 
	ROW Fs3 $00 vF
	ROW REL 
	ROW Gs3 $00 vF
	ROW Fs3 $00 vF 
	ROW E_3 $00 vF
	ROW PAUSE+1 
	ROW REL 
	ROW E_3 $00 vF
	ROW REL 
	ROW Fs3 $00 vF
	ROW Ds3 $00 vF
	
PTN1_04 
	ROW B_2 $00 v0 CMD5 $05 CMD8 $06 CMD9 $FF 
	ROW PAUSE+1  
	ROW REL 
	ROW E_3 $00 v0 
	ROW REL 
	ROW E_3 $00 v0
	ROW Ds3 $00 v0 
	ROW Cs3 $00 v0
	ROW PAUSE+1   
	ROW REL 
	ROW Cs3 $00 v0
	ROW REL 
	ROW Cs3 $00 v0
	ROW B_2 $00 v0 
	ROW Fs3 $00 v0 
	ROW PAUSE+1 
	ROW REL 
	ROW Fs3 $00 v0
	ROW REL 
	ROW Gs3 $00 v0
	ROW Fs3 $00 v0 
	ROW E_3 $00 v0
	ROW PAUSE+1 
	ROW REL 
	ROW E_3 $00 v0
	ROW REL 
	ROW Fs3 $00 v0
	ROW Ds3 $00 v0
	
;----------------- 

;--------------------------------------------------------------------------------------------------;

;* Instrument Data Pointers, 4 bytes per instrument 
 
test_instrument_0
	dta $00,$FF,$FF,$FF 					; Using Volume Envelope 0 

;-----------------

;* Instrument Volume Envelope, 64 bytes per instrument 

test_envelope_0
	dta test_envelope_0_sustain_start - test_envelope_0_start 
	dta test_envelope_0_release_start - test_envelope_0_start 
	dta test_envelope_0_end - test_envelope_0_start 
	 
test_envelope_0_start
	dta $0C,$0B,$0A,$09,$09,$08,$08,$07,$07,$07,$06,$06	; Attack/Decay 
	
test_envelope_0_sustain_start
	dta $05,$05,$05,$05,$04,$04,$04,$04,$05,$05,$05,$05	; Sustain 
	
test_envelope_0_release_start 
	dta $04,$03,$03,$02,$02,$02,$02,$02,$02,$01,$01,$00 	; Release
	
test_envelope_0_end

;-----------------

;* Instrument Distortion/AUDCTL Table, 64 bytes per instrument 
	
test_distortion_0 

;-----------------

;* Instrument Notes Table, 64 bytes per instrument 
	
test_notes_0 

;-----------------

;* Instrument Freqs Table, 64 bytes per instrument 
	
test_freqs_0 

;-----------------

;--------------------------------------------------------------------------------------------------;
;* No extra Module data exists past this point, unless it is specified otherwise... 
;--------------------------------------------------------------------------------------------------;

ENDFILE 

;* That's all folks :D 

;----------------- 

;--------------------------------------------------------------------------------------------------;

