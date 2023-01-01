;* --- Dumb Unless Made Better ---
;*
;* DUMB Module Construction Pseudocode - Prototype 2 
;* By VinsCool 
;* 
;* An attempt at construction Module data using Assembly macros pseudocode
;* The goal is mainly to be able to make something that is humanly readable and editiable
;* Ideally, the syntax is as close as possible to the look and feel of a typical Music Tracker 
;* This is also done for the purpose of easily decoding the data to a functional purpose later 
;--------------------------------------------------------------------------------------------------; 

;* Much of everything is being designed right now!!!
;* TODO: A FUCKTON of things, lmfaooo 

//-----------------------------------------------------------------------------------------------------------//

;* Some humanly readable data definitions
;* Designed to make things much easier to follow
;* This is also intended to be used within the music driver itself 
;* Future design changes will be a lot faster and easier to apply in the code 
;* Otherwise, I know I will get frustrated if I need to edit everything by hand  
;* Small and subtle changes are very easy to miss in the ASM code, specifically! 
;* Nothing here is definitive yet, but hopefully, this provides a good enough idea for how it's being made  
;* I'm still in the process of brainstorming better ideas, regarding new driver features, and optimisations 

//-----------------------------------------------------------------------------------------------------------//

;* Byte $VV bits Constants 

PAUSE		= %10000000	; Pause length of 0 
NOTE		= %01000000
INSTRUMENT	= %00100000
VOLUME		= %00010000 
COMMAND_1	= %00001000
COMMAND_2	= %00000100
COMMAND_3	= %00000010
COMMAND_4	= %00000001


;* Byte $II bits Constants 

INSTRPAR 	= 12 		; number of instrument parameters before tables and envelopes 
;INSTRINIT	= %01000000	; if bit 6 is set, the instrument will be reset 
;INSTRESET	= %10111111	; use to clear bit 6 in the selected instrument 

INSTRINIT	= %10000000	; if bit 7 is set, the instrument will be reset 
INSTRESET	= %01111111

;* Byte $CC bits Constants 

TERMINATOR	= $FF		; End a pattern, it will be needed twice if the Pattern is longer than 128 rows 

;* Row Volume Constants 

v0	= $00
v1	= $10
v2	= $20
v3	= $30
v4	= $40
v5	= $50
v6	= $60
v7	= $70
v8	= $80
v9	= $90
vA	= $A0
vB	= $B0
vC	= $C0
vD	= $D0
vE	= $E0
vF	= $F0 
__	= $100		; A way to write an empty Instrument, Volume, etc  

;* Row Notes Index Number Constants 

C_0	= $00
Cs0	= $01
D_0	= $02
Ds0	= $03
E_0	= $04
F_0	= $05
Fs0	= $06
G_0	= $07
Gs0	= $08
A_0	= $09
As0	= $0A
B_0	= $0B
C_1	= $0C
Cs1	= $0D
D_1	= $0E
Ds1	= $0F
E_1	= $10
F_1	= $11
Fs1	= $12
G_1	= $13
Gs1	= $14
A_1	= $15
As1	= $16
B_1	= $17
C_2	= $18
Cs2	= $19
D_2	= $1A
Ds2	= $1B
E_2	= $1C
F_2	= $1D
Fs2	= $1E
G_2	= $1F
Gs2	= $20
A_2	= $21
As2	= $22
B_2	= $23
C_3	= $24
Cs3	= $25
D_3	= $26
Ds3	= $27
E_3	= $28
F_3	= $29
Fs3	= $2A
G_3	= $2B
Gs3	= $2C
A_3	= $2D
As3	= $2E
B_3	= $2F
C_4	= $30
Cs4	= $31
D_4	= $32
Ds4	= $33
E_4	= $34
F_4	= $35
Fs4	= $36
G_4	= $37
Gs4	= $38
A_4	= $39
As4	= $3A
B_4	= $3B
C_5	= $3C
Cs5	= $3D
D_5	= $3E
Ds5	= $3F
E_5	= $40
F_5	= $41
Fs5	= $42
G_5	= $43
Gs5	= $44
A_5	= $45
As5	= $46
B_5	= $47
C_6	= $48
Cs6	= $49
D_6	= $4A
Ds6	= $4B
E_6	= $4C
F_6	= $4D
Fs6	= $4E
G_6	= $4F
Gs6	= $50
A_6	= $51
As6	= $52
B_6	= $53
C_7	= $54
Cs7	= $55
D_7	= $56
Ds7	= $57
E_7	= $58
F_7	= $59
Fs7	= $5A
G_7	= $5B
Gs7	= $5C
A_7	= $5D
As7	= $5E
B_7	= $5F 
REL	= $60
OFF	= $7F  
___	= $100		; A way to write an Empty Note, Command, XY Parameter, etc

;* Effect Commands Constants 

CMD0	= $00 
CMD1	= $01 
CMD2	= $02 
CMD3	= $03 
CMD4	= $04 
CMD5	= $05 
CMD6	= $06 
CMD7	= $07 
CMD8	= $08 
CMD9	= $09 
CMDA	= $0A 
CMDB	= $0B 
CMDC	= $0C 
CMDD	= $0D 
CMDE	= $0E 
CMDF	= $0F 

//-----------------------------------------------------------------------------------------------------------//

;* Row Pause creation macro, pretty self explanatory regarding what it could do 
;* I would prefer being able to simply have both the Row Pause and Row Creation macros merged, but whatever 
;* As long as it works, I'm fine with that :P 
;* 
;* Parameters:
;* p = Pause length, up to $7F, or 128 rows 

.MACRO	SET_PAUSE [p] 
	.IF (:p > TERMINATOR) 
		.BYTE $80		; Missing parameter, Empty Row with a Pause length of 0 is assumed 
		
	.ELSEIF (:p < PAUSE) 
		.BYTE PAUSE + :p 	; Set the Pause length by adding the Parameter p to it  

	.ELSE 
		.BYTE :p		; Limit the pause length to $7F if a larger number is used 
			
	.ENDIF	

.ENDM 

.MACRO	END_PATTERN 
	 
	.BYTE $00			; Pattern End 

.ENDM

//-----------------------------------------------------------------------------------------------------------//

;* Pattern Row creation macro, this is made with the goal of creating modules in the Assembly code easily 
;* This may become good enough for the creation of complete module file, from start to finish, with simplicity in mind 
;* Currently, most of this stuff is a proof of concept, but it may eventually become useful for future C++ adaptation 
;* This is intended to be flexible, and painless to update when I have to edit the pseudocode to match any driver changes 
;* 
;* Parameters:
;* not = Note Index, from $00 (C-0) to $5F (B-7), or 96 notes. Also used for Note Command, such as Note Cut, Note Release, etc 
;* inst = Instrument Index, from $00 to $3F, or 64 instruments (not yet implemented properly in the driver) 
;* vol = Volume, from $00 to $0F, or 16 levels 
;* cmd0-3 = Effect Commands, to do later (not yet implemented properly in the driver) 
;* xy0-3 = Effect Commands $XY parameters, to do later (not yet implemented properly in the driver) 
;* paus = Row Pause length, this parameter only exists as a soft limit, technically any byte after $VV may be used the same way 
;* 
;* TODO: a LOT, it's a bit complex to make it all work, but it will be EXTREMELY rewarding! :D 

.MACRO	ROW [not, inst, vol, cmd0, xy0, cmd1, xy1, cmd2, xy2, cmd3, xy3] 

;* First, verify if the arguments aren't missing, if the first argument is empty, spit out a $80 and bail out! 

	.IF (:not > TERMINATOR+1) 
		.BYTE $80	; Missing parameter, an Empty Row with a Pause length of 0 is assumed 
		
;	.ELSEIF (:not > OFF) 
;		.BYTE :not	; :not is a Row Pause Command

	.ELSE	;* Everything is processed like normal from here, if the arguments aren't empty 
	
;* Check how many arguments were passed to the macro, in order to know exactly what is actually expected! 

		.IF (:xy3 <= TERMINATOR)
			argnum = 11	; up to 11 arguments may be valid 

		.ELSEIF (:cmd3 <= TERMINATOR)
			argnum = 10	; up to 10 arguments may be valid 

		.ELSEIF (:xy2 <= TERMINATOR)
			argnum = 9	; up to 9 arguments may be valid 

		.ELSEIF (:cmd2 <= TERMINATOR)
			argnum = 8	; up to 8 arguments may be valid 

		.ELSEIF (:xy1 <= TERMINATOR)
			argnum = 7	; up to 7 arguments may be valid 

		.ELSEIF (:cmd1 <= TERMINATOR)
			argnum = 6	; up to 6 arguments may be valid 

		.ELSEIF (:xy0 <= TERMINATOR)
			argnum = 5	; up to 5 arguments may be valid 

		.ELSEIF (:cmd0 <= TERMINATOR)
			argnum = 4	; up to 4 arguments may be valid 

		.ELSEIF (:vol <= TERMINATOR)
			argnum = 3	; up to 3 arguments may be valid 

		.ELSEIF (:inst <= TERMINATOR)
			argnum = 2	; up to 2 arguments may be valid 
			
		.ELSEIF (:not <= TERMINATOR)
			argnum = 1	; only 1 argument may be valid 
			
		.ELSE
			argnum = 0	; no valid argument 
	
		.ENDIF

;* Process Row values from here 

		.IF (argnum == 0) 
			.BYTE $80

		.ELSEIF (argnum == 1) 
		
			.IF (:not > OFF) 
				.BYTE :not	; :not is a Row Pause Command
				
			.ELSEIF (:not == OFF) 
				.BYTE NOTE 
				.BYTE $FF	; no, this is NOT a PAUSE command! 
				
			.ELSE
				.BYTE NOTE 
				.BYTE :not 
			.ENDIF

		.ELSEIF (argnum == 2) 
			.BYTE NOTE + INSTRUMENT 
			.BYTE :not 
			.BYTE :inst + INSTRINIT

		.ELSEIF (argnum == 3) 
		
			.IF (:not == ___ && :inst == ___ && :vol == ___) 
				.BYTE $80
			
			.ELSEIF (:not == ___ && :inst == ___) 
				.BYTE VOLUME 
				.BYTE :vol 
				
			.ELSEIF (:not == ___ && :vol == ___) 
				.BYTE INSTRUMENT 
				.BYTE :inst
				
			.ELSEIF (:inst == ___ && :vol == ___) 
				.BYTE NOTE 
				.BYTE :not 

			.ELSEIF (:not == ___) 
				.BYTE INSTRUMENT + VOLUME  
				.BYTE :inst + INSTRINIT
				.BYTE :vol
				
			.ELSEIF (:inst == ___) 
				.BYTE NOTE + VOLUME  
				.BYTE :not 
				.BYTE :vol
				
			.ELSEIF (:vol == ___) 
				.BYTE NOTE + INSTRUMENT 
				.BYTE :not 
				.BYTE :inst
			
			.ELSE
				.BYTE NOTE + INSTRUMENT + VOLUME 
				.BYTE :not 
				.BYTE :inst + INSTRINIT
				.BYTE :vol 
			
			.ENDIF
			
/*	
				.BYTE NOTE + INSTRUMENT + VOLUME 
				.BYTE :not 
				.BYTE :inst + INSTRINIT
				.BYTE :vol 
*/
			
		.ELSEIF (argnum == 4) 
			.BYTE NOTE + INSTRUMENT + VOLUME + COMMAND_1 
			.BYTE :not 
			.BYTE :inst + INSTRINIT
			.BYTE :vol 
			.BYTE :cmd0 
			.BYTE $00
				
		.ELSEIF (argnum == 5) 

			.IF (:not == OFF) 
				.BYTE NOTE + COMMAND_1 
				.BYTE $FF	; no, this is NOT a PAUSE command! 
				.BYTE :cmd0 
				.BYTE :xy0 
				
			.ELSE 
				.BYTE NOTE + INSTRUMENT + VOLUME + COMMAND_1 
				.BYTE :not 
				.BYTE :inst + INSTRINIT
				.BYTE :vol
				.BYTE :cmd0 
				.BYTE :xy0 
			.ENDIF 

		.ELSEIF (argnum == 6) 
			.BYTE NOTE + INSTRUMENT + VOLUME + COMMAND_1 + COMMAND_2
			.BYTE :not 
			.BYTE :inst + INSTRINIT
			.BYTE :vol
			.BYTE :cmd0 
			.BYTE :xy0
			.BYTE :cmd1 
			.BYTE $00
				
		.ELSEIF (argnum == 7) 
			.BYTE NOTE + INSTRUMENT + VOLUME + COMMAND_1 + COMMAND_2
			.BYTE :not 
			.BYTE :inst + INSTRINIT
			.BYTE :vol
			.BYTE :cmd0 
			.BYTE :xy0
			.BYTE :cmd1
			.BYTE :xy1

		.ELSEIF (argnum == 8) 
			.BYTE NOTE + INSTRUMENT + VOLUME + COMMAND_1 + COMMAND_2 + COMMAND_3
			.BYTE :not 
			.BYTE :inst + INSTRINIT
			.BYTE :vol
			.BYTE :cmd0 
			.BYTE :xy0
			.BYTE :cmd1
			.BYTE :xy1 
			.BYTE :cmd2
			.BYTE $00 

		.ELSEIF (argnum == 9) 
			.BYTE NOTE + INSTRUMENT + VOLUME + COMMAND_1 + COMMAND_2 + COMMAND_3
			.BYTE :not 
			.BYTE :inst + INSTRINIT
			.BYTE :vol
			.BYTE :cmd0 
			.BYTE :xy0
			.BYTE :cmd1
			.BYTE :xy1 
			.BYTE :cmd2
			.BYTE :xy2
				
		.ELSEIF (argnum == 10) 
			.BYTE NOTE + INSTRUMENT + VOLUME + COMMAND_1 + COMMAND_2 + COMMAND_3 + COMMAND_4
			.BYTE :not 
			.BYTE :inst + INSTRINIT
			.BYTE :vol
			.BYTE :cmd0 
			.BYTE :xy0
			.BYTE :cmd1
			.BYTE :xy1 
			.BYTE :cmd2
			.BYTE :xy2 
			.BYTE :cmd3 
			.BYTE $00 

		.ELSEIF (argnum == 11) 
			.BYTE NOTE + INSTRUMENT + VOLUME + COMMAND_1 + COMMAND_2 + COMMAND_3 + COMMAND_4
			.BYTE :not 
			.BYTE :inst + INSTRINIT
			.BYTE :vol
			.BYTE :cmd0 
			.BYTE :xy0
			.BYTE :cmd1
			.BYTE :xy1 
			.BYTE :cmd2
			.BYTE :xy2 
			.BYTE :cmd3 
			.BYTE :xy3 
			
		.ENDIF 

	.ENDIF 

;* Finished the macro! 

.ENDM 




















/*

;* First, verify if the arguments aren't missing, if the first argument is empty, spit out a $80 and bail out! 

	.IF (:not > TERMINATOR) 
		.BYTE $80	; Missing parameter, an Empty Row with a Pause length of 0 is assumed 

	.ELSE	;* Everything is processed like normal from here, if the arguments aren't empty 
	
;* Check how many arguments were passed to the macro, in order to know exactly what is actually expected! 

		.IF (:paus <= TERMINATOR)
			argnum = 12	; all 12 arguments may be valid, anything above that will be ignored 

		.ELSEIF (:xy3 <= TERMINATOR)
			argnum = 11	; up to 11 arguments may be valid 

		.ELSEIF (:cmd3 <= TERMINATOR)
			argnum = 10	; up to 10 arguments may be valid 

		.ELSEIF (:xy2 <= TERMINATOR)
			argnum = 9	; up to 9 arguments may be valid 

		.ELSEIF (:cmd2 <= TERMINATOR)
			argnum = 8	; up to 8 arguments may be valid 

		.ELSEIF (:xy1 <= TERMINATOR)
			argnum = 7	; up to 7 arguments may be valid 

		.ELSEIF (:cmd1 <= TERMINATOR)
			argnum = 6	; up to 6 arguments may be valid 

		.ELSEIF (:xy0 <= TERMINATOR)
			argnum = 5	; up to 5 arguments may be valid 

		.ELSEIF (:cmd0 <= TERMINATOR)
			argnum = 4	; up to 4 arguments may be valid 

		.ELSEIF (:vol <= TERMINATOR)
			argnum = 3	; up to 3 arguments may be valid 

		.ELSEIF (:inst <= TERMINATOR)
			argnum = 2	; up to 2 arguments may be valid 
			
		.ELSEIF (:not <= TERMINATOR)
			argnum = 1	; only 1 argument may be valid 
	
		.ENDIF
		
;* Create the Byte $VV here, it will always be the first byte processed by DUMB Music Driver 
;* The number of arguments will be directly related to its creation, so this is very important to not half ass it all! 
;* Note, Instrument and Volume are minimal number of arguments expected for a "complete" Byte $VV 
;* Anything else will depend on the arguments number, and a bit of luck, if the assumptions aren't wrong in the first place! 

		.IF (argnum == 1)			; argument 1: Note 
			.IF (:not < MAXNOTE) 
				byte_vv = NOTE		; :not is a valid Note Index 
				
			.ELSE
				byte_vv = PAUSE 	; :not was set to be used as the Row Pause Length
			
			.ENDIF

			.IF (byte_vv == PAUSE) 
				.BYTE :not		; Set Pause Command, using the value of :not directly 
			
			.ELSEIF (byte_vv == NOTE) 
				.BYTE byte_vv		; $VV => Set Note Command  
				.BYTE :not 		; $NN => :not 
				.BYTE PAUSE		; Missing parameter, a Pause length of 0 is assumed 
			
			.ENDIF
			
		.ELSEIF (argnum == 2)			; argument 2: Instrument 
			.IF (:inst < MAXINSTRUMENT && :not < MAXNOTE) 
				byte_vv = NOTE + INSTRUMENT	; :not is a valid Note Index, :inst is a valid Instrument Index 		

			.ELSEIF (:inst < MAXINSTRUMENT) 
				byte_vv = INSTRUMENT 	; :inst is a valid Instrument Index, :not will be ignored 

			.ELSEIF (:not < MAXNOTE) 
				byte_vv = NOTE		; :not is a valid Note Index, :inst was set to be used as the Row Pause Length 

			.ELSE
				byte_vv = PAUSE 	; WARNING: This should never happen! Unfuck your code immediately Vin! 
			
			.ENDIF

			.IF (byte_vv == PAUSE) 
				.BYTE PAUSE		; Missing parameter, a Pause length of 0 is assumed 

			.ELSEIF (byte_vv == NOTE + INSTRUMENT) 
				.BYTE byte_vv		; $VV => Set Note and Instrument Command 
				.BYTE :not 		; $NN => :not 
				.BYTE :inst		; $II => :inst 
				.BYTE PAUSE		; Missing parameter, a Pause length of 0 is assumed 

			.ELSEIF (byte_vv == INSTRUMENT) 
				.BYTE byte_vv		; $VV => Set Instrument Command  
				.BYTE :inst		; $II => :inst 
				.BYTE PAUSE		; Missing parameter, a Pause length of 0 is assumed 

			.ELSEIF (byte_vv == NOTE) 
				.BYTE byte_vv		; $VV => Set Note Command  
				.BYTE :not 		; $NN => :not 
				.BYTE :inst		; $II => :inst, Trigger Bit was set 
			
			.ENDIF		
			 
		.ELSEIF (argnum == 3)			; argument 3: Volume 
			.IF (:vol < MAXVOLUME && :inst < MAXINSTRUMENT && :not < MAXNOTE) 
				byte_vv = VOLUME + NOTE + INSTRUMENT	; :not is a valid Note Index, :inst is a valid Instrument Index :vol is a valid Volume level		

			.ELSEIF (:vol < MAXVOLUME && :inst < MAXINSTRUMENT) 
				byte_vv = VOLUME + INSTRUMENT		; :inst is a valid Instrument Index :vol is a valid Volume level, :not will be ignored
				
			.ELSEIF (:vol < MAXVOLUME && :not < MAXNOTE) 
				byte_vv = VOLUME + NOTE			; :not is a valid Note Index, :vol is a valid Volume level, :inst will be ignored

			.ELSEIF (:vol < MAXVOLUME) 
				byte_vv = VOLUME	; :vol is a valid Volume level, :not and :inst will be ignored 

			.ELSEIF (:inst < MAXINSTRUMENT && :not < MAXNOTE) 
				byte_vv = NOTE + INSTRUMENT	; :not is a valid Note Index, :inst is a valid Instrument Index, :vol was set to be used as the Row Pause Length 

			.ELSEIF (:inst < MAXINSTRUMENT) 
				byte_vv = INSTRUMENT 	; :inst is a valid Instrument Index, :not will be ignored, :vol was set to be used as the Row Pause Length 

			.ELSEIF (:not < MAXNOTE) 
				byte_vv = NOTE		; :not is a valid Note Index, :inst will be ignored, :vol was set to be used as the Row Pause Length 

			.ELSE
				byte_vv = PAUSE 	; WARNING: This should never happen! Unfuck your code immediately Vin! 
			
			.ENDIF

			.IF (byte_vv == PAUSE) 
				.BYTE PAUSE		; Missing parameter, a Pause length of 0 is assumed 

			.ELSEIF (byte_vv == VOLUME + NOTE + INSTRUMENT) 
				.BYTE byte_vv + :vol 	; $VV => Set Volume, Note and Instrument Command, Volume was set to the value of :vol  
				.BYTE :not 		; $NN => :not 
				.BYTE :inst		; $II => :inst 
				.BYTE PAUSE		; Missing parameter, a Pause length of 0 is assumed 

			.ELSEIF (byte_vv == VOLUME + INSTRUMENT) 
				.BYTE byte_vv + :vol 	; $VV => Set Volume and Instrument Command, Volume was set to the value of :vol  
				.BYTE :inst 		; $II => :inst 
				.BYTE PAUSE		; Missing parameter, a Pause length of 0 is assumed

			.ELSEIF (byte_vv == VOLUME + NOTE) 
				.BYTE byte_vv + :vol 	; $VV => Set Volume and Note Command, Volume was set to the value of :vol  
				.BYTE :not 		; $NN => :not 
				.BYTE PAUSE		; Missing parameter, a Pause length of 0 is assumed

			.ELSEIF (byte_vv == VOLUME) 
				.BYTE byte_vv + :vol 	; $VV => Set Volume Command, Volume was set to the value of :vol  
				.BYTE PAUSE		; Missing parameter, a Pause length of 0 is assumed 

			.ELSEIF (byte_vv == NOTE + INSTRUMENT) 
				.BYTE byte_vv		; $VV => Set Note and Instrument Command 
				.BYTE :not 		; $NN => :not 
				.BYTE :inst		; $II => :inst 
				.BYTE :vol		; $CC => :vol, Trigger Bit was set 

			.ELSEIF (byte_vv == INSTRUMENT) 
				.BYTE byte_vv		; $VV => Set Instrument Command  
				.BYTE :inst		; $II => :inst 
				.BYTE :vol		; $CC => :vol, Trigger Bit was set 

			.ELSEIF (byte_vv == NOTE) 
				.BYTE byte_vv		; $VV => Set Note Command  
				.BYTE :not 		; $NN => :not 
				.BYTE :vol		; $II => :vol, Trigger Bit was set 

			.ENDIF	


		.ELSEIF (argnum >= 4)			; argument 4 and beyond: Effect Commands  
			.IF (:vol < MAXVOLUME && :inst < MAXINSTRUMENT && :not < MAXNOTE) 
				byte_vv = VOLUME + NOTE + INSTRUMENT	; :not is a valid Note Index, :inst is a valid Instrument Index :vol is a valid Volume level		

			.ELSEIF (:vol < MAXVOLUME && :inst < MAXINSTRUMENT) 
				byte_vv = VOLUME + INSTRUMENT		; :inst is a valid Instrument Index :vol is a valid Volume level, :not will be ignored
				
			.ELSEIF (:vol < MAXVOLUME && :not < MAXNOTE) 
				byte_vv = VOLUME + NOTE			; :not is a valid Note Index, :vol is a valid Volume level, :inst will be ignored

			.ELSEIF (:vol < MAXVOLUME) 
				byte_vv = VOLUME	; :vol is a valid Volume level, :not and :inst will be ignored 

			.ELSEIF (:inst < MAXINSTRUMENT && :not < MAXNOTE) 
				byte_vv = NOTE + INSTRUMENT	; :not is a valid Note Index, :inst is a valid Instrument Index, :vol was set to be used as the Row Pause Length 

			.ELSEIF (:inst < MAXINSTRUMENT) 
				byte_vv = INSTRUMENT 	; :inst is a valid Instrument Index, :not will be ignored, :vol was set to be used as the Row Pause Length 

			.ELSEIF (:not < MAXNOTE) 
				byte_vv = NOTE		; :not is a valid Note Index, :inst will be ignored, :vol was set to be used as the Row Pause Length 

			.ELSE
;				byte_vv = PAUSE 	; WARNING: This should never happen! Unfuck your code immediately Vin! 
				byte_vv = $00
			
			.ENDIF

;			.IF (byte_vv == PAUSE) 
;				.BYTE PAUSE		; Missing parameter, a Pause length of 0 is assumed 

			.IF (byte_vv == $00) 
				.BYTE byte_vv		; Empty Row, Processing Byte $CC immediately 

			.ELSEIF (byte_vv == VOLUME + NOTE + INSTRUMENT) 
				.BYTE byte_vv + :vol 	; $VV => Set Volume, Note and Instrument Command, Volume was set to the value of :vol  
				.BYTE :not 		; $NN => :not 
				.BYTE :inst		; $II => :inst 

			.ELSEIF (byte_vv == VOLUME + INSTRUMENT) 
				.BYTE byte_vv + :vol 	; $VV => Set Volume and Instrument Command, Volume was set to the value of :vol  
				.BYTE :inst 		; $II => :inst 

			.ELSEIF (byte_vv == VOLUME + NOTE) 
				.BYTE byte_vv + :vol 	; $VV => Set Volume and Note Command, Volume was set to the value of :vol  
				.BYTE :not 		; $NN => :not 

			.ELSEIF (byte_vv == VOLUME) 
				.BYTE byte_vv + :vol 	; $VV => Set Volume Command, Volume was set to the value of :vol  

			.ELSEIF (byte_vv == NOTE + INSTRUMENT) 
				.BYTE byte_vv		; $VV => Set Note and Instrument Command 
				.BYTE :not 		; $NN => :not 
				.BYTE :inst		; $II => :inst 
				.BYTE :vol		; $CC => :vol, Trigger Bit was set 

			.ELSEIF (byte_vv == INSTRUMENT) 
				.BYTE byte_vv		; $VV => Set Instrument Command  
				.BYTE :inst		; $II => :inst 
				.BYTE :vol		; $CC => :vol, Trigger Bit was set 

			.ELSEIF (byte_vv == NOTE) 
				.BYTE byte_vv		; $VV => Set Note Command  
				.BYTE :not 		; $NN => :not 
;				.BYTE :vol		; $II => :vol, Trigger Bit was set 

			.ENDIF	
			
		.ENDIF 
			
;* Effect Commands, used when argnum >= 4 only 

		.IF (argnum >= 4) 

;* CMD0 

			.IF (:cmd0 >= PAUSE && argnum == 4) 
				.BYTE :cmd0		; Pause length was set to the value :cmd0 

			.ELSEIF (:cmd0 < MAXCMD) 
				.IF (:xy0 < TERMINATOR && :xy0 > $00) 
					.BYTE :cmd0 + USE_XY	; $CC => :cmd0, using $XY parameter :xy0
					.BYTE :xy0		; $XY => :xy0 
			
				.ELSEIF (:xy0 > TERMINATOR || :xy0 == $00) 
					.BYTE :cmd0 		; $CC => :cmd0, $XY parameter of 0 is assumed 
				
				.ENDIF
				
				.IF (argnum == 4 || argnum == 5) 
					.BYTE PAUSE		; Missing parameter, a Pause length of 0 is assumed 
				
				.ENDIF 
				
			.ENDIF

;* CMD1 

			.IF (:cmd1 >= PAUSE && argnum == 6) 
				.BYTE :cmd1		; Pause length was set to the value :cmd1 

			.ELSEIF (:cmd1 < MAXCMD) 
				.IF (:xy1 < TERMINATOR && :xy1 > $00) 
					.BYTE :cmd1 + USE_XY	; $CC => :cmd1, using $XY parameter :xy1
					.BYTE :xy1		; $XY => :xy1 
			
				.ELSEIF (:xy1 > TERMINATOR || :xy1 == $00) 
					.BYTE :cmd1 		; $CC => :cmd1, $XY parameter of 0 is assumed 
				
				.ENDIF
				
				.IF (argnum == 6 || argnum == 7) 
					.BYTE PAUSE		; Missing parameter, a Pause length of 0 is assumed 
				
				.ENDIF 
				
			.ENDIF

;* CMD2 

			.IF (:cmd2 >= PAUSE && argnum == 8) 
				.BYTE :cmd2		; Pause length was set to the value :cmd2 

			.ELSEIF (:cmd2 < MAXCMD) 
				.IF (:xy2 < TERMINATOR && :xy2 > $00) 
					.BYTE :cmd2 + USE_XY	; $CC => :cmd2, using $XY parameter :xy2
					.BYTE :xy2		; $XY => :xy2 
			
				.ELSEIF (:xy2 > TERMINATOR || :xy2 == $00) 
					.BYTE :cmd2 		; $CC => :cmd2, $XY parameter of 0 is assumed 
				
				.ENDIF
				
				.IF (argnum == 8 || argnum == 9) 
					.BYTE PAUSE		; Missing parameter, a Pause length of 0 is assumed 
				
				.ENDIF 
				
			.ENDIF

;* CMD3 

			.IF (:cmd3 >= PAUSE && argnum == 10) 
				.BYTE :cmd3		; Pause length was set to the value :cmd3 

			.ELSEIF (:cmd3 < MAXCMD) 
				.IF (:xy3 < TERMINATOR && :xy3 > $00) 
					.BYTE :cmd3 + USE_XY	; $CC => :cmd3, using $XY parameter :xy3
					.BYTE :xy3		; $XY => :xy3 
			
				.ELSEIF (:xy3 > TERMINATOR || :xy3 == $00) 
					.BYTE :cmd3 		; $CC => :cmd3, $XY parameter of 0 is assumed 
				
				.ENDIF
				
				.IF (argnum == 10 || argnum == 11) 
					.BYTE PAUSE		; Missing parameter, a Pause length of 0 is assumed 
				
				.ENDIF 
				
			.ENDIF 
			
			.IF (argnum == 12) 
				.BYTE :paus		; Pause length was set to the value :paus 
			.ENDIF 

		.ENDIF 

;* Maximum of arguments number reached from this point, anything else will be ignored 

	.ENDIF 

;* Finished the macro! 

.ENDM 

*/

//-----------------------------------------------------------------------------------------------------------//

