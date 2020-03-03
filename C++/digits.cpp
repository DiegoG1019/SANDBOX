#include<string>
#include<iostream>
#include<sstream>
using namespace std;

int getDigit(int N,int n){
	string out;
	stringstream sa,sb;
	sa << N; out = sa.str();
	sb << out.at(n);
	return stoi(sb.str()); 
}
int main(){
	int val,pos;
	cout << "Insert a number" << endl;
	cin  >> val;
	cout << "Insert a position to extract a digit from, starting from 0" << endl;
	cin  >> pos;
	cout << getDigit(val,pos);
}
