#include <xc.h>

void ADC_Initialize(void) {
    TRISAbits.RA0 = 1;       //analog input port
    TRISAbits.RA1 = 0; //output
    ADCON1bits.VCFG0 = 0;
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110;  	// Ref vtg is VDD & Configure pin as analog pin 
    ADCON0bits.CHS = 0b0000;  //AN0 ?? analog input
    ADCON2bits.ADCS = 0b100;  //????000(1Mhz < 2.86Mhz)
    ADCON2bits.ACQT = 0b010;  //Tad = 2 us acquisition time?2Tad = 4 > 2.4
    ADCON0bits.ADON = 1;
    ADCON2bits.ADFM = 0;    //left justified 8 bit 0:255
    LATA = 0;
    // ADCON2 = 0x92;  	
//    ADFM = 1 ;          // Right Justifie
//    ADCON2bits.ADCS = 7; // 
    ADRESH=0;  			// Flush ADC output Register
    ADRESL=0;  
//    PIE1bits.ADIE = 1;
//    PIR1bits.ADIF = 0;
//    INTCONbits.PEIE = 1;
    
    ADCON0bits.GO = 1;
//    ADCON0bits.ADON = 1; //enable
}

int ADC_Read(void)
{
//    int digital;
    
//    ADCON0bits.CHS =  0x07; // Select Channe7
//    ADCON0bits.GO = 1;
//    ADCON0bits.ADON = 1; //enable
    
//    while(ADCON0bits.GO==1);

//    digital = ADRESH;
    return(ADRESH);
}