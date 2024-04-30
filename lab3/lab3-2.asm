List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	;storage
	MOVLW 0x76 ; num 1-1
	MOVWF 0x000 ; num 1-1 = 0x000
	MOVLW 0x12 ;num 1-2
	MOVWF 0x001 ; num 1-2 = 0x001
	MOVLW 0x44 ;num 2-1
	MOVWF 0x010 ;num 2-1 = 0x010
	MOVLW 0x93 ; num 2-2
	MOVWF 0x011 ; num 2-2 = 0x011
	MOVLW 0x01 ;set a carry bit
	MOVWF 0x002 ;0x002 = carry bit
	
	;addition
	MOVF 0x011,w ; wreg = 0x011
	ADDWF 0x001,w; wreg = 0x001+0x011
	MOVWF 0x021 ; 0x021 = wreg
	MOVF 0x000,w; move 0x000 to wreg
	BTFSC STATUS,0 ;check if carry == 1,then add wreg
	ADDWF 0x002,w ; wreg = wreg+1
	ADDWF 0x010,w; wreg = 0x010+0x000
	MOVWF 0x020 ; 0x020 = wreg
	NOP
	end