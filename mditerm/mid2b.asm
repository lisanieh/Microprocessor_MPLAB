List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	;setting
	LFSR 0,0x040 ;fsr0 = 0x040
	LFSR 1,0x010 ;fsr1 = 1
	LFSR 2,0x020 ;fsr2 = 2
	MOVLW 0x05
	MOVWF 0x050 ;counter = 5
	;1
	MOVLW 0x01
	MOVWF 0x010
	MOVLW 0x04
	MOVWF 0x011
	MOVLW 0x07
	MOVWF 0x012
	;2
	MOVLW 0x02
	MOVWF 0x020
	MOVLW 0x03
	MOVWF 0x021
	MOVLW 0x09
	MOVWF 0x022
	;3
	MOVLB 0x1 ; bank == 1
	MOVLW 0x05
	MOVWF 0x100
	MOVLW 0x06
	MOVWF 0x101
	MOVLW 0x08
	MOVWF 0x102
	
	;store 3 back to 0x030
	MOVF 0x100,w
	MOVLB 0x0 ; bank == 0
	MOVWF 0x030
	MOVLB 0x1 ; bank == 1
	MOVF 0x101,w
	MOVLB 0x0 ; bank == 0
	MOVWF 0x031
	MOVLB 0x1 ; bank == 1
	MOVF 0x102,w
	MOVLB 0x0 ; bank == 0
	MOVWF 0x032
	
	;sort
	sort:
	MOVLB 0x0 ; bank == 0
	MOVF POSTINC1,w ;wreg = 0x010
	CPFSLT INDF2 ;1<2 goto store (1>2 then skip)
	GOTO store
	MOVF POSTINC2,w ;wreg = smallest
	MOVF POSTDEC1 ;fsr1--
	GOTO store
	
	store:
	MOVWF POSTINC0 ;store smallest
	DECFSZ 0x050 ;counter--
	GOTO sort
	CPFSEQ 0x0
	
	;sort2
	
	sort2:
	
	finish:
	
	end