#include <iostream>
#include <stdio.h>
using namespace std;

class color{
	private:
		int rgb[3];
	public:
		color(int r,int g,int b);
		int* get();
};
int * color::get(){
	//cout << endl << "get1: " << this -> rgb[0] <<"	"<< this -> rgb[1] <<"	"<< this -> rgb[2] << endl;
	return rgb;
};
color::color(int r=0,int g=0,int b=0){
	//cout << "constructor 1:" << r <<"	"<< g <<"	"<< b << endl;
	this -> rgb[0] = r;
	this -> rgb[1] = g;
	this -> rgb[2] = b;
	//cout << "constructor 2:"<< this -> rgb[0] <<"	"<< this -> rgb[1] <<"	"<< this -> rgb[2] << endl << endl;
};
color pgreen (0,255,0);
color pblue  (0,0,255);
color pred   (255,0,0);

color green (20,230,20);
color blue  (20,20,230);
color red   (230,20,20);
int main(){
	int*a = blue.get();
	cout << a[0] << "	" << a[1] << "	" << a[2] << "	";
}
