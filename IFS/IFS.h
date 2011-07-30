#ifndef IFS_H
#define IFS_H

#include <WProgram.h>
#include <Point.h>

class IFS {
public:
	IFS(double* affine, int affineSize);
	Point next(Point point);
private:
	double getAffine(int x, int y);
	int randomAffine();
	double* _affine;
	int _affineSize;
};

#endif
