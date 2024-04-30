List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00

	;function

	initial:
	MOVLW 0x07 ;n
	MOVWF 0x001 ;0x001=n
	MOVLW 0x02 ;k
	MOVWF 0x002 ;0x002=k
	RCALL Fact
	GOTO finish

	Fact:
	MOVF 0x002,w ;wreg = k
	CPFSEQ 0x001 ;check if n==k, then add one to 0x000
	GOTO zero
	RCALL one
	RETURN
	zero:
	TSTFSZ 0x002 ;check if k ==0, then add one to 0x000
	GOTO count
	RCALL one
	RETURN
	count:
	DECF 0x001 ;n = n-1
	RCALL Fact ;c(n-1,k)
 	DECF 0x002 ;k = k-1
	RCALL Fact ;c(n-1,k-1)
	INCF 0x001 ;return to initial n
	INCF 0x002 ;return to initial k
	RETURN

	one:
	INCF 0x000
	RETURN

	finish:
	NOP
	end


