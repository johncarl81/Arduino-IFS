#include <DirectAVRIO.h>
#include <Point.h>
#include <PointScreenTransformer.h>
#include <IFS.h>



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
  -0.15, 0.28,	0.26,	0.24,	0.00,	0.44,	0.07};

//triangle
double triangleaffine[3 * 7] = {
  0.5,  0,  0,  0.5,  0,  0,  0.33,
  0.5,  0,  0,  0.5,  0.5,  0,  0.33,
  0.5,  0,  0,  0.5,  0.25,  0.433,  0.34};

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
  -0.309, -0.2245, 0.2245, -0.309, 0.607, 0.309, 0.167,
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

double* affineTrans[] = {
  d1affine, d2affine, d3affine, laffine, faffine, triangleaffine, spiralaffine, saffine, taffine, maffine, kaffine};
int affineSizes[sizeof(affineTrans)/sizeof(double*)] = 
{
  sizeof(d1affine), sizeof(d2affine), sizeof(d3affine), sizeof(laffine), sizeof(faffine), sizeof(triangleaffine), sizeof(spiralaffine), sizeof(saffine), sizeof(taffine), sizeof(maffine), sizeof(kaffine)};

double* affine = d1affine;
int affineSize = sizeof(*affine);

DirectAVRIO renderer;
IFS ifs(affine, affineSize);
PointScreenTransformer transformer;

Point pointAllocation = Point();
Point pointAllocation2 = Point();

Point* point = &pointAllocation;
Point* drawPoint = &pointAllocation2;

double offset[3];
double scale[3];
double max[3] = {
  0,0};
double min[3] = {
  4000000, 400000};
int colormesh0[128];
int generation = 50;

const int colorSize = 256;
int xcolor[colorSize];
int ycolor[colorSize];
int color[colorSize];

void setup () {

  Serial.begin(9600);

  for(int i = 0; i < colorSize; i++){
    xcolor[i] = 0;
    ycolor[i] = 0;
    color[i] = 0;
  }

  DDRD = 0x7C;

  renderer.init();

  setupTransformer();

  //random seed
  randomSeed(analogRead(0));

}

void setupTransformer(){
  for(int i = 0; i < 1000; i++){
    transformer.train(ifs.next(point));
  }
}

void loop() {
  point = ifs.next(point);
  
  renderer.draw(transformer.transform(point, drawPoint), 0, 0, 255);
}

