List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	;storage
	MOVLW 0x03 ; num 1
	MOVWF TRISA ;TRISA = num 1
	MOVLW 0x0F ;num 2
	MOVWF TRISB ;TRISB = nun 2
	MOVLW 0x08 ;counter
	MOVWF 0x000 ;0x000 = counter
	MOVLW 0x00 ;set wreg to be product
	
	;multiple
multiple:
	BTFSC TRISB,0 ;if bit 0 == 0, then don't do addition
	ADDWF TRISA,w ; wreg = wreg + TRISA
	RRCF TRISB ;multiplier move right
	BCF TRISB,7 ;set bit 7 = 0
	RLCF TRISA ;multiplicand move left
	BCF TRISA,0 ;set bit 0 = 0
	DECFSZ 0x000 ;stop branch if counter == 0
	BRA  multiple;branch to multiple
	
	;store
	MOVWF TRISC ;store the result from wreg to TRISC
	
	NOP
	end