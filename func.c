 void send(unsigned char data);
 void gettime();
 void disp(unsigned char n); 
 void fade(unsigned char ms);
 void insert_weeks(unsigned char dy);
 void paste_time(unsigned char s);  
 void hardware_init();
 void paste_date();  
 void send(unsigned char data);
 void paste_year();
 void settime(); 
 unsigned char eeprom_write(unsigned int address, unsigned char data);
 unsigned char eeprom_read(unsigned int address);
 void read_alerts();
 void write_alerts();
 
void send(unsigned char data)
 {
SPDR=data | (sec_led<<7); //data & 0xff;
while (!(SPSR & (1 << SPIF)));
WRI; 
}

void settime() 
{
  rtc_set_time(t.hour,t.min,t.sec);  
  rtc_set_date(t.dow,t.date,t.month,t.year);  
}

 void gettime()
 {
  if(time_start){ 
  rtc_get_time(&t.hour,&t.min,&t.sec);  
  rtc_get_date(&t.dow,&t.date,&t.month,&t.year);  
  time_start=0;
  }
 } 
 
void disp(unsigned char n)
{
n = abs(n); 
send( (alph)?chars[n]:n ); 
}

 void fade(unsigned char ms)
 {
unsigned  int j=0,i=0;   
for (j=0 ; j<light_var; j++ ) { LIGHT(j); delay_ms(1);}   
for (i=0; i<ms; i++) {   gettime();  if(sec_en) paste_time(0);   delay_ms(1000); while(b_menu || !B1 || !B2); } ;  
for (j=light_var; j>0; j-- ) { LIGHT(j); delay_ms(1);}  
 }
  
void insert_weeks(unsigned char dy)
{
unsigned char i=0;
d[0]=chars[0];
d[1]=chars[dy];
for(i=0; i<2; i++) 
{
d[i+2]=weeks[dy-1][i];
} 
}

 void paste_time(unsigned char s)
 {               
 if(s) { d[0]=a.hour/10;
 d[1]=a.hour%10;
  d[2]=a.min/10; 
  d[3]=a.min%10;} else {
      d[0]=t.hour/10;
 d[1]=t.hour%10;
  d[2]=t.min/10; 
  d[3]=t.min%10;
  } 
 }  
 
 void paste_date()
 {
 d[0]=t.date/10;
d[1]=t.date%10; 
d[2]=t.month/10;
d[3]=t.month%10;  
 }  
 void paste_year(){
d[0]=2;
d[1]=0; 
d[2]=t.year/10;
d[3]=t.year%10; 
}
 void hardware_init()
 {
PORTB=0xC0;
DDRB=0x2E;
PORTC=0x00;
DDRC=0x7F;
PORTD=0x10;
DDRD=0x20;
TCCR0=0x00;
TCNT0=0x00;
TCCR1A=0x83;
TCCR1B=0x09;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x02;
OCR1BL=0x00;
ASSR=0x00;
TCCR2=0x07;
TCNT2=0x00;
OCR2=0x00;
GICR|=0x40;
MCUCR=0x02;
GIFR=0x40;
TIMSK=0x41;
UCSRB=0x00;
ACSR=0x80;
SFIOR=0x00;
ADCSRA=0x00;
SPCR=0x51;
SPSR=0; 
TWCR=0x00;
}

unsigned char eeprom_read(unsigned int address) //������� ������ �� ������� EEPROM
{
unsigned char data;                    
i2c_start();                       //������ ������� "C����" �� ���� I2C
i2c_write(Ext_EEPROM_Adr);         //������ �� ���� ����� 24LC512
i2c_write(address>>8);               //������� ���� ��������� ������������ 24LC512
i2c_write(address & 0xFF);               //������� ����
i2c_start();                       //����� �������� "�����" � ����
i2c_write(Ext_EEPROM_Adr | 1);     //���������� � 24LC512 � ������ ������, �.�. �� ������ 101000001
data=i2c_read(0);                  //��������� ������ � ���� � ��������� � ����������
i2c_stop();                        //�������� ������� "C���"
return data;                       //���������� �������� ������������
}

 
unsigned char eeprom_write(unsigned int address, unsigned char data) //������� ������ �� ������� EEPROM
{ 
i2c_start();                           //������ ������� "C����" �� ���� I2C
i2c_write(Ext_EEPROM_Adr);             //������ �� ���� ����� 24LC512
i2c_write(address>>8);                   //������� ���� ��������� ������������ 24LC512
i2c_write(address & 0xFF);                   //������� ����
if(!i2c_write(data )) return 0;  
i2c_stop();                          //�������� ������� "����"
delay_ms(5);                           //���� ���������� ����� �������� ������, EEPROM �������� �����������
return 1;
}

void read_alerts()
{
unsigned char i=0;
a.min=eeprom_read(0);
a.hour=eeprom_read(1);
a.ae=eeprom_read(2);
for (i=3; i<10; i++) a.dow[i-3]=eeprom_read(i);
t_delay=eeprom_read(10);
}

void write_alerts()
{
eeprom_write(0,a.min);
eeprom_write(1,a.hour);
eeprom_write(2,a.ae);
for (i=3; i<10; i++) eeprom_write(i, a.dow[i-3]);
eeprom_write(10,t_delay);
}