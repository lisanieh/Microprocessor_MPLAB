List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	Bit_xor macro num
	;load num
	MOVLW 0x00
	BTFSC num,7
	MOVLW 0x01
	MOVWF 0x010
	;load num
	MOVLW 0x00
	BTFSC num,6
	MOVLW 0x01
	MOVWF 0x011
	;compare xor
	MOVF 0x010,w ;wreg = bit 7
	XORWF 0x011,f ;0x011 = xor result
	;load num
	MOVLW 0x00
	BTFSC num,5
	MOVLW 0x01
	MOVWF 0x010
	;compare xor
	MOVF 0x010,w 
	XORWF 0x011,f ;0x011 = xor result
	;load num
	MOVLW 0x00
	BTFSC num,4
	MOVLW 0x01
	MOVWF 0x010
	;compare xor
	MOVF 0x010,w 
	XORWF 0x011,f ;0x011 = xor result
	;load num
	MOVLW 0x00
	BTFSC num,3
	MOVLW 0x01
	MOVWF 0x010
	;compare xor
	MOVF 0x010,w 
	XORWF 0x011,f ;0x011 = xor result
	;load num
	MOVLW 0x00
	BTFSC num,2
	MOVLW 0x01
	MOVWF 0x010
	;compare xor
	MOVF 0x010,w 
	XORWF 0x011,f ;0x011 = xor result
	;load num
	MOVLW 0x00
	BTFSC num,1
	MOVLW 0x01
	MOVWF 0x010
	;compare xor
	MOVF 0x010,w 
	XORWF 0x011,f ;0x011 = xor result
	;load num
	MOVLW 0x00
	BTFSC num,0
	MOVLW 0x01
	MOVWF 0x010
	;compare xor
	MOVF 0x010,w 
	XORWF 0x011,f ;0x011 = xor result
	;store result
	MOVFF 0x011,num
	endm
	
	;main
	MOVLW 0x4A ;n1
	MOVWF 0x001
	MOVLW 0xC2 ;n2
	MOVWF 0x002
	MOVLW 0x7B ;n3
	MOVWF 0x003
	MOVLW 0xA3 ;n4
	MOVWF 0x004
	Bit_xor 0x001
	Bit_xor 0x002
	Bit_xor 0x003
	Bit_xor 0x004
	;set final
	BCF 0x000,3
	TSTFSZ 0x0004
	BSF 0x000,3
	BCF 0x000,2
	TSTFSZ 0x0003
	BSF 0x000,2
	BCF 0x000,1
	TSTFSZ 0x0002
	BSF 0x000,1
	BCF 0x000,0
	TSTFSZ 0x0001
	BSF 0x000,0
	
	end