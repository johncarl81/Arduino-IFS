#ifndef IFS_H
#define IFS_H

#if defined(ARDUINO) && ARDUINO >= 100
#include "Arduino.h"
#else
#include "WProgram.h"
#endif
#include <Point.h>

class IFS {
public:
	IFS(double* affine, int affineSize);
	Point* next(Point* point);
private:
	double getAffine(int x, int y);
	int randomAffine();
	double* _affine;
	int _affineSize;
};

#endif
