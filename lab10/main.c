#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include "stdio.h"
#include "string.h"
// using namespace std;
#define _XTAL_FREQ 1000000

char str[20];

int state;

void delay_ms(unsigned int milliseconds) {
   while(milliseconds > 0) {
      milliseconds--;
       __delay_us(990);
   }
}

void Mode1(){   // Todo : Mode1 
    while(INTCONbits.INT0IF == 0){
        CCPR1L = 0x62;
        while(CCPR1L > 0x52){
            if(INTCONbits.INT0IF == 1) break;
            __delay_ms(10);
//            CCPR1L += 0x01;
            if(CCP1CONbits.DC1B != 0b00){
                CCP1CONbits.DC1B -= 0b01;
            }
            else{
                CCP1CONbits.DC1B = 0b11;
                CCPR1L -= 0x01;
            }
        }
    }
}
void Mode2(){   // Todo : Mode2 
    while(INTCONbits.INT0IF == 0){
        CCPR1L = 0x52;
        __delay_ms(100);
        CCPR1L = 0x62;
        __delay_ms(100);
    }
}
void main(void) 
{
    SYSTEM_Initialize() ;
    //interrupt
    ADCON1 = 0x0f;
    state = 1;
//    TRISA = 0x00;
//    LATA = 0x00; //counter
    TRISBbits.RB0 = 1;
    RCONbits.IPEN = 0;
    INTCONbits.INT0F = 0;
    INTCONbits.INT0E = 1;
    INTCONbits.GIE = 1;
    
    // Timer2 -> On, prescaler -> 16
    T2CONbits.TMR2ON = 0b1;
    T2CONbits.T2CKPS = 0b11;

    // Internal Oscillator Frequency, Fosc = 4MHz, Tosc = 0.25 탎
    OSCCONbits.IRCF = 0b110;
    
    // PWM mode, P1A, P1C active-high; P1B, P1D active-high
    CCP1CONbits.CCP1M = 0b1100;
    
    // CCP1/RC2 -> Output
    TRISCbits.TRISC2 = 0;
    LATC = 0;
    
    // Set up PR2, CCP to decide PWM period and Duty Cycle
    /** 
     * PWM period
     * = (PR2 + 1) * 4 * Tosc * (TMR2 prescaler)
     * = (0x9b + 1) * 4 * 0.25탎 * 16
     * = 0.019968s ~= 20ms
     */
    PR2 = 0x4e;
    
    /**
     * Duty cycle
     * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
     * = (0x0b*4 + 0b01) * 0.25탎 * 16
     * = 0.00144s ~= 1450탎
     */
    /**
     * -90 = 0x03 = 0x52
     * -45 = 0x07 = 0x56
     * 0 = 0x0b = 0x5a
     * 45 = 0x0e = 0x5d
     * 90 = 0x13  = 0x62
     */
    CCPR1L = 0x5a;
    CCP1CONbits.DC1B = 0b01;
    
//    Mode2();
    str[0] = 'm';
    str[1] = 'o';
    str[2] = 'd';
    str[3] = 'e';
    str[4] = 'l';
    str[5] = state + '0';
    str[6] = '\r';
    str[7] = '\0';
    UART_Write_Text(str);
//    UART_Write('0');
    while(1) {
        //lab10-1
//        MyusartRead();
        
        
//        strcpy(str, GetString()); // TODO : GetString() in uart.c
//        if(str[0]=='m' && str[1]=='1'){ // Mode1
//            Mode1();
//            ClearBuffer();
//        }
//        else if(str[0]=='m' && str[1]=='2'){ // Mode2
//            Mode2();
//            ClearBuffer();  
//        }
    }
    return;
}

void __interrupt(high_priority) Hi_ISR(void)
{
    if(INTCONbits.INT0IF == 1){
        if(state == 1){
            state = 2;
            //add string
            str[0] = 'm';
            str[1] = 'o';
            str[2] = 'd';
            str[3] = 'e';
            str[4] = 'l';
            str[5] = state + '0';
            str[6] = '\r';
            str[7] = '\0';
            UART_Write_Text(str);
//            __delay_ms(500);
            INTCONbits.INT0IF = 0;
            Mode1();
        }
        else{
            state = 1;
            //add string
            str[0] = 'm';
            str[1] = 'o';
            str[2] = 'd';
            str[3] = 'e';
            str[4] = 'l';
            str[5] = state + '0';
            str[6] = '\r';
            str[7] = '\0';
            UART_Write_Text(str);
//            __delay_ms(500);
            INTCONbits.INT0IF = 0;
            Mode2();
        }
//        INTCONbits.INT0IF = 0;
    }
    
    //add string
    str[0] = 'm';
    str[1] = 'o';
    str[2] = 'd';
    str[3] = 'e';
    str[4] = 'l';
    str[5] = state + '0';
    str[6] = '\r';
    str[7] = '\0';
    
    UART_Write_Text(str);
    __delay_ms(500);
    INTCONbits.INT0IF = 0;
    
    //step5 & go back step3
    /*
    delay at least 2tad
    ADCON0bits.GO = 1;
    */
//    __delay_us(2);
//    ADCON0bits.GO = 1;
    
    return;
}