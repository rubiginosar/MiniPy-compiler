%{
#include <string.h>
#include "compil.tab.h"
#include "stack.h"

  //Declarations
  int yycolumn = 1;
  int beginning = 1;
  int indentation_type;
  int indent_type(int indent_depth);

  //Definitions
  int indent_type(int indent_depth){
        if(indent_depth < peek())
        {
          while (indent_depth < peek()) pop();
          yylval.indent_depth = indent_depth;
          return 1;
        }

        if(indent_depth == peek())
        {
          yylval.indent_depth = indent_depth;
          return 2;
        }
        if(indent_depth > peek())
        {
          push(indent_depth);
          yylval.indent_depth = indent_depth;
          return 3;
        }
  }

%}

%option yylineno

comment #(.*)\n
digit	[0-9]
letter	[a-zA-Z]
id	[A-Z]({letter}|{digit})*
int	{digit}+
float {int}\.{int} 
int_signed "(-"{int}")"
float_signed "(-"{float}")"
char \'.\'

%%

{comment} {}
"\n"  {yycolumn=1; return T_newLine;}

[\t]* {
        indent_depth = strlen(yytext) + 1;
        indentation_type = indent_type(indent_depth);
        if(indentation_type == 1) return Dedent;
        else if(indentation_type == 2) return Nodent;
        else return Indent;
      }

"true" { if (recherche(yytext)==-1);return T_True;}
"false" { if (recherche(yytext)==-1); return T_False;}
"if" { if (recherche(yytext)==-1) inserer (strdup(yytext),0); return T_if;}
"in" { if (recherche(yytext)==-1) inserer (strdup(yytext),0); return T_in;}
"while" {if (recherche(yytext)==-1) inserer (strdup(yytext),0); return T_while;}
<<EOF>> {return T_EOF;}
":" { if (recherche(yytext)==-1) inserer (strdup(yytext),6);return T_colon;}
">" { if (recherche(yytext)==-1) inserer (strdup(yytext),6);return T_greaterThan;}
"<" { if (recherche(yytext)==-1) inserer (strdup(yytext),6);return T_lesserThan;}
">=" { if (recherche(yytext)==-1) inserer (strdup(yytext),6);return T_greaterThanEqualTo;}
"<=" { if (recherche(yytext)==-1) inserer (strdup(yytext),6);return T_lesserThanEqualTo;}
"==" { if (recherche(yytext)==-1) inserer (strdup(yytext),6);return T_equalOP;}
"!=" {if (recherche(yytext)==-1)inserer (strdup(yytext),6); return T_notEqualOP;}
"and" {if (recherche(yytext)==-1) inserer (strdup(yytext),0); return T_and;}
"or" {if (recherche(yytext)==-1) inserer (strdup(yytext),0);return T_or;}
"not" {if (recherche(yytext)==-1) inserer (strdup(yytext),0);return T_not;}
"else" {if (recherche(yytext)==-1) inserer (strdup(yytext),0); return T_else;}
"in range" {if (recherche(yytext)==-1)  inserer (strdup(yytext),0);return T_range;}
"for" {if (recherche(yytext)==-1) inserer (strdup(yytext),0); return T_for;}
"int" {if (recherche(yytext)==-1) inserer (strdup(yytext),0);return INT;}
"float" {if (recherche(yytext)==-1) inserer (strdup(yytext),0);return FLOAT;}
"char" {if (recherche(yytext)==-1) inserer (strdup(yytext),0);return CHAR;}
"bool" {if (recherche(yytext)==-1) inserer (strdup(yytext),0);return BOOL;}
"[" {if (recherche(yytext)==-1) inserer (strdup(yytext),6); return T_openBracket;}
"]" {if (recherche(yytext)==-1) inserer (strdup(yytext),6); return T_closeBracket;}
"," {if (recherche(yytext)==-1) inserer (strdup(yytext),6); return T_comma;}
"=" {if (recherche(yytext)==-1) inserer (strdup(yytext),6); return T_assignOP;}
"+" {if (recherche(yytext)==-1) inserer (strdup(yytext),6);return T_plus;}
"-" {if (recherche(yytext)==-1) inserer (strdup(yytext),6);return T_minus;}
"*" {if (recherche(yytext)==-1) inserer (strdup(yytext),6); return T_multiply;}
"/" {if (recherche(yytext)==-1)  inserer (strdup(yytext),6);return T_division;}
"(" {if (recherche(yytext)==-1)  inserer (strdup(yytext),6);return T_openParanthesis;}
")" {if (recherche(yytext)==-1)  inserer (strdup(yytext),6);return T_closeParanthesis;}
{char} {yylval.data = strdup(yytext);  return T_char;}
{int} {                        if(atoi(yytext)<-32768||atoi(yytext)>32767) {
	                    printf(" lexical error  ->  ligne: %d  \"%s\" a depasse les limites\n",yylineno,strdup(yytext));
                        exit(0);
                    } else yylval.data = strdup(yytext);  return T_int;}
{float} {yylval.data = strdup(yytext); return T_float;}
{int_signed} {yylval.data = strdup(yytext); return T_intsig;}
{float_signed} {yylval.data = strdup(yytext);  return T_floatsig;}
{id} {yylval.data = strdup(yytext); return T_identifier;}

%%

int yywrap()
{
    strcpy(yylval.data,yytext);
    return 1;
}
