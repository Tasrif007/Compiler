%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
void yyerror(const char *s){
	fprintf(stderr,"%s\n",s);
}
extern FILE *yyin;
int yylex();
int count_start;
int count_end;
int var=0;
int mul=1;
%}

%token NUMBER TOKEN PRINT SERIESMUL
%%
seriesmul_statement : seriesmul_cond statement ';' { }
	     ;
seriesmul_cond : token '(' expression ')' { int count = 0;}
	 ;




	
	 
expression: TOKEN '=' expression1 ':' expression1 {count_start=$3;count_end=$5; var=$1; }
	;
statement: command TOKEN {if(var==$2){ 
		for(var=count_start;var<count_end;var+=1){
			mul=mul*var;
		}
		printf("The multiplication is : %d ",mul);
	}
	}
	;	 
	 


	
command: PRINT { }
       ;
token: SERIESMUL { }
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
      | NUMBER {$$ = $1;}
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

