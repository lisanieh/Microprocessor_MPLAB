List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	;setting
	MOVLW 0x01
	MOVWF 0x001 ;a1
	MOVLW 0x02
	MOVWF 0x002 ;a2
	MOVLW 0x04
	MOVWF 0x003 ;a3
	MOVLW 0x05
	MOVWF 0x004 ;n
	LFSR 0, 0x001
	
	;stair
	MOVFF 0x001,0x000 ;outcome = a1
	DCFSNZ 0x004,f ;n--
	GOTO finish
	MOVFF 0x002,0x000 ;outcome = a2
	DCFSNZ 0x004,f ;n--
	GOTO finish
	MOVFF 0x003,0x000 ;outcome = a3
	DCFSNZ 0x004,f ;n--
	GOTO finish
	stair:
	MOVF 0x001,w ;wreg = an-3
	ADDWF 0x002,w ;wreg = an-3 + an-2
	ADDWF 0x003,w ;wreg = an = an-1 + an-2 + an-3
	MOVWF 0x000 ;outcome = an
	MOVWF POSTINC0 ;0x001 = an-1
	DCFSNZ 0x004,f ;n--
	GOTO finish
	MOVF 0x001,w ;wreg = an-3
	ADDWF 0x002,w ;wreg = an-3 + an-2
	ADDWF 0x003,w ;wreg = an = an-1 + an-2 + an-3
	MOVWF 0x000 ;outcome = an
	MOVWF POSTINC0 ;0x001 = an-1
	DCFSNZ 0x004,f ;n--
	GOTO finish
	MOVF 0x001,w ;wreg = an-3
	ADDWF 0x002,w ;wreg = an-3 + an-2
	ADDWF 0x003,w ;wreg = an = an-1 + an-2 + an-3
	MOVWF 0x000 ;outcome = an
	MOVWF POSTDEC0 
	MOVF POSTDEC0 ;0x001 = an-1
	DCFSNZ 0x004,f ;n--
	GOTO finish
	GOTO stair
	
	finish:
	NOP
	
	end