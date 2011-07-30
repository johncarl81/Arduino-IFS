#ifndef PCT_H
#define PCT_H

#include <WProgram.h>
#include <Point.h>

class PointScreenTransformer {
public:
	PointScreenTransformer();
	void train(Point* point);
	void clearTraining();
	Point* transform(Point* input, Point* output);
	Point _maxPoint, _minPoint, _scalePoint, _offsetPoint; 
private:
	double maxDouble(double a, double b);
	double minDouble(double a, double b);
	
};

#endif
