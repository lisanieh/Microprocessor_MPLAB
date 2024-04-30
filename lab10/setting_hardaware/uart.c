#include <xc.h>
    //setting TX/RX


char mystring[20];
int lenStr = 0;

void UART_Initialize() {
           
//    LATA = 0;
//    LATC = 0;
    /*       TODObasic   
           Serial Setting      
        1.   Setting Baud rate
        2.   choose sync/async mode 
        3.   enable Serial port (configures RX/DT and TX/CK pins as serial port pins)
        3.5  enable Tx, Rx Interrupt(optional)
        4.   Enable Tx & RX
           
    TRISCbits.TRISC6 = ;            
    TRISCbits.TRISC7 = ;            
    
    //  Setting baud rate
    TXSTAbits.SYNC = ;           
    BAUDCONbits.BRG16 = ;          
    TXSTAbits.BRGH = ;
    SPBRG = ;      
    
   //   Serial enable
    RCSTAbits.SPEN = ;              
    PIR1bits.TXIF = ;
    PIR1bits.RCIF = ;
    TXSTAbits.TXEN = ;           
    RCSTAbits.CREN = ;             
    PIE1bits.TXIE = ;       
    IPR1bits.TXIP = ;             
    PIE1bits.RCIE = ;              
    IPR1bits.RCIP = ;    
    */  
    //lab10-1
//    TRISCbits.TRISC6 = 1;   //input         
//    TRISCbits.TRISC7 = 1; 
//    
//    TXSTAbits.SYNC = 0;           
//    BAUDCONbits.BRG16 = 0;          
//    TXSTAbits.BRGH = 0;
//    SPBRG = 103;  
//    
//    RCSTAbits.SPEN = 1;     //enable asynchronous  
//    PIR1bits.TXIF = 1; //empty at first
//    PIR1bits.RCIF = 0; //no data at first
//    TXSTAbits.TXEN = 1;   //enable transmitter     
//    RCSTAbits.CREN = 1; //enable receiver        
//    PIE1bits.TXIE = 0; //no interrupt (busy waiting)       
//    IPR1bits.TXIP = 0; //no priority      
//    PIE1bits.RCIE = 0; // no interrupt (busy waiting)              
//    IPR1bits.RCIP = 0;  //no priority  
    
    //lan10-2
    TRISCbits.TRISC6 = 1;    //input        
    TRISCbits.TRISC7 = 1; 
    
    TXSTAbits.SYNC = 0;           
    BAUDCONbits.BRG16 = 0;          
    TXSTAbits.BRGH = 0;
    SPBRG = 51;  
    
    RCSTAbits.SPEN = 1;     //enable asynchronous  
    PIR1bits.TXIF = 1; //empty at first
    PIR1bits.RCIF = 0; //no data at first
    TXSTAbits.TXEN = 1;   //enable transmitter     
    RCSTAbits.CREN = 1; //enable receiver        
    PIE1bits.TXIE = 1; //has interrupt    
    IPR1bits.TXIP = 1; //high priority      
    PIE1bits.RCIE = 1; // no interrupt (busy waiting)              
    IPR1bits.RCIP = 1;  //high priority  
    }

void UART_Write(unsigned char data)  // Output on Terminal
{
    while(!TXSTAbits.TRMT);
    TXREG = data;              //write to TXREG will send data 
}


void UART_Write_Text(char* text) { // Output on Terminal, limit:10 chars
    for(int i=0;text[i]!='\0';i++){
        if(text[i] != '\r') UART_Write(text[i]);
    else {
        UART_Write('\n');
        UART_Write('\r');
    }
    }
}

void ClearBuffer(){
    for(int i = 0; i < 10 ; i++)
        mystring[i] = '\0';
    lenStr = 0;
}

void MyusartRead()
{
    /* TODObasic: try to use UART_Write to finish this function */
    //lab10-1
    while(!PIR1bits.RCIF);
    if(RCREG != '\r') UART_Write(RCREG);
    else {
        UART_Write('\n');
        UART_Write('\r');
    }
//    PIR1bits.RCIF = 0;
    
    //lab10-2
    
    return ;
}

char *GetString(){
    return mystring;
}


// void interrupt low_priority Lo_ISR(void)
void __interrupt(low_priority)  Lo_ISR(void)
{
    if(RCIF)
    {
        if(RCSTAbits.OERR)
        {
            CREN = 0;
            Nop();
            CREN = 1;
        }
        
        MyusartRead();
    }
    
   // process other interrupt sources here, if required
    return;
}