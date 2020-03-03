#include <iostream>
#include "support.cpp"
using namespace std;
extern string dec2hex(int dec);

class color{
	private:
		int rgb[3];
	public:
		color(int r,int g,int b);
		int* get();
		color operator+(const color& b){
			color a(
				(this->rgb[0]+b.rgb[0])/2,
				(this->rgb[1]+b.rgb[1])/2,
				(this->rgb[2]+b.rgb[2])/2
				);
			return a;
		};
		color operator*(const color& b){
			(min(this->rgb[0]+b.rgb[0],255));
			(min(this->rgb[1]+b.rgb[1],255));
			(min(this->rgb[2]+b.rgb[2],255));
		};
		string gethex();
};
int* color::get(){
	//cout << endl << "get1: " << this -> rgb[0] <<"	"<< this -> rgb[1] <<"	"<< this -> rgb[2] << endl;
	return rgb;
};
string color::gethex(){
	string rs = dec2hex(rgb[0]);
	string gs = dec2hex(rgb[1]);
	string bs = dec2hex(rgb[2]);
	return rs+gs+bs;
};
color::color(int r=0,int g=0,int b=0){
	//cout << "constructor 1:" << r <<"	"<< g <<"	"<< b << endl;
	this -> rgb[0] = r;
	this -> rgb[1] = g;
	this -> rgb[2] = b;
	//cout << "constructor 2:"<< this -> rgb[0] <<"	"<< this -> rgb[1] <<"	"<< this -> rgb[2] << endl << endl;
};
//color puregreen (0,255,0);
//color pureblue  (0,0,255);
//color purered   (255,0,0);

//color green (20,230,20);
color blue  (20,20,230);
//color red   (230,20,20);
