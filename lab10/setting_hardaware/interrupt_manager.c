#include <xc.h>
#include <pic18f4520.h>

void INTERRUPT_Initialize (void)
{
//    ADCON1 = 0x0f;
    
//    RCONbits.IPEN = 1;      //enable Interrupt Priority mode
    INTCONbits.GIEH = 1;    //enable high priority interrupt
    INTCONbits.GIEL = 1;     //disable low priority interrupt
    INTCONbits.INT0IF = 0;
    INTCONbits.INT0IE = 1;
//    TRISBbits.TRISB0 = 1; //button
//    TRISA = 0;
//    LATA = 0;
}

