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

	initial:
	rcall multiply
	GOTO finish

	multiply: ;25 1F 1D 30 04 03 02 01
	Matrix 0x25,0x1F,0x04,0x02,0x000
	Matrix 0x25,0x1F,0x03,0x01,0x001
	Matrix 0x1D,0x30,0x04,0x02,0x002
	Matrix 0x1D,0x30,0x03,0x01,0x003
	RETURN

	finish:
	NOP
	end