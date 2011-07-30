#define DC PIND4
#define CS PIND2
#define SDA PIND6
#define RESET PIND3
#define CLK PIND5

#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))
#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))

/* 4-bit serial communication LDS183 LCD module */
const int SCOMMAND = 0;
const int SDATA = 1;

byte gr;
byte gg;
byte gb;

void lcdInit() {

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

void setPixel(byte r,byte g,byte b){
   sendData((r&248)|g>>5);
   sendData((g&7)<<5|b>>3);
}

void shiftBits(byte b, int dc) {
  
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
void sendData(byte data) {
  shiftBits(data, SDATA);
}

//send cmd
void sendCMD(byte data) {
  shiftBits(data, SCOMMAND);
}

void setXY(byte x, byte y, byte dx, byte dy) {
  sendCMD(0x2A);
  sendData(x);
  sendData(x+dx-1);

  sendCMD(0x2B);
  sendData(y);
  sendData(y+dy-1);

  sendCMD(0x2C);
}

//converts a 3*8Bit-RGB-Pixel to the 2-Byte-RGBRGB 565 Format of the Display
void setPixel2(byte r,byte g,byte b) {
   sendData((r&248)|g>>5);
   sendData((g&7)<<5|b>>3);
}

//thin dragon
double d1affine[2 * 7] = {
0.846, -0.308, 0.308, 0.846, 25, 25, 0.5,
-0.141, -0.1, 0.2, -0.141, 125, -75, 0.5};

double d2affine[2 * 7] = {
0.5, -0.5, 0.5, 0.5, 0, 0, 0.5,
-0.5, -0.5, 0.5, -0.5, 1, 0, 0.5};

//thick dragon
double d3affine[2 * 7] = {
0.824074, 0.281428, -0.212346, 0.864198, -1.882290, -0.110607, 0.8,
0.088272, 0.520988, -0.463889, -0.377778, 0.785360, 8.095795, 0.2};
    
//leaf
double laffine[4 * 7] = {
0.14,	0.01,	0.00,	0.51,	-0.08,	-1.31,	0.10,
0.43,	0.52,	-0.45,	0.50,	1.49,	-0.75,	0.35,
0.45,	-0.49,	0.47,	0.47,	-1.62,	-0.74,	0.35,
0.49,	0.00,	0.00,	0.51,	0.02,	1.62,	0.20};

//fern
double faffine[4 * 7] = {
0.00,	0.00,	0.00,	0.16,	0.00,	0.00,	0.01,
0.85,	0.04,	-0.04,	0.85,	0.00,	1.60,	0.85,
0.20,	-0.26,	0.23,	0.22,	0.00,	1.60,	0.07,
-0.15,	0.28,	0.26,	0.24,	0.00,	0.44,	0.07};

//triangle
double triangleaffine[3 * 7] = {
0.5,  0,  0,  0.5,  0,  0,  0.33,
0.5,  0,  0,  0.5,  0.5,  0.5,  0.33,
0.5,  0,  0,  0.5,  1,  0,  0.33};

//spiral
double spiralaffine[3 * 7] = {
0.787879, -0.424242, 0.242424, 0.859848, 1.758647, 1.408065, 0.90,
-0.121212, 0.257576, 0.151515,  0.053030, -6.721654, 1.377236, 0.05,
0.181818, -0.136364, 0.090909, 0.181818, 6.086107, 1.568035, 0.05};

//snowflake
double saffine[6 * 7] = {
0.382, 0, 0, 0.382, 0.309, 0.57, 0.166,
0.118, -0.3633, 0.3633, 0.118, 0.3633, 0.3306, 0.167,
0.118, 0.3633, -0.3633, 0.118, 0.5187, 0.694, 0.167,
0.309, -0.2245, 0.2245, -0.309, 0.607, 0.309, 0.167,
-0.309, 0.2245, -0.2245, -0.309, 0.7016, 0.5335, 0.167,
0.382, 0, 0, -0.382, 0.309, 0.677, 0.166};

//tree
double taffine[5 * 7] = {
0.1950, -0.4880,  0.3440, 0.4430, 0.4431, 0.2452, 0.2,
0.4620, 0.4140,  -0.2520, 0.3610, 0.2511, 0.5692,  0.2,
-0.6370, 0, 0, 0.5010, 0.8562, 0.2512, 0.2,
-0.0350,  0.0700, -0.4690, 0.0220, 0.4884, 0.5069, 0.2,
-0.0580,-0.0700,0.4530, -0.1110, 0.5976, 0.0969, 0.2};

//mandelbrot style
double maffine[2 * 7] = {
0.2020, -0.8050, -0.6890, -0.3420, -0.3730, -0.6530, 0.5,
0.1380, 0.6650, -0.5020, -0.2220, 0.6600, -0.2770, 0.5};

//Koch Curve
double kaffine[4 * 7] = {
0.333, 0, 0, 0.333, 0, 0, 0.25,
0.167, -0.289, 0.289, 0.167, 0.33, 0, 0.25,
0.167, 0.289, -0.289, 0.167, 0.5, 0.289, 0.25,
0.333, 0, 0, 0.333, 0.667, 0, 0.25};
  
double* affineTrans[] = {d1affine, d2affine, d3affine, laffine, faffine, triangleaffine, spiralaffine, saffine, taffine, maffine, kaffine};
int affineSizes[sizeof(affineTrans)/sizeof(double*)] = 
 {sizeof(d1affine), sizeof(d2affine), sizeof(d3affine), sizeof(laffine), sizeof(faffine), sizeof(triangleaffine), sizeof(spiralaffine), sizeof(saffine), sizeof(taffine), sizeof(maffine), sizeof(kaffine)};

double* affine = d1affine;
int affineSize = sizeof(*affine);

double x = 0;
double y = 0;
double offset[3];
double scale[3];
double max[3] = {0,0};
double min[3] = {4000000, 400000};
int colormesh0[128];
int generation = 50;

const int colorSize = 256;
int xcolor[colorSize];
int ycolor[colorSize];
int color[colorSize];

void setup () {
  
  for(int i = 0; i < colorSize; i++){
    xcolor[i] = 0;
    ycolor[i] = 0;
    color[i] = 0;
  }
  
  DDRD = 0x7C;
  
  lcdInit();
  
  setupScale();
  
  //random seed
  randomSeed(analogRead(0));
  
}

void setupScale(){
  for(int i = 0; i < 500; i++){
    
    int a = randomAffine();
  
    double x1 = ((getAffine(a, 0) * x) + (getAffine(a, 1) * y) + (getAffine(a, 4)));
    double y1 = ((getAffine(a, 2) * x) + (getAffine(a, 3) * y) + (getAffine(a, 5)));
    
    x = x1;
    y = y1;
    
    if(x > max[0]){
      max[0] = x;
    }
    if(y > max[1]){
      max[1] = y;
    }
    if(x < min[0]){
      min[0] = x;
    }
    if(y < min[1]){
      min[1] = y;
    }
  }
  
  scale[0] = 96 / (max[0] - min[0]);
  scale[1] = 96 / (max[1] - min[1]);
  offset[0] = 64 - scale[0] * ((max[0] + min[0]) / 2);
  offset[1] = 64 - scale[1] * ((max[1] + min[1]) / 2);
  
}

double getAffine(int x, int y){
 return (affine[(x * 7) + y]); 
}


void loop() {

    int a = randomAffine();
    
    double x1 = ((getAffine(a, 0) * x) + (getAffine(a, 1) * y) + (getAffine(a, 4)));
    double y1 = ((getAffine(a, 2) * x) + (getAffine(a, 3) * y) + (getAffine(a, 5)));
    
    if(a == 0){
      generation++;
    }
    
    x = x1;
    y = y1;
    
    drawPixel(int((x * scale[0]) + offset[0]), int((y * scale[1]) + offset[1]));
}


int randomAffine(){
  
  int rand = random(100);
  
  for(int i = 0; i < affineSize; i++){
    
    double affineProbability = getAffine(i, 6) * 100;
    
    if(rand < affineProbability){
      return i;
    }
    
    rand -= affineProbability;
    
  }
  
  return affineSize - 1;
}

void drawPixel(int x, int y) {

    if(x >= 0 && x < 128 && y >= 0 && y < 128){
	setXY(x, y, x, y);
      
        setPixel(0, 0, 255);
       
        setXY(0,0,128,128);
    }
}

int findColor(int x, int y){
 int i = 0;
  for(; i < colorSize && xcolor[i] > 0 && ycolor[i] > 0; i++){
    if(xcolor[i] == x && ycolor[i] == y){
      if(color[i] < 255){
        color[i] = color[i] + 10;
      }
      return 255;//color[i];
     
    }
  }
  
  if(i < colorSize){
    xcolor[i] = x;
    ycolor[i] = y;
    return 123;//color[i]++;
  }
 
 return 0;
}



void updatePixel(int x, int y){
   if(x >= 0 && x < 128 && y >= 0 && y < 128){
      setXY(x, y, x, y);
      int color = getIncrementColor(x,y);
      setPixel(color, 0, 0);
      setXY(0,0,128,128);
   }
}

int getIncrementColor(int x, int y){
    return ++colormesh0[x];
}
