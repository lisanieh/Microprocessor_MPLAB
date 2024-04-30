List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	;setting
	MOVLW 0x01 ;F1 and F2
	MOVWF 0x001 ;0x001 = F1
	MOVWF 0x002 ;0x002 = F2
	MOVLW 0x0C ;n
	MOVWF 0x010 ;0x010 = n = counter
	
	;n to fibonacci
	MOVFF 0x001,0x003 ;0x003 = outcome = F1 and F2
	DCFSNZ 0x010,f ;n--
	GOTO finish ;output = F1
	DCFSNZ 0x010,f ;n--
	GOTO finish ;output = F2
	add:
	MOVF 0x001,w ;wreg = n-2
	ADDWF 0x003,f ;outcome = n-2 + n-1
	MOVFF 0x003,0x001 ;0x001 = n-1
	DCFSNZ 0x010,f ;n--
	GOTO gray
	MOVF 0x002,w ;wreg = n-2
	ADDWF 0x003,f ;outcome = n-2 + n-1
	MOVFF 0x003,0x002 ;0x002 = n-1
	DCFSNZ 0x010,f ;n--
	GOTO gray
	GOTO add
	
	;binary to gray
	gray:
	;0x020 = origin
	;0x021 = right shifted
	;0x022 = result of XOR
	;0x024 = origin leftmost bit
	;0x025 = XOR leftmost bit
	MOVFF 0x003,0x020 ;store input in 0x020
	MOVFF 0x003,0x021 
	;check the leftmost bit is 0 or 1 in the origin num
	MOVLW 0x01 ;assign 1 in WREG
	BTFSS 0x020,7 ;check thie left most bit is 0 or 1
	MOVLW 0x00 ;assign 0 in WREG
	MOVWF 0x024 ;store the leftmost bit in 0x004
	
	RRNCF 0x021 ;right shift 
	MOVF 0x021, w ;store 0x001 in WREG
	
	ANDWF 0x020, w ;origin AND rightshift, and store in WREG
	MOVWF 0x022 ;store WREG(result of and) in 0x002
	COMF 0x022, f ;not the AND and restore in 0x002
	
	MOVF 0x020, w ;store 0x000 in WREG
	IORWF 0x021, w ;origin OR rightshift, and restore in WREG
	
	ANDWF 0x022, f ;WREG(OR) AND NAND, restore in 0x002
	
	MOVLW 0x01 ;assign 1 in WREG
	BTFSS 0x022,7 ;check thie left most bit is 0 or 1
	MOVLW 0x00 ;assign 0 in WREG
	MOVWF 0x025 ;store the leftmost bit in 0x005
	
	MOVF 0x024, w ;assogn 0x004 in WREG
	CPFSEQ 0x025 ;if 0x004 == 0x005, then skip
	GOTO change
	GOTO fin
	change:
	BCF 0x022,7;==0
	TSTFSZ 0x024 ;check if 0x004 == 0, then skip
	BSF 0x022,7;==1
	fin:
	MOVF 0x022, w ;load the output in WREG
	MOVWF 0x003 ;store ouput WREG in 0x003
	
	finish:
	MOVFF 0x003,0x000 ;0x000 = output
	
	end