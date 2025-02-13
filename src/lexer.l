%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>

#define YY_DECL int yylex(void)

%}

%%

[ \t\r]+    ;  // Ignorar espaços, tabulações e quebras de linha

"var"       { return VAR; }
"print"     { return PRINT; }
[0-9]+      { yylval.ival = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return IDENTIFIER; }

"="         { return EQUALS; }
";"         { return SEMICOLON; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return TIMES; }
"/"         { return DIVIDE; }

.           { printf("Caractere inesperado: %s\n", yytext); exit(1); }

%%

int yywrap() {
    return 1;
}
