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

unsigned int dtime;

void delay_ms(unsigned int milliseconds) {
   while(milliseconds > 0) {
      milliseconds--;
       __delay_us(990);
   }
}

void __interrupt(high_priority)H_ISR(){
    
    //step4
    int value_h = ADRESH;
//    LATAbits.LATA1 = 1;
    //do things
    /*
     AN4106018 --> 4106018 --> 7 state
     256 / 7 = 36.57 
    */
    if(value_h < 85){ //4 = 0100
//        delay_time = 100;
        dtime = 5000;
        LATAbits.LATA1 = 1;
        delay_ms(dtime);
        LATAbits.LATA1 = 0;
        delay_ms(dtime);
    }
    else if(value_h >= 85 && value_h < 170){ //1 = 0001
//        delay_time = 50;
        dtime = 2500;
        LATAbits.LATA1 = 1;
        delay_ms(dtime);
        LATAbits.LATA1 = 0;
        delay_ms(dtime);
    }
    else { //8 = 1000
//        delay_time = 25;
        dtime = 1250;
        LATAbits.LATA1 = 1;
        delay_ms(dtime);
        LATAbits.LATA1 = 0;
        delay_ms(dtime);
    }
    
    //clear flag bit
    PIR1bits.ADIF = 0;
    
    
    
    //step5 & go back step3
    /*
    delay at least 2tad
    ADCON0bits.GO = 1;
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
//    TRISAbits.RA2 = 0;
//    TRISAbits.RA3 = 0;
//    TRISAbits.RA4 = 0;
    dtime = 5000;
    
//    RCONbits.IPEN = 1; //set priority
    
    
    //step1
    ADCON1bits.VCFG0 = 0;
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110; //AN0 ?analog input,???? digital
    ADCON0bits.CHS = 0b0000;  //AN0 ?? analog input
    ADCON2bits.ADCS = 0b100;  //????000(1Mhz < 2.86Mhz)
    ADCON2bits.ACQT = 0b010;  //Tad = 2 us acquisition time?2Tad = 4 > 2.4
    ADCON0bits.ADON = 1;
    ADCON2bits.ADFM = 0;    //left justified 8 bit 0:255
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