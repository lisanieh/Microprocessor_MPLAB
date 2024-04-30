List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	MOVLW b'11110000' ;move num1 to wreg
	MOVWF TRISA ;move num1 to TRISA
	
	;check MSB
	MOVLW 0x00 ;wreg = 0
	BTFSC TRISA,7 ;if TRISA MSB == 1,then set wreg to 1
	MOVLW 0x01 ;wreg = 1
	MOVWF 0x000; move bit7 to 0x000
	
	;arithmetic
	RRCF TRISA ;right shift TRISA
	BCF TRISA,7 ;set bit 7 = 0
	TSTFSZ 0x000 ;if MSB == 1, them set bit 7 to 1
	BSF TRISA,7 ; set bit 7 = 1
	
	;logic
	RRNCF TRISA ;right shift TRISA
	BCF TRISA,7 ;set bit 7 = 0
	
	end