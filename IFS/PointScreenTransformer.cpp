#include <PointScreenTransformer.h>

PointScreenTransformer::PointScreenTransformer(){
	clearTraining();
}

void PointScreenTransformer::train(Point* point){

	_maxPoint.setX(maxDouble(point->getX(), _maxPoint.getX()));
	_maxPoint.setY(maxDouble(point->getY(), _maxPoint.getY()));
	_minPoint.setX(minDouble(point->getX(), _minPoint.getX()));
	_minPoint.setY(minDouble(point->getY(), _minPoint.getY()));

	_scalePoint.setX(96 / (_maxPoint.getX() - _minPoint.getX()));
	_scalePoint.setY(96 / (_maxPoint.getY() - _minPoint.getY()));
	_offsetPoint.setX(64 - (_scalePoint.getX() * ((_maxPoint.getX() + _minPoint.getX()) / 2)));
	_offsetPoint.setY(64 - (_scalePoint.getY() * ((_maxPoint.getY() + _minPoint.getY()) / 2)));
}

double PointScreenTransformer::maxDouble(double one, double two){
	if(one > two){
		return one;
	}
	return two;
}

double PointScreenTransformer::minDouble(double one, double two){
	if(one < two){
		return one;
	}
	return two;
}

void PointScreenTransformer::clearTraining(){
	_maxPoint.setX(-4000000);
	_maxPoint.setY(-400000);
	_minPoint.setX(4000000);
	_minPoint.setY(400000);
	_scalePoint.setX(0);
	_scalePoint.setY(0);
	_offsetPoint.setX(0);
	_offsetPoint.setY(0);
}

Point* PointScreenTransformer::transform(Point* input, Point* output){
	output->setX((input->getX() * _scalePoint.getX()) + _offsetPoint.getX());
	output->setY((input->getY() * _scalePoint.getY()) + _offsetPoint.getY());
	
	return output;
}
