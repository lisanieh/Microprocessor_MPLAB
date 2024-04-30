#include"xc.inc"
Global _multi_signed

PSECT mytext,local,class=CODE,reloc=2

_multi_signed:
    MOVWF 0X010 ;0x010 = multiplicand from wreg
    CLRF 0x011 ;0x011 = high byte of multiplicand
    MOVFF 0X001,0X012 ;0x011 = multiplier from 0x001
    MOVLW 0x04 ;counter
    MOVWF 0x015 ;0x015 = counter
    MOVFF 0x010,0x030 ;tmp storage for multiplicand
    MOVFF 0x012,0x031 ;tmp storage for multiplier
    ;test MSB
    BTFSC 0x010,7 ;if multiplicand  is negative, then add 0x013
    INCF 0x013 ;+- record  
    BTFSC 0x012,7 ;if multiplier is negative, then add 0x013
    INCF 0x013 ;+- record
    ;negate negative number
    BTFSC 0x010,7 ;if multiplicand is positive , then skip
    NEGF 0x010
    BTFSC 0x012,7 ;if multiplier is positive , then skip the negation 
    NEGF 0x012
    ;multiplication
    CLRF 0x020 ;0x020 = low production
    CLRF 0x021 ;0x021 = high production 
    CLRF 0x016 ;tmp addition for high byte
    multiplication:
    CLRF 0x022 ;reset the carry
    MOVF 0x020,w ;wreg = low production 
    BTFSC 0x012,0 ;if multiplier lsb == 0, then don?t to multiplication 
    ADDWF 0x010,w ;wreg = result of production
    MOVWF 0x020 ;move the result to 0x020
    MOVF 0x021,w ;wreg = high production
    BTFSC 0x012,0 ;if multiplier lsb == 0, then don?t to multiplication 
    ADDWFC 0x011,w ;wreg = result of production + carry
    MOVWF 0x021 ;move the result to 0x021
    DCFSNZ 0x015 ;counter = counter - 1, if counter == 0, then exit the loop
    GOTO det ;exit the loop
    RRCF 0x012 ;multiplier rotate right
    BCF 0x012,7 ;make it shift by msb = 0
    BTFSS 0x010,7 ;check if there is overflow, add 1 in high byte if over flow
    GOTO shift
    MOVLW 0x01 ;the bit for carry
    MOVWF 0x022 ;0x022 = carry 
    shift:
    RLCF 0x010 ;low multiplicand rotate left
    BCF 0x010,0 ;make it shift by lsb = 0
    RLCF 0x011 ;high multiplicand rotate left
    BCF 0x011,0 ;make it shift by lsb = 0
    BTFSC 0x022,0 ;if carry = 1 ,then add the high multiplicand 
    INCF 0x011
    GOTO multiplication 
    ;determine if production is negative 
    det:
    BTFSS 0x013,0 ;check if multiplicand is positive
    GOTO finish ;if production is positive
    NEGF 0x020 ;change low byte to negative
    NEGF 0x021 ;change high byte to negative
    DECF 0x021 ;turn the high byte to one's complement
    ;finish
    finish:
    MOVFF 0x020,0x001 ;low 8 bits result will be read in 0x001
    MOVFF 0x021,0x002 ;high 8 bits result will be read in 0x002
RETURN





