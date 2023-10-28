#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylineno;
#define taille 10000

typedef struct {
				char* nom;
				int type;
				}elem;
				
elem TS[taille];
int indexTS =0;
extern int indent_depth;
extern int pop();
extern int peek();


 reset_depth()
{
    while(peek()) pop();
    indent_depth = 10;
}

int recherche (char * el)
{
	int i=0;
	while (i<indexTS && strcmp(TS[i].nom,el)) i++;
	if (i==indexTS) return -1;
	return i;
}
void inserer (char* el, int typ)
{ if ((recherche(el)==-1)){
	TS[indexTS].nom=el;
	TS[indexTS].type=typ;
	indexTS ++;}
}

void afficherTS ()
{
	int i=0; 
          printf("--------------------------\n");
          printf("Name                Type\n");
          printf("--------------------------\n");
	for (i=0;i<indexTS;i++){
        switch (TS[i].type)
        {
        //case 0: {printf ("%-12s \t mot cle\n",TS[i].nom);	}	break;
        case 1: {printf ("idf %-12s \t idf\n",TS[i].nom);	} break;
        case 2: {printf ("idf %-12s \t entier\n",TS[i].nom);	} break;
		case 3: {printf ("idf %-12s \t reel\n",TS[i].nom);	} break;
		case 4: {printf ("idf %-12s \t boolean\n",TS[i].nom);	} break;
		case 5: {printf ("idf %-12s \t caractere\n",TS[i].nom);	} break;
		default: {break;}
        //default: {printf ("%-12s \t separateur\n",TS[i].nom);	}
           // break;
        }
        }	  
}

int typeIdf(char* el)
{ 
	return TS[recherche(el)].type;
}

void dec (char * el)
{ 
if (recherche(el)==-1){printf("erreur semantique IDF  non declare ligne %d\n", yylineno);}

}

void  doubleDec (char* el,int x)
{  
if (recherche(el)!=-1){printf("erreur semantique double declaration d'un IDF ligne %d\n", yylineno);}
else inserer(el,x);

}

int comType(int e1, int e2) {
	if (e1!=e2) return -1 ;
	else return 0;
}

