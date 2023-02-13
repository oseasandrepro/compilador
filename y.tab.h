/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    EQ = 258,                      /* EQ  */
    NE = 259,                      /* NE  */
    GT = 260,                      /* GT  */
    LT = 261,                      /* LT  */
    EGT = 262,                     /* EGT  */
    ELT = 263,                     /* ELT  */
    VARNAME = 264,                 /* VARNAME  */
    STRINGCONST = 265,             /* STRINGCONST  */
    INT = 266,                     /* INT  */
    FLOAT = 267,                   /* FLOAT  */
    INPUT_COMMAND = 268,           /* INPUT_COMMAND  */
    OUTPUT_COMMAND = 269,          /* OUTPUT_COMMAND  */
    ENQ = 270,                     /* ENQ  */
    FIMENQ = 271,                  /* FIMENQ  */
    SE = 272,                      /* SE  */
    SENAO = 273,                   /* SENAO  */
    FIMSE = 274,                   /* FIMSE  */
    INT_VALUE = 275,               /* INT_VALUE  */
    FLOAT_VALUE = 276,             /* FLOAT_VALUE  */
    RAT = 277,                     /* RAT  */
    TRUE = 278,                    /* TRUE  */
    FALSE = 279                    /* FALSE  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define EQ 258
#define NE 259
#define GT 260
#define LT 261
#define EGT 262
#define ELT 263
#define VARNAME 264
#define STRINGCONST 265
#define INT 266
#define FLOAT 267
#define INPUT_COMMAND 268
#define OUTPUT_COMMAND 269
#define ENQ 270
#define FIMENQ 271
#define SE 272
#define SENAO 273
#define FIMSE 274
#define INT_VALUE 275
#define FLOAT_VALUE 276
#define RAT 277
#define TRUE 278
#define FALSE 279

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 56 "comp.y"
 
	struct nss_token { 
		char name[100]; 
		struct node* nd;
	} nd_obj;

        struct nss_obj2 { 
		char name[100]; 
		struct node* nd;
                char if_body[5];
                char else_body[5];
	} nd_obj2;

        struct nss_obj3 { 
		char name[100]; 
		struct node* nd;
		char type[6];
	} nd_obj3;
        

#line 136 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
