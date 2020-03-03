//support functions
#include <iostream>
#include <stdio.h>
using namespace std;

static string dec2hex(int dec) {
	if (dec < 1) return "00";

	int hex = dec;
	string hexStr = "";

	while (dec > 0)
	{
		hex = dec % 16;

		if (hex < 10)
			hexStr = hexStr.insert(0, string(1, (hex + 48)));
		else
			hexStr = hexStr.insert(0, string(1, (hex + 55)));

		dec /= 16;
	}

	return hexStr;
};

int min(int a, int b){
	if(a>b){
		return b;
	};return a;
}

int max(int a, int b){
	if(a<b){
		return b;
	};
	return a;
}
//;int max(float a, float b){
//	if(a<b){
//		return b;
//	};
//	return a;
//};int max(double a, double b){
//	if(a<b){
//		return b;
//	};
//	return a;
//};
