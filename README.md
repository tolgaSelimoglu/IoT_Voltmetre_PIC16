# PicOxilosscope

IoT Multimeter using ESP32 & PIC16F887

# Schematic

![Schematic](/Hardware%20Design/Schematic.png)

# PCB Design

![Bottom_Layer](/Hardware%20Design/PCB_Bottom_Layer.png)

![3D](/Hardware%20Design/PCB_3D.png)

# Firebase 

![Firebase_interface](/Mobile%20App/firebase_1.jpg)

# Mobile App

![MobileApp_interface_1](/Mobile%20App/mobil_11.jpg)

![MobileApp_interface_2](/Mobile%20App/mobil_12.jpg)

![MobileApp_interface_3](/Mobile%20App/mobil_13.jpg)



# Reel Photos

![Top ](/Hardware%20Design/reel_foto_1.jpg)

![Top ](/Hardware%20Design/reel_foto_2.jpg)

![Bottom ](/Hardware%20Design/reel_foto_1.jpg)

# PIC16 Embed Codes 

## C File

```c
    #include <pic_proje_son.h>
 
#define R1 3000
#define R2 1200
#define R3 200
#define R4 220    //resistor variables



enum ranges {
   AN0_SELECT  =  0, 
   AN1_SELECT  =  1,
   AN2_SELECT  =  2,
   AN3_SELECT  =  3   
};
typedef struct{
   float AN0_value   ;

   float AN1_value ;

   float AN2_value;
 
   float AN3_value   ;
} analog_datas_array ;

analog_datas_array analog_datas;

typedef struct {
    int value : 2; // 2 bitlik bir alan
} auto_range;

void lcd_print_value(float x){
   printf(lcd_putc, "\fValue = %f" , x);
}

int read_analog_channels(){
   float a = 0.0; 
   delay_us(100);
   set_adc_channel(0);
   delay_us(100);
   a = read_adc();
   if (a < 58900){
   analog_datas.AN0_value = a*5/65536;
   delay_us(100);
   return 0;
   }else{
       set_adc_channel(1);
       delay_us(100);
       a = read_adc();
       if(a < 58900){
            analog_datas.AN1_value = a*5/65536;
            delay_us(100);
            return 1;
       }else{
             set_adc_channel(2);
       delay_us(100);
       a = read_adc();
       if(a < 58900){
            analog_datas.AN2_value = a*5/65536;
            delay_us(100);
            return 2 ;
            }else{
                   set_adc_channel(3);
                   delay_us(100);
                   a = read_adc();
                   if(a < 58900){
                        analog_datas.AN3_value = a*5/65536;
                        delay_us(100);
                        return 3;
            }else{
               return 4;
            }
       }
   }

}
}


float amp2=0;

float map(float x, float in_min, float in_max, float out_min, float out_max) {
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}


float interpolation(float x, float a , float b , float c, float d){ //ax^3+bx^2+cx+d = 0
   float output = a*x*x*x + b*x*x +c*x+d ;
   return output;
}
float voltage = 0.0;
float voltage_prev = 0.0;
float amper_prev =0.0;

unsigned int8 lcd_addr_find ;

float deger_amp = 0;
float prev_amp = 0;


  // void amp_func       
void main()
{
   lcd_addr_find = lcd_i2c_address_find();
   setup_adc_ports(sAN0|sAN1|sAN2|sAN3|sAN4);
   setup_adc(ADC_CLOCK_DIV_2);
   lcd_init(lcd_addr_find);
   lcd_putc("GR17 LCD TEST");
   delay_ms(500);
   int x = 0;

   while(1){
   
          x = read_analog_channels(); // analog_datas structina deger atanir.
         delay_us(10);
    
        if(x==0){
               voltage = analog_datas.AN0_value;       
      }
        
       else if(x==1){
               voltage = analog_datas.AN1_value;
               //voltage = voltage*R1/(R2+R3+R4)*1.54;
               //voltage = map(voltage, 1.58,3.49,4.5,13);
               voltage = map(voltage, 3.42,4.24,5.48,6.88);
              // voltage = interpolation(voltage, 0.343106, (-3.41583),14.0275,(-11.9987));
      }
         
        else if(x==2){
               voltage = analog_datas.AN2_value;
               //voltage = voltage*(R1+R2)/(R3+R4)*1.76*0.63;
               
               voltage = interpolation(voltage, 0.0944675, (-0.846445),6.7373,(-2.76416));
               voltage = map(voltage, 0 , 13,0,9);
      }
         
        else if(x==3){
               voltage = analog_datas.AN3_value;
               //voltage = voltage*(R1+R2+R3)/(R4);
               voltage = interpolation(voltage, 4.68481, (-42.6179),137.434,(-129.642));
   
         }
         else{
         printf(lcd_putc,"\fhatali deger");
         delay_ms(300);
         }
// Amperr //
        delay_ms(100);
        set_adc_channel(4);
        delay_ms(10);
        deger_amp = read_adc();
        deger_amp = map(deger_amp, 0, 64192, 0, 30);
         
        
         if(voltage != voltage_prev ||deger_amp != prev_amp ){
         lcd_gotoxy(1,1);
            printf(lcd_putc, "\fVoltage = %f \n", voltage); 
            printf(lcd_putc,"amper=%f",deger_amp);
            
            delay_ms(100);
            
            printf("Voltage = %f \n", voltage);
            printf("Amper = %f \n" , deger_amp);
            printf("x = %i \n", x);
             prev_amp = deger_amp;
            voltage_prev = voltage;
         }
         



       

   }
   }
       

```

## H File

```h

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

```

# ESP32 Files

## CPP Main file 

```cpp




#include <Arduino.h>
#if defined(ESP32)
  #include <WiFi.h>
#elif defined(ESP8266)
  #include <ESP8266WiFi.h>
#endif
#include <Firebase_ESP_Client.h>

#include <WiFiManager.h>
//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Insert your network credentials
#define WIFI_SSID "Tolga"
#define WIFI_PASSWORD "skylabharika"

  //API KEY = AIzaSyBkTU_Nxw6zlUKAES_fkq4OqwsKCTKuVbE
  // Api id: 1:211940387045:android:f17c46006e635d78a98c0c
  //Project id = picoxiloscope.firebaseio.com
// Insert Firebase project API Key
#define API_KEY "AIzaSyBkTU_Nxw6zlUKAES_fkq4OqwsKCTKuVbE"

#define PROJECT_ID "picoxiloscope"

// Insert RTDB URLefine the RTDB URL */
#define DATABASE_URL "https://picoxiloscope-default-rtdb.firebaseio.com/" 

//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
int count = 0;
bool signupOK = false;

/****************************************
 * SETUP
****************************************/
void setup(){
  WiFiManager wm;

  Serial.begin(115200); // Serial for debugging purposes
  Serial2.begin(9600); // Serial1 for ESP32 RX: 16, TX: 17

  bool res;
    // res = wm.autoConnect(); // auto generated AP name from chipid
    // res = wm.autoConnect("AutoConnectAP"); // anonymous ap
    res = wm.autoConnect("AutoConnectAP","password"); // password protected ap

    if(!res) {
        Serial.println("Failed to connect");
        // ESP.restart();
    } 
    else {
        //if you get here you have connected to the WiFi    
        Serial.println("connected...yeey :)");
    }
  /*
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();*/

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Sign up */
  if (Firebase.signUp(&config, &auth, "", "")){
    Serial.println("ok");
    signupOK = true;
  }
  else{
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

struct multimeter{
  float voltage;
  float amper;
  float range;
};

struct multimeter multimeter;
/****************************************
 * LOOP
****************************************/
void loop(){
  // Firebase e sürekli random data gönderiyoruz
     /*
        Seri haberleşmeden gelen veriler su sekilde :

        Voltage = 0.00
        Amper = 0.00

        Buna gore parser kodu asagidaki gibi olacak
   */

    delay(100);

    //TEST KODU
    /*while(1){   
       if (Serial2.available() > 0){
        Serial.println("Serial1 available");
  
        Serial.println(Serial2.readStringUntil('\n'));
    }
    }*/
    //TEST KODU

         /*
        Seri haberleşmeden gelen veriler su sekilde :

        Voltage = 0.00
        Amper = 0.00

        Buna gore parser kodu asagidaki gibi olacak
   */
    if (Serial2.available() > 0){
        Serial.println("Serial1 available");
        String data = Serial2.readStringUntil('\n');
        Serial.println(data);
        int index = data.indexOf("=");
        String voltage = data.substring(index+1, data.indexOf("\n"));
        Serial.println(voltage);
        multimeter.voltage = voltage.toFloat();
        Serial.println(multimeter.voltage);
        Serial.println("Voltage ok");
        data = Serial2.readStringUntil('\n');
        Serial.println(data);
        index = data.indexOf("=");
        String amper = data.substring(index+1, data.indexOf("\n"));
        Serial.println(amper);
        multimeter.amper = amper.toFloat();
        Serial.println(multimeter.amper);
        Serial.println("Amper ok");

        data = Serial2.readStringUntil('\n');
        Serial.println(data);
        index = data.indexOf("=");
        String range = data.substring(index+1, data.indexOf("\n"));
        Serial.println(range);
        multimeter.range = range.toFloat();
        Serial.println(multimeter.range);
        Serial.println("Range ok");
        
    
        
        
  if (Firebase.ready() && signupOK ){ // Sürekli random data gönderiyoruz
    // Write an Float number on the database path test/float



    if (Firebase.RTDB.setFloat(&fbdo, "voltage", multimeter.voltage)){
      Serial.println("PASSED");
      Serial.print("PATH: ");
      Serial.println(fbdo.dataPath());
      Serial.print("TYPE: ");
      Serial.println(fbdo.dataType());
      Serial.println(multimeter.voltage);
     
    }
    else {
      Serial.println("FAILED");
      Serial.print("REASON: ");
      Serial.println(fbdo.errorReason());
    }
    if (Firebase.RTDB.setFloat(&fbdo, "ampere", multimeter.amper)){
      Serial.println("PASSED");
      Serial.print("PATH: ");
      Serial.println(fbdo.dataPath());
      Serial.print("TYPE: ");
      Serial.println(fbdo.dataType());
      Serial.println(multimeter.amper);
     
    }
  }
  else{
    Serial.println("Bağlantı yok");
  }
    }
}

```