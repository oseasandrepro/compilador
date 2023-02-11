%{
	#include "y.tab.h"
	int countline = 0;

%}

%option yylineno

ID[a-zA-Z_][a-zA-Z0-9_]*
DIGIT [0-9]

%%

"se"    		        {return SE;}
"senao"                 {return SENAO;}
"fimse"					{return FIMSE;}
"enq"					{return ENQ;}
"fimenq"				{return FIMENQ;}
"int"					{return INT;}
"float"					{return FLOAT;}
"imprim"				{return OUTPUT_COMMAND;}
"input"					{return INPUT_COMMAND;}
"rat" 					{return RAT;}

"+" 					{return *yytext;}
"-" 					{return *yytext;}
"%" 					{return *yytext;}
"*"						{return *yytext;}
"="                     {return *yytext;}
","						{return *yytext;}
"{" 					{return *yytext;}
"}" 					{return *yytext;}

">"						{return GT;}
"<" 					{return LT;}
">="					{return EGT;}
"<="					{return ELT;}
"eq"                    {return EQ;}
"!="					{return NE;}

[-]?[1-9]*{DIGIT}* 		{return INT_VALUE;}
{DIGIT}*[.]{DIGIT}*		{return FLOAT_VALUE;}

{ID}					{return VARNAME;}

["].*[""]				{return STRINGCONST;}
[ \t]+                {;}
[\n]					{countline++;}
.					    {printf("Caracter desconhencido: %c\n", *yytext); return *yytext;}
%%

int yywrap() {

	return(1);
}


