%{

void yyerror (char *s);
int yylex();

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "exemplo.h"
#include "y.tab.h"

struct symbol_table {
  variable variables[MAX_VARIABLES];
  int count;
};



void init_symbol_table(struct symbol_table *table);
void declare_variable(struct symbol_table *table, char *name);
void update_variable(struct symbol_table *table, char *str, int value);
variable *find_variable(struct symbol_table *table, char *name);
int variableValue(char *str);

struct symbol_table symbol_table;
%}

%union
{
	int num; 
	char *sptr;
};


%start PROGRAM

%token <sptr> VARNAME
%token <num> INTEGER

%token	OUT_PUT
%token	EXIT_COMMAND
%token	NEW_VARIABLE
%token	EQ


%type <num> VALUE EXP

%left '+' '-'
%left '*' '/'


%%

PROGRAM	:	PROGRAM INSTRUCTION | ;
		;

INSTRUCTION		:	ASSIGMENT '\n'	{;}
				|	EXIT_COMMAND	{printf("--TERMINANDO--\n"); exit(EXIT_SUCCESS); }
				|	OUT_PUT EXP '\n'  {printf("%d \n", $2); }
				|	EXP
				|	DECLARATION '\n'
				;
EXP		: VALUE			{$$ = $1;}
		| EXP '+' VALUE	{$$ = $1 + $3;}
		| EXP '-' VALUE	{$$ = $1 - $3;}
		| EXP '*' VALUE	{$$ = $1 * $3;}
		| EXP '%' VALUE	{$$ = $1 / $3;}
		;

ASSIGMENT	: VARNAME EQ EXP {update_variable(&symbol_table, $1, $3); printf("--ASSIGMENT--\n");}
			;
DECLARATION	: NEW_VARIABLE VARNAME {declare_variable(&symbol_table, $2); printf("--DECLARATION--\n");}

VALUE	:	VARNAME {$$ = variableValue($1);} 
		|	INTEGER	{$$ = $1;} 

%%

int main(void) {
	init_symbol_table(&symbol_table);
	yyparse();
	return(0);
}

void init_symbol_table(struct symbol_table *table) {
  table->count = 0;
}

void declare_variable(struct symbol_table *table, char *name)
{
  if (table->count == MAX_VARIABLES) 
  {
    fprintf(stderr, "variavéis demais\n");
    exit(1);
  }

  strcpy(table->variables[table->count].name, name);
  table->variables[table->count].value = 0;
  table->count++;
}

variable *find_variable(struct symbol_table *table, char *name) 
{
  for (int i = 0; i < table->count; i++)
  {
    if (strcmp(table->variables[i].name, name) == 0) 
	{
        return &table->variables[i];
    }
  }
  return NULL;
}

void update_variable(struct symbol_table *table, char *str, int value) 
{
	variable * var = find_variable(&symbol_table, str);

	if( var == NULL){
	fprintf(stderr, "Erro, varivel não existe\n");
    exit(1);
	}

	var->value = value;
	
}


int variableValue(char *str){

	variable * var = find_variable(&symbol_table, str);
	if(var == NULL){
		printf("Erro, varivel não existe\n");
	}

	return var->value;
}