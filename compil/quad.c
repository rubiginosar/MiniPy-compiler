#include "quad.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


int indq=0;
int quad(char* o,char*o1,char*o2,char*r){
    q[indq].opr=strdup(o);
    q[indq].op1=strdup(o1);
    q[indq].op2=strdup(o2);
    q[indq].res=strdup(r);
    indq++;
    return indq;
}

void afficherQuad(){
   int i;
    for (i=0;i<indq;i++){
        printf ("%d-( %s , %s , %s , %s )\n",i+1,q[i].opr,q[i].op1,q[i].op2,q[i].res);
    }
}
