%{
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "comp.h"
#include "y.tab.h"

int reg_count = 0;
%}

%start PROGRAM
%token VAR_NAME INT_VALUE FLOAT_VALUE INT FLOAT IMPRIM INPUT_COMMAND STRING_CONST ENQ SE SENAO FIMSE FIMENQ RAT

%%

PROGRAM : | PROGRAM LINE
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

DECLARATION :   DATA_TYPE VAR_NAME
            |   DATA_TYPE VAR_NAME '=' EXP
            ;

ASSIGNMENT  : VAR_NAME '=' EXP
            ;

INPUT   : INPUT_COMMAND '{'DATA_TYPE ',' VAR_NAME'}'
        ;

OUTPUT  : IMPRIM   '"' STRING_CONST '"'
        | IMPRIM    VAR_NAME  
        ;

CONDITIONAL :   SE '{' EXP '}' PROGRAM FIMSE
            |   SE '{' EXP '}' PROGRAM SENAO FIMSE
            ;

LOOP: ENQ '{' EXP '}' PROGRAM FIMENQ

EXP :   VALUE
    |   EXP '+' EXP
    |   EXP '-' EXP
    |   EXP '*' EXP
    |   EXP '%' EXP
    ;

VALUE   : VAR_NAME
        | FLOAT_VALUE
        | INT_VALUE
        ;
%%

int main(void) {

	yyparse();
	return(0);
}