List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	MOVLW b'11101010' ;first number
	MOVWF 0x000 ;assign first number to 0x000
	MOVLW 0x20 ;second number
	MOVWF 0x002 ;assign the second number to 0x002
	MOVLW b'11101010' ;store the original number in WREG
	
	loop:
	BTFSS 0x000, 0 ;check if the right most number in 0x000 == 1,then skip
	GOTO add
	DECF 0x002 ;minus 1
	GOTO shift
	add:
	INCF 0x002 ;add 1
	
	shift:
	RRNCF 0X000 ;right shift the binary
	CPFSEQ 0x000 ;check if 0x000 == WREG,then skip
	GOTO loop
	
	end