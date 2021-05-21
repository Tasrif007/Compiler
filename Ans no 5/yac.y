%{
#include<stdio.h>
#include<stdlib.h>
#include <math.h>
extern FILE *yyin;
double vbltable[26] ;
int vbltable2[26] ;
void yyerror(const char *c){
	fprintf(stderr,"%s",c);
}
int yylex();
%}
%union{
	double dval;
	int vblno;
	int intval;
}

%token SINE
%token SUB
%token ABS
%token VOLUME
%token <vblno> NAME
%token <dval> NUMBER
%token <intval> INTNUMBER

%type <dval> expression term factor
%type <intval> expression1 term1 factor1
%%
statement_list: statement_list statement ';' '\n'
	      | statement ';' '\n'
	      | statement1 ';' '\n'
	      ;
statement: NAME '=' expression { vbltable[$1] = $3; printf("%c = %lf\n",$1+'a',$3);} 
	 | expression { printf("= %g\n",$1); }
	 ;
expression: expression '+' term { $$ = $1 + $3; }
	  | expression '-' term { $$ = $1 - $3; }
	  | term { }
	  ;
term: term '*' factor { $$ = $1 * $3; }
    | term '/' factor 
      { 
	  if($3==0.0){
		  yyerror ("divide by zero");  
	  }	
	  else{
 		  $$ = $1 / $3;
	  }
      }
    | factor { }
    ;
factor: '-' factor { $$ = -$2; }
      | '(' expression1 ')' { $$ = $2; }
      | INTNUMBER {$$ = $1;}
      | SUB '(' expression1 ',' expression1 ')' { $$ = $3-$5; }
      | ABS '(' expression1 ')' {if($3<0){$$=(-1)*$3;}}
      | VOLUME '(' expression1 ')' { $$ = 3.1416*$3*$3; }
      | INTNUMBER { $$ = vbltable2[$1]; } 
      ;
      
      



statement1: NAME '=' expression1 { vbltable2[$1] = $3; printf("%c = %d\n",$1+'a',$3);} 
	 | expression1 { printf("= %d\n",$1); }
	 ;
expression1: expression1 '+' term1 { $$ = $1 + $3; }
	  | expression1 '-' term1 { $$ = $1 - $3; }
	  | term1 { }
	  ;
term1: term1 '*' factor1 { $$ = $1 * $3; }
    | term1 '/' factor1 
      { 
	  if($3==0.0){
		  yyerror ("divide by zero");  
	  }	
	  else{
 		  $$ = $1 / $3;
	  }
      }
    | factor1 { }
    ;
factor1: '-' factor1 { $$ = -$2; }
      | '(' expression1 ')' { $$ = $2; }
      | INTNUMBER {$$ = $1;}
      | SUB '(' expression1 ',' expression1 ')' { $$ = $3-$5; }
      | ABS '(' expression1 ')' {if($3<0){$$=(-1)*$3;}}
      | VOLUME '(' expression1 ')' { $$ = 3.1416*$3*$3; }
      | INTNUMBER { $$ = vbltable2[$1]; } 
      ;
%%
int main(){	
	FILE *file;
	file = fopen("code.c", "r") ;
	if (!file) {
		printf("couldnot open file");
		exit (1);	
	}
	else {
		yyin = file;
	}
	yyparse();
}

