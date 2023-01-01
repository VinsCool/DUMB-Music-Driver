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
	dta $09 						; Initial Module Speed 
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

PTNTBL
	dta a(PTN_00) 
	dta a(PTN_01) 
	dta a(PTN_02)  
	dta a(PTN_03) 
	dta a(PTN_04) 
	dta a(PTN_05) 
	dta a(PTN_06) 
	dta a(PTN_07) 
	dta a(PTN_08) 
	dta a(PTN_09) 
	dta a(PTN_0A) 
	dta a(PTN_0B) 
	dta a(PTN_0C) 
	dta a(PTN_0D) 

	dta a(PTN_0E) 
	dta a(PTN_0F) 
	dta a(PTN_10) 
	dta a(PTN_11) 
	dta a(PTN_12) 
	dta a(PTN_13) 
	
	dta a(PTN_14) 
	dta a(PTN_15) 
	dta a(PTN_16) 
	dta a(PTN_17) 
	dta a(PTN_18) 
	dta a(PTN_19)
	
	dta a(PTN_1A) 
	dta a(PTN_1B) 
	dta a(PTN_1C) 
	dta a(PTN_1D) 
	dta a(PTN_1E) 
	dta a(PTN_1F)
	
	dta a(PTN_20) 
	dta a(PTN_21) 
	dta a(PTN_22) 
	dta a(PTN_23) 
	dta a(PTN_24) 
	dta a(PTN_25)
	
	dta a(PTN_26) 
	dta a(PTN_27) 
	dta a(PTN_28) 
	dta a(PTN_29) 
	dta a(PTN_2A) 
	dta a(PTN_2B) 
	
	dta a(PTN_2C) 
	dta a(PTN_2D) 
	dta a(PTN_2E) 
	dta a(PTN_2F) 
	dta a(PTN_30) 
	dta a(PTN_31) 
	
	dta a(PTN_32) 
	dta a(PTN_33) 
	dta a(PTN_34) 
	dta a(PTN_35) 


;-----------------

;* Instrument Address Tables, for all channels used in a DUMB Module 

INSTTBL 
	dta a(pickbass_c) 
	dta a(pulse_drum_2) 
	dta a(pulse_snare) 
	dta a(shaker_cut) 
	dta a(shaker) 
	dta a(pickbass_a) 
	dta a(some_kind_of_flute_no_vib) 
	dta a(distortion_a_lead_2_pwm)
	dta a(distortion_a_lead_2_pwm_set)
	dta a(distortion_a_bell_64khz_pwm_set) 
	dta a(distortion_c_179_arp) 
	
INSTENV
	dta a(pickbass_c_vol) 
	dta a(pulse_drum_2_vol) 
	dta a(pulse_snare_vol) 
	dta a(shaker_cut_vol) 
	dta a(shaker_vol) 
	dta a(some_kind_of_flute_no_vib_vol) 
	dta a(distortion_a_lead_2_pwm_vol)
	dta a(distortion_a_bell_64khz_pwm_set_vol) 

INSTAUD
	dta a(pickbass_c_aud) 
	dta a(pulse_drum_2_aud) 
	dta a(pulse_snare_aud) 
	dta a(shaker_cut_aud) 
	dta a(shaker_aud) 
	dta a(pickbass_a_aud) 
	dta a(some_kind_of_flute_no_vib_aud) 
	dta a(distortion_a_lead_2_pwm_aud)
	dta a(distortion_c_179_arp_aud) 
	
INSTNOT
	dta a(some_kind_of_flute_no_vib_notes) 

INSTFRE
	dta a(pickbass_c_freqs) 
	dta a(pulse_drum_2_freqs) 
	dta a(pulse_snare_freqs) 
	dta a(shaker_cut_freqs) 
	dta a(shaker_freqs) 
	dta a(some_kind_of_flute_no_vib_freqs) 
	
INSTCMD 
	dta a(pickbass_c_cmd) 
	dta a(some_kind_of_flute_no_vib_cmd) 
	dta a(distortion_a_lead_2_pwm_cmd)
	dta a(distortion_a_lead_2_pwm_set_cmd) 
	dta a(distortion_a_bell_64khz_pwm_set_cmd) 
	
;-----------------

;--------------------------------------------------------------------------------------------------;
;* DUMB Module Data Tables 
;--------------------------------------------------------------------------------------------------;

;* Songline Data, the length and the number of channels used are defined by the DUMB Module Header 
;* 1 byte is used for each Pattern Index Number, which may also be unique to a channel, if desired 
;* Pattern Index numbers between $00 and $FE may be used, while $FF is reserved for Empty Patterns 
;* This should make the Songline structure very flexible, hopefully 

SONGLNE 
	dta $04,$01,$0A,$20
	dta $05,$00,$0A,$21
	dta $06,$00,$0B,$22
	dta $07,$00,$0B,$23
	dta $08,$00,$0A,$24
	dta $09,$00,$0A,$25 

	dta $0E,$26,$0C,$2C
	dta $0F,$27,$0C,$2D
	dta $10,$28,$0D,$2E
	dta $11,$29,$0D,$2F
	dta $12,$2A,$0C,$30
	dta $13,$2B,$0C,$31 

	dta $32,$01,$0A,$20
	dta $33,$00,$0A,$21
	dta $32,$00,$0A,$20
	dta $33,$00,$0A,$21
	dta $34,$00,$0B,$22
	dta $35,$00,$0B,$23
	dta $34,$00,$0B,$22
	dta $35,$00,$0B,$23
	dta $32,$00,$0A,$24
	dta $33,$00,$0A,$25
	dta $32,$00,$0A,$24
	dta $33,$00,$0A,$25

/*
	dta $01,$14,$0C,$1A
	dta $00,$15,$0C,$1B
	dta $00,$16,$0D,$1C
	dta $00,$17,$0D,$1D
	dta $00,$18,$0C,$1E
	dta $00,$19,$0C,$1F 
*/

SONGLNE_END

;-----------------

;--------------------------------------------------------------------------------------------------; 

;* Instrument Data Pointers, 5 bytes per instrument 
;* In order: Volume Envelope, Distortion/AUDCTL Envelope, Notes Table, Freqs Table, Commands Table 

pickbass_c
	dta $00,$00,$FF,$FF,$00
pulse_drum_2 
	dta $01,$01,$FF,$FF,$FF
pulse_snare 
	dta $02,$02,$FF,$FF,$FF 
shaker_cut 
	dta $03,$03,$FF,$FF,$FF
shaker 
	dta $04,$04,$FF,$FF,$FF
pickbass_a
	dta $00,$05,$FF,$FF,$00
some_kind_of_flute_no_vib 
	dta $05,$06,$FF,$FF,$01
distortion_a_lead_2_pwm
	dta $06,$07,$FF,$FF,$02 
distortion_a_lead_2_pwm_set
	dta $06,$07,$FF,$FF,$03 
distortion_a_bell_64khz_pwm_set 
	dta $07,$07,$FF,$FF,$04 
distortion_c_179_arp 
	dta $06,$08,$FF,$FF,$00 

;----------------- 

;--------------------------------------------------------------------------------------------------;

;* Row data used in patterns, indexed using the Pattern pointers 
;* The current format is not quite optimised at the moment, but it will become as flexible as possible 
;* Due to the way Patterns are constructed, "jumping" to a specific Row Number is not yet possible, unfortunately 
;* This may or may not be addressed in a future format revision, since this really isn't a big problem anyway 
;* Other than that, there is no hard limit related to the pattern length, unlike the RMT Module format 
;* The number of bytes per pattern is not technically limited, but the actual pattern length is capped at 256 Rows 
;* 256 Rows is be more than enough anyway, that was chosen only because that's also the highest number a single byte could count 

PTN_00 
	END_PATTERN 

PTN_01 
	ROW OFF 
	END_PATTERN 
	
/*	
	ROW C_0 $01 vF CMDF $07 
	ROW C_0 $03 v2
	ROW C_0 $04 v6
	ROW C_0 $02 vF	
	ROW C_0 $01 vF 
	ROW C_0 $03 v2
	ROW C_0 $02 vF
	ROW C_0 $03 v2
	ROW C_0 $01 vF 
	ROW C_0 $03 v2
	ROW C_0 $04 v6
	ROW C_0 $02 vF
	ROW C_0 $01 vF 
	ROW C_0 $03 v2
	ROW C_0 $02 vF
	ROW C_0 $03 v2
	ROW C_0 $01 vF 
	ROW C_0 $03 v2
	ROW C_0 $04 v6
	ROW C_0 $02 vF	
	ROW C_0 $01 vF 
	ROW C_0 $03 v2
	ROW C_0 $02 vF
	ROW C_0 $03 v2	
	ROW C_0 $01 vF 
	ROW C_0 $03 v2
	ROW C_0 $04 v6
	ROW C_0 $02 vF	
	ROW C_0 $01 vF 
	ROW C_0 $03 v2
	ROW C_0 $02 vF
	ROW C_0 $03 v2	
	ROW C_0 $01 vF 
	ROW C_0 $02 vF 
	ROW C_0 $04 v6
	ROW C_0 $02 vF 
	ROW C_0 $01 vF 
	ROW C_0 $03 v2
	ROW C_0 $02 vF
	ROW C_0 $03 v2
*/
	
PTN_02 
/*
	ROW F_2 $00 vF 
	ROW PAUSE+1 
	ROW F_2 $00 vF 
	ROW PAUSE+1 	
	ROW C_2 $00 vF 
	ROW PAUSE 
	ROW Cs2 $00 vF 
	ROW PAUSE+1 
	ROW Cs2 $00 vF 
	ROW PAUSE+1 	
	ROW As1 $00 vF 
	ROW PAUSE 
	ROW Ds2 $00 vF 
	ROW PAUSE+1 
	ROW Ds2 $00 vF 
	ROW PAUSE+1 	
	ROW F_2 $00 vF 
	ROW PAUSE 
	ROW Gs2 $00 vF 
	ROW PAUSE+1 
	ROW Gs2 $00 vF 
	ROW PAUSE+1 	
	ROW As2 $00 vF 
	ROW PAUSE 
	ROW C_3 $05 vF 
	ROW PAUSE+1 
	ROW Gs2 $00 vF 
	ROW PAUSE+1 	
	ROW G_2 $00 vF 
	ROW PAUSE 
*/
	
PTN_03 
/*
	ROW F_2 $00 vF 
	ROW PAUSE+1 
	ROW F_2 $00 vF 
	ROW PAUSE+1 	
	ROW C_2 $00 vF 
	ROW PAUSE 
	ROW Cs2 $00 vF 
	ROW PAUSE+1 
	ROW Cs2 $00 vF 
	ROW PAUSE+1 	
	ROW As1 $00 vF 
	ROW PAUSE 
	ROW Ds2 $00 vF 
	ROW PAUSE+1 
	ROW Ds2 $00 vF 
	ROW PAUSE+1 	
	ROW F_2 $00 vF 
	ROW PAUSE 
	ROW Gs2 $00 vF 
	ROW PAUSE+1 
	ROW Gs2 $00 vF 
	ROW PAUSE+1 	
	ROW As2 $00 vF 
	ROW PAUSE 
	ROW G_2 $00 vF 
	ROW PAUSE+1 
	ROW Gs2 $00 vF 
	ROW PAUSE+1 	
	ROW G_2 $00 vF 
	ROW PAUSE 
*/
	
PTN_04
	ROW C_3 $06 vF CMDF $09 CMD0 $00 CMD4 $00
	ROW As3 $06 vF
	ROW A_3 $06 vF 
	ROW ___ ___ v6 
	ROW F_3 $06 vF 
	ROW PAUSE+1
	ROW ___ ___ v6 
	ROW G_3 $06 vF 
	ROW E_3 $06 vF
	ROW D_3 $06 vF
	ROW ___ ___ v6 
	ROW C_3 $06 vF 
	ROW D_3 $06 vF
	ROW PAUSE+1
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW C_3 $06 vF 
	ROW ___ ___ v6
	ROW D_3 $06 vF 
	ROW ___ ___ v6
	ROW F_3 $06 vF 
	ROW ___ ___ v6
	ROW AS3 $06 vF 
	ROW ___ ___ v6
	ROW A_3 $06 vF
	ROW G_3 $06 vF
	ROW PAUSE+1
	ROW ___ ___ v6
	ROW ___ ___ v2
	
PTN_05
	ROW C_3 $06 vF 
	ROW As3 $06 vF
	ROW A_3 $06 vF 
	ROW ___ ___ v6 
	ROW F_3 $06 vF 
	ROW PAUSE+1
	ROW ___ ___ v6 
	ROW G_3 $06 vF 
	ROW E_3 $06 vF
	ROW D_3 $06 vF
	ROW ___ ___ v6 
	ROW C_3 $06 vF 
	ROW D_3 $06 vF
	ROW PAUSE+1
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW F_3 $06 vF 
	ROW G_3 $06 vF 
	ROW A_3 $06 vF 
	ROW ___ ___ v6
	ROW As3 $06 vF 
	ROW ___ ___ v6
	ROW C_4 $06 vF 
	ROW ___ ___ v6
	ROW D_4 $06 vF 
	ROW ___ ___ v6
	ROW As3 $06 vF 
	ROW A_3 $06 vF 
	ROW PAUSE 
	ROW ___ ___ v6
	
PTN_06 
	ROW G_3 $06 vF 
	ROW PAUSE+3 
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW PAUSE 	
	ROW E_3 $06 vF 
	ROW ___ ___ v6	
	ROW F_3 $06 vF 
	ROW E_3 $06 vF 
	ROW ___ ___ v6
	ROW D_3 $06 vF 
	ROW C_3 $06 vF 
	ROW ___ ___ v6	
	ROW D_3 $06 vF 
	ROW PAUSE+3 
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW PAUSE 
	ROW G_3 $06 vF 
	ROW A_3 $06 vF 
	ROW As3 $06 vF 
	ROW C_4 $06 vF 
	ROW ___ ___ v6
	ROW As3 $06 vF 
	ROW A_3 $06 vF 
	ROW ___ ___ v6
	
PTN_07
	ROW G_3 $06 vF 
	ROW PAUSE+3 
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW PAUSE 	
	ROW E_3 $06 vF 
	ROW ___ ___ v6	
	ROW F_3 $06 vF 
	ROW E_3 $06 vF 
	ROW ___ ___ v6
	ROW D_3 $06 vF 
	ROW C_3 $06 vF 
	ROW ___ ___ v6	
	ROW D_3 $06 vF 
	ROW PAUSE+3 
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW PAUSE 
	ROW G_3 $06 vF 
	ROW A_3 $06 vF 
	ROW As3 $06 vF 
	ROW G_3 $06 vF 
	ROW ___ ___ v6
	ROW A_3 $06 vF 
	ROW ___ ___ v6
	ROW F_3 $06 vF 

PTN_08
	ROW C_3 $06 vF 
	ROW As3 $06 vF
	ROW A_3 $06 vF 
	ROW ___ ___ v6 
	ROW F_3 $06 vF 
	ROW PAUSE
	ROW ___ ___ v6
	ROW ___ ___ v2 
	ROW G_3 $06 vF 
	ROW E_3 $06 vF
	ROW D_3 $06 vF
	ROW ___ ___ v6 
	ROW C_3 $06 vF 
	ROW D_3 $06 vF
	ROW PAUSE+1
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW C_3 $06 vF 
	ROW ___ ___ v6
	ROW E_3 $06 vF 
	ROW F_3 $06 vF 
	ROW PAUSE
	ROW ___ ___ v6 
	ROW E_3 $06 vF 
	ROW ___ ___ v6 
	ROW D_3 $06 vF
	ROW PAUSE+2
	ROW ___ ___ v6
	ROW ___ ___ v2

PTN_09
	ROW C_3 $06 vF 
	ROW ___ ___ v6
	ROW As3 $06 vF 
	ROW ___ ___ v6
	ROW C_4 $06 vF 
	ROW As3 $06 vF 
	ROW PAUSE 
	ROW ___ ___ v6
	ROW A_3 $06 vF 
	ROW PAUSE 
	ROW ___ ___ v6	
	ROW G_3 $06 vF 
	ROW ___ ___ v6
	ROW F_3 $06 vF 
	ROW ___ ___ v6	
	ROW A_3 $06 vF 
	ROW G_3 $06 vF 
	ROW PAUSE+6 
	ROW ___ ___ v6
	ROW PAUSE+4
	ROW ___ ___ v2
	END_PATTERN 
	
PTN_0A
	ROW C_2 $00 vF 
	ROW PAUSE+1
	ROW C_2 $00 vF 
	ROW PAUSE+1
	ROW C_2 $00 vF 
	ROW PAUSE
	ROW D_2 $00 vF 
	ROW PAUSE+1
	ROW As1 $00 vF 
	ROW PAUSE+1
	ROW A_1 $00 vF 
	ROW PAUSE
	ROW G_1 $00 vF 
	ROW PAUSE+1
	ROW G_1 $00 vF 
	ROW PAUSE+1
	ROW F_1 $00 vF 
	ROW PAUSE
	ROW As1 $00 vF 
	ROW PAUSE+1
	ROW C_2 $00 vF 
	ROW PAUSE+1
	ROW D_2 $00 vF 
	END_PATTERN

PTN_0B
	ROW C_2 $00 vF 
	ROW PAUSE+1
	ROW C_2 $00 vF 
	ROW PAUSE+1
	ROW C_2 $00 vF 
	ROW PAUSE
	ROW F_2 $00 vF 
	ROW PAUSE+1
	ROW As2 $00 vF 
	ROW PAUSE+1
	ROW A_2 $00 vF 
	ROW PAUSE
	ROW G_2 $00 vF 
	ROW PAUSE+1
	ROW F_2 $00 vF 
	ROW PAUSE+1
	ROW E_2 $00 vF 
	ROW PAUSE
	ROW D_2 $00 vF 
	ROW PAUSE+1
	ROW F_2 $00 vF 
	ROW PAUSE+1
	ROW E_2 $00 vF 
	END_PATTERN
	
PTN_0C
	ROW E_2 $00 vF 
	ROW PAUSE+1
	ROW E_2 $00 vF 
	ROW PAUSE+1
	ROW E_2 $00 vF 
	ROW PAUSE
	ROW Fs2 $00 vF 
	ROW PAUSE+1
	ROW D_2 $00 vF 
	ROW PAUSE+1
	ROW Cs2 $00 vF 
	ROW PAUSE
	ROW B_1 $00 vF 
	ROW PAUSE+1
	ROW B_1 $00 vF 
	ROW PAUSE+1
	ROW A_1 $00 vF 
	ROW PAUSE
	ROW D_2 $00 vF 
	ROW PAUSE+1
	ROW E_2 $00 vF 
	ROW PAUSE+1
	ROW Fs2 $00 vF 
	END_PATTERN

PTN_0D 	
	ROW E_2 $00 vF 
	ROW PAUSE+1
	ROW E_2 $00 vF 
	ROW PAUSE+1
	ROW E_2 $00 vF 
	ROW PAUSE
	ROW A_2 $00 vF 
	ROW PAUSE+1
	ROW D_3 $05 vF 
	ROW PAUSE+1
	ROW Cs3 $05 vF 
	ROW PAUSE
	ROW B_2 $00 vF 
	ROW PAUSE+1
	ROW A_2 $00 vF 
	ROW PAUSE+1
	ROW Gs2 $00 vF 
	ROW PAUSE
	ROW Fs2 $00 vF 
	ROW PAUSE+1
	ROW A_2 $00 vF 
	ROW PAUSE+1
	ROW Gs2 $00 vF 
	END_PATTERN

PTN_0E
	ROW E_3 $06 vF 
	ROW D_4 $06 vF
	ROW Cs4 $06 vF 
	ROW ___ ___ v6 
	ROW A_3 $06 vF 
	ROW PAUSE+1
	ROW ___ ___ v6 
	ROW B_3 $06 vF 
	ROW Gs3 $06 vF
	ROW Fs3 $06 vF
	ROW ___ ___ v6 
	ROW E_3 $06 vF 
	ROW Fs3 $06 vF
	ROW PAUSE+1
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW E_3 $06 vF 
	ROW ___ ___ v6
	ROW Fs3 $06 vF 
	ROW ___ ___ v6
	ROW A_3 $06 vF 
	ROW ___ ___ v6
	ROW D_4 $06 vF 
	ROW ___ ___ v6
	ROW Cs4 $06 vF
	ROW B_3 $06 vF
	ROW PAUSE+1
	ROW ___ ___ v6
	ROW ___ ___ v2
	
PTN_0F
	ROW E_3 $06 vF 
	ROW D_4 $06 vF
	ROW Cs4 $06 vF 
	ROW ___ ___ v6 
	ROW A_3 $06 vF 
	ROW PAUSE+1
	ROW ___ ___ v6 
	ROW B_3 $06 vF 
	ROW Gs3 $06 vF
	ROW Fs3 $06 vF
	ROW ___ ___ v6 
	ROW E_3 $06 vF 
	ROW Fs3 $06 vF
	ROW PAUSE+1
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW A_3 $06 vF 
	ROW B_3 $06 vF 
	ROW Cs4 $06 vF 
	ROW ___ ___ v6
	ROW D_4 $06 vF 
	ROW ___ ___ v6
	ROW E_4 $06 vF 
	ROW ___ ___ v6
	ROW Fs4 $06 vF 
	ROW ___ ___ v6
	ROW D_4 $06 vF 
	ROW Cs4 $06 vF 
	ROW PAUSE 
	ROW ___ ___ v6
	
PTN_10 
	ROW B_3 $06 vF 
	ROW PAUSE+3 
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW PAUSE 	
	ROW Gs3 $06 vF 
	ROW ___ ___ v6	
	ROW A_3 $06 vF 
	ROW Gs3 $06 vF 
	ROW ___ ___ v6
	ROW Fs3 $06 vF 
	ROW E_3 $06 vF 
	ROW ___ ___ v6	
	ROW Fs3 $06 vF 
	ROW PAUSE+3 
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW PAUSE 
	ROW B_3 $06 vF 
	ROW Cs4 $06 vF 
	ROW D_4 $06 vF 
	ROW B_3 $06 vF 
	ROW ___ ___ v6
	ROW Cs4 $06 vF 
	ROW ___ ___ v6
	ROW A_3 $06 vF 
	
PTN_11
	ROW B_3 $06 vF 
	ROW PAUSE+3 
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW PAUSE 	
	ROW Gs3 $06 vF 
	ROW ___ ___ v6	
	ROW A_3 $06 vF 
	ROW Gs3 $06 vF 
	ROW ___ ___ v6
	ROW Fs3 $06 vF 
	ROW E_3 $06 vF 
	ROW ___ ___ v6	
	ROW Fs3 $06 vF 
	ROW PAUSE+3 
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW PAUSE 
	ROW B_3 $06 vF 
	ROW Cs4 $06 vF 
	ROW D_4 $06 vF 
	ROW E_4 $06 vF 
	ROW ___ ___ v6
	ROW Cs4 $06 vF 
	ROW B_3 $06 vF 
	ROW ___ ___ v6

PTN_12
	ROW E_3 $06 vF 
	ROW D_4 $06 vF
	ROW Cs4 $06 vF 
	ROW ___ ___ v6 
	ROW A_3 $06 vF 
	ROW PAUSE
	ROW ___ ___ v6
	ROW ___ ___ v2 
	ROW B_3 $06 vF 
	ROW Gs3 $06 vF
	ROW Fs3 $06 vF
	ROW ___ ___ v6 
	ROW E_3 $06 vF 
	ROW Fs3 $06 vF
	ROW PAUSE+1
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW E_3 $06 vF 
	ROW ___ ___ v6
	ROW Gs3 $06 vF 
	ROW A_3 $06 vF 
	ROW PAUSE
	ROW ___ ___ v6 
	ROW Gs3 $06 vF 
	ROW ___ ___ v6 
	ROW Fs3 $06 vF
	ROW PAUSE+2
	ROW ___ ___ v6
	ROW ___ ___ v2

PTN_13
	ROW E_3 $06 vF 
	ROW ___ ___ v6
	ROW D_4 $06 vF 
	ROW ___ ___ v6
	ROW E_4 $06 vF 
	ROW D_4 $06 vF 
	ROW PAUSE 
	ROW ___ ___ v6
	ROW Cs4 $06 vF 
	ROW PAUSE 
	ROW ___ ___ v6	
	ROW B_3 $06 vF 
	ROW ___ ___ v6
	ROW A_3 $06 vF 
	ROW ___ ___ v6	
	ROW Cs4 $06 vF 
	ROW B_3 $06 vF 
	ROW PAUSE+6 
	ROW ___ ___ v6
	ROW PAUSE+4
	ROW ___ ___ v2
	END_PATTERN 

PTN_14
	ROW E_3 $07 vF CMD4 $02
	ROW D_4 $07 vF
	ROW Cs4 $07 vF 
	ROW ___ ___ v6 
	ROW A_3 $07 vF 
	ROW PAUSE+1
	ROW ___ ___ v6 
	ROW B_3 $07 vF 
	ROW Gs3 $07 vF
	ROW Fs3 $07 vF
	ROW ___ ___ v6 
	ROW E_3 $07 vF 
	ROW Fs3 $07 vF
	ROW PAUSE+1
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW E_3 $07 vF 
	ROW ___ ___ v6
	ROW Fs3 $07 vF 
	ROW ___ ___ v6
	ROW A_3 $07 vF 
	ROW ___ ___ v6
	ROW D_4 $07 vF 
	ROW ___ ___ v6
	ROW Cs4 $07 vF
	ROW B_3 $07 vF
	ROW PAUSE+1
	ROW ___ ___ v6
	ROW ___ ___ v2
	
PTN_15
	ROW E_3 $07 vF 
	ROW D_4 $07 vF
	ROW Cs4 $07 vF 
	ROW ___ ___ v6 
	ROW A_3 $07 vF 
	ROW PAUSE+1
	ROW ___ ___ v6 
	ROW B_3 $07 vF 
	ROW Gs3 $07 vF
	ROW Fs3 $07 vF
	ROW ___ ___ v6 
	ROW E_3 $07 vF 
	ROW Fs3 $07 vF
	ROW PAUSE+1
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW A_3 $07 vF 
	ROW B_3 $07 vF 
	ROW Cs4 $07 vF 
	ROW ___ ___ v6
	ROW D_4 $07 vF 
	ROW ___ ___ v6
	ROW E_4 $07 vF 
	ROW ___ ___ v6
	ROW Fs4 $07 vF 
	ROW ___ ___ v6
	ROW D_4 $07 vF 
	ROW Cs4 $07 vF 
	ROW PAUSE 
	ROW ___ ___ v6
	
PTN_16
	ROW B_3 $07 vF 
	ROW PAUSE+3 
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW PAUSE 	
	ROW Gs3 $07 vF 
	ROW ___ ___ v6	
	ROW A_3 $07 vF 
	ROW Gs3 $07 vF 
	ROW ___ ___ v6
	ROW Fs3 $07 vF 
	ROW E_3 $07 vF 
	ROW ___ ___ v6	
	ROW Fs3 $07 vF 
	ROW PAUSE+3 
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW PAUSE 
	ROW B_3 $07 vF 
	ROW Cs4 $07 vF 
	ROW D_4 $07 vF 
	ROW B_3 $07 vF 
	ROW ___ ___ v6
	ROW Cs4 $07 vF 
	ROW ___ ___ v6
	ROW A_3 $07 vF 
	
PTN_17
	ROW B_3 $07 vF 
	ROW PAUSE+3 
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW PAUSE 	
	ROW Gs3 $07 vF 
	ROW ___ ___ v6	
	ROW A_3 $07 vF 
	ROW Gs3 $07 vF 
	ROW ___ ___ v6
	ROW Fs3 $07 vF 
	ROW E_3 $07 vF 
	ROW ___ ___ v6	
	ROW Fs3 $07 vF 
	ROW PAUSE+3 
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW PAUSE 
	ROW B_3 $07 vF 
	ROW Cs4 $07 vF 
	ROW D_4 $07 vF 
	ROW E_4 $07 vF 
	ROW ___ ___ v6
	ROW Cs4 $07 vF 
	ROW B_3 $07 vF 
	ROW ___ ___ v6

PTN_18
	ROW E_3 $07 vF 
	ROW D_4 $07 vF
	ROW Cs4 $07 vF 
	ROW ___ ___ v6 
	ROW A_3 $07 vF 
	ROW PAUSE
	ROW ___ ___ v6
	ROW ___ ___ v2 
	ROW B_3 $07 vF 
	ROW Gs3 $07 vF
	ROW Fs3 $07 vF
	ROW ___ ___ v6 
	ROW E_3 $07 vF 
	ROW Fs3 $07 vF
	ROW PAUSE+1
	ROW ___ ___ v6
	ROW ___ ___ v2
	ROW E_3 $07 vF 
	ROW ___ ___ v6
	ROW Gs3 $07 vF 
	ROW A_3 $07 vF 
	ROW PAUSE
	ROW ___ ___ v6 
	ROW Gs3 $07 vF 
	ROW ___ ___ v6 
	ROW Fs3 $07 vF
	ROW PAUSE+2
	ROW ___ ___ v6
	ROW ___ ___ v2

PTN_19
	ROW E_3 $07 vF 
	ROW ___ ___ v6
	ROW D_4 $07 vF 
	ROW ___ ___ v6
	ROW E_4 $07 vF 
	ROW D_4 $07 vF 
	ROW PAUSE 
	ROW ___ ___ v6
	ROW Cs4 $07 vF 
	ROW PAUSE 
	ROW ___ ___ v6	
	ROW B_3 $07 vF 
	ROW ___ ___ v6
	ROW A_3 $07 vF 
	ROW ___ ___ v6	
	ROW Cs4 $07 vF 
	ROW B_3 $07 vF 
	ROW PAUSE+6 
	ROW ___ ___ v6
	ROW PAUSE+4
	ROW ___ ___ v2
	END_PATTERN 

PTN_1A
	ROW E_3 $09 v8 CMD4 $02
	ROW D_4 $09 v8
	ROW Cs4 $09 v8 
	ROW ___ ___ v3 
	ROW A_3 $09 v8 
	ROW PAUSE+1
	ROW ___ ___ v3 
	ROW B_3 $09 v8 
	ROW Gs3 $09 v8
	ROW Fs3 $09 v8
	ROW ___ ___ v3 
	ROW E_3 $09 v8 
	ROW Fs3 $09 v8
	ROW PAUSE+1
	ROW ___ ___ v3
	ROW ___ ___ v1
	ROW E_3 $09 v8 
	ROW ___ ___ v3
	ROW Fs3 $09 v8 
	ROW ___ ___ v3
	ROW A_3 $09 v8 
	ROW ___ ___ v3
	ROW D_4 $09 v8 
	ROW ___ ___ v3
	ROW Cs4 $09 v8
	ROW B_3 $09 v8
	ROW PAUSE+1
	ROW ___ ___ v3
	ROW ___ ___ v1
	
PTN_1B
	ROW E_3 $09 v8 
	ROW D_4 $09 v8
	ROW Cs4 $09 v8 
	ROW ___ ___ v3 
	ROW A_3 $09 v8 
	ROW PAUSE+1
	ROW ___ ___ v3 
	ROW B_3 $09 v8 
	ROW Gs3 $09 v8
	ROW Fs3 $09 v8
	ROW ___ ___ v3 
	ROW E_3 $09 v8 
	ROW Fs3 $09 v8
	ROW PAUSE+1
	ROW ___ ___ v3
	ROW ___ ___ v1
	ROW A_3 $09 v8 
	ROW B_3 $09 v8 
	ROW Cs4 $09 v8 
	ROW ___ ___ v3
	ROW D_4 $09 v8 
	ROW ___ ___ v3
	ROW E_4 $09 v8 
	ROW ___ ___ v3
	ROW Fs4 $09 v8 
	ROW ___ ___ v3
	ROW D_4 $09 v8 
	ROW Cs4 $09 v8 
	ROW PAUSE 
	ROW ___ ___ v3
	
PTN_1C
	ROW B_3 $09 v8 
	ROW PAUSE+3 
	ROW ___ ___ v3
	ROW ___ ___ v1
	ROW PAUSE 	
	ROW Gs3 $09 v8 
	ROW ___ ___ v3	
	ROW A_3 $09 v8 
	ROW Gs3 $09 v8 
	ROW ___ ___ v3
	ROW Fs3 $09 v8 
	ROW E_3 $09 v8 
	ROW ___ ___ v3	
	ROW Fs3 $09 v8 
	ROW PAUSE+3 
	ROW ___ ___ v3
	ROW ___ ___ v1
	ROW PAUSE 
	ROW B_3 $09 v8 
	ROW Cs4 $09 v8 
	ROW D_4 $09 v8 
	ROW B_3 $09 v8 
	ROW ___ ___ v3
	ROW Cs4 $09 v8 
	ROW ___ ___ v3
	ROW A_3 $09 v8 
	
PTN_1D
	ROW B_3 $09 v8 
	ROW PAUSE+3 
	ROW ___ ___ v3
	ROW ___ ___ v1
	ROW PAUSE 	
	ROW Gs3 $09 v8 
	ROW ___ ___ v3	
	ROW A_3 $09 v8 
	ROW Gs3 $09 v8 
	ROW ___ ___ v3
	ROW Fs3 $09 v8 
	ROW E_3 $09 v8 
	ROW ___ ___ v3	
	ROW Fs3 $09 v8 
	ROW PAUSE+3 
	ROW ___ ___ v3
	ROW ___ ___ v1
	ROW PAUSE 
	ROW B_3 $09 v8 
	ROW Cs4 $09 v8 
	ROW D_4 $09 v8 
	ROW E_4 $09 v8 
	ROW ___ ___ v3
	ROW Cs4 $09 v8 
	ROW B_3 $09 v8 
	ROW ___ ___ v3

PTN_1E
	ROW E_3 $09 v8 
	ROW D_4 $09 v8
	ROW Cs4 $09 v8 
	ROW ___ ___ v3 
	ROW A_3 $09 v8 
	ROW PAUSE
	ROW ___ ___ v3
	ROW ___ ___ v1 
	ROW B_3 $09 v8 
	ROW Gs3 $09 v8
	ROW Fs3 $09 v8
	ROW ___ ___ v3 
	ROW E_3 $09 v8 
	ROW Fs3 $09 v8
	ROW PAUSE+1
	ROW ___ ___ v3
	ROW ___ ___ v1
	ROW E_3 $09 v8 
	ROW ___ ___ v3
	ROW Gs3 $09 v8 
	ROW A_3 $09 v8 
	ROW PAUSE
	ROW ___ ___ v3 
	ROW Gs3 $09 v8 
	ROW ___ ___ v3 
	ROW Fs3 $09 v8
	ROW PAUSE+2
	ROW ___ ___ v3
	ROW ___ ___ v1

PTN_1F
	ROW E_3 $09 v8 
	ROW ___ ___ v3
	ROW D_4 $09 v8 
	ROW ___ ___ v3
	ROW E_4 $09 v8 
	ROW D_4 $09 v8 
	ROW PAUSE 
	ROW ___ ___ v3
	ROW Cs4 $09 v8 
	ROW PAUSE 
	ROW ___ ___ v3	
	ROW B_3 $09 v8 
	ROW ___ ___ v3
	ROW A_3 $09 v8 
	ROW ___ ___ v3	
	ROW Cs4 $09 v8 
	ROW B_3 $09 v8 
	ROW PAUSE+6 
	ROW ___ ___ v3
	ROW PAUSE+4
	ROW ___ ___ v1
	END_PATTERN 
	
PTN_20
	ROW C_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW C_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW F_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW F_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW G_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW G_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW C_3 $08 vF CMD4 $00
	ROW D_3 $08 vF 
	ROW C_3 $08 v6 CMD4 $02
	ROW D_3 $08 v6
	ROW C_3 $08 v2 
	ROW D_3 $08 v2	
	ROW C_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW C_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW F_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW F_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW A_3 $08 vF CMD4 $00
	ROW G_3 $08 vF 
	ROW A_3 $08 v6 CMD4 $02
	ROW G_3 $08 v6
	ROW A_3 $08 v2 
	ROW G_3 $08 v2	

PTN_21
	ROW C_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW C_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW F_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW F_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW G_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW G_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW C_3 $08 vF CMD4 $00
	ROW D_3 $08 vF 
	ROW C_3 $08 v6 CMD4 $02
	ROW D_3 $08 v6
	ROW C_3 $08 v2 
	ROW D_3 $08 v2	
	ROW F_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW F_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW As3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW As3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW As3 $08 v2 
	ROW PAUSE
	ROW As3 $08 vF CMD4 $00
	ROW A_3 $08 vF 
	ROW As3 $08 v6 CMD4 $02
	ROW A_3 $08 v6

PTN_22 
	ROW G_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW G_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW G_3 $08 v4 
	ROW PAUSE 
	ROW G_3 $08 v2 
	ROW PAUSE 
	ROW E_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW F_3 $08 vF 
	ROW PAUSE 
	ROW F_3 $08 v6 CMD4 $02
	ROW D_3 $08 vF CMD4 $00
	ROW C_3 $08 vF 
	ROW D_3 $08 v6 
	ROW D_3 $08 vF 
	ROW D_3 $08 v2 
	ROW D_3 $08 v6 CMD4 $02 
	ROW PAUSE 
	ROW D_3 $08 v4 
	ROW PAUSE 
	ROW D_3 $08 v2 
	ROW PAUSE 	
	ROW G_3 $08 vF CMD4 $00
	ROW PAUSE
	ROW As3 $08 vF
	ROW C_4 $08 vF
	ROW As3 $08 v6
	ROW As3 $08 vF
	ROW A_3 $08 vF
	ROW As3 $08 v6 
	
PTN_23
	ROW G_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW G_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW G_3 $08 v4 
	ROW PAUSE 
	ROW G_3 $08 v2 
	ROW PAUSE 
	ROW E_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW F_3 $08 vF 
	ROW PAUSE 
	ROW F_3 $08 v6 CMD4 $02
	ROW D_3 $08 vF CMD4 $00
	ROW C_3 $08 vF 
	ROW D_3 $08 v6 
	ROW D_3 $08 vF 
	ROW D_3 $08 v2 
	ROW D_3 $08 v6 CMD4 $02 
	ROW PAUSE 
	ROW D_3 $08 v4 
	ROW PAUSE 
	ROW D_3 $08 v2 
	ROW PAUSE 	
	ROW G_3 $08 vF CMD4 $00
	ROW PAUSE
	ROW As3 $08 vF
	ROW G_3 $08 vF
	ROW As3 $08 v6
	ROW A_3 $08 vF
	ROW As3 $08 v2
	ROW F_3 $08 vF 

PTN_24
	ROW C_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW C_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW F_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW F_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW G_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW D_3 $08 vF 
	ROW PAUSE 
	ROW C_3 $08 vF CMD4 $00
	ROW D_3 $08 vF 
	ROW C_3 $08 v6 CMD4 $02
	ROW D_3 $08 v6
	ROW C_3 $08 v2 
	ROW D_3 $08 v2	
	ROW C_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW C_3 $08 v6 CMD4 $02
	ROW F_3 $08 vF CMD4 $00
	ROW C_3 $08 v2
	ROW F_3 $08 v6 CMD4 $02
	ROW E_3 $08 vF CMD4 $00
	ROW F_3 $08 v2
	ROW D_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW D_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW D_3 $08 v2 
	ROW PAUSE 

PTN_25
	ROW C_3 $08 vF CMD4 $00
	ROW PAUSE
	ROW As3 $08 vF 
	ROW PAUSE 
	ROW C_4 $08 vF
	ROW As3 $08 vF 
	ROW C_4 $08 v6 CMD4 $02
	ROW As3 $08 v6 
	ROW A_3 $08 vF CMD4 $00
	ROW As3 $08 v2 
	ROW A_3 $08 v6 CMD4 $02
	ROW G_3 $08 vF CMD4 $00 
	ROW A_3 $08 v2 
	ROW F_3 $08 vF
	ROW PAUSE 
	ROW A_3 $08 vF
	ROW G_3 $08 vF
	ROW A_3 $08 v6 CMD4 $02 
	ROW G_3 $08 v6
	ROW A_3 $08 v2
	ROW G_3 $08 v2
	ROW A_3 $08 v1
	ROW G_3 $08 v1
	ROW A_3 $08 v4
	ROW G_3 $08 v4
	ROW A_3 $08 v2
	ROW G_3 $08 v2
	ROW A_3 $08 v1
	ROW G_3 $08 v1
	END_PATTERN 

PTN_26
	ROW E_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW E_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW A_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW A_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW B_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW B_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW E_3 $08 vF CMD4 $00
	ROW Fs3 $08 vF 
	ROW E_3 $08 v6 CMD4 $02
	ROW Fs3 $08 v6
	ROW E_3 $08 v2 
	ROW Fs3 $08 v2	
	ROW E_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW E_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW A_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW A_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW Cs4 $08 vF CMD4 $00
	ROW B_3 $08 vF 
	ROW Cs4 $08 v6 CMD4 $02
	ROW B_3 $08 v6
	ROW Cs4 $08 v2 
	ROW B_3 $08 v2	

PTN_27
	ROW E_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW E_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW A_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW A_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW B_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW B_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW E_3 $08 vF CMD4 $00
	ROW Fs3 $08 vF 
	ROW E_3 $08 v6 CMD4 $02
	ROW Fs3 $08 v6
	ROW E_3 $08 v2 
	ROW Fs3 $08 v2	
	ROW A_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW A_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW D_4 $08 vF CMD4 $00
	ROW PAUSE 
	ROW D_4 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW D_4 $08 v2 
	ROW PAUSE
	ROW D_4 $08 vF CMD4 $00
	ROW Cs4 $08 vF 
	ROW D_4 $08 v6 CMD4 $02
	ROW Cs4 $08 v6

PTN_28 
	ROW B_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW B_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW B_3 $08 v4 
	ROW PAUSE 
	ROW B_3 $08 v2 
	ROW PAUSE 
	ROW Gs3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW A_3 $08 vF 
	ROW PAUSE 
	ROW A_3 $08 v6 CMD4 $02
	ROW Fs3 $08 vF CMD4 $00
	ROW E_3 $08 vF 
	ROW Fs3 $08 v6 
	ROW Fs3 $08 vF 
	ROW Fs3 $08 v2 
	ROW Fs3 $08 v6 CMD4 $02 
	ROW PAUSE 
	ROW Fs3 $08 v4 
	ROW PAUSE 
	ROW Fs3 $08 v2 
	ROW PAUSE 	
	ROW B_3 $08 vF CMD4 $00
	ROW PAUSE
	ROW D_4 $08 vF
	ROW B_3 $08 vF
	ROW D_4 $08 v6
	ROW Cs4 $08 vF
	ROW D_4 $08 v2
	ROW A_3 $08 vF 
	
PTN_29
	ROW B_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW B_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW B_3 $08 v4 
	ROW PAUSE 
	ROW B_3 $08 v2 
	ROW PAUSE 
	ROW Gs3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW A_3 $08 vF 
	ROW PAUSE 
	ROW A_3 $08 v6 CMD4 $02
	ROW Fs3 $08 vF CMD4 $00
	ROW E_3 $08 vF 
	ROW Fs3 $08 v6 
	ROW Fs3 $08 vF 
	ROW Fs3 $08 v2 
	ROW Fs3 $08 v6 CMD4 $02 
	ROW PAUSE 
	ROW Fs3 $08 v4 
	ROW PAUSE 
	ROW Fs3 $08 v2 
	ROW PAUSE 	
	ROW B_3 $08 vF CMD4 $00
	ROW PAUSE
	ROW D_4 $08 vF
	ROW E_4 $08 vF 
	ROW D_4 $08 v6 
	ROW Cs4 $08 vF
	ROW B_3 $08 vF
	ROW Cs4 $08 v6

PTN_2A
	ROW E_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW E_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW A_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW A_3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW B_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW Fs3 $08 vF 
	ROW PAUSE 
	ROW E_3 $08 vF CMD4 $00
	ROW Fs3 $08 vF 
	ROW E_3 $08 v6 CMD4 $02
	ROW Fs3 $08 v6
	ROW E_3 $08 v2 
	ROW Fs3 $08 v2	
	ROW E_3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW E_3 $08 v6 CMD4 $02
	ROW A_3 $08 vF CMD4 $00
	ROW E_3 $08 v2
	ROW A_3 $08 v6 CMD4 $02
	ROW Gs3 $08 vF CMD4 $00
	ROW A_3 $08 v2
	ROW Fs3 $08 vF CMD4 $00
	ROW PAUSE 
	ROW Fs3 $08 v6 CMD4 $02
	ROW PAUSE 
	ROW Fs3 $08 v2 
	ROW PAUSE 

PTN_2B
	ROW E_3 $08 vF CMD4 $00
	ROW PAUSE
	ROW D_4 $08 vF 
	ROW PAUSE 
	ROW E_4 $08 vF
	ROW D_4 $08 vF 
	ROW E_4 $08 v6 CMD4 $02
	ROW D_4 $08 v6 
	ROW Cs4 $08 vF CMD4 $00
	ROW D_4 $08 v2 
	ROW Cs4 $08 v6 CMD4 $02
	ROW B_3 $08 vF CMD4 $00 
	ROW Cs4 $08 v2 
	ROW A_3 $08 vF
	ROW PAUSE 
	ROW Cs4 $08 vF
	ROW B_3 $08 vF
	ROW Cs4 $08 v6 CMD4 $02 
	ROW B_3 $08 v6
	ROW Cs4 $08 v2
	ROW B_3 $08 v2
	ROW Cs4 $08 v1
	ROW B_3 $08 v1
	ROW Cs4 $08 v4
	ROW B_3 $08 v4
	ROW Cs4 $08 v2
	ROW B_3 $08 v2
	ROW Cs4 $08 v1
	ROW B_3 $08 v1
	END_PATTERN

PTN_2C
	ROW E_3 $07 vA CMD4 $00
	ROW PAUSE 
	ROW E_3 $07 v3 CMD4 $02
	ROW PAUSE 
	ROW A_3 $07 vA CMD4 $00
	ROW PAUSE 
	ROW A_3 $07 v3 CMD4 $02
	ROW PAUSE 
	ROW B_3 $07 vA CMD4 $00
	ROW PAUSE 
	ROW B_3 $07 v3 CMD4 $02
	ROW PAUSE 
	ROW E_3 $07 vA CMD4 $00
	ROW Fs3 $07 vA 
	ROW E_3 $07 v3 CMD4 $02
	ROW Fs3 $07 v3
	ROW E_3 $07 v1 
	ROW Fs3 $07 v1	
	ROW E_3 $07 vA CMD4 $00
	ROW PAUSE 
	ROW E_3 $07 v3 CMD4 $02
	ROW PAUSE 
	ROW A_3 $07 vA CMD4 $00
	ROW PAUSE 
	ROW A_3 $07 v3 CMD4 $02
	ROW PAUSE 
	ROW Cs4 $07 vA CMD4 $00
	ROW B_3 $07 vA 
	ROW Cs4 $07 v3 CMD4 $02
	ROW B_3 $07 v3
	ROW Cs4 $07 v1 
	ROW B_3 $07 v1	

PTN_2D
	ROW E_3 $07 vA CMD4 $00
	ROW PAUSE 
	ROW E_3 $07 v3 CMD4 $02
	ROW PAUSE 
	ROW A_3 $07 vA CMD4 $00
	ROW PAUSE 
	ROW A_3 $07 v3 CMD4 $02
	ROW PAUSE 
	ROW B_3 $07 vA CMD4 $00
	ROW PAUSE 
	ROW B_3 $07 v3 CMD4 $02
	ROW PAUSE 
	ROW E_3 $07 vA CMD4 $00
	ROW Fs3 $07 vA 
	ROW E_3 $07 v3 CMD4 $02
	ROW Fs3 $07 v3
	ROW E_3 $07 v1 
	ROW Fs3 $07 v1	
	ROW A_3 $07 vA CMD4 $00
	ROW PAUSE 
	ROW A_3 $07 v3 CMD4 $02
	ROW PAUSE 
	ROW D_4 $07 vA CMD4 $00
	ROW PAUSE 
	ROW D_4 $07 v3 CMD4 $02
	ROW PAUSE 
	ROW D_4 $07 v1 
	ROW PAUSE
	ROW D_4 $07 vA CMD4 $00
	ROW Cs4 $07 vA 
	ROW D_4 $07 v3 CMD4 $02
	ROW Cs4 $07 v3

PTN_2E 
	ROW B_3 $07 vA CMD4 $00
	ROW PAUSE 
	ROW B_3 $07 v3 CMD4 $02
	ROW PAUSE 
	ROW B_3 $07 v2 
	ROW PAUSE 
	ROW B_3 $07 v1 
	ROW PAUSE 
	ROW Gs3 $07 vA CMD4 $00
	ROW PAUSE 
	ROW A_3 $07 vA 
	ROW PAUSE 
	ROW A_3 $07 v3 CMD4 $02
	ROW Fs3 $07 vA CMD4 $00
	ROW E_3 $07 vA 
	ROW Fs3 $07 v3 
	ROW Fs3 $07 vA 
	ROW Fs3 $07 v1 
	ROW Fs3 $07 v3 CMD4 $02 
	ROW PAUSE 
	ROW Fs3 $07 v2 
	ROW PAUSE 
	ROW Fs3 $07 v1 
	ROW PAUSE 	
	ROW B_3 $07 vA CMD4 $00
	ROW PAUSE
	ROW D_4 $07 vA
	ROW B_3 $07 vA
	ROW D_4 $07 v3
	ROW Cs4 $07 vA
	ROW D_4 $07 v1
	ROW A_3 $07 vA 
	
PTN_2F
	ROW B_3 $07 vA CMD4 $00
	ROW PAUSE 
	ROW B_3 $07 v3 CMD4 $02
	ROW PAUSE 
	ROW B_3 $07 v2 
	ROW PAUSE 
	ROW B_3 $07 v1 
	ROW PAUSE 
	ROW Gs3 $07 vA CMD4 $00
	ROW PAUSE 
	ROW A_3 $07 vA 
	ROW PAUSE 
	ROW A_3 $07 v3 CMD4 $02
	ROW Fs3 $07 vA CMD4 $00
	ROW E_3 $07 vA 
	ROW Fs3 $07 v3 
	ROW Fs3 $07 vA 
	ROW Fs3 $07 v1 
	ROW Fs3 $07 v3 CMD4 $02 
	ROW PAUSE 
	ROW Fs3 $07 v2 
	ROW PAUSE 
	ROW Fs3 $07 v1 
	ROW PAUSE 	
	ROW B_3 $07 vA CMD4 $00
	ROW PAUSE
	ROW D_4 $07 vA
	ROW E_4 $07 vA 
	ROW D_4 $07 v3 
	ROW Cs4 $07 vA
	ROW B_3 $07 vA
	ROW Cs4 $07 v3

PTN_30
	ROW E_3 $07 vA CMD4 $00
	ROW PAUSE 
	ROW E_3 $07 v3 CMD4 $02
	ROW PAUSE 
	ROW A_3 $07 vA CMD4 $00
	ROW PAUSE 
	ROW A_3 $07 v3 CMD4 $02
	ROW PAUSE 
	ROW B_3 $07 vA CMD4 $00
	ROW PAUSE 
	ROW Fs3 $07 vA 
	ROW PAUSE 
	ROW E_3 $07 vA CMD4 $00
	ROW Fs3 $07 vA 
	ROW E_3 $07 v3 CMD4 $02
	ROW Fs3 $07 v3
	ROW E_3 $07 v1 
	ROW Fs3 $07 v1	
	ROW E_3 $07 vA CMD4 $00
	ROW PAUSE 
	ROW E_3 $07 v3 CMD4 $02
	ROW A_3 $07 vA CMD4 $00
	ROW E_3 $07 v1
	ROW A_3 $07 v3 CMD4 $02
	ROW Gs3 $07 vA CMD4 $00
	ROW A_3 $07 v1
	ROW Fs3 $07 vA CMD4 $00
	ROW PAUSE 
	ROW Fs3 $07 v3 CMD4 $02
	ROW PAUSE 
	ROW Fs3 $07 v1 
	ROW PAUSE 

PTN_31
	ROW E_3 $07 vA CMD4 $00
	ROW PAUSE
	ROW D_4 $07 vA 
	ROW PAUSE 
	ROW E_4 $07 vA
	ROW D_4 $07 vA 
	ROW E_4 $07 v3 CMD4 $02
	ROW D_4 $07 v3 
	ROW Cs4 $07 vA CMD4 $00
	ROW D_4 $07 v1 
	ROW Cs4 $07 v3 CMD4 $02
	ROW B_3 $07 vA CMD4 $00 
	ROW Cs4 $07 v1 
	ROW A_3 $07 vA
	ROW PAUSE 
	ROW Cs4 $07 vA
	ROW B_3 $07 vA
	ROW Cs4 $07 v3 CMD4 $02 
	ROW B_3 $07 v3
	ROW Cs4 $07 v2
	ROW B_3 $07 v2
	ROW Cs4 $07 v1
	ROW B_3 $07 v1
	ROW Cs4 $07 v3
	ROW B_3 $07 v3
	ROW Cs4 $07 v2
	ROW B_3 $07 v2
	ROW Cs4 $07 v1
	ROW B_3 $07 v1
	END_PATTERN 
	
PTN_32
	ROW C_5 $0A v6 CMD0 $74
	ROW ___ ___ v3
	ROW REL 
	ROW C_5 $0A v6
	ROW ___ ___ v3
	ROW REL 
	ROW C_5 $0A v6
	ROW REL 
	ROW G_5 $0A v6 CMD0 $73
	ROW ___ ___ v3
	ROW REL 
	ROW G_5 $0A v6
	ROW ___ ___ v3
	ROW REL 
	ROW G_5 $0A v6
	ROW REL 
	ROW E_5 $0A v6 CMD0 $63
	ROW ___ ___ v3
	ROW REL 
	ROW E_5 $0A v6
	ROW ___ ___ v3
	ROW REL 
	ROW E_5 $0A v6
	ROW REL 
	ROW F_5 $0A v6 CMD0 $74
	ROW ___ ___ v3
	ROW REL 
	ROW F_5 $0A v6
	ROW ___ ___ v3
	ROW REL 
	ROW F_5 $0A v6
	ROW ___ ___ v3 

PTN_33
	ROW C_5 $0A v6 CMD0 $74
	ROW ___ ___ v3
	ROW REL 
	ROW C_5 $0A v6
	ROW ___ ___ v3
	ROW REL 
	ROW C_5 $0A v6
	ROW ___ ___ v3
	ROW G_5 $0A v6 CMD0 $73
	ROW ___ ___ v3
	ROW REL 
	ROW G_5 $0A v6
	ROW ___ ___ v3
	ROW REL 
	ROW G_5 $0A v6
	ROW ___ ___ v3
	ROW As5 $0A v6 CMD0 $74
	ROW ___ ___ v3
	ROW REL 
	ROW As5 $0A v6
	ROW ___ ___ v3
	ROW REL 
	ROW As5 $0A v6
	ROW ___ ___ v3
	ROW F_5 $0A v6 CMD0 $74
	ROW ___ ___ v3
	ROW REL 
	ROW F_5 $0A v6
	ROW ___ ___ v3
	ROW REL 
	ROW F_5 $0A v6
	ROW ___ ___ v3 
	
PTN_34
	ROW G_5 $0A v6 CMD0 $73
	ROW ___ ___ v3
	ROW REL 
	ROW G_5 $0A v6
	ROW ___ ___ v3
	ROW REL 
	ROW G_5 $0A v6
	ROW ___ ___ v3
	ROW D_6 $0A v6 CMD0 $73
	ROW ___ ___ v3
	ROW REL 
	ROW D_6 $0A v6
	ROW ___ ___ v3
	ROW REL 
	ROW D_6 $0A v6
	ROW ___ ___ v3
	ROW A_5 $0A v6 CMD0 $73
	ROW ___ ___ v3
	ROW REL 
	ROW A_5 $0A v6
	ROW ___ ___ v3
	ROW REL 
	ROW A_5 $0A v6
	ROW ___ ___ v3
	ROW As5 $0A v6 CMD0 $74
	ROW ___ ___ v3
	ROW REL 
	ROW As5 $0A v6
	ROW ___ ___ v3
	ROW REL 
	ROW As5 $0A v6
	ROW ___ ___ v3 

PTN_35
	ROW G_5 $0A v6 CMD0 $73
	ROW ___ ___ v3
	ROW REL 
	ROW G_5 $0A v6
	ROW ___ ___ v3
	ROW REL 
	ROW G_5 $0A v6
	ROW ___ ___ v3
	ROW D_6 $0A v6 CMD0 $73
	ROW ___ ___ v3
	ROW REL 
	ROW D_6 $0A v6
	ROW ___ ___ v3
	ROW REL 
	ROW D_6 $0A v6
	ROW ___ ___ v3
	ROW F_6 $0A v6 CMD0 $74
	ROW ___ ___ v3
	ROW REL 
	ROW F_6 $0A v6
	ROW ___ ___ v3
	ROW REL 
	ROW F_6 $0A v6
	ROW ___ ___ v3
	ROW C_6 $0A v6 CMD0 $74
	ROW ___ ___ v3
	ROW REL 
	ROW C_6 $0A v6
	ROW ___ ___ v3
	ROW REL 
	ROW C_6 $0A v6
	ROW ___ ___ v3 

PTN_FF
	ROW OFF
	END_PATTERN 
	
;----------------- 

;--------------------------------------------------------------------------------------------------;

;* Instrument Volume Envelope 

pickbass_c_vol
.IF (pickbass_c_vol_end - pickbass_c_vol_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta pickbass_c_vol_sustain_start - pickbass_c_vol 
	dta pickbass_c_vol_release_start - pickbass_c_vol 
	dta pickbass_c_vol_end - pickbass_c_vol 
pickbass_c_vol_start						; Attack/Decay 
	dta $0F,$0F,$08,$06,$06,$06,$05,$05,$04,$04,$04,$03,$03
pickbass_c_vol_sustain_start					; Sustain 
	dta $02 
pickbass_c_vol_release_start 					; Release 
	dta $01,$01,$01,$01,$01,$01,$01,$00 
pickbass_c_vol_end

;-----------------

pulse_drum_2_vol 
.IF (pulse_drum_2_vol_end - pulse_drum_2_vol_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta pulse_drum_2_vol_sustain_start - pulse_drum_2_vol 
	dta pulse_drum_2_vol_release_start - pulse_drum_2_vol 
	dta pulse_drum_2_vol_end - pulse_drum_2_vol 
pulse_drum_2_vol_start						; Attack/Decay 
	dta $06,$0C,$0A,$08,$06,$04,$03,$03,$02,$02,$02 
pulse_drum_2_vol_sustain_start					; Sustain 
	dta $00
pulse_drum_2_vol_release_start 					; Release 
pulse_drum_2_vol_end

;-----------------

pulse_snare_vol 
.IF (pulse_snare_vol_end - pulse_snare_vol_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta pulse_snare_vol_sustain_start - pulse_snare_vol 
	dta pulse_snare_vol_release_start - pulse_snare_vol 
	dta pulse_snare_vol_end - pulse_snare_vol 
pulse_snare_vol_start						; Attack/Decay 
	dta $06,$0A,$09,$08,$07,$06,$05,$04
	dta $04,$03,$03,$03,$02,$02,$02,$02
	dta $01,$01,$01,$01,$01
pulse_snare_vol_sustain_start					; Sustain 
	dta $00
pulse_snare_vol_release_start 					; Release 
pulse_snare_vol_end

;-----------------

shaker_cut_vol 
.IF (shaker_cut_vol_end - shaker_cut_vol_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta shaker_cut_vol_sustain_start - shaker_cut_vol 
	dta shaker_cut_vol_release_start - shaker_cut_vol 
	dta shaker_cut_vol_end - shaker_cut_vol 
shaker_cut_vol_start						; Attack/Decay 
	dta $0F,$05
shaker_cut_vol_sustain_start					; Sustain 
	dta $00
shaker_cut_vol_release_start 					; Release 
shaker_cut_vol_end 

;-----------------

shaker_vol 
.IF (shaker_vol_end - shaker_vol_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta shaker_vol_sustain_start - shaker_vol 
	dta shaker_vol_release_start - shaker_vol 
	dta shaker_vol_end - shaker_vol 
shaker_vol_start						; Attack/Decay 
	dta $0F,$05,$08,$02,$05,$04,$02,$04,$03,$01,$01
shaker_vol_sustain_start					; Sustain 
	dta $00
shaker_vol_release_start 					; Release 
shaker_vol_end 

;-----------------

some_kind_of_flute_no_vib_vol 
.IF (some_kind_of_flute_no_vib_vol_end - some_kind_of_flute_no_vib_vol_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta some_kind_of_flute_no_vib_vol_sustain_start - some_kind_of_flute_no_vib_vol 
	dta some_kind_of_flute_no_vib_vol_release_start - some_kind_of_flute_no_vib_vol 
	dta some_kind_of_flute_no_vib_vol_end - some_kind_of_flute_no_vib_vol 
some_kind_of_flute_no_vib_vol_start						; Attack/Decay 
	dta $02,$03,$04,$05,$06,$06
some_kind_of_flute_no_vib_vol_sustain_start					; Sustain 
	dta $05
some_kind_of_flute_no_vib_vol_release_start 					; Release 
some_kind_of_flute_no_vib_vol_end 

;-----------------

distortion_a_lead_2_pwm_vol 
.IF (distortion_a_lead_2_pwm_vol_end - distortion_a_lead_2_pwm_vol_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta distortion_a_lead_2_pwm_vol_sustain_start - distortion_a_lead_2_pwm_vol 
	dta distortion_a_lead_2_pwm_vol_release_start - distortion_a_lead_2_pwm_vol 
	dta distortion_a_lead_2_pwm_vol_end - distortion_a_lead_2_pwm_vol 
distortion_a_lead_2_pwm_vol_start						; Attack/Decay 
	dta $01,$03,$04,$04,$04 
distortion_a_lead_2_pwm_vol_sustain_start					; Sustain 
	dta $05
distortion_a_lead_2_pwm_vol_release_start 					; Release 
	dta $04,$03,$03,$02,$02,$02,$02,$01,$01,$01,$01,$00 
distortion_a_lead_2_pwm_vol_end 

;-----------------

distortion_a_bell_64khz_pwm_set_vol 
.IF (distortion_a_bell_64khz_pwm_set_vol_end - distortion_a_bell_64khz_pwm_set_vol_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta distortion_a_bell_64khz_pwm_set_vol_sustain_start - distortion_a_bell_64khz_pwm_set_vol 
	dta distortion_a_bell_64khz_pwm_set_vol_release_start - distortion_a_bell_64khz_pwm_set_vol 
	dta distortion_a_bell_64khz_pwm_set_vol_end - distortion_a_bell_64khz_pwm_set_vol 
distortion_a_bell_64khz_pwm_set_vol_start						; Attack/Decay 
	dta $03,07,06,05,04,04 
distortion_a_bell_64khz_pwm_set_vol_sustain_start					; Sustain 
	dta $05
distortion_a_bell_64khz_pwm_set_vol_release_start 					; Release 
distortion_a_bell_64khz_pwm_set_vol_end 

;-----------------

;--------------------------------------------------------------------------------------------------;

;* Instrument Distortion/AUDCTL Table 
	
pickbass_c_aud 
.IF (pickbass_c_aud_end - pickbass_c_aud_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta pickbass_c_aud_sustain_start - pickbass_c_aud 
	dta pickbass_c_aud_release_start - pickbass_c_aud 
	dta pickbass_c_aud_end - pickbass_c_aud 
pickbass_c_aud_start						; Attack/Decay 
	dta $40 
pickbass_c_aud_sustain_start					; Sustain 
	dta $0C 
pickbass_c_aud_release_start 				; Release 
pickbass_c_aud_end

;-----------------

pulse_drum_2_aud 
.IF (pulse_drum_2_aud_end - pulse_drum_2_aud_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta pulse_drum_2_aud_sustain_start - pulse_drum_2_aud 
	dta pulse_drum_2_aud_release_start - pulse_drum_2_aud 
	dta pulse_drum_2_aud_end - pulse_drum_2_aud 
pulse_drum_2_aud_start						; Attack/Decay 
	dta $08,$0A,$0A,$0A,$0A,$0C,$0C,$0C,$0C,$0C,$0C
pulse_drum_2_aud_sustain_start					; Sustain 
	dta $00 
pulse_drum_2_aud_release_start 					; Release 
pulse_drum_2_aud_end

;-----------------

pulse_snare_aud 
.IF (pulse_snare_aud_end - pulse_snare_aud_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta pulse_snare_aud_sustain_start - pulse_snare_aud 
	dta pulse_snare_aud_release_start - pulse_snare_aud 
	dta pulse_snare_aud_end - pulse_snare_aud 
pulse_snare_aud_start						; Attack/Decay 
	dta $00,$0A,$0A,$0A,$0A,$00,$08,$08
	dta $08,$08,$08,$08,$08,$08,$08,$08
	dta $08,$08,$08,$08,$08 
pulse_snare_aud_sustain_start					; Sustain 
	dta $00 
pulse_snare_aud_release_start 					; Release 
pulse_snare_aud_end

;-----------------

shaker_cut_aud 
.IF (shaker_cut_aud_end - shaker_cut_aud_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta shaker_cut_aud_sustain_start - shaker_cut_aud 
	dta shaker_cut_aud_release_start - shaker_cut_aud 
	dta shaker_cut_aud_end - shaker_cut_aud 
shaker_cut_aud_start						; Attack/Decay 
	dta $00,$0A 
shaker_cut_aud_sustain_start					; Sustain 
	dta $00 
shaker_cut_aud_release_start 					; Release 
shaker_cut_aud_end

;-----------------

shaker_aud 
.IF (shaker_aud_end - shaker_aud_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta shaker_aud_sustain_start - shaker_aud 
	dta shaker_aud_release_start - shaker_aud 
	dta shaker_aud_end - shaker_aud 
shaker_aud_start						; Attack/Decay 
	dta $00,$0A,$08,$08,$08,$08,$08,$08,$08,$08,$08
shaker_aud_sustain_start					; Sustain 
	dta $00 
shaker_aud_release_start 					; Release 
shaker_aud_end

;-----------------

pickbass_a_aud 
.IF (pickbass_a_aud_end - pickbass_a_aud_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta pickbass_a_aud_sustain_start - pickbass_a_aud 
	dta pickbass_a_aud_release_start - pickbass_a_aud 
	dta pickbass_a_aud_end - pickbass_a_aud 
pickbass_a_aud_start						; Attack/Decay 
	dta $40 
pickbass_a_aud_sustain_start					; Sustain 
	dta $0A 
pickbass_a_aud_release_start 					; Release 
pickbass_a_aud_end

;-----------------

some_kind_of_flute_no_vib_aud 
.IF (some_kind_of_flute_no_vib_aud_end - some_kind_of_flute_no_vib_aud_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta some_kind_of_flute_no_vib_aud_sustain_start - some_kind_of_flute_no_vib_aud 
	dta some_kind_of_flute_no_vib_aud_release_start - some_kind_of_flute_no_vib_aud 
	dta some_kind_of_flute_no_vib_aud_end - some_kind_of_flute_no_vib_aud 
some_kind_of_flute_no_vib_aud_start						; Attack/Decay 
	dta $40,$0A,$0A
some_kind_of_flute_no_vib_aud_sustain_start					; Sustain 
	dta $42 
some_kind_of_flute_no_vib_aud_release_start 					; Release 
some_kind_of_flute_no_vib_aud_end

;----------------- 

distortion_a_lead_2_pwm_aud 
.IF (distortion_a_lead_2_pwm_aud_end - distortion_a_lead_2_pwm_aud_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta distortion_a_lead_2_pwm_aud_sustain_start - distortion_a_lead_2_pwm_aud 
	dta distortion_a_lead_2_pwm_aud_release_start - distortion_a_lead_2_pwm_aud 
	dta distortion_a_lead_2_pwm_aud_end - distortion_a_lead_2_pwm_aud 
distortion_a_lead_2_pwm_aud_start						; Attack/Decay 
	dta $28 
distortion_a_lead_2_pwm_aud_sustain_start					; Sustain 
	dta $2A
distortion_a_lead_2_pwm_aud_release_start 					; Release 
distortion_a_lead_2_pwm_aud_end 

;-----------------

distortion_c_179_arp_aud 
.IF (distortion_c_179_arp_aud_end - distortion_c_179_arp_aud_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta distortion_c_179_arp_aud_sustain_start - distortion_c_179_arp_aud 
	dta distortion_c_179_arp_aud_release_start - distortion_c_179_arp_aud 
	dta distortion_c_179_arp_aud_end - distortion_c_179_arp_aud 
distortion_c_179_arp_aud_start						; Attack/Decay 
	dta $48 
distortion_c_179_arp_aud_sustain_start					; Sustain 
	dta $4C
distortion_c_179_arp_aud_release_start 					; Release 
distortion_c_179_arp_aud_end 

;-----------------

;--------------------------------------------------------------------------------------------------;

;* Instrument Notes Table 
	
some_kind_of_flute_no_vib_notes
.IF (some_kind_of_flute_no_vib_notes_end - some_kind_of_flute_no_vib_notes_sustain_start == 0)
	dta %10000000 + (%00000001 * some_kind_of_flute_no_vib_notes_absolute) 
.ELSE 
	dta %00000000 + (%00000001 * some_kind_of_flute_no_vib_notes_absolute) 
.ENDIF
	dta some_kind_of_flute_no_vib_notes_sustain_start - some_kind_of_flute_no_vib_notes
	dta some_kind_of_flute_no_vib_notes_release_start - some_kind_of_flute_no_vib_notes
	dta some_kind_of_flute_no_vib_notes_end - some_kind_of_flute_no_vib_notes
some_kind_of_flute_no_vib_notes_start						; Attack/Decay 
	dta $80,$01
some_kind_of_flute_no_vib_notes_sustain_start					; Sustain 
	dta $00 
some_kind_of_flute_no_vib_notes_release_start 					; Release 
some_kind_of_flute_no_vib_notes_end
some_kind_of_flute_no_vib_notes_absolute = 0
 
;-----------------

;--------------------------------------------------------------------------------------------------;

;* Instrument Freqs Table 

pickbass_c_freqs
.IF (pickbass_c_freqs_end - pickbass_c_freqs_sustain_start == 0)
	dta %10000000 + (%00000001 * pickbass_c_freqs_absolute) 
.ELSE 
	dta %00000000 + (%00000001 * pickbass_c_freqs_absolute) 
.ENDIF
	dta pickbass_c_freqs_sustain_start - pickbass_c_freqs 
	dta pickbass_c_freqs_release_start - pickbass_c_freqs 
	dta pickbass_c_freqs_end - pickbass_c_freqs 
pickbass_c_freqs_start						; Attack/Decay 
	dta $00 
pickbass_c_freqs_sustain_start					; Sustain 
pickbass_c_freqs_release_start 					; Release 
pickbass_c_freqs_end 
pickbass_c_freqs_absolute = 1

;-----------------

pulse_drum_2_freqs
.IF (pulse_drum_2_freqs_end - pulse_drum_2_freqs_sustain_start == 0)
	dta %10000000 + (%00000001 * pulse_drum_2_freqs_absolute) 
.ELSE 
	dta %00000000 + (%00000001 * pulse_drum_2_freqs_absolute) 
.ENDIF
	dta pulse_drum_2_freqs_sustain_start - pulse_drum_2_freqs 
	dta pulse_drum_2_freqs_release_start - pulse_drum_2_freqs 
	dta pulse_drum_2_freqs_end - pulse_drum_2_freqs 
pulse_drum_2_freqs_start					; Attack/Decay 
	dta $00,$DF,$EF,$F8,$FF,$F2,$F2,$F2,$FF,$FF,$FF
pulse_drum_2_freqs_sustain_start				; Sustain 
	dta $00 
pulse_drum_2_freqs_release_start 				; Release 
pulse_drum_2_freqs_end 
pulse_drum_2_freqs_absolute = 1

;-----------------

pulse_snare_freqs
.IF (pulse_snare_freqs_end - pulse_snare_freqs_sustain_start == 0)
	dta %10000000 + (%00000001 * pulse_snare_freqs_absolute) 
.ELSE 
	dta %00000000 + (%00000001 * pulse_snare_freqs_absolute) 
.ENDIF
	dta pulse_snare_freqs_sustain_start - pulse_snare_freqs 
	dta pulse_snare_freqs_release_start - pulse_snare_freqs 
	dta pulse_snare_freqs_end - pulse_snare_freqs 
pulse_snare_freqs_start						; Attack/Decay 
	dta $07,$88,$98,$C8,$DF,$05,$05,$04
	dta $04,$04,$04,$04,$04,$04,$04,$04
	dta $04,$04,$04,$04,$04 
pulse_snare_freqs_sustain_start					; Sustain 
	dta $00 
pulse_snare_freqs_release_start 				; Release 
pulse_snare_freqs_end 
pulse_snare_freqs_absolute = 1

;-----------------

shaker_cut_freqs
.IF (shaker_cut_freqs_end - shaker_cut_freqs_sustain_start == 0)
	dta %10000000 + (%00000001 * shaker_cut_freqs_absolute) 
.ELSE 
	dta %00000000 + (%00000001 * shaker_cut_freqs_absolute) 
.ENDIF
	dta shaker_cut_freqs_sustain_start - shaker_cut_freqs 
	dta shaker_cut_freqs_release_start - shaker_cut_freqs 
	dta shaker_cut_freqs_end - shaker_cut_freqs 
shaker_cut_freqs_start					; Attack/Decay 
	dta $00,$02 
shaker_cut_freqs_sustain_start				; Sustain 
	dta $00 
shaker_cut_freqs_release_start 				; Release 
shaker_cut_freqs_end 
shaker_cut_freqs_absolute = 1

;-----------------

shaker_freqs
.IF (shaker_freqs_end - shaker_freqs_sustain_start == 0)
	dta %10000000 + (%00000001 * shaker_freqs_absolute) 
.ELSE 
	dta %00000000 + (%00000001 * shaker_freqs_absolute) 
.ENDIF
	dta shaker_freqs_sustain_start - shaker_freqs 
	dta shaker_freqs_release_start - shaker_freqs 
	dta shaker_freqs_end - shaker_freqs 
shaker_freqs_start					; Attack/Decay 
	dta $00,$02,$01,$01,$04,$01,$01,$04,$01,$01,$04 
shaker_freqs_sustain_start				; Sustain 
	dta $00 
shaker_freqs_release_start 				; Release 
shaker_freqs_end 
shaker_freqs_absolute = 1

;-----------------

some_kind_of_flute_no_vib_freqs
.IF (some_kind_of_flute_no_vib_freqs_end - some_kind_of_flute_no_vib_freqs_sustain_start == 0)
	dta %10000000 + (%00000001 * some_kind_of_flute_no_vib_freqs_absolute) 
.ELSE 
	dta %00000000 + (%00000001 * some_kind_of_flute_no_vib_freqs_absolute) 
.ENDIF
	dta some_kind_of_flute_no_vib_freqs_sustain_start - some_kind_of_flute_no_vib_freqs
	dta some_kind_of_flute_no_vib_freqs_release_start - some_kind_of_flute_no_vib_freqs
	dta some_kind_of_flute_no_vib_freqs_end - some_kind_of_flute_no_vib_freqs
some_kind_of_flute_no_vib_freqs_start						; Attack/Decay 
	dta $70,$00,$01
some_kind_of_flute_no_vib_freqs_sustain_start					; Sustain 
	dta $00 
some_kind_of_flute_no_vib_freqs_release_start 					; Release 
some_kind_of_flute_no_vib_freqs_end
some_kind_of_flute_no_vib_freqs_absolute = 0
 
;-----------------

;--------------------------------------------------------------------------------------------------;

;* Instrument Command Table 
	
pickbass_c_cmd
.IF (pickbass_c_cmd_end - pickbass_c_cmd_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta pickbass_c_cmd_sustain_start - pickbass_c_cmd 
	dta pickbass_c_cmd_release_start - pickbass_c_cmd 
	dta pickbass_c_cmd_end - pickbass_c_cmd 
pickbass_c_cmd_start							; Attack/Decay 
	dta $80,$00
pickbass_c_cmd_sustain_start						; Sustain 
pickbass_c_cmd_release_start 						; Release 
pickbass_c_cmd_end

;-----------------

some_kind_of_flute_no_vib_cmd
.IF (some_kind_of_flute_no_vib_cmd_end - some_kind_of_flute_no_vib_cmd_sustain_start == 0)
	dta %10000000 
.ELSE 
	dta %00000000 
.ENDIF
	dta some_kind_of_flute_no_vib_cmd_sustain_start - some_kind_of_flute_no_vib_cmd
	dta some_kind_of_flute_no_vib_cmd_release_start - some_kind_of_flute_no_vib_cmd
	dta some_kind_of_flute_no_vib_cmd_end - some_kind_of_flute_no_vib_cmd
some_kind_of_flute_no_vib_cmd_start						; Attack/Decay 
	dta $80,$00
	dta $00,$01
	dta $02,$01
some_kind_of_flute_no_vib_cmd_sustain_start					; Sustain 
some_kind_of_flute_no_vib_cmd_release_start 					; Release 
some_kind_of_flute_no_vib_cmd_end 
 
;----------------- 

distortion_a_lead_2_pwm_cmd 
.IF (distortion_a_lead_2_pwm_cmd_end - distortion_a_lead_2_pwm_cmd_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta distortion_a_lead_2_pwm_cmd_sustain_start - distortion_a_lead_2_pwm_cmd 
	dta distortion_a_lead_2_pwm_cmd_release_start - distortion_a_lead_2_pwm_cmd 
	dta distortion_a_lead_2_pwm_cmd_end - distortion_a_lead_2_pwm_cmd 
distortion_a_lead_2_pwm_cmd_start						; Attack/Decay 
	dta $80,$00 
	dta $02,$FD 
distortion_a_lead_2_pwm_cmd_sustain_start					; Sustain 
distortion_a_lead_2_pwm_cmd_release_start 					; Release 
distortion_a_lead_2_pwm_cmd_end 

;-----------------

distortion_a_lead_2_pwm_set_cmd 
.IF (distortion_a_lead_2_pwm_set_cmd_end - distortion_a_lead_2_pwm_set_cmd_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta distortion_a_lead_2_pwm_set_cmd_sustain_start - distortion_a_lead_2_pwm_set_cmd 
	dta distortion_a_lead_2_pwm_set_cmd_release_start - distortion_a_lead_2_pwm_set_cmd 
	dta distortion_a_lead_2_pwm_set_cmd_end - distortion_a_lead_2_pwm_set_cmd 
distortion_a_lead_2_pwm_set_cmd_start						; Attack/Decay 
	dta $80,$00  
distortion_a_lead_2_pwm_set_cmd_sustain_start					; Sustain 
	dta $02,$01
	dta $02,$00
	dta $02,$00
	dta $02,$00
	dta $02,$00
	dta $02,$00
	dta $02,$00
	dta $02,$00
	dta $02,$00
	dta $02,$00
	dta $02,$00
	dta $02,$00
	dta $02,$00
	dta $02,$00
	dta $02,$00
distortion_a_lead_2_pwm_set_cmd_release_start 					; Release 
distortion_a_lead_2_pwm_set_cmd_end 

;-----------------

distortion_a_bell_64khz_pwm_set_cmd 
.IF (distortion_a_bell_64khz_pwm_set_cmd_end - distortion_a_bell_64khz_pwm_set_cmd_sustain_start == 0)
	dta %10000000
.ELSE 
	dta %00000000
.ENDIF
	dta distortion_a_bell_64khz_pwm_set_cmd_sustain_start - distortion_a_bell_64khz_pwm_set_cmd 
	dta distortion_a_bell_64khz_pwm_set_cmd_release_start - distortion_a_bell_64khz_pwm_set_cmd 
	dta distortion_a_bell_64khz_pwm_set_cmd_end - distortion_a_bell_64khz_pwm_set_cmd 
distortion_a_bell_64khz_pwm_set_cmd_start						; Attack/Decay 
	dta $80,$00 
	dta $02,$FF 
	dta $00,$00
	dta $00,$00
	dta $00,$0C
	dta $00,$0C
distortion_a_bell_64khz_pwm_set_cmd_sustain_start					; Sustain 
distortion_a_bell_64khz_pwm_set_cmd_release_start 					; Release 
distortion_a_bell_64khz_pwm_set_cmd_end 

;-----------------

;--------------------------------------------------------------------------------------------------;

;--------------------------------------------------------------------------------------------------;
;* No extra Module data exists past this point, unless it is specified otherwise... 
;--------------------------------------------------------------------------------------------------;

ENDFILE 

;* That's all folks :D 

;----------------- 

;--------------------------------------------------------------------------------------------------;

