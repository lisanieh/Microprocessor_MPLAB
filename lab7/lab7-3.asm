List p=18f4520
    #include "p18f4520.inc"

    ; CONFIG1H
      CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
      CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
      CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

    ; CONFIG2L
      CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
      CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
      CONFIG  BORV = 3              ; Brown Out Reset Voltage bits (Minimum setting)

    ; CONFIG2H
      CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
      CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

    ; CONFIG3H
      CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
      CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
      CONFIG  LPT1OSC = OFF         ; Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
      CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

    ; CONFIG4L
      CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
      CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
      CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

    ; CONFIG5L
      CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
      CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
      CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
      CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

    ; CONFIG5H
      CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
      CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

    ; CONFIG6L
      CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
      CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
      CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
      CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

    ; CONFIG6H
      CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
      CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
      CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

    ; CONFIG7L
      CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
      CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
      CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
      CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

    ; CONFIG7H
      CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)

	org 0x00

    goto Initial	
    ISR_timer:				
	org 0x08 ;button pressed = high priority
	rcall arrange_light 
	BSF PIE1 , TMR2IE ;turn on the light
	BCF INTCON, INT0IF     
	RETFIE
	
    ISR_light:
	org 0x18 ;time's up = low priority
	BTFSC 0x000,0 ;if forward,skip
	BRA light_backward
	BRA light_forward
	light_forward:
	INCF LATA
	MOVLW 0x10 ;wreg = 0001,0000
	CPFSLT LATA;check if overflow,skip if not
	BRA finish
	BRA isr_light_end
	light_backward:
	MOVLW 0x00 ;wreg = 0
	CPFSEQ LATA ;if light is all dark, skip
	BRA next
	BRA turn_on
	    turn_on:
;	    INCF 0x001 ;first dark time happen
	    MOVLW 0x0F
	    MOVWF LATA ;turn all the light on
	    BRA next
	next:
	DECF LATA
	MOVLW 0x00 ;wreg = 0
	CPFSGT LATA;check if LATA == 0, shut down the light
	BRA finish
	BRA isr_light_end
	finish:
	CLRF LATA
	BCF PIE1 , TMR2IE ;turn off the light
	BRA isr_light_end
	isr_light_end:
	BCF PIR1, TMR2IF  
	RETFIE
	
    arrange_light:
	BTFSC 0x000,0 ;if forward,skip
	BRA set_forward
	BRA set_backward
	set_forward:
	DECF 0x000
	BRA set_timer
	set_backward:
	INCF 0x000
	BRA set_timer
	set_timer:
	MOVLW D'244' ;wreg = delay 1 sec
	CPFSEQ PR2 ;if pr2 = delay 1 sec, skip
	BRA mul2
	BRA div4
	mul2:
	RLCF PR2 ;pr2 *= 2
	BCF PR2,0
	BRA isr_timer_end
	div4:
	RRCF PR2 ;pr2 /= 4
	BCF PR2,7
	RRCF PR2 
	BCF PR2,7
	BRA isr_timer_end
	isr_timer_end:
	RETURN

    Initial:	
	;global
	MOVLW 0x0F
	MOVWF ADCON1
	BSF RCON, IPEN ;open priority
	BSF INTCON, GIEL
	;input setting
	CLRF TRISA
	CLRF LATA
	;button setting
	BSF TRISB,  0
	BCF INTCON, INT0IF
	BSF INTCON, INT0IE
	BSF INTCON, GIEH ;button with high priority
	;timer setting
	BCF PIR1, TMR2IF		
	BCF IPR1, TMR2IP ;low priority
	BSF PIE1 , TMR2IE
	MOVLW b'11111111'	        
	MOVWF T2CON		
	MOVLW D'61'		
	MOVWF PR2		
	MOVLW D'00100000'
	MOVWF OSCCON	       
	;others
	CLRF 0x000 ;0x000 = state forward/backward
;	CLRF 0x001 ;0x001 = count down num of dark times

    main:		
	BRA main	    
    end