%{
#include <stdio.h>
#include <stdlib.h>
#include "exemplo.h"
#include "y.tab.h"

extern struct symbol_table symbol_table;
extern variable* add_variable(struct symbol_table *table, char *name, int value);

char *create_var(char *s, int l);
int yywrap(void);
%}

%%
"RAT"							{return EXIT_COMMAND;}
"PRINT"							{return OUT_PUT;}
"VAR"							{return NEW_VARIABLE;}
=								{return EQ;}
[a-zA-Z][a-zA-Z0-9_]*			{yylval.sptr = create_var(yytext, yyleng); return VARNAME; }
[0-9][0-9]*						{yylval.num = atoi(yytext); return INTEGER;}
[ \t]                			{;}
[-+%*\n]          	   			{return yytext[0];}
.			 					{ fprintf(stderr, "Unknown char: %c.\n", *yytext);}
%%

char *create_var(char *s, int l) {
	char *out = (char *)malloc(sizeof(char) * l);

	strcpy(out, s);

	return(out);
}

void yyerror(char *s) {
	fprintf(stderr, "Error: %s\n", s);
}
int yywrap(void) {

	return(1);
}
