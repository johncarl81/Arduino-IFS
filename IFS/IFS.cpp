#include <IFS.h>

IFS::IFS(double* affine, int affineSize){
	_affine = affine;
	_affineSize = affineSize;
}

Point* IFS::next(Point* input){
	int a = randomAffine();

	double x = ((getAffine(a, 0) * input->getX()) + (getAffine(a, 1) * input->getY()) + (getAffine(a, 4)));
    double y = ((getAffine(a, 2) * input->getX()) + (getAffine(a, 3) * input->getY()) + (getAffine(a, 5)));
    
    input->setX(x);
    input->setY(y);
    
    return input;
}

double IFS::getAffine(int x, int y){
  return _affine[(x * 7) + y]; 
}

int IFS::randomAffine(){
  int rand = random(100);

  for(int i = 0; i < _affineSize; i++){

    double affineProbability = getAffine(i, 6) * 100;

    if(rand < affineProbability){
      return i;
    }

    rand -= affineProbability;
  }

  return _affineSize - 1;
}
