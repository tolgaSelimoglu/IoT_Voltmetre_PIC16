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
       
