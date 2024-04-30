List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
setup:	
	MOVLB 0x1 ; bank == 1
	MOVLW 0x15 ;WREG = num1
	MOVWF 0x100 ;[0x100] = num1
	MOVLW 0x12 ;WREG = num2
	MOVWF 0x101 ;[0x101] = num2
	LFSR 0, 0x102 ;FSR0 point to 0x102
	LFSR 1, 0x101 ;FSR1 point to 0x101
	LFSR 2, 0x100 ;FSR2 point to 0x100
	MOVLW 0x07 ;set counter = 7
	MOVWF 0x109 ;store counter in 0x109
	
start:
	BTFSS 0x109,0 ;if counter 0 bit == 1, jump to even
	GOTO odd
	GOTO even
    
    even: ;2 4 6 8
	DECF 0x109 ; counter--
	MOVF POSTINC2,w ;WREG = [FSR2], then FSR2++
	ADDWF POSTINC1,w ;WREG = [FSR1] + WREG, then FSR1++
	MOVWF POSTINC0 ; [FSR0] = WREG ,then FSR0++
	TSTFSZ 0x109 ;if counter == 0, jump to finish
	GOTO start
	GOTO finish
    odd: ;3 5 7
	DECF 0x109 ; counter--
	MOVF POSTINC2,w ; WREG = [FSR2], then FSR2++
	SUBWF POSTINC1,w ;WREG = [FSR1] - WREG,then FSR1++
	MOVWF POSTINC0 ; [FSR0] = WREG, then FSR0++
	GOTO start
	
finish:	
	NOP
    
    end