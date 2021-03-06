#include <mega8.h>
#include <delay.h>
#include <spi.h>
  #asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=6
   .equ __scl_bit=7
#endasm
#include <i2c.h>
#include <stdlib.h>
   #asm 
 .equ __w1_port=0x18 ;PORTB 
 .equ __w1_bit=0
 #endasm 
#include <1wire.h>
#include <ds18b20.h>
#include <ds1307.h>
#define WRI PORTC.1=1; PORTC.1=0; // �������
#define L1 PORTC.5
#define L2 PORTC.4
#define L3 PORTC.3
#define L4 PORTC.2
#define DS PORTD.5
#define LIGHT(D)OCR1AH=(0xFF00 & D) >> 8; OCR1AL=(0x00FF & D)
#define BEEP(D)TCCR1A=0x83 | (D<<5);
#define FAD(F)TCCR0=F;
#define B1 PINB.6
#define B2 PIND.4
#define MENU PINB.7
#define Ext_EEPROM_Adr 0b10100000   
flash unsigned char chars[] = 
{
0b00111111, // 0
0b00000110, // 1
0b01011011, // 2
0b01001111,//  3
0b01100110,//  4
0b01101101,//  5
0b01111101,//  6
0b00100111,//  7
0b01111111,//  8
0b01101111,//  9
0,        // 10 -
0b00001000,// 11 -  _
0b01011000, // 12-  c
0b00110111, // 13- n
0b01110001, // 14- f
0b00111001, // 15- C
0b00111000, // 16- L
};
flash unsigned char weeks[7][2] ={
{0b00110111,0b01110110},
{0b01111111,0b01110011},
{0b00111001,0b01110011},
{0b01100110,0b00110001},
{0b00110111,0b00111110},
{0b00111001,0b01111101},
{0b01111111,0b00111001}
};
unsigned char menu_var=0, i=0;
unsigned char d[4]= {10};
volatile unsigned char t_delay=0,step=0; 
volatile bit BEEP_DIS=0, BEEP_START=0, sec_led=0,time_start=1, alph=1,sec_en=0, b_menu=0;
volatile unsigned int light_var=1024;
typedef struct{ 
    unsigned char sec;
    unsigned char min;
    unsigned char hour; 
    unsigned char dow;
    unsigned char date;
    unsigned char month;
    unsigned char year;
}time; time t; 


typedef struct{ 
 
    unsigned char min;
    unsigned char hour;
    unsigned char ae;  
    unsigned char dow[7];
 
}alert;
alert a={0};  
#include <func.c> 
 
interrupt [EXT_INT0] void ext_int0_isr(void)
{  
sec_led=(sec_led^1) & sec_en;
time_start=1;
if(a.ae) if( a.dow[t.dow-1] && t.hour==a.hour && !BEEP_START) {  if( t.min==a.min  && !BEEP_DIS && !b_menu)  { BEEP_START=1;} }  else  BEEP_DIS=0;
if(BEEP_START) if(t.min > a.min+5 || (!B1&&!B2) || t.hour!=a.hour || !a.dow[t.dow-1] || !a.ae) { BEEP_START=0; BEEP(0);  BEEP_DIS=1;}
}

interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
send(0);
L1=L2=L3=L4=0;
switch (step)
{
case 0: L1=1; L2=L3=L4=0; break;
case 1: L2=1; L1=L3=L4=0; break;
case 2: L3=1; L1=L2=L4=0; break;
case 3: L4=1; L1=L2=L3=0; break;
}
disp(d[step]) ; 
step=(step<3)?(step+1):0;
}
 interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{


if(BEEP_START) { i=(i>128)?0:(i+1); if(i% ( 12/( (t.min - a.min)+1 )) ==0)  { BEEP(1); } else  BEEP(0); } 
if(!MENU && B1 && B2) { 

FAD(4);
menu_var++;
delay_ms(300);
sec_en=sec_led=0;
b_menu=alph=1;
 } 
  if(!B1 && !B2 && !MENU)#asm("RJMP 0"); 
if(!b_menu && MENU) {
 if(!B1)  light_var = (light_var>=1023)?1023:(light_var+8);  
if(!B2)  light_var = (light_var<=8)?0:(light_var-8); 
if(!B1 || !B2)  {
alph=1; 
d[0]=( (int) light_var/100 ) /10;
d[1]=( (int) light_var/100 ) %10;
d[2]=( (int) light_var%100 ) /10;
d[3]=( (int) light_var%100 ) %10;
LIGHT(light_var);
 }
} 
if(!MENU && !B1 && B2) {a.ae=1; d[0]=0;d[1]=13;d[2]=10;d[3]=10;write_alerts(); } 
if(!MENU && B1 && !B2) {a.ae=0; d[0]=0;d[1]=14;d[2]=14;d[3]=10;write_alerts();}  
if(menu_var) switch (menu_var)
{
case 1: if(!B1){t.hour=t.hour>=23?0:t.hour+1;} if(!B2){t.hour=t.hour<=0?23:t.hour-1;}   paste_time(0); d[2]=d[3]=10;     break;
case 2: if(!B1){t.min=t.min>=59?0:t.min+1;} if(!B2){t.min=t.min<=0?59:t.min-1;}  paste_time(0);  d[0]=d[1]=10;     break;
case 3: if(!B1){t.dow=t.dow>=7?1:t.dow+1;} if(!B2){t.dow=t.dow<=1?7:t.dow-1;}  d[0]=0; d[1]=t.dow;     d[2]=d[3]=10;  break;
case 4: if(!B1){t.date=t.date>=31?0:t.date+1;} if(!B2){t.date=t.date<=1?31:t.date-1;}   paste_date(); d[2]=d[3]=10;     break;
case 5: if(!B1){t.month=t.month>=12?1:t.month+1;} if(!B2){t.month=t.month<=1?12:t.month-1;}  paste_date();  d[0]=d[1]=10;     break;
case 6: if(!B1){t.year=t.year>=50?12:t.year+1;} if(!B2){t.year=t.year<=12?50:t.year-1;}  paste_year();      break;

case 7: if(!B1){t_delay=t_delay>=99?1:t_delay+1;} if(!B2){t_delay=t_delay<=1?99:t_delay-1;} d[0]=15;d[1]=16;d[2]=t_delay/10;d[3]=t_delay%10;   break;

case 8: if(!B1) a.ae=1; if(!B2) a.ae=0;  if(a.ae) {d[0]=0;d[1]=13;d[2]=10;d[3]=10;} else {d[0]=0;d[1]=14;d[2]=14;d[3]=10;}  break;

case 9:  if(!B1){a.hour=a.hour>=23?0:a.hour+1;} if(!B2){a.hour=a.hour<=0?23:a.hour-1;}   paste_time(1); d[2]=d[3]=10;     break;
case 10: if(!B1){a.min=a.min>=59?0:a.min+1;} if(!B2){a.min=a.min<=0?59:a.min-1;}  paste_time(1);  d[0]=d[1]=10;     break;

case 11:   if(!B1) a.dow[0]=1;if(!B2) a.dow[0]=0;  d[0]=0; d[1]=1; d[2]=0; d[3]=a.dow[0];    break;
case 12:   if(!B1) a.dow[1]=1;if(!B2) a.dow[1]=0;  d[0]=0; d[1]=2; d[2]=0; d[3]=a.dow[1];    break;
case 13:   if(!B1) a.dow[2]=1;if(!B2) a.dow[2]=0;  d[0]=0; d[1]=3; d[2]=0; d[3]=a.dow[2];    break;
case 14:   if(!B1) a.dow[3]=1;if(!B2) a.dow[3]=0;  d[0]=0; d[1]=4; d[2]=0; d[3]=a.dow[3];    break;
case 15:   if(!B1) a.dow[4]=1;if(!B2) a.dow[4]=0;  d[0]=0; d[1]=5; d[2]=0; d[3]=a.dow[4];    break;
case 16:   if(!B1) a.dow[5]=1;if(!B2) a.dow[5]=0;  d[0]=0; d[1]=6; d[2]=0; d[3]=a.dow[5];    break;
case 17:   if(!B1) a.dow[6]=1;if(!B2) a.dow[6]=0;  d[0]=0; d[1]=7; d[2]=0; d[3]=a.dow[6];    break;

case 18: menu_var=b_menu=0; t.sec=0; settime(); write_alerts();  #asm("RJMP 0");  break;
}
 
 
}
 
void main(void)
{
signed int temper=0;
unsigned char count=0;
 
hardware_init(); 
LIGHT(0);  
send(0);          
 
i2c_init();  
rtc_init(0,1,0);  
 
w1_init();  
DS=1; ds18b20_init(0,-30,80,DS18B20_9BIT_RES);  DS=0;    
FAD(3); 
 read_alerts(); 
#asm("sei") 
 
sec_led=1; 
d[0]=d[1]=d[2]=d[3]=8;
fade(1);
 
while (1)
      {  
gettime();  
count=0; 
DS=1;while(  (temper=(int)ds18b20_temperature(0)) && (temper<-30 || temper>80) && count++<200 ) delay_ms(50);  DS=0;  
d[2]=12;
d[3]=10;
d[0]=temper/10;
d[1]=temper%10;   
fade(1);
 
sec_en=1; 

paste_time(0);  
fade(t_delay);
sec_en=sec_led=0;
  
insert_weeks(t.dow);
alph=0;
fade(1);
alph=1;          
         
paste_date(); 
fade(1);
        
paste_year();  
fade(1);

if(( ( a.dow[t.dow-1]  && (a.hour>=t.hour  && a.min>=t.min  ) )
 ||  a.dow[ (t.dow>7)?0:t.dow ] ) && a.ae ) 
{
 d[0]=0;
 d[1]=13;
 d[2]=10;
 d[3]=10;
 fade(1);
paste_time(1);  
fade(1);

}

     }
}
