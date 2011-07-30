#include "DirectAVRIO.h"
#include "Point.h"

#define DC PIND4
#define CS PIND2
#define SDA PIND6
#define RESET PIND3
#define CLK PIND5

#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))
#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))
     
const int SCOMMAND = 0;
const int SDATA = 1;

byte gr;
byte gg;
byte gb;
    
DirectAVRIO::DirectAVRIO(){}

void DirectAVRIO::init(){
        
  cbi(PORTD, CS);
  cbi(PORTD, SDA);
  sbi(PORTD, CLK);

  sbi(PORTD, RESET);
  cbi(PORTD, RESET);
  sbi(PORTD, RESET);

  sbi(PORTD, CLK);
  sbi(PORTD, SDA);
  sbi(PORTD, CLK);

  //delay(10);

  //Software Reset
  sendCMD(0x01);

  // Write Contrast
  sendCMD(0x25);
  sendData(64);

  //Sleep Out and booster on
  sendCMD(0x11);

  // Booster on
  //sendCMD(0x03);

  //delay(10);

  // Display Inversion off
  sendCMD(0x20);

  // Idle Mode off
  sendCMD(0x38);

  // Display on
  sendCMD(0x29);

  // Normal Mode on
  sendCMD(0x13);

  // Memory Data Access control
  sendCMD(0x36);
  sendData(0x60);
  // sendData(0x00);
  //sendData(8|128);

  sendCMD(0x3A);
  sendData(5);   //16-Bit per Pixel

  // Color set
  // sendCMD(0x2D);
  // sendDATA(0x00);

  // X_Address or Column Address Area
  sendCMD(0x2A);
  sendData(0);
  sendData(127);

  // Frame Frequency Select
  sendCMD(0xB4);
  sendData(0x03);
  sendData(0x08);
  sendData(0x0b);
  sendData(0x0e);

  // Display Control
  sendCMD(0xBA);
  sendData(0x07);
  sendData(0x0D);

  //Page Adress Set
  sendCMD(0x2B);
  sendData(0);
  sendData(127);

  //Memory Write
  sendCMD(0x2C);

  // black background
  for(int m = 0; m < 128; m++){
    for (int i=0; i<128; i++) {
      setPixel(0,0,0);
    }
  }
  //Memory Write
  sendCMD(0x2C);
}
 
 
void DirectAVRIO::draw(Point point, byte r, byte g, byte b){
	setXY(point.getX(), point.getY(), point.getX(), point.getY());
	setPixel(r,g,b);
	setXY(0, 0, 128, 128);
}     
     
void DirectAVRIO::setPixel(byte r,byte g,byte b){
  sendData((r&248)|g>>5);
  sendData((g&7)<<5|b>>3);
}

void DirectAVRIO::shiftBits(byte b, int dc) {
  cbi(PORTD, CLK);
  if ((b&128)!=0)
    sbi(PORTD, SDA);
  else
    cbi(PORTD, SDA);
  sbi(PORTD, CLK);

  cbi(PORTD, CLK);
  if ((b&64)!=0)
    sbi(PORTD, SDA);
  else
    cbi(PORTD, SDA);
  sbi(PORTD, CLK);

  cbi(PORTD, CLK);
  if ((b&32)!=0)
    sbi(PORTD, SDA);
  else
    cbi(PORTD, SDA);
  sbi(PORTD, CLK);

  cbi(PORTD, CLK);
  if ((b&16)!=0)
    sbi(PORTD, SDA);
  else
    cbi(PORTD, SDA);
  sbi(PORTD, CLK);

  cbi(PORTD, CLK);
  if ((b&8)!=0)
    sbi(PORTD, SDA);
  else
    cbi(PORTD, SDA);
  sbi(PORTD, CLK);

  cbi(PORTD, CLK);
  if ((b&4)!=0)
    sbi(PORTD, SDA);
  else
    cbi(PORTD, SDA);
  sbi(PORTD, CLK);

  cbi(PORTD, CLK);
  if ((b&2)!=0)
    sbi(PORTD, SDA);
  else
    cbi(PORTD, SDA);
  sbi(PORTD, CLK);

  cbi(PORTD, CLK);
  if ((b&1)!=0)
    sbi(PORTD, SDA);
  else
    cbi(PORTD, SDA);
  if (dc == SDATA)
    sbi(PORTD, DC);
  else        
    cbi(PORTD, DC);
  sbi(PORTD, CLK);
}

//send data
void DirectAVRIO::sendData(byte data) {
  shiftBits(data, SDATA);
}

//send cmd
void DirectAVRIO::sendCMD(byte data) {
  shiftBits(data, SCOMMAND);
}

void DirectAVRIO::setXY(byte x, byte y, byte dx, byte dy) {
  sendCMD(0x2A);
  sendData(x);
  sendData(x+dx-1);

  sendCMD(0x2B);
  sendData(y);
  sendData(y+dy-1);

  sendCMD(0x2C);
}

//converts a 3*8Bit-RGB-Pixel to the 2-Byte-RGBRGB 565 Format of the Display
void DirectAVRIO::setPixel2(byte r,byte g,byte b) {
  sendData((r&248)|g>>5);
  sendData((g&7)<<5|b>>3);
}
