#ifndef POINT_H
#define POINT_H

#include <WProgram.h>

class Point {
public:
	Point(){_x = 0; _y = 0;};
	Point(double x, double y){_x = x; _y = y;}
	double getX(){return _x;}
	void setX(double x){_x = x;}
	double getY(){return _y;}
	void setY(double y){_y = y;}

private:
	double _x, _y;
};

#endif
