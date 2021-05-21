%{
#include "y.tab.h"
#include <math.h>
extern double vbltable[26];
extern int vbltable2[26];
%}
%%
(([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?) {
	yylval.dval = atof(yytext); return NUMBER;
}
[0-9]+ { yylval.intval = atoi(yytext); return INTNUMBER;}

"area" { return AREA; }
"mod" { return MOD; }
"exponent" { return EXPONENT; }
[ \t] ; /* ignore whitespace */
[a-z] { yylval.vblno = yytext[0] - 'a'; return NAME; }
\n|. return yytext[0];
%%
