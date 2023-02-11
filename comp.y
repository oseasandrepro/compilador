%{

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include "comp.h"

void yyerror(const char *s);
int yylex();
int yywrap();
void add(char);
void insert_type();
int search(char *);
void insert_type();

struct dataType {
        char * id_name;
        char * data_type;
        char * type;
        int line_no;
} symbol_table[100];

int count = 0;
int q;
char type[10];
extern int countline;
extern char *yytext;

%}

%start PROGRAM
%token EQ NE GT LT EGT ELT VARNAME STRINGCONST INT FLOAT INPUT_COMMAND 
%token OUTPUT_COMMAND ENQ FIMENQ SE SENAO FIMSE INT_VALUE FLOAT_VALUE RAT
%token TRUE FALSE

%right '='
%left '+' '-'
%left '*' '/'
%left '<' '>'

%%

PROGRAM : LINE RAT {add('K');}
        ;

LINE    : 
        | STM LINE

STM     :   DECLARATION
        |   ASSIGNMENT
        |   INPUT
        |   OUTPUT
        |   CONDITIONAL
        |   LOOP
        ;

DATA_TYPE       : INT   { insert_type();}
                | FLOAT { insert_type(); }

DECLARATION :   DATA_TYPE VARNAME { add('V'); } init
            ;
init    : 
        | '=' EXP
        ;

ASSIGNMENT  : VARNAME '=' EXP                   {;}
            ;

INPUT   : input_command '{' DATA_TYPE ',' VARNAME '}'  
        ;
input_command : INPUT_COMMAND { add('K'); }

OUTPUT  : output_command    STRINGCONST          {;}    
        | output_command    EXP                  
        ;
output_command : OUTPUT_COMMAND                                 { add('K'); }

CONDITIONAL :   SE '{' CONDI '}' LINE fimse                     { add('K'); }
            |   SE '{' CONDI '}' LINE senao LINE FIMSE          { add('K'); }
            ;
fimse : FIMSE   { add('K'); }
senao : SENAO   { add('K'); }

LOOP: ENQ { add('K'); }  '{' CONDI '}' LINE fimenq
fimenq : FIMENQ { add('K'); }


EXP     : VALUE
        | EXP arithmetic EXP
        ;

arithmetic : '+' | '-' | '*' | '%' ;

CONDI   : VALUE relop VALUE
        | TRUE                  { add('K'); }
        | FALSE                 { add('K'); }
        ;

relop: LT | GT | EGT | ELT | EQ | NE ;

VALUE   : VARNAME
        | FLOAT_VALUE   { add('C'); }
        | INT_VALUE     { add('C'); }
        ;
%%


void yyerror(const char *s) {
	fprintf(stderr, "Erro: %s\n", s);
}

int main() {
        yyparse();
        printf("\n\n");
	printf("\tPHASE 1: LEXICAL ANALYSIS \n\n");
	printf("\nSYMBOL   DATATYPE   TYPE   LINE NUMBER \n");
	printf("_______________________________________\n\n");
	int i=0;
	for(i=0; i<count; i++) {
		printf("%s\t%s\t%s\t%d\t\n", symbol_table[i].id_name, symbol_table[i].data_type, symbol_table[i].type, symbol_table[i].line_no);
	}
	for(i=0;i<count;i++) {
		free(symbol_table[i].id_name);
		free(symbol_table[i].type);
	}
	printf("\n\n");
}

void insert_type() {
    strcpy(type, yytext);
}

void add(char c) 
{
        q=search(yytext);
        if(!q) 
        {
                if(c == 'K') 
                {
                        symbol_table[count].id_name=strdup(yytext);
                        symbol_table[count].data_type=strdup("N/A");
                        symbol_table[count].line_no=countline+1;
                        symbol_table[count].type=strdup("Keyword\t");   
                        count++;  
                }  
                else if(c == 'V') 
                {
                        symbol_table[count].id_name=strdup(yytext);
                        symbol_table[count].data_type=strdup(type);
                        symbol_table[count].line_no=countline+1;
                        symbol_table[count].type=strdup("Variable");   
                        count++;  
                }  
                else if(c == 'C') 
                {
                        symbol_table[count].id_name=strdup(yytext);
                        symbol_table[count].data_type=strdup("CONST");
                        symbol_table[count].line_no=countline+1;
                        symbol_table[count].type=strdup("Constant");   
                        count++;  
                }
        }
}

int search(char *type) { 
    int i; 
    for(i=count-1; i>=0; i--) {
        if(strcmp(symbol_table[i].id_name, type)==0) {   
            return -1;
        }
    } 
    return 0;
}