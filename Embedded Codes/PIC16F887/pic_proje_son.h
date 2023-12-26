#include <16F887.h>
#device ADC=16

#FUSES NOWDT                    //No Watch Dog Timer
#FUSES NOBROWNOUT               //No brownout reset
#FUSES NOLVP                    //No low voltage prgming, B3(PIC16) or B5(PIC18) used for I/O

#use delay(crystal=4MHz)
#use i2c(Master,Fast,sda=PIN_C4,scl=PIN_C3,Stream=I2C_LCD)

#use rs232(baud=9600, xmit=PIN_C6,rcv=PIN_C7,PARITY=E,BITS=8,STOP=1,ERRORS)

int8 get_ack_status(int8 address)
{
int8 status;

i2c_start();
status = i2c_write(address);  // Status = 0 if got an ACK
i2c_stop();

if(status == 0)
   return(TRUE);
else
   return(FALSE);
}

unsigned int8 lcd_i2c_address_find(){

      unsigned int8 i;
      unsigned int8 status;
      unsigned int8 count = 0;
      unsigned int8 addr;
      printf("\n\rStart:\n\r");
      
      delay_ms(1000);
      
      // Try all slave addresses from 0x10 to 0xEF.
      // See if we get a response from any slaves
      // that may be on the i2c bus.
      for(i=0x10; i < 0xF0; i+=2)
         {
          status = get_ack_status(i);
          if(status == TRUE)
            { 
             printf("ACK addr: %X\n\r", i);
             count++;
             delay_ms(2000);
             addr = i;
            }
         }
      
      if(count == 0)
         printf("\n\rNothing Found");
      else
         printf("\n\rNumber of i2c chips found: %u", count);
      return addr;
}


//###################################################
//####################LCD############################



unsigned int8 LCD_ADDR = 0x40 ;//             0x4E        //I2C slave address for LCD module 
byte lcd_total_rows = 4;//       2           //Number of rows: 1,2,3 or 4 
byte lcd_total_columns =20 ;//    16          //Number of columns: 1...20   

#define RS                    0b00000001  //P0 - PCF8574T Pin connected to RS 
#define RW                    0b00000010  //P1 - PCF8574T Pin connected to RW 
#define ENABLE                0b00000100  //P2 - PCF8574T Pin connected to EN 
#define LCD_BACKLIGHT         0b00001000  //P3 - PCF8574T Pin connected to BACKLIGHT LED 

#define addr_row_one          0x00        //LCD RAM address for row 1 
#define addr_row_two          0x40        //LCD RAM address for row 2 
#define addr_row_three        0x14        //LCD RAM address for row 3 
#define addr_row_four         0x54        //LCD RAM address for row 4 

#define ON                    1 
#define OFF                   0 
#define NOT                   ~ 
#define data_shifted          data<<4 
int8 new_row_request=1, BACKLIGHT_LED=LCD_BACKLIGHT; 

void lcd_backlight_led(byte bl) 
{  
      If (bl) BACKLIGHT_LED=LCD_BACKLIGHT; else BACKLIGHT_LED=OFF; 
} 

void i2c_send_nibble(byte data, byte type) 
{    
   switch (type) 
   {      
      case 0 :      
      i2c_write(data_shifted | BACKLIGHT_LED); 
      delay_cycles(1); 
      i2c_write(data_shifted | ENABLE | BACKLIGHT_LED ); 
      delay_us(2); 
      i2c_write(data_shifted & NOT ENABLE | BACKLIGHT_LED); 
      break; 
      
      case 1 : 
      i2c_write(data_shifted | RS | BACKLIGHT_LED); 
      delay_cycles(1); 
      i2c_write(data_shifted | RS | ENABLE | BACKLIGHT_LED ); 
      delay_us(2); 
      i2c_write(data_shifted | RS | BACKLIGHT_LED); 
      break; 
   } 
} 
    
void lcd_send_byte(byte data, byte type) 
   { 
        i2c_start(); 
        i2c_write(LCD_ADDR); 
        i2c_send_nibble(data >> 4 , type); 
        i2c_send_nibble(data & 0xf , type); 
        i2c_stop();        
   } 

void lcd_clear() 
{  
        lcd_send_byte(0x01,0); 
        delay_ms(2); 
        new_row_request=1; 
} 

void lcd_init(unsigned int8 __lcd_addr ) //byte ADDR,...byte col, byte row
{ 
   LCD_ADDR = __lcd_addr;
   byte i;
   byte CONST lcd_type=2;  // 0=5x7, 1=5x10, 2=2 lines 
   byte CONST LCD_INIT_STRING[4] = {0x20 | (lcd_type << 2), 0xc, 1, 6}; // These bytes need to be sent to the LCD to start it up.
   
   BACKLIGHT_LED=LCD_BACKLIGHT;
   //LCD_ADDR =ADDR;//             0x4E        //I2C slave address for LCD module 
   //lcd_total_rows =row;//       2           //Number of rows: 1,2,3 or 4 
   //lcd_total_columns= col ;
   disable_interrupts(GLOBAL); 
   delay_ms(50); //LCD power up delay 
    
   i2c_start(); 
   i2c_write(LCD_ADDR); 
      i2c_send_nibble(0x00,0); 
      delay_ms(15); 
    
   for (i=1;i<=3;++i)    
   { 
      i2c_send_nibble(0x03,0); 
      delay_ms(5); 
   }    
      i2c_send_nibble(0x02,0); 
      delay_ms(5); 
   i2c_stop(); 
    
   for (i=0;i<=3;++i) { 
   lcd_send_byte(LCD_INIT_STRING[i],0); 
   delay_ms(5); 
   } 
   lcd_clear();  //Clear Display 
   enable_interrupts(GLOBAL); 
} 

void lcd_gotoxy( byte x, byte y) 
{ 
byte row,column,row_addr,lcd_address; 
//static char data; 

   if (y>lcd_total_rows) row=lcd_total_rows; else row=y; 
  
   switch(row) 
   { 
      case 1:  row_addr=addr_row_one;     break; 
      case 2:  row_addr=addr_row_two;     break; 
      case 3:  row_addr=addr_row_three;   break; 
      case 4:  row_addr=addr_row_four;    break; 
      default: row_addr=addr_row_one;     break;  
   }  
    
   if (x>lcd_total_columns) column=lcd_total_columns; else column=x;  
   lcd_address=(row_addr+(column-1)); 
   lcd_send_byte(0x80|lcd_address,0); 
} 

//Display the character on LCD screen. 
void lcd_putc(char in_data) 
{    

  switch(in_data)
   {  
     
     case '\f': lcd_clear();                       break;
      
     case '\n': 
     new_row_request++; 
     if (new_row_request>lcd_total_rows) new_row_request=1; 
     lcd_gotoxy(1, new_row_request); 
     
     break; 
                  
     case '\b': lcd_send_byte(0x10,0);             break; 
        
     default: lcd_send_byte(in_data,1);            break;      
      
   } 
} 
