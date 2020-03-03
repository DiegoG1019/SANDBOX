#include <iostream>
using namespace std;

double notas[3];
double notafinal = 0;
double notamedia = 0;

int main(){
	cout << "Introduzca 3 notas, separadas por un enter:" << endl;
	cin  >> notas[0];cin >> notas[1];cin >> notas[2];
	for(int a = 0; a<2; a++){
		notas[a] = notas[a]*0.3;
		notamedia += notas[a];
	};
	notas[2] = notas[2]*0.4;
	for(int a = 0; a<3; a++){
		notafinal = notafinal + notas[a];
	}
	cout << "Su nota acumulada entre el I y II corte es igual a: " << notamedia << endl;
	cout << "Su nota final es igual a: " << notafinal << endl;
	cout << "La minima nota que necesitaba para pasar el III corte era: " << (20-notamedia)*0.4 << endl;
	system("PAUSE");
	return 0;
}
