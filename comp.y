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
} symbol_table[MAX_SYMBOLS];

int count = 0;
int q;
char type[10];
extern int countline;
extern char *yytext;

struct node { 
        struct node *left; 
	struct node *right; 
	char *token; 
};

#define COUNT 7
void printtree(struct node*);
void printInorder(struct node* root, int space);
struct node* mknode(struct node *left, struct node *right, char *token);

struct node *head = NULL;
struct node *last_line = NULL;


%}

%union { 
	struct nss_token { 
		char name[100]; 
		struct node* nd;
	} nd_obj;
} 

%token <nd_obj> EQ NE GT LT EGT ELT VARNAME STRINGCONST INT FLOAT INPUT_COMMAND
%token <nd_obj> OUTPUT_COMMAND ENQ FIMENQ SE SENAO FIMSE INT_VALUE FLOAT_VALUE RAT
%token <nd_obj> TRUE FALSE
%type  <nd_obj> output_command se relop arithmetic program line rat stm fimse fimenq declaration init assignment input datatype output conditional senao loop exp value condi

%right '='
%left '+' '-'
%left '*' '/'
%left '<' '>'

%%

program: line rat { $$.nd = mknode($1.nd, $2.nd, "program"); head = $$.nd; };

rat : RAT { add('K'); $$.nd = mknode(NULL, NULL, $1.name); }

line    : { $$.nd =  NULL;}
        | stm line      { $$.nd = mknode($1.nd, $2.nd, "line"); }

stm     :   declaration
        |   assignment
        |   input
        |   output
        |   conditional
        |   loop
        ;

datatype       : INT   { insert_type(); }
               | FLOAT { insert_type(); }

declaration :   datatype VARNAME { add('V'); } init    {        $2.nd = mknode(NULL, NULL, $2.name); 
                                                                $$.nd = mknode($2.nd, $4.nd, "declaration");

                                                        };
init    :               { $$.nd = NULL; } 
        | '=' exp       { $$.nd = $2.nd; }
        ;

assignment  : VARNAME '=' exp   { $$.nd = mknode($1.nd, $3.nd, "="); }
            ;

input   : INPUT_COMMAND { add('K'); } '{' datatype ',' VARNAME '}'    {  $$.nd = mknode($4.nd, $6.nd, $1.name); }
        ;


output  : output_command        STRINGCONST { add('C'); }     { $2.nd = mknode(NULL, NULL,$2.name); $$.nd = mknode(NULL, $2.nd, $1.name);}    
        | output_command        exp                           { $$.nd = mknode(NULL, $2.nd, $1.name);}                
        ; 
output_command : OUTPUT_COMMAND { add('K'); }

conditional  :   se '{' condi '}' line fimse               { struct node *sse = mknode($3.nd, $5.nd, $1.name); $$.nd = mknode(sse, $6.nd, "se-senao"); }
             |   se '{' condi '}' line senao line fimse    { 
                                                                                struct node *sse = mknode($3.nd, $5.nd, $1.name);
                                                                                $6.nd->left = $7.nd;
                                                                                $6.nd->right = $7.nd;
                                                                                $$.nd = mknode(sse, $8.nd, "se-senao"); 
                                                                        };
            ;
fimse : FIMSE   { add('K'); } { $$.nd = mknode(NULL, NULL, $1.name);}
senao : SENAO   { add('K'); } { $$.nd = mknode(NULL, NULL, $1.name); }
se    : SE      { add('K'); } { $$.nd = mknode(NULL, NULL, $1.name); }    

loop: ENQ { add('K'); }  '{' condi '}' line fimenq                      { 
                                                                                struct node *eqq = mknode($4.nd, $6.nd, $1.name);
                                                                                $$.nd = mknode(eqq, $7.nd, "loop"); 
                                                                        } 
fimenq : FIMENQ { add('K'); } { $$.nd = mknode(NULL, NULL, $1.name); }


exp     : value                 { $$.nd = $1.nd; }
        | exp arithmetic exp    { $$.nd = mknode($1.nd, $3.nd, $2.name); }
        ;

arithmetic : '+' | '-' | '*' | '%' ;

condi   : value relop value     { $$.nd = mknode($1.nd, $3.nd, $2.name); }
        | TRUE                  { add('K'); $$.nd = NULL; }
        | FALSE                 { add('K'); $$.nd = NULL; }
        ;

relop: LT | GT | EGT | ELT | EQ | NE ;

value   : VARNAME       { $$.nd = mknode(NULL, NULL, $1.name); }
        | FLOAT_VALUE   { add('C'); $$.nd = mknode(NULL, NULL, $1.name); }
        | INT_VALUE     { add('C'); $$.nd = mknode(NULL, NULL, $1.name); }
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
	printf("\t\t PHASE 2: SYNTAX ANALYSIS \n\n");
	printtree(head); 
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

struct node* mknode(struct node *left, struct node *right, char *token) 
{
  struct node *newnode = (struct node*) malloc(sizeof(struct node));
  char *newstr = (char*) malloc(strlen(token)+1);
  strcpy(newstr, token);
  newnode->left = left;
  newnode->right = right;
  newnode->token = newstr;
  return(newnode);
}

void printtree(struct node* root) {
	printf("\n\n Inorder traversal of the Parse Tree: \n\n");
	printInorder(root, 0);
	printf("\n\n");
}

void printInorder(struct node* root, int space) {
if (root == NULL)
     return;

    space += COUNT;

    printInorder(root->right, space);

    printf("\n");
    for (int i = COUNT; i < space; i++)
        printf(" ");

    printf("%s\n", root->token);

    printInorder(root->left, space);
}

/*
void print2DUtil(struct node* root, int space)
{
   if (root == NULL)
     return;

    space += COUNT;

    print2DUtil(root->right, space);

    printf("\n");
    for (int i = COUNT; i < space; i++)
        printf(" ");

    printf("%s\n", root->token);

    print2DUtil(root->left, space);
}

void print2D(struct node* root){
    print2DUtil(root, 0);
}
*/