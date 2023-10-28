%{
	#include <stdio.h>
	#include "TS.h"
    #include "quad.h"
    extern FILE* yyin;
    extern int indq;
    int nTemp=1, op=0, Qc, sauvBZ, sauvBR; char tempC[12]=""; 
	int yylex();
	int yyerror(char*);
    extern int yylineno;

	void finish()
	{
            afficherTS ();
            afficherQuad();
		exit(0);
	}

%}

%union {char *data;
 int indent_depth;
 struct {int type;char* res;}NT;};

%token T_intsig T_floatsig INT CHAR BOOL FLOAT T_for <data>T_identifier T_False T_True  Indent Nodent Dedent T_colon T_newLine T_lesserThan T_greaterThanEqualTo T_lesserThanEqualTo T_or T_and T_not T_assignOP T_notEqualOP T_equalOP T_greaterThan T_in T_if T_while T_else T_minus T_plus T_division T_multiply T_openParanthesis T_closeParanthesis T_EOF T_return T_openBracket T_closeBracket T_comma T_range T_int T_float T_char
%type<NT> constant term arith_exp assign_stmt bool_exp bool_factor bool_term variable tab type list_id
%type<data> T_intsig T_floatsig
%left T_plus T_minus
%left T_multiply T_division
%right T_assignOP
%nonassoc T_if
%nonassoc T_else
%start Start

%%

Start : StartParse T_EOF {finish();};

constant : T_int {$$.type=2; $$.res = $1;}
         | T_char {$$.type=5; $$.res = $1;}
		 | T_float{$$.type=3; $$.res = $1;}
         | T_intsig {$$.type=2; $$.res = $1;}
         | T_floatsig {$$.type=3; $$.res = $1;}
         ;

term : T_identifier {dec($1); $$.type=typeIdf($1);  $$.res=strdup($1); }
     | constant 
     ;

declaration: variable
     | tab
     ;

variable: type list_id {$2.type=$1.type;}
|type assign_stmt {$2.type=$1.type;}
|assign_stmt
;

list_id: list_id  T_comma T_identifier {inserer($3, 1); } //the idea was to use inserer($3, $$.type); but the type wouldn't change so i saved it as an IDF
|T_identifier{inserer($1, 1);};//same here

tab: type T_identifier T_openBracket T_int T_closeBracket {doubleDec ($2,$1.type); 
 sprintf(tempC,"T%d",nTemp);$$.res=strdup(tempC);nTemp++;tempC[0]='\0';
							Qc=quad ("BOUNDS",$4,$$.res,"");
                            Qc=quad("ADEC",$2,"","");
if(atoi($4)==0) printf("declaration d'un tableau nul ligne %d\n",yylineno);};
// pour l'erreur semantique d'un index negatif elle est deja verifiee car on a utilise le token T_int (les entiers positifs seulement)

type: INT {$$.type=2;}
|BOOL {$$.type=4;}
|CHAR {$$.type=5;}
|FLOAT {$$.type=3;}
;

StartParse : T_newLine StartParse | finalStatements T_newLine {reset_depth();} StartParse | ;

basic_stmt :arith_exp
           | bool_exp
           |declaration
           ;

arith_exp : term {$$.type = $1.type; $$.res == $1.res;}
          | arith_exp  T_plus  arith_exp {if (comType($1.type,$3.type)==-1) printf("incompatibilte de type ligne %d\n", yylineno-1); 
          else {$$.type = $1.type; $$.res == $1.res;
          sprintf(tempC,"T%d",nTemp);$$.res=strdup(tempC);nTemp++;tempC[0]='\0';
							Qc=quad ("+",$1.res,$3.res,$$.res);}
                            }
      

          | arith_exp  T_minus  arith_exp {if (comType($1.type,$3.type)==-1) printf("incompatibilte de type ligne %d\n", yylineno-1); 
          else {$$.type = $1.type; $$.res == $1.res;
          sprintf(tempC,"T%d",nTemp);$$.res=strdup(tempC);nTemp++;tempC[0]='\0';
							Qc=quad ("-",$1.res,$3.res,$$.res);}
                            }


          | arith_exp  T_multiply  arith_exp {if (comType($1.type,$3.type)==-1) printf("incompatibilte de type ligne %d\n", yylineno-1); 
          else {$$.type = $1.type; $$.res == $1.res;
          sprintf(tempC,"T%d",nTemp);$$.res=strdup(tempC);nTemp++;tempC[0]='\0';
							Qc=quad ("*",$1.res,$3.res,$$.res);}}


          | arith_exp  T_division  arith_exp {if (comType($1.type,$3.type)==-1) printf("incompatibilte de type ligne %d\n", yylineno-1); 
          else {$$.type = $1.type; $$.res == $1.res;
          sprintf(tempC,"T%d",nTemp);$$.res=strdup(tempC);nTemp++;tempC[0]='\0';
							Qc=quad ("/",$1.res,$3.res,$$.res);}}


          | T_minus arith_exp {$$.type=$2.type; $$.res=$2.res;
          sprintf(tempC,"T%d",nTemp);$$.res=strdup(tempC);nTemp++;tempC[0]='\0';
							Qc=quad ("-",$2.res,"",$$.res);}


          | T_openParanthesis arith_exp T_closeParanthesis {$$.type=$2.type; $$.res=$2.res;}; 


bool_exp : bool_term T_or bool_term {if (comType($1.type,$3.type)==-1) printf("incompatibilte de type ligne %d\n", yylineno-1); 
          else {$$.type = $1.type; $$.res == $1.res;
          sprintf(tempC,"T%d",nTemp);$$.res=strdup(tempC);nTemp++;tempC[0]='\0';
							Qc=quad ("or",$1.res,$3.res,$$.res);}
                            }


         | arith_exp T_lesserThan arith_exp {if (comType($1.type,$3.type)==-1) printf("incompatibilte de type ligne %d\n", yylineno-1); 
          else {$$.type = $1.type; $$.res == $1.res;
          sprintf(tempC,"T%d",nTemp);$$.res=strdup(tempC);nTemp++;tempC[0]='\0';
							Qc=quad ("BL",$1.res,$3.res,$$.res);
}}


         | bool_term T_and bool_term {if (comType($1.type,$3.type)==-1) printf("incompatibilte de type ligne %d\n", yylineno-1); 
          else {$$.type = $1.type; $$.res == $1.res;
          sprintf(tempC,"T%d",nTemp);$$.res=strdup(tempC);nTemp++;tempC[0]='\0';
							Qc=quad ("and",$1.res,$3.res,$$.res);
                   }}


         | arith_exp T_greaterThan arith_exp {if (comType($1.type,$3.type)==-1) printf("incompatibilte de type ligne %d\n", yylineno-1); 
          else {$$.type = $1.type; $$.res == $1.res;
          sprintf(tempC,"T%d",nTemp);$$.res=strdup(tempC);nTemp++;tempC[0]='\0';
                            Qc = quad ("BG","",$1.res,$3.res);}
                }


         | arith_exp T_lesserThanEqualTo arith_exp {if (comType($1.type,$3.type)==-1) printf("incompatibilte de type ligne %d\n", yylineno-1); 
          else {$$.type = $1.type; $$.res == $1.res;
          sprintf(tempC,"T%d",nTemp);$$.res=strdup(tempC);nTemp++;tempC[0]='\0';
							Qc=quad ("BLE",$1.res,$3.res,$$.res);
                            }
                            }


         | arith_exp T_greaterThanEqualTo arith_exp {if (comType($1.type,$3.type)==-1) printf("incompatibilte de type ligne %d\n", yylineno-1); 
          else {$$.type = $1.type; $$.res == $1.res;
          sprintf(tempC,"T%d",nTemp);$$.res=strdup(tempC);nTemp++;tempC[0]='\0';
							Qc=quad ("BGE",$1.res,$3.res,$$.res);}
                         }


         | bool_term {$$.type =$1.type; $$.res=$1.res;}


bool_term : bool_factor
          | arith_exp T_equalOP arith_exp 
           {$$.type = $1.type; $$.res == $1.res;
          sprintf(tempC,"T%d",nTemp);$$.res=strdup(tempC);nTemp++;tempC[0]='\0';
							Qc=quad ("BZ",$1.res,$3.res,$$.res);}
|arith_exp T_notEqualOP arith_exp  {$$.type = $1.type; $$.res == $1.res;
          sprintf(tempC,"T%d",nTemp);$$.res=strdup(tempC);nTemp++;tempC[0]='\0';
							Qc=quad ("BNZ",$1.res,$3.res,$$.res);}

          | T_True {$$.type =4; $$.res=$1; 
          sprintf(tempC,"T%d",nTemp);$$.res=strdup(tempC);nTemp++;tempC[0]='\0';
							Qc=quad ("=","0","",$$.res);}


          | T_False  {$$.type =4; $$.res=$1;
          sprintf(tempC,"T%d",nTemp);$$.res=strdup(tempC);nTemp++;tempC[0]='\0';
							Qc=quad ("=","1","",$$.res);};

bool_factor : T_not bool_factor {$$.type =$2.type; $$.res=$2.res;
sprintf(tempC,"T%d",nTemp);$$.res=strdup(tempC);nTemp++;tempC[0]='\0';
							Qc=quad ("not",$2.res,"",$$.res);}
            | T_openParanthesis bool_exp T_closeParanthesis  {$$.type =$2.type; $$.res=$2.res;};

assign_stmt : T_identifier T_assignOP arith_exp {inserer ($1, $3.type); 
sprintf(tempC,"T%d",nTemp);$$.res=strdup(tempC);nTemp++;tempC[0]='\0';
							Qc=quad ("=",$3.res,"",$1);}


            | T_identifier T_assignOP bool_exp {inserer ($1,$3.type);};

finalStatements : basic_stmt
                | cmpd_stmt
                | error T_newLine {yyerrok; yyclearin;};

cmpd_stmt : if_stmt
          | while_stmt
          |for_stmt;

if_stmt : T_if bool_exp T_colon start_suite 
        | T_if bool_exp T_colon start_suite elif_stmts;

elif_stmts : else_stmt
           |else_stmt T_if bool_exp T_colon start_suite  elif_stmts;

else_stmt : T_else T_colon start_suite  ;

while_stmt : T_while bool_exp T_colon start_suite;

for_stmt: T_for T_identifier T_in T_identifier T_colon start_suite {dec($4);}
|T_for T_identifier T_range T_openParanthesis T_int T_comma T_int T_closeParanthesis T_colon start_suite ;

start_suite : basic_stmt
            | T_newLine Indent finalStatements suite;

suite : T_newLine Nodent finalStatements suite
      | T_newLine end_suite;
      | {reset_depth();} elif_stmts;

end_suite : Dedent finalStatements
          | Dedent
          | {reset_depth();} finalStatements
          | {reset_depth();};


%%

int yyerror(char* msg)
{
	printf("\nSyntax Error at Line %d\n",  yylineno);
	exit(0);
}

int main()
{
    
	yyin = fopen("Valid_Input.txt", "r");
	yyparse();
	fclose (yyin);
	return 0;
}
