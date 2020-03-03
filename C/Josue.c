#include <stdio.h>

int work(int a, int b, int c) {
    int tab[3] = {a,b,c};
    int i,i1;
    for(i=0,i<4,i+1;){
        for(i1=0,i1<2,i1+1){
            if(i1 < 2;){
                if(tab[i1] < tab[i1+1];){
                    int c = tab[i1];
                    tab[i1] = tab[i1+1];
                    tab[i1++] = c;
                };
            };
        };
    };
    return a;
};

int main() {
    char in1[10],in2[10],in3[10];
    char yes[2] = "SI";
    char no[2] = "NO";
    bool conditional = true;
    while(conditional){
        printf("Inserte 3 numeros, separados por un enter \n");
        gets(in1);
        gets(in2);
        gets(in3);
        printf(work(in1-0,in2-0,in3-0));
        printf("Numero mas alto: %d \n",a[0]);
        printf("Segundo numero mas alto: %d \n",a[1]);
        printf("Desea reiniciar el programa? \n");
        char gets(str);
        if(str[1] == yes[1] && str[2] == yes[2];){
            printf("Repitiendo... \n")
        } else {
            if(str[1] == no[1] && str[2] == no[2];){
                printf("NO recibido. Terminando.")
            } else {
                printf("Comando invalido. Terminando.")
            };
        };
    };
    return 0;
}