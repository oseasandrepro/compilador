%{
#include <stdio.h>
#include <stdlib.h>
#include "exemplo.h"
#include "y.tab.h"
char *create_var(char *s, int l);
void yyerror(char *);
int yywrap(void);
%}

%%
[a-zA-Z][a-zA-Z0-9]* 	{	yylval.sptr = create_var(yytext, yyleng);
			 	return VARNAME;

			}

[0-9][0-9]*		{	yylval.ival = atoi(yytext);
				return INTEGER;
			}
[+;=]			{	return *yytext;	}

[ \t\n]+		;
.			fprintf(stderr, "Unknown char: %c.\n", *yytext);	

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
