#ifndef DIRECT_AVR_IO_H
#define DIRECT_AVR_IO_H

#include <WProgram.h>
#include <Point.h>

class DirectAVRIO {
public:
	DirectAVRIO();
	void init();
	void draw(Point* point, byte r, byte g, byte b);
	void setPixel(byte r,byte g,byte b);
	void setXY(byte x, byte y, byte dx, byte dy);

private: 
	void shiftBits(byte b, int dc);
	void sendData(byte data);
	void sendCMD(byte data);
	void setPixel2(byte r,byte g,byte b);
	bool withinBounds(int value);
};

#endif
