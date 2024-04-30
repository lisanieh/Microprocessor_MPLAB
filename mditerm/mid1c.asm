List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	;function
	Matrix macro x1,x2,y1,y2,s
	MOVLW x1 ;wreg = x1
	MULLW y1 ;x1*y1
	MOVFF PRODL,0x005 ;0x005=PRODL
	MOVLW x2 ;wreg = x2
	MULLW y2 ;x2*y2
	MOVF PRODL,w ;wreg=PRODL
	ADDWF 0x005,w ;wreg = x1*y1 + x2*y2
	MOVWF s ;s = wreg
	endm
	
	end