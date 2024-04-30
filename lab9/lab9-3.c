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
    //do things
    /*
     256 / 16 = 16
    */
    if(value_h < 16){CCPR1L = 0x00;}//12
    else if(value_h >= 16 && value_h < 32){CCPR1L = 0x10;}//24
    else if(value_h >= 32 && value_h < 48){CCPR1L = 0x20;}//36
    else if(value_h >= 48 && value_h < 64){CCPR1L = 0x30;}//48
    else if(value_h >= 64 && value_h < 80){CCPR1L = 0x40;}//60
    else if(value_h >= 80 && value_h < 96){CCPR1L = 0x50;}//72
    else if(value_h >= 96 && value_h < 112){CCPR1L = 0x60;}//84
    else if(value_h >= 112 && value_h < 128){CCPR1L = 0x70;}//96
    else if(value_h >= 128 && value_h < 144){CCPR1L = 0x80;}//108
    else if(value_h >= 144 && value_h < 160){CCPR1L = 0x90;}//120
    else if(value_h >= 160 && value_h < 176){CCPR1L = 0xa0;}//132
    else if(value_h >= 176 && value_h < 192){CCPR1L = 0xb0;}//144
    else if(value_h >= 192 && value_h < 208){CCPR1L = 0xc0;}
    else if(value_h >= 208 && value_h < 224){CCPR1L = 0xd0;}
    else if(value_h >= 224 && value_h < 240){CCPR1L = 0xe0;}
    else {CCPR1L = 0xf0;}
    
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
    
    //step1
    ADCON1bits.VCFG0 = 0;
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110; //AN0 = analog input,???? digital
    ADCON0bits.CHS = 0b0000;  //AN0 = analog input
    ADCON2bits.ADCS = 0b100;  //1 tosc = 4Mhz = 0.25 us
    ADCON2bits.ACQT = 0b010;  //Tad = 4 tosc = 1 us > 0.7 us ; acquisition time, set 4 tad = 4*1 = 4 us > 2.4 us
    ADCON0bits.ADON = 1; //open ADC
    ADCON2bits.ADFM = 0;    //left justified 
    LATC = 0; 
    TRISC = 0;
    T2CONbits.TMR2ON = 0b1; // Timer2 -> On, prescaler -> 4
    T2CONbits.T2CKPS = 0b01;
    CCP1CONbits.CCP1M = 0b1100; // PWM mode, P1A, P1C active-high; P1B, P1D active-high
    // Set up PR2, CCP to decide PWM period and Duty Cycle
    /** 
     * PWM period
     * = (PR2 + 1) * 4 * Tosc * (TMR2 prescaler)
     * = (0xFF + 1) * 4 * 0.25µs * 4
     * = 1020 us ~= 1ms = 1000 us
     */
    PR2 = 0xff;
    /**
     * Duty cycle
     * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
     * = (0x0c*4 + 0b00) * 0.25µs * 4
     * = 50 us (1/20 of pr2)
     */
    CCPR1L = 0x00;
    CCP1CONbits.DC1B = 0b00;
    
    
    //step2 set interrupt
    PIE1bits.ADIE = 1;
    PIR1bits.ADIF = 0;
    INTCONbits.PEIE = 1;
    INTCONbits.GIE = 1;


    //step3
    ADCON0bits.GO = 1;
    
    while(1);
    
    return;
}