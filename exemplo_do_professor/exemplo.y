%{
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "exemplo.h"
#include "y.tab.h"

struct sym {
	int reg;
	char name[20];
} symtable[100];


int reg_count = 0;
%}

%union {
	int ival;
	char *sptr;
	value_t *valptr;

};

%token <sptr> VARNAME
%token <ival> INTEGER

%type <valptr> value exp

%%
program	: program stmt 
		| ;

stmt	:	VARNAME '=' exp ';'		{printf("variable: %s\n", $1);}
		|	exp ';'
		;

exp	:	exp '+' value			{$$ = create_add($1, $3);}
	|	value
	;

value	:	VARNAME			{$$ = search_symtab($1);} 
		|	INTEGER			{$$ = create_const($1);}
		;

%%

value_t *create_const(int i) 
{
	 value_t *out = (value_t *) malloc(sizeof(value_t)); 

	out->type = INTCONST;
	out->i = i;
	return(out);
}

value_t *search_symtab(char *s) 
{
	value_t *out = (value_t *) malloc(sizeof(value_t));

	out->type = VAR;
	out->i = 123; //Numero magico so para testar

	return(out);
}



value_t *create_add(value_t *a, value_t *b) {
	value_t *out = (value_t *)malloc(sizeof(value_t));

	out->type = OPER;
	out->i = reg_count++;

	printf("r%d = %c%d + %c%d;\n", out->i, (a->type == INTCONST ? ' ' : 'r'), a->i, (b->type == INTCONST ? ' ' : 'r'), b->i);

	return(out);	
}



int main(void) {

	yyparse();
	return(0);
}
