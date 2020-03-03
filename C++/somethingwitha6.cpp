#include <iostream>
using namespace std;

int main(){
	int a = 0;
	int b = 1;
	double c = 0.0;
	while(a < 300*6){
		if(a%10 == 0){
			cout << "Cycle #" << a/6 << " Found: " << a << endl;
		}
		a+=6;
		if(a>(b*1000)){
			cout << "Reached the: " << b*1000 << " cycles mark." << endl;
			b+=1;
		}
	}
	cout << " Finished. The value you want should be: " << ((double)a/6.0)*(100.0/35.0);
}
