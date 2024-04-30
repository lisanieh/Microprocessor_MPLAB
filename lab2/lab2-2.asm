List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
setup:	
	MOVLW 0x0A ;WREG = num1
	MOVWF 0x000 ;[0x000] = WREG
	MOVLW 0x03 ;WREG = num2
	MOVWF 0x018 ;[0x018] = WREG
	LFSR 0, 0x000 ;FSR0 point to 0x000
	LFSR 1, 0x018 ;FSR1 point to 0x018
	MOVLW d'16' ;set counter = 16
	MOVWF 0x009 ;store counter in 0x009
	
start:
	BTFSS 0x009,0 ;if counter 0 bit == 1, jump to sub
	GOTO add
	GOTO sub
    
    add:
	DECF 0x009 ; counter--
	MOVF POSTINC0,w ;WREG = [FSR0], then FSR0++
	ADDWF INDF1,w ;WREG = [FSR1] + WREG
	MOVWF POSTDEC0 ; [FSR0] = WREG, then FSR0--
	GOTO start
	
    sub:
	DECF 0x009 ; counter--
	MOVF POSTDEC1,w ;WREG = [FSR1], then FSR1--
	SUBWF POSTINC0,w ;WREG = [FSR0] - WREG, then FSR0++
	MOVWF INDF1 ;[FSR1] = WREG
	TSTFSZ 0x009 ;if counter == 0, jump to finish
	GOTO start
	GOTO finish
	
finish:
    NOP
    end