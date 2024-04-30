  List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00

	;function
	Add_Mul macro xh,xl,yh,yl 
	;addition
	MOVLW xl; wreg=xl
	ADDLW yl; wreg=xl+yl
	MOVWF 0X001 ;0X001=xl + yl
	MOVLW xh; wreg=xh
	MOVWF 0x002 ;0x002 = xh
	MOVLW yh;wreg = yh
	ADDWFC 0x002,w ;wreg=carry+xh+yh
	MOVWF 0X000 ;0x000=xh+yh
	;mul
	MULWF 0x001 ;0x000 * 0x001
	MOVF 0x001,w ;wreg = h
	BTFSC 0x000,7 ;if h is negative, then subtract l from PRODH
	SUBWF PRODH,f ;PRODH -= l
	MOVF 0x000,w ;wreg = l
	BTFSC 0x001,7 ;if l is negative, then subtract h from PRODH
	SUBWF PRODH,f ;PRODH -= h
	MOVFF PRODH,0X010 ;0X010 = PRODH
	MOVFF PRODL,0X011 ;0X011 = PRODL
	endm

	;main
	Add_Mul 0x00,0xFF,0x02,0x0C
	NOP
	end
