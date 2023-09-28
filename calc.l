%option yylineno
%{
#include <stdio.h>
#include<math.h>
#include <stdlib.h>
#include "calc.tab.h"
%}
entier [0-9]+
ident [a-zA-Z_][a-zA-Z0-9_]*
reel ({entier}[\.]{entier}|{entier})
blank [ \t\n]+ 
Commentaire (#" "*(.)*|"/*"(.)*"*/"|"//"(.)*)
reel_mal [\.]{entier};
%%
{reel} {yylval.type_reel = atof(yytext); return(REEL);}
"<" {return(INF);}
">" {return(SUP);}
"<=" {return(FE);}
">=" {return(SE);}
"==" {return(EQ);}
"!=" {return(DIFF);}
"Si"|"SI"|"si" {return(SI);}
"Sinon"|"SINON"|"sinon" {return(SINON);}
"Sinon_Si"|"SINON_SI"|"sinon_si" {return(SINONSI);}
"FinSi"|"FINSI"|"finsi" {return(FINSI);}
"Pour"|"POUR"|"pour" {return(POUR);}
"De"|"DE"|"de" {return(DE);}
"A"|"a" {return(A);}
"Alors"|"alors"|"ALORS" {return(ALORS);}
"Faire"|"FAIRE"|"faire" {return(FAIRE);}
"FinPour"|"FINPOUR"|"finpour" {return(FINPOUR);}
"Tantque"|"TANTQUE"|"tantque" {return(TANTQUE);}
"FinTantque"|"FINTANTQUE"|"fintantque" {return(FINTANTQUE);}
"Repeter"|"REPETER"|"repeter" {return(REPETER);}
"Jusqua"|"JUSQUA"|"jusqua" {return(JUSQUA);}
";"         {return(FIN);}
"+"	   {return(PLUS);}
"-"	   {return(MOINS);}
"="	   {return(EGAL);}
":="	   {return(AFFECT);}
"*"	   {return(MULTI);}
"/"    {return(DIV);}
"^"    {return(PUISS);}
"("	   {return(PO);}
")"    {return(PF);}

"Exit"|"exit"|"EXIT" {return(EXIT);}
{blank} {}
{Commentaire} {}
{ident} {return(ID);}
{reel_mal} printf("**Error : ligne %d il manque chiffre avant virgule %s\n", yylineno, yytext);
. {printf("**ERROR: Unexpected input erreur lexical the result is invalid %c in line line %d : \n",yytext[0], yylineno);}
%%
int yywrap() {return 1;}
