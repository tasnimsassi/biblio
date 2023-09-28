%{
#include <stdio.h>
#include "lex.yy.c"
int yylex(void);
void yyerror(char *s);
extern int yylineno;
%}
%token  FIN REEL ID SI SINON SINONSI FINSI ALORS POUR DE A FAIRE FINPOUR TANTQUE FINTANTQUE REPETER JUSQUA PLUS MOINS EGAL AFFECT MULTI DIV PUISS PO PF EXIT INF SUP FE SE EQ DIFF 
%start INPUT
%left PLUS MOINS
%left MULTI DIV 
%right PUISS 
%union {
double type_reel;
}
%type<type_reel> REEL E RES condition EGAL statment ID AFFECTATION FOR 
%%
INPUT :|INPUT RES {printf("The result of line N%d is %f\n",yylineno,$2);}  
	| RES {printf("The result of line N%d is %f\n",yylineno,$1);} INPUT 
       |ifcond INPUT | FOR INPUT |WHILE INPUT | REPETE INPUT 
       | EXIT {printf("In Exit..");exit(0);};

RES : EGAL | E EGAL | AFFECTATION RES;

AFFECTATION : ID AFFECT E FIN {$$=$3;$1=$3; {printf("SUCCESSUF Affectation \n");}} ;


ifcond:  SI PO condition PF ALORS statment SINON statment FINSI 
		{printf("Struct Si/Sinon Accepted\n");
		 if ($3==1) 
              		  printf("Si result %f\n",$6);
		   else 
              		  printf("Sinon result %f\n",$8);
   
          	} 
	| SI PO condition PF ALORS statment FINSI 
                   {printf("Struct Si Accepted\n");
			if ($3==1) 
         		      printf("Si result %f\n",$6);
                         else if ($3==0)
                          printf("**ERORR : INVALID Condition\n"); 
                   }
				   
				   
				   
				   
				   | SI PO condition PF ALORS statment  
                   {printf("erreur sémantique manque de finsi");
			
                   }
				   		   
				   
                | SI PO condition PF ALORS statment SINONSI PO condition PF ALORS statment SINON statment FINSI
		{printf("Struct Si/Sinon_Si/Sinon Accepted\n");
			if ($3==1) 
         		      printf("Si result %f\n",$6);

                        else if ($9==1) 
           		      printf("Sinon Si result %f\n",$12);

                        else 
           		       printf("Sinon result %f\n",$14);
                   };
	|AFFECTATION AFFECTATION SI ID SUP ID ALORS statment SINON statment FINSI 
		{printf("Struct Si/Sinon Accepted\n");
		 if ($1>$2) 
              		  printf("Si result %f\n",$8);
		   else 
              		  printf("Sinon result %f\n",$10);
   
          	} 
	|AFFECTATION AFFECTATION SI ID INF ID ALORS statment SINON statment FINSI 
		{printf("Struct Si/Sinon Accepted\n");
		 if ($1<$2) 
              		  printf("Si result %f\n",$8);
		   else 
              		  printf("Sinon result %f\n",$10);}
	|AFFECTATION AFFECTATION SI ID FE ID ALORS statment SINON statment FINSI 
		{printf("Struct Si/Sinon Accepted\n");
		 if ($1<=$2) 
              		  printf("Si result %f\n",$8);
		   else 
              		  printf("Sinon result %f\n",$10);}
	|AFFECTATION AFFECTATION SI ID SE ID ALORS statment SINON statment FINSI 
		{printf("Struct Si/Sinon Accepted\n");
		 if ($1>=$2) 
              		  printf("Si result %f\n",$8);
		   else 
              		  printf("Sinon result %f\n",$10);}
	|AFFECTATION AFFECTATION SI ID EQ ID ALORS statment SINON statment FINSI 
		{printf("Struct Si/Sinon Accepted\n");
		 if ($1==$2) 
              		  printf("Si result %f\n",$8);
		   else 
              		  printf("Sinon result %f\n",$10);}
                
 
	|AFFECTATION AFFECTATION SI ID DIFF ID ALORS statment SINON statment FINSI 
		{printf("Struct Si/Sinon Accepted\n");
		 if ($1!=$2) 
              		  printf("Si result %f\n",$8);
		   else 
              		  printf("Sinon result %f\n",$10);}

          |AFFECTATION AFFECTATION SI ID INF ID ALORS statment FINSI 
                   {printf("Struct Si Accepted\n");
			if ($1<$2) 
         		      printf("Si result %f\n",$8);
                         else 
                          printf("**ERORR : INVALID Condition\n"); 
                   }
           |AFFECTATION AFFECTATION SI ID SUP ID ALORS statment FINSI 
                   {printf("Struct Si Accepted\n");
			if ($1>$2) 
         		      printf("Si result %f\n",$8);
                         else 
                          printf("**ERORR : INVALID Condition\n"); 
                   }
	|AFFECTATION AFFECTATION SI ID FE ID ALORS statment FINSI 
                   {printf("Struct Si Accepted\n");
			if ($1<=$2) 
         		      printf("Si result %f\n",$8);
                         else 
                          printf("**ERORR : INVALID Condition\n"); 
                   }
	| AFFECTATION AFFECTATION SI ID SE ID ALORS statment FINSI 
                   {printf("Struct Si Accepted\n");
			if ($1>=$2) 
         		      printf("Si result %f\n",$8);
                         else 
                          printf("**ERORR : INVALID Condition\n"); 
                   }
	| AFFECTATION AFFECTATION SI ID EQ ID ALORS statment FINSI 
                   {printf("Struct Si Accepted\n");
			if ($1==$2) 
         		      printf("Si result %f\n",$8);
                         else 
                          printf("**ERORR : INVALID Condition\n"); 
                   }
    | AFFECTATION AFFECTATION SI ID DIFF ID ALORS statment FINSI 
                   {printf("Struct Si Accepted\n");
			if ($1!=$2) 
         		      printf("Si result %f\n",$8);
                         else 
                          printf("**ERrOR : INVALID Condition\n"); 
                   };

condition: E SUP E { float x = $1, y= $3;
                     if (x>y) 
                        $$=1;
		     else 
                        $$=0;}
           | E INF E { float x = $1, y= $3;
                     if (x<y) 
                        $$=1;
		     else 
                        $$=0;}
	   |E FE E { float x = $1, y= $3;
                     if (x<=y) 
                        $$=1;
		     else 
                        $$=0;}
           | E SE E { float x = $1, y= $3;
                     if (x>=y) 
                        $$=1;
		     else 
                        $$=0;}
           | E EQ E { float x = $1, y= $3;
                     if (x==y) 
                        $$=1;
		     else 
                        $$=0;}
           | E DIFF E { float x = $1, y= $3;
                     if (x!=y) 
                        $$=1;
		     else 
                        $$=0;};



E :   PO E PF {$$= $2;}| REEL | ID {$$=$1;}
     | E PLUS E {$$ = $1 + $3;} 
     | E MOINS E {$$ = $1 - $3;} 
     | MOINS E {$$ = -1*$2;}
     | E MULTI E {$$ = $1 * $3;}
     | E DIV E { if($3 == 0)
                    {printf("**ERROR ****erreur sémantique***** can not divide by zero******the result is invalid\n");
                     printf("**Warning : This expression: { /%f }  is not considered ! \n", $3);}
		 else 
                     $$ = $1 / $3;}
     |  E PUISS E  { float x = $1;
		   for(int i = 1;i<$3;i++)
			x *=$1;
		    $$ = x;};

statment: E {$$=$1;} | statment E {$$=$1;} |ID AFFECT E FIN {$$=$3; $1=$3;} ;


FOR : POUR ID DE REEL A REEL FAIRE statment FINPOUR {printf("Pour Struct Accepted\n");
                                                     for(int i=$4;i<=$6;i++) printf("FOR RESULT: %f\n", $8);}
     | AFFECTATION AFFECTATION POUR ID DE ID A ID FAIRE statment FINPOUR {printf("Pour Accepted\n");
                                                     for(int i=$1;i<=$2;i++) printf("FOR RESULT: %f\n", $10);};

     
WHILE : TANTQUE E SUP E FAIRE statment FINTANTQUE {printf("Tantque Struct Accepted\n");
						    if ($2>$4) {
								 printf("Condition Checked\n $2-- in every instruction \n");
								 while ($2>$4) {printf("**ERROR: Erreur sémantique Boucle INFINIE Condition $2>$4 is always checked try $2++ : While Result %f\n",$6); $2--;}

							} else {printf("Condition not Checked\n"); exit(0);};
                                                     }
	| AFFECTATION AFFECTATION TANTQUE ID SUP ID FAIRE statment FINTANTQUE {printf("Tantque Struct Accepted\n");
						    if ($1>$2) {
								 printf("Condition Checked\n $1-- in every instruction \n");
								 while ($1>$2) {printf("While Result %f\n",$8); $1--;}

							}else {printf("Condition not Checked\n"); exit(0);};
                                                     }
	|TANTQUE E INF E FAIRE statment FINTANTQUE {printf("Tantque Struct Accepted\n");
						    if ($2<$4) {
								 printf("Condition Checked\n $2++ in every instruction \n");
								 while ($2<$4) {printf("While Result %f\n",$6); $2++;}

							}else {printf("Condition not Checked\n"); exit(0);};
                                                     }
	| AFFECTATION AFFECTATION TANTQUE ID INF ID FAIRE statment FINTANTQUE {printf("Tantque Struct Accepted\n");
						    if ($1<$2) {
								 printf("Condition Checked\n $1-- in every instruction \n");
								 while ($1<$2) {printf("**ERROR: Boucle INFINIE ****erreur semantique***Condition $1>$2 is always checked try $1++ :While Result %f\n",$8); $1--;}

							}else {printf("Condition not Checked\n"); exit(0);};
                                                     }
	|TANTQUE E FE E FAIRE statment FINTANTQUE {printf("Tantque Struct Accepted\n");
						    if ($2<=$4) {
								 printf("Condition Checked\n $2++ in every instruction\n ");
								 while ($2<=$4) {printf("While Result %f\n",$6); $2++;}

							} else {printf("Condition not Checked\n"); exit(0);};
                                                     }
	| AFFECTATION AFFECTATION TANTQUE ID FE ID FAIRE statment FINTANTQUE {printf("Tantque Struct Accepted\n");
						    if ($1<=$2) {
								 printf("Condition Checked\n  $1++ in every instruction\n ");
								 while ($1<=$2) {printf("While Result %f\n",$8); $1++;}

							} else {printf("Condition not Checked\n"); exit(0);};
                                                     }
	|TANTQUE E SE E FAIRE statment FINTANTQUE {printf("Tantque Struct Accepted\n");
						    if ($2>=$4) {
								 printf("Condition Checked\n  $2-- in every instruction\n ");
								 while ($2>=$4) {printf("While Result %f\n",$6); $2--;}

							} else {printf("Condition not Checked\n"); exit(0);};
                                                     }
	| AFFECTATION AFFECTATION TANTQUE ID SE ID FAIRE statment FINTANTQUE {printf("Tantque Struct Accepted\n");
						    if ($1>=$2) {
								 printf("Condition Checked\n  $1-- in every instruction\n ");
								 while ($1>=$2) {printf("While Result %f\n",$8); $1--;}

							} else {printf("Condition not Checked\n") ; exit(0);};
                                                     }
	|TANTQUE E EQ E FAIRE statment FINTANTQUE {printf("Tantque Struct Accepted\n");
						    if ($2==$4) {
								 printf("Condition Checked\n  $2-- in every instruction\n ");
								 while ($2==$4) {printf("While Result %f\n",$6); $2--;}

							} else {printf("Condition not Checked\n"); exit(0);};
                                                     }
	| AFFECTATION AFFECTATION TANTQUE ID EQ ID FAIRE statment FINTANTQUE {printf("Tantque Struct Accepted\n");
						    if ($1==$2) {
								 printf("Condition Checked\n  $2-- in every instruction\n ");
								 while ($1==$2) {printf("While Result %f\n",$8); $2--;}
								

							} else {printf("Condition not Checked\n"); exit(0);};
                                                     }
        |TANTQUE E DIFF E FAIRE statment FINTANTQUE {printf("Tantque Struct Accepted\n");
						    if ($2!=$4) {
								 printf("Condition Checked\n");
								 while ($2>$4) { printf("$2-- in every instruction\n While Result %f\n",$6); $2--;}
								 while ($2<$4) { printf("$2++ in every instruction\n While Result %f\n",$6); $2++;}

							} else {printf("Condition not Checked\n"); exit(0);};
                                                     }
	| AFFECTATION AFFECTATION TANTQUE ID DIFF ID FAIRE statment FINTANTQUE {printf("Tantque Struct Accepted\n");
						    if ($1!=$2) {
								 printf("Condition Checked\n");
								 while ($1>$2) { printf("$1-- in every instruction\n While Result %f\n",$8); $1--;}
								 while ($1<$2) { printf("$1++ in every instruction\n While Result %f\n",$8); $1++;}

							}
                                                     else {printf("Condition not Checked\n"); exit(0);};
                                                     };

REPETE : REPETER statment JUSQUA condition FIN {printf("REPETE Struct Accepted\n");}; 
%%
void yyerror(char *s){
	printf ("**Error happend : %s\n",s);
}
int main()
{
 yyparse(); // lancer l analyse syntaxique
 getchar();
}