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
void declare_variable(struct symbol_table *table, char *name, char *dataType);
void update_variable(struct symbol_table *table, char *str, int value);
void add(struct symbol_table *table, char *name);
variable *find_variable(struct symbol_table *table, char *name);
int variableValue(char *str);

struct symbol_table symbol_table;

%}

%union
{
	int num;
        float num2;
	char *sptr;
};

%start PROGRAM
%token <sptr> VARNAME
%token <sptr> STRINGCONST
%token <sptr> INT
%token <sptr> FLOAT
%token <sptr> INPUT_COMMAND
%token <sptr> OUTPUT_COMMAND
%token <sptr> ENQ
%token <sptr> FIMENQ
%token <sptr> SE
%token <sptr> SENAO
%token <sptr> FIMSE
%token <sptr> RAT



%token <num> INT_VALUE 
%token <num2> FLOAT_VALUE 

%token EQ GT LT EGT ELT

%type <num> VALUE EXP CONDI 
%type <sptr> CONDITIONAL OUTPUT LOOP DATA_TYPE


%right '='
%left '+' '-'
%left '*' '/'
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
        |   RAT {add(&symbol_table, $1);}
        ;

DATA_TYPE   :   INT | FLOAT

DECLARATION :   DATA_TYPE VARNAME {declare_variable(&symbol_table, $2, $1); printf("--DECLARATION--\n");}
            |   DATA_TYPE VARNAME '=' EXP {declare_variable(&symbol_table, $2, $1); update_variable(&symbol_table, $2, $4); printf("--DECLARATION--\n");}
            ;

ASSIGNMENT  : VARNAME '=' EXP {update_variable(&symbol_table, $1, $3); printf("--ASSIGMENT--\n");}
            ;

INPUT   : INPUT_COMMAND '{' DATA_TYPE ',' VARNAME '}' {add(&symbol_table, $1); declare_variable(&symbol_table, $5, $3); printf("--INPUT--\n");}
        ;

OUTPUT  : OUTPUT_COMMAND    STRINGCONST                         {add(&symbol_table, $1); printf("%s \n", $2);}
        | OUTPUT_COMMAND    VARNAME                             {add(&symbol_table, $1); printf("%s \n", $2);}
        | OUTPUT_COMMAND    EXP                                 {add(&symbol_table, $1); printf("%d \n", $2);}
        ;

CONDITIONAL :   SE '{' CONDI '}' EXP FIMSE                  {add(&symbol_table, $1); add(&symbol_table, $6); if($3){$$ = $5;} else {$$ = 0;};}
            |   SE '{' CONDI '}' EXP SENAO EXP FIMSE    {add(&symbol_table, $1); add(&symbol_table, $6); add(&symbol_table, $8); if($3){$$ = $5;} else {$$ = $7;};}
            ;

LOOP: ENQ '{' CONDI '}' EXP FIMENQ  {add(&symbol_table, $1); add(&symbol_table, $6); while($3){$$ = 5;}}

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

        printf("Simbolo |DataType       |Type   |Value \n");
        for(int i = 0; i < symbol_table.count; i++){
                printf("%s\t|%s\t|%s\t|%d\n", symbol_table.variables[i].name, symbol_table.variables[i].data_type, symbol_table.variables[i].type, symbol_table.variables[i].value);
        }        

	return(0);
}

void init_symbol_table(struct symbol_table *table) {
  table->count = 0;
}

void declare_variable(struct symbol_table *table, char *name, char *dataType)
{
  if (table->count == MAX_VARIABLES) 
  {
    fprintf(stderr, "variavéis demais\n");
    exit(1);
  }

  strcpy(table->variables[table->count].name, name);
  table->variables[table->count].value = 0;
  strcpy(table->variables[table->count].data_type, dataType);
  strcpy(table->variables[table->count].type, "Variavel");
  
  table->count++;
}

void add(struct symbol_table *table, char *name)
{
  if (table->count == MAX_VARIABLES) 
  {
    fprintf(stderr, "variavéis demais\n");
    exit(1);
  }

  strcpy(table->variables[table->count].name, name);
  table->variables[table->count].value = 0;
  strcpy(table->variables[table->count].data_type, "Keyword");
  strcpy(table->variables[table->count].type, "N/A");
  
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
