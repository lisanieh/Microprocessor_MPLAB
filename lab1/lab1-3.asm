List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	;0x000 = origin
	;0x001 = right shifted
	;0x002 = result of XOR
	;0x004 = origin leftmost bit
	;0x005 = XOR leftmost bit
	
	MOVLW d'2' ;input
	MOVWF 0x000 ;store input in 0x000
	MOVWF 0x001 
	
	;check the leftmost bit is 0 or 1 in the origin num
	MOVLW 0x01 ;assign 1 in WREG
	BTFSS 0x000,7 ;check thie left most bit is 0 or 1
	MOVLW 0x00 ;assign 0 in WREG
	MOVWF 0x004 ;store the leftmost bit in 0x004
	
	RRNCF 0x001 ;right shift 
	MOVF 0x001, w ;store 0x001 in WREG
	
	ANDWF 0x000, w ;origin AND rightshift, and store in WREG
	MOVWF 0x002 ;store WREG(result of and) in 0x002
	COMF 0x002, f ;not the AND and restore in 0x002
	
	MOVF 0x000, w ;store 0x000 in WREG
	IORWF 0x001, w ;origin OR rightshift, and restore in WREG
	
	ANDWF 0x002, f ;WREG(OR) AND NAND, restore in 0x002
	
	MOVLW 0x01 ;assign 1 in WREG
	BTFSS 0x002,7 ;check thie left most bit is 0 or 1
	MOVLW 0x00 ;assign 0 in WREG
	MOVWF 0x005 ;store the leftmost bit in 0x005
	
	MOVF 0x004, w ;assogn 0x004 in WREG
	CPFSEQ 0x005 ;if 0x004 == 0x005, then skip
	GOTO change
	GOTO fin
	change:
	BCF 0x002,7;==0
	TSTFSZ 0x004 ;check if 0x004 == 0, then skip
	BSF 0x002,7;==1
	
	fin:
	MOVF 0x002, w ;load the output in WREG
	MOVWF 0x001 ;store ouput WREG in 0x001
	
	end