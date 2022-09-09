%{
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "comp.h"
#include "y.tab.h"

int reg_count = 0;
%}

%start PROGRAM
%token DATA_TYPE VAR_NAME INTEGER FLOAT DATATYPE IMPRIM STRING_CONST ENQ SE SENAO FIMSE FIMENQ RAT

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

DECLARATION :   DATA_TYPE VAR_NAME
            |   DATA_TYPE VAR_NAME '=' EXP
            ;

ASSIGNMENT  : VAR_NAME '=' EXP
            ;

INPUT   :   '{'DATA_TYPE ',' VAR_NAME'}'
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
        | INTEGER
        | FLOAT
        ;
%%

int main(void) {

	yyparse();
	return(0);
}