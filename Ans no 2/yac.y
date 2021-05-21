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
int inc;

%}

%token NUMBER TOKEN PRINT DOWHILE
%%
dowhile_statement : dowhile_cond statement ';' { }
	     ;
dowhile_cond : token '(' expression ')' { int count = 0;}
	 ;




	
	 
expression: expression1 '<' '=' TOKEN '<' '=' expression1 ':' NUMBER {count_start=$1; count_end=$7; var=$4; inc=$9; }
	;
	
statement: command TOKEN {if(var==$2){ 
		do{ 
			printf("%d ",count_start);
			count_start+=inc;
		  
		  } while(count_start<=count_end);
		} 
	}
	;	 
	 


	
command: PRINT { }
       ;
token: DOWHILE { }
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

