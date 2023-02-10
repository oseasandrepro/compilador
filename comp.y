%{

void yyerror (char *s);
int yylex();

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include "comp.h"
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
	int num;;
	char *sptr;
};

%start PROGRAM
%token <sptr> VARNAME
%token <sptr> STRINGCONST 
%token <num> INT_VALUE 
%token <num> FLOAT_VALUE 

%token INT FLOAT INPUT_COMMAND OUTPUT_COMMAND ENQ FIMENQ SE SENAO FIMSE RAT EQ GT LT EGT ELT

%type <num> VALUE EXP CONDI 
%type <sptr> CONDITIONAL OUTPUT LOOP

%right EQ
%left PLUS MINUS
%left MULTY DIVIDE
%left '<' '>'

%%

PROGRAM : 
        | PROGRAM LINE
        ;

LINE    :   DECLARATION
        |   ASSIGNMENT
        |   INPUT
        |   OUTPUT
        |   CONDITIONAL
        |   LOOP
        |   RAT
        ;

DATA_TYPE   :   INT | FLOAT

DECLARATION :   DATA_TYPE VARNAME {declare_variable(&symbol_table, $2); printf("--DECLARATION--\n");}
            |   DATA_TYPE VARNAME '=' EXP {declare_variable(&symbol_table, $2); update_variable(&symbol_table, $2, $4); printf("--DECLARATION--\n");}
            ;

ASSIGNMENT  : VARNAME '=' EXP {update_variable(&symbol_table, $1, $3); printf("--ASSIGMENT--\n");}
            ;

INPUT   : INPUT_COMMAND '{' DATA_TYPE ',' VARNAME '}' {declare_variable(&symbol_table, $5); printf("--INPUT--\n");}
        ;

OUTPUT  : OUTPUT_COMMAND    STRINGCONST                         {printf("%s \n", $2); }
        | OUTPUT_COMMAND    VARNAME                             {printf("%s \n", $2); }
        | OUTPUT_COMMAND    EXP                                 {printf("%d \n", $2);}
        ;

CONDITIONAL :   SE '{' CONDI '}' PROGRAM FIMSE                  { /*if(){ } else { };*/ }
            |   SE '{' CONDI '}' PROGRAM SENAO PROGRAM FIMSE    { /*if(){ } else { };*/ }
            ;

LOOP: ENQ '{' CONDI '}' PROGRAM FIMENQ  { /*while(){ }*/ }

EXP :   VALUE           
    |   EXP '+' EXP     {$$ = $1 + $3;}
    |   EXP '-' EXP     {$$ = $1 - $3;}
    |   EXP '*' EXP     {$$ = $1 * $3;}
    |   EXP '%' EXP     {$$ = $1 / $3;}
    ;

CONDI   : VALUE
        | CONDI LT  CONDI   {$$ = $1 < $3;}
        | CONDI GT  CONDI   {$$ = $1 > $3;}
        | CONDI EGT CONDI   {$$ = $1 >= $3;}
        | CONDI ELT CONDI   {$$ = $1 <= $3;}
        | CONDI EQ  CONDI   {$$ = $1 == $3;}
        ;

VALUE   : VARNAME {$$ = variableValue($1);}
        | FLOAT_VALUE {$$ = $1;} 
        | INT_VALUE {$$ = $1;} 
        ;
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
