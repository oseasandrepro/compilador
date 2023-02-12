%{
	#include "y.tab.h"
	#include <string.h>
	int countline = 0;

%}

%option yylineno

ID[a-zA-Z_][a-zA-Z0-9_]*
DIGIT [0-9]

%%

"se"    		        {strcpy(yylval.nd_obj.name,(yytext)); return SE;}
"senao"                 {strcpy(yylval.nd_obj.name,(yytext)); return SENAO;}
"fimse"					{strcpy(yylval.nd_obj.name,(yytext)); return FIMSE;}
"enq"					{strcpy(yylval.nd_obj.name,(yytext)); return ENQ;}
"fimenq"				{strcpy(yylval.nd_obj.name,(yytext)); return FIMENQ;}
"int"					{strcpy(yylval.nd_obj.name,(yytext)); return INT;}
"float"					{strcpy(yylval.nd_obj.name,(yytext)); return FLOAT;}
"imprim"				{strcpy(yylval.nd_obj.name,(yytext)); return OUTPUT_COMMAND;}
"input"					{strcpy(yylval.nd_obj.name,(yytext)); return INPUT_COMMAND;}
"rat" 					{strcpy(yylval.nd_obj.name,(yytext)); return RAT;}
"true"					{strcpy(yylval.nd_obj.name,(yytext)); return TRUE;}
"false"					{strcpy(yylval.nd_obj.name,(yytext)); return FALSE;}

"+" 					{strcpy(yylval.nd_obj.name,(yytext)); return *yytext;}
"-" 					{strcpy(yylval.nd_obj.name,(yytext)); return *yytext;}
"%" 					{strcpy(yylval.nd_obj.name,(yytext)); return *yytext;}
"*"						{strcpy(yylval.nd_obj.name,(yytext)); return *yytext;}
"="                     {strcpy(yylval.nd_obj.name,(yytext)); return *yytext;}
","						{strcpy(yylval.nd_obj.name,(yytext)); return *yytext;}
"{" 					{strcpy(yylval.nd_obj.name,(yytext)); return *yytext;}
"}" 					{strcpy(yylval.nd_obj.name,(yytext)); return *yytext;}

">"						{strcpy(yylval.nd_obj.name,(yytext)); return GT;}
"<" 					{strcpy(yylval.nd_obj.name,(yytext)); return LT;}
">="					{strcpy(yylval.nd_obj.name,(yytext)); return EGT;}
"<="					{strcpy(yylval.nd_obj.name,(yytext)); return ELT;}
"eq"                    {strcpy(yylval.nd_obj.name,(yytext)); return EQ;}
"!="					{strcpy(yylval.nd_obj.name,(yytext)); return NE;}

[-]?[1-9]*{DIGIT}* 		{strcpy(yylval.nd_obj.name,(yytext)); return INT_VALUE;}
{DIGIT}*[.]{DIGIT}*		{strcpy(yylval.nd_obj.name,(yytext)); return FLOAT_VALUE;}

{ID}					{strcpy(yylval.nd_obj.name,(yytext)); return VARNAME;}

["].*["]				{strcpy(yylval.nd_obj.name,(yytext)); return STRINGCONST;}
[ \t]+                  {;}
[\n]					{countline++;}
.					    {printf("Caracter desconhencido: %c\n", *yytext); return *yytext;}
%%

int yywrap() {

	return(1);
}


