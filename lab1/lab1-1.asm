List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	MOVLW 0x04 ;x1
	MOVWF 0x000 ;assign x1 to 0x000
	MOVLW 0x02 ;x2
	MOVWF 0x001 ;assign x2 to 0x001
	ADDWF 0x000, 0 ;add WREG(x2) and x1, then store in WREG
	MOVWF 0x010 ;store WREG to 0x010
	
	MOVLW 0x0A ;y1
	MOVWF 0x002 ;assign y1 to 0x002
	MOVLW 0x04 ;y2
	MOVWF 0x003 ;assign y2 to 0x003
	SUBWF 0x002, 0 ;y1 - WREG(y2), then store in WREG
	MOVWF 0x011 ;store WREG to 0x011
	
	
	CPFSEQ 0x010, 0 ;check if 0x010 == WREG(0x011)
	GOTO unequel
	MOVLW 0xFF ;equal
	GOTO fin
	
	unequel:
	MOVLW 0x01 ;unequal
	
	fin:
	MOVWF 0x020 ;store the result  
	
	end


