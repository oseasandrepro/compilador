%{

#include <stdio.h>

%}


%option noyywrap

DIGIT [0-9]+
LETTER [a-zA-Z]
ID[a-zA-Z][a-zA-Z0-9]*
WHITESPACE[  ]
ABERTURA[ ( ]
FECHAMENTO[ ) ]
STRING_ABERTURA[ " ]
STRING_FECHAMENTO[ " ]
ID_SPACE[a-zA-Z ][a-zA-Z0-9 ]*

%%



senao  {printf("[%s] -> CONDICIONAL\n", yytext); }
"senao"+{WHITESPACE} {printf("[%s] -> CONDICIONAL\n", yytext); }

fimse  {printf("[%s] -> CONDICIONAL\n", yytext); }
"fimse"+{WHITESPACE} {printf("[%s] -> CONDICIONAL\n", yytext); }


enq {printf("[%s] -> REPETICAO\n", yytext); }
"enq"+{WHITESPACE} {printf("[%s] -> REPETICAO\n", yytext); }

fimenq  {printf("[%s] -> REPETICAO\n", yytext); }
"fimnq"+{WHITESPACE} {printf("[%s] -> REPETICAO\n", yytext); }



int {printf("[%s] -> TIPO DE DADOS\n", yytext); }
"int"+{WHITESPACE} {printf("[%s] -> TIPO DE DADOS\n", yytext); }



float  {printf("[%s] -> TIPO DE DADOS\n", yytext); }
"float"+{WHITESPACE} {printf("[%s] -> TIPO DE DADOS\n", yytext); }

imprim {printf("[%s] -> FUNCAO DE SAIDA\n", yytext); }
"imprim"+{WHITESPACE} {printf("[%s] -> FUNCAO DE SAIDA\n", yytext); }

input {printf("[%s] -> FUNCAO DE ENTRADA\n", yytext); }
"input"+{WHITESPACE} {printf("[%s] -> FUNCAO DE ENTRADA\n", yytext); }

rat {printf("[%s] -> FIM PROGRAMA\n", yytext); }

"+" {printf("[%s] -> OPERADOR SOMA\n", yytext);}
"-" {printf("[%s] -> OPERADOR SUBTRACAO\n", yytext);}
"%" {printf("[%s] -> OPERADOR DIVISAO\n", yytext);}
"*" {printf("[%s] -> OPERADOR DIVISAO\n", yytext);}


">" {printf("[%s] -> OPERADOR MAIOR QUE\n", yytext);}
"<" {printf("[%s] -> OPERADOR MENOR QUE\n", yytext);}
">=" {printf("[%s] -> OPERADOR MAIOR OU IGUAL\n", yytext);}
"<=" {printf("[%s] -> OPERADOR MENOR OU IGUAL\n", yytext);}


"=" {printf("[%s] -> OPERADOR DE ATRIBUICAO\n", yytext);}

e {printf("[%s] -> OPERADOR DE ATRIBUICAO\n", yytext);}

"{" {printf("[%s] -> ABERTURA DE CHAVES\n", yytext);}
"}" {printf("[%s] -> FECHAMENTO DE CHAVES\n", yytext);}

{DIGIT} {printf("[%s] -> DIGITO\n", yytext);}
{DIGIT}+{WHITESPACE} {printf("[%s] -> DIGITO\n", yytext);}
{WHITESPACE}+{DIGIT}+{WHITESPACE} {printf("[%s] -> DIGITO\n", yytext);}

{ID_SPACE}+{DIGIT} {printf("[%s] -> IDENTIFICADOR\n", yytext);}
{ID_SPACE}+{DIGIT}+{WHITESPACE} {printf("[%s] -> IDENTIFICADOR\n", yytext);}
([:space:])*+{ID}+{DIGIT} {printf("[%s] -> IDENTIFICADOR\n", yytext);}

{LETTER} {printf("[%s] -> LETRA\n", yytext);}
{LETTER}+{WHITESPACE} {printf("[%s] -> LETRA\n", yytext);}
{WHITESPACE}+{LETTER}+{WHITESPACE} {printf("[%s] -> LETRA\n", yytext);}

{STRING_ABERTURA}+{ID}+([[:space:]]+{ID})*{STRING_FECHAMENTO} {printf("[%s] -> STRING\n", yytext);}
{STRING_ABERTURA}+{ID}+([[:space:]])* {printf("[%s] -> ERRO\n", yytext);}
{STRING_ABERTURA}+{ID_SPACE}*{DIGIT}*{STRING_FECHAMENTO} {printf("[%s] -> STRING\n", yytext);}
{STRING_ABERTURA}+{ID}+{DIGIT}+{STRING_FECHAMENTO} {printf("[%s] -> STRING\n", yytext);}


[[:^space:]]+;

%%
int main(){
	yylex();
	return 0;
}