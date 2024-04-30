List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
settings:
	MOVLB 0x1 ; bank == 1
	MOVLW 0x23 ; num1
	MOVWF 0x100 ;
	MOVLW 0x23 ; num2
	MOVWF 0x101 ;
	MOVLW 0x12 ; num3
	MOVWF 0x102 ;
	MOVLW 0x22 ; num4
	MOVWF 0x103 ;
	MOVLW 0xF7 ; num5
	MOVWF 0x104 ;
	MOVLW 0xFF ; num6
	MOVWF 0x105 ;
	LFSR 0, 0x100 ;FSR0 point to 0x100
	LFSR 1, 0x101 ;FSR1 point to 0x101
	MOVLW d'0' ; left index
	MOVWF 0x106 ;
	MOVLW d'5' ; right index
	MOVWF 0x107 ;
	
start:	
	DECF 0x106 ;left--
    first:
	INCF 0x106; left++
	MOVF 0x107,w ;put right index in WREG
	CPFSLT 0x106 ; if left < right, then keep stay in while loop
	GOTO finish
	MOVFF 0x106,0x108 ; move left to i
	DECF 0x108 ;i--
	
	left:
	INCF 0x108 ;i++
	MOVF 0x107,w ;put right index in WREG
	CPFSLT 0x108 ;if i < right, then keep stay in the left loop
	GOTO next
	MOVF INDF1,w ;WREG = [i+1]
	CPFSGT INDF0 ;if [i] > [i+1], go to left change
	GOTO move_fsrl
	    left_change: ;switch
	    MOVFF INDF0,0x109 ; [0x109] = tmp,tmp = [i]
	    MOVFF INDF1, POSTINC0 ; [i] = [i+1], FSR0++
	    MOVFF 0x109, POSTINC1 ; [i+1] = tmp, FSR1++
	    GOTO left
	    move_fsrl: ;move pointer only
	    MOVFF POSTINC0, 0x109 ; FSR0++
	    MOVFF POSTINC1, 0x109 ; FSR1++
	    GOTO left
    
	next:
	DECF 0x107 ;right--
	MOVFF POSTDEC0, 0x109 ; FSR0--
	MOVFF POSTDEC1, 0x109 ; FSR1--
	MOVFF POSTDEC0, 0x109 ; FSR0--
	MOVFF POSTDEC1, 0x109 ; FSR1--
	MOVFF 0x107,0x108 ; move right to i
	INCF 0x108 ;i++
	    right:
	    DECF 0x108 ;i--
	    MOVF 0x106,w ;put left index in WREG
	    CPFSGT 0x108 ;if i > left, then keep stay in the right loop
	    GOTO tmp
	    MOVF INDF1,w ;WREG = [i]
	    CPFSGT INDF0 ;if [i-1] > [i], go to right change
	    GOTO move_fsrr
		right_change: ;switch
		MOVFF INDF0,0x109 ; [0x109] = tmp,tmp = [i]
		MOVFF INDF1, POSTDEC0 ; [i] = [i-1], FSR0--
		MOVFF 0x109, POSTDEC1 ; [i-1] = tmp, FSR1--
		GOTO right
		move_fsrr: ;move pointer only
		MOVFF POSTDEC0, 0x109 ; FSR0--
		MOVFF POSTDEC1, 0x109 ; FSR1--
		GOTO right

tmp:
	MOVFF POSTINC0, 0x109 ; FSR0++
	MOVFF POSTINC1, 0x109 ; FSR1++
	MOVFF POSTINC0, 0x109 ; FSR0++
	MOVFF POSTINC1, 0x109 ; FSR1++
	GOTO first
    
finish:
	;store the result
	MOVFF 0x100,0x110
	MOVFF 0x101,0x111
	MOVFF 0x102,0x112
	MOVFF 0x103,0x113
	MOVFF 0x104,0x114
	MOVFF 0x105,0x115
	NOP
	end