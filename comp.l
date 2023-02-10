%{

#include <stdio.h>
#include <stdlib.h>
#include "comp.h"
#include "y.tab.h"

extern struct symbol_table symbol_table;
extern variable* add_variable(struct symbol_table *table, char *name, int value);

char *create_var(char *s, int l);
int yywrap();

%}


DIGIT [0-9]
LETTER [a-zA-Z]
ID[a-zA-Z_][a-zA-Z0-9_]*
ABERTURA[(]
FECHAMENTO[)]
STRING_ABERTURA["]
STRING_FECHAMENTO["]

%%

"se"    		        {printf("[%s] -> CONDICIONAL\n", yytext);			return SE;}
"senao"                 {printf("[%s] -> CONDICIONAL\n", yytext);			return SENAO;}
"fimse"					{printf("[%s] -> CONDICIONAL\n", yytext);			return FIMSE;}
"enq"					{printf("[%s] -> REPETICAO\n",	yytext);			return ENQ;}
"fimenq"				{printf("[%s] -> REPETICAO\n", yytext);				return FIMENQ;}
"int"					{printf("[%s] -> TIPO DE DADOS\n", yytext); 		return INT;}
"float"					{printf("[%s] -> TIPO DE DADOS\n", yytext); 		return FLOAT;}
"imprim"				{printf("[%s] -> COMANDO DE SAIDA\n", yytext); 		return OUTPUT_COMMAND;}
"input"					{printf("[%s] -> COMANDO DE ENTRADA\n", yytext); 	return INPUT_COMMAND;}
"rat" 					{printf("[%s] -> FIM PROGRAMA\n", yytext);			return RAT;}

"+" 					{printf("[%s] -> OPERADOR SOMA\n", yytext);			    return *yytext;}
"-" 					{printf("[%s] -> OPERADOR SUBTRACAO\n", yytext);	    return *yytext;}
"%" 					{printf("[%s] -> OPERADOR DIVISAO\n", yytext);		    return *yytext;}
"*"						{printf("[%s] -> OPERADOR DIVISAO\n", yytext);		    return *yytext;}
"="                     {printf("[%s] -> OPERADOR DE ATRIBUIÇÃO\n", yytext);    return *yytext;}
","						{printf("[%s] -> VIRGULA\n", yytext);                   return *yytext;}
"{" 					{printf("[%s] -> ABERTURA DE CHAVES\n", yytext);        return *yytext;}
"}" 					{printf("[%s] -> FECHAMENTO DE CHAVES\n", yytext);	    return *yytext;}

">"						{printf("[%s] -> OPERADOR MAIOR QUE\n", yytext);	    return GT;}
"<" 					{printf("[%s] -> OPERADOR MENOR QUE\n", yytext);	    return LT;}
">="					{printf("[%s] -> OPERADOR MAIOR OU IGUAL\n", yytext);	return EGT;}
"<="					{printf("[%s] -> OPERADOR MENOR OU IGUAL\n", yytext);	return ELT;}
"eq"                    {printf("[%s] -> OPERADOR DE COMPARACAO\n", yytext);	return EQ;}

[-]?[1-9]*{DIGIT}* 		{yylval.num = atoi(yytext); printf("[%s] -> UM VALOR INTEIRO\n", yytext);   return INT_VALUE;}
{DIGIT}*[.]{DIGIT}*		{yylval.num = atoi(yytext); printf("[%s] -> UM VALOR FLOAT\n", yytext);     return FLOAT_VALUE;}

{ID}					{yylval.sptr = create_var(yytext, yyleng); printf("[%s] -> IDENTIFICADOR\n", yytext); return VARNAME;}

{STRING_ABERTURA}.*{STRING_FECHAMENTO}				{printf("[%s] -> STRING\n", yytext); return STRINGCONST;}
{STRING_ABERTURA}.*					                {printf("[%s] string mal formatada-> ERRO\n", yytext);}

[ \n\t]+                {;}
.					    {printf("Caracter desconhencido: %c\n", *yytext); return *yytext;}
%%


char *create_var(char *s, int l) {
	char *out = (char *)malloc(sizeof(char) * l);

	strcpy(out, s);

	return(out);
}

void yyerror(char *s) {
	fprintf(stderr, "Error: %s\n", s);
}


int yywrap() {

	return(1);
}


