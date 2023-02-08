%{

#include <stdio.h>
#include "comp.h"

%}


%option noyywrap

DIGIT [0-9]
LETTER [a-zA-Z]
ID[a-zA-Z_][a-zA-Z0-9_]*
ABERTURA[(]
FECHAMENTO[)]
STRING_ABERTURA["]
STRING_FECHAMENTO["]

%%


"senao"					{printf("[%s] -> CONDICIONAL\n", yytext);			return SENAO;}
"fimse"					{printf("[%s] -> CONDICIONAL\n", yytext);			return FIMSE;}
"enq"					{printf("[%s] -> REPETICAO\n",	yytext);			return ENQ;}
"fimenq"				{printf("[%s] -> REPETICAO\n", yytext);				return FIMENQ;}
"int"					{printf("[%s] -> TIPO DE DADOS\n", yytext); 		return INT;}
"float"					{printf("[%s] -> TIPO DE DADOS\n", yytext); 		return FLOAT;}
"imprim"				{printf("[%s] -> COMANDO DE SAIDA\n", yytext); 		return IMPRIM;}
"input"					{printf("[%s] -> COMANDO DE ENTRADA\n", yytext); 	return INPUT_COMMAND;}
"rat" 					{printf("[%s] -> FIM PROGRAMA\n", yytext);			return RAT;}

"+" 					{printf("[%s] -> OPERADOR SOMA\n", yytext);}
"-" 					{printf("[%s] -> OPERADOR SUBTRACAO\n", yytext);}
"%" 					{printf("[%s] -> OPERADOR DIVISAO\n", yytext);}
"*"						{printf("[%s] -> OPERADOR DIVISAO\n", yytext);}


">"						{printf("[%s] -> OPERADOR MAIOR QUE\n", yytext);}
"<" 					{printf("[%s] -> OPERADOR MENOR QUE\n", yytext);}
">="					{printf("[%s] -> OPERADOR MAIOR OU IGUAL\n", yytext);}
"<="					{printf("[%s] -> OPERADOR MENOR OU IGUAL\n", yytext);}


"=" 					{printf("[%s] -> OPERADOR DE ATRIBUICAO\n", yytext);}


"{" 					{printf("[%s] -> ABERTURA DE CHAVES\n", yytext);}
"}" 					{printf("[%s] -> FECHAMENTO DE CHAVES\n", yytext);}

[-]?[1-9]*{DIGIT}* 			{printf("[%s] -> UM VALOR INTEIRO\n", yytext); return INT_VALUE;}
{DIGIT}*[.]{DIGIT}*		{printf("[%s] -> UM VALOR FLOAT\n", yytext); return FLOAT_VALUE;}

{ID}					{printf("[%s] -> IDENTIFICADOR\n", yytext);}						;

{STRING_ABERTURA}.*{STRING_FECHAMENTO}				{printf("[%s] -> STRING\n", yytext); return STRING_CONST;}
{STRING_ABERTURA}.*					{printf("[%s] string mal formatada-> ERRO\n", yytext);}

[ \t]                	{;}
[,\n]          	   		{return *yytext;}

.						{printf("Caracter desconhencido: %c\n", *yytext); return *yytext;}
%%

int main()
{
	while( yylex() != RAT ){

	}
	return 0;
}