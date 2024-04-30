#include <xc.h>
#include<stdio.h>
#include<stdlib.h>
#include <time.h>
#define _XTAL_FREQ 1000000

#pragma config OSC = INTIO67  //OSCILLATOR SELECTION BITS (INTERNAL OSCILLATOR BLOCK, PORT FUNCTION ON RA6 AND RA7)
#pragma config WDT = OFF      //Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PWRT = OFF     //Power-up Timer Enable bit (PWRT disabled)
#pragma config BOREN = ON     //Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
#pragma config PBADEN = OFF   //PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF      //Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
#pragma config CPD = OFF      //Data EEPROM Code Protection bit (Data EEPROM not code-protected)

void __interrupt(high_priority)H_ISR(){
    
    //step4
    int value_h = ADRESH;
    int value_l = ADRESL;
    
    //do things
    /*
     1024 / 16 = 64
     64 = 2^6
     count from 6th bit
    */
    if(value_l < 64){ //00
        LATAbits.LATA3 = 0;
        LATAbits.LATA4= 0;
    }
    else if(value_l >= 64 && value_l < 128){ //01
        LATAbits.LATA3 = 0;
        LATAbits.LATA4 = 1;
    }
    else if(value_l >= 128 && value_l < 192){ //10
        LATAbits.LATA3 = 1;
        LATAbits.LATA4 = 0;
    }
    else{ //11
        LATAbits.LATA3 = 1;
        LATAbits.LATA4 = 1;
    }
    if(value_h < 1){ //00
        LATAbits.LATA1 = 0;
        LATAbits.LATA2 = 0;
    }
    else if(value_h >= 1 && value_h < 2){ //01
        LATAbits.LATA1 = 0;
        LATAbits.LATA2 = 1;
    }
    else if(value_h >= 2 && value_h < 3){ //10
        LATAbits.LATA1 = 1;
        LATAbits.LATA2 = 0;
    }
    else{
        LATAbits.LATA1 = 1;
        LATAbits.LATA2 = 1;
    }
    
    //clear flag bit
    PIR1bits.ADIF = 0;
    
    
    //step5 & go back step3
    /*
    delay at least 2tad
    ADCON0bits.GO = 1;
    1 tad = 4 tosc = 1/4M * 4 = 1us
    2 tad = 2 us
    */
    __delay_us(2);
    ADCON0bits.GO = 1;
    
    return;
}

void main(void) 
{
    //configure OSC and port
    OSCCONbits.IRCF = 0b110; //4MHz
    TRISAbits.RA0 = 1;       //analog input port
    TRISAbits.RA1 = 0; //output
    TRISAbits.RA2 = 0;
    TRISAbits.RA3 = 0;
    TRISAbits.RA4 = 0;
    
    //step1
    ADCON1bits.VCFG0 = 0;
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110; //AN0 ?analog input,???? digital
    ADCON0bits.CHS = 0b0000;  //AN0 ?? analog input
    ADCON2bits.ADCS = 0b100;  //4 tocs = 5.71 mhz
    ADCON2bits.ACQT = 0b010;  //Tad = 4 us acquisition time
    ADCON0bits.ADON = 1;
    ADCON2bits.ADFM = 1;    //right justified 
    LATA = 0; //set led
//    TRISD = 0;
    
    
    //step2
    PIE1bits.ADIE = 1;
    PIR1bits.ADIF = 0;
    INTCONbits.PEIE = 1;
    INTCONbits.GIE = 1;


    //step3
    ADCON0bits.GO = 1;
    
    while(1);
    
    return;
}