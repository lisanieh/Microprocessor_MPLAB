LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67 ; 1 MHZ
	CONFIG WDT = OFF
	CONFIG LVP = OFF

	L1	EQU 0x14
	L2	EQU 0x15
	org 0x00

    ; Total_cycles = 2 + (2 + 7 * num1 + 2) * num2 cycles
    ; num1 = 200, num2 = 180, Total_cycles = 252360
    ; Total_delay ~= Total_cycles/1M = 0.25s
    DELAY macro num1, num2 
	local LOOP1         ; innerloop
	local LOOP2         ; outerloop
	MOVLW num2          ; 2 cycles
	MOVWF L2
	LOOP2:
	    MOVLW num1          ; 2 cycles
	    MOVWF L1
	LOOP1:
	    NOP                 ; 7 cycles
	    NOP
	    NOP
	    NOP
	    NOP
	    DECFSZ L1, 1
	    BRA LOOP1
	    DECFSZ L2, 1        ; 2 cycles
	    BRA LOOP2
    endm

    start:
    init:
	MOVLW 0x0f
	MOVWF ADCON1           ;set digital IO
	CLRF PORTB
	BSF TRISB, 0            ;set RB0 as input TRISB = 0000 0001
	CLRF LATA
	CLRF TRISA          ;set RA as output TRISA = 0000 0000

    ; ckeck button
    check_process:          
       BTFSC PORTB, 0
       BRA check_process
       BRA lightup

    lightup:
	BTFSC LATA, 3 ;if 3 is lighten
	GOTO state1
	BTFSC LATA, 2 ;if 2 is lighten
	GOTO state5
	BTFSC LATA, 1 ;if 1 is lighten
	GOTO state4
	BTFSC LATA, 0 ;if 0 is lighten
	GOTO state3
	GOTO state2 ;if all off
    state1:
	BTG LATA, 3 ;turn off light 3
	GOTO finish
    state2:
	BTG LATA, 0 ;turn on light 0
	GOTO finish
    state3:
	BTG LATA, 1 ;turn on light 1
	BTG LATA, 0 ;turn off light 0
	GOTO finish
    state4:
	BTG LATA, 2 ;turn on light 2
	BTG LATA, 1 ;turn off light 1
	GOTO finish
    state5:
	BTG LATA, 3 ;turn on light 3
	BTG LATA, 2 ;turn off light 2
	GOTO finish
    finish:
	DELAY d'200', d'180' ;delay 0.25s
	BRA check_process
    end