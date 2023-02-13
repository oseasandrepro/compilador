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

char *get_type(char *var);

struct dataType {
        char * id_name;
        char * data_type;
        char * type;
        int line_no;
} symbol_table[MAX_SYMBOLS];

int temp_var=0;
int count = 0;
int q;
char type[10];
int ic_idx = 0;
int label = 0;
int is_enq = 0;
int is_else = 0;
char buff[100];
char icg[50][100];
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
        
} 

%token <nd_obj> EQ NE GT LT EGT ELT VARNAME STRINGCONST INT FLOAT INPUT_COMMAND
%token <nd_obj> OUTPUT_COMMAND ENQ FIMENQ SE SENAO FIMSE INT_VALUE FLOAT_VALUE RAT
%token <nd_obj> TRUE FALSE
%type  <nd_obj> output_command se relop arithmetic program line rat stm fimse fimenq declaration assignment input datatype output senao loop conditional
%type  <nd_obj2> condi
%type  <nd_obj3>  exp value init

%right '='
%left '+' '-'
%left '*' '/'
%left '<' '>'

%%

program: line rat { $$.nd = mknode($1.nd, $2.nd, "program"); head = $$.nd;  };

rat : RAT { add('K'); $$.nd = mknode(NULL, NULL, $1.name); sprintf(icg[ic_idx++], "return 0; }");}

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
                                                                sprintf(icg[ic_idx++], "%s %s %s;\n", $1.name, $2.name, $4.name);
                                                        };
init    :               { $$.nd = NULL; sprintf($$.name, " "); } 
        | '=' exp       { $$.nd = $2.nd; sprintf($$.name, "=%s", $2.name);}
        ;

assignment  : VARNAME '=' exp   { $$.nd = mknode($1.nd, $3.nd, "="); sprintf(icg[ic_idx++], "%s = %s;\n", $1.name, $3.name);}
            ;

input   : INPUT_COMMAND { add('K'); } '{' datatype ',' VARNAME '}'    {  $$.nd = mknode($4.nd, $6.nd, $1.name);
                                                                         if( strcmp(type, "int") == 0 )
                                                                                sprintf(icg[ic_idx++],"scanf(\"%%d\",&%s);\n", $6.name);
                                                                        else if( strcmp(type, "float") == 0 )
                                                                                sprintf(icg[ic_idx++],"scanf(\"%%f\",&%s);\n", $6.name);
                                                                      }
        ;


output  : output_command        STRINGCONST { add('C'); }     { $2.nd = mknode(NULL, NULL,$2.name); $$.nd = mknode(NULL, $2.nd, $1.name);
                                                                sprintf(icg[ic_idx++],"printf(%s);\n", $2.name);
                                                              }    
        | output_command        exp                           { 
                                                                $$.nd = mknode(NULL, $2.nd, $1.name);
                                                                if( strcmp($2.type, "int" ) == 0 )
                                                                         sprintf(icg[ic_idx++],"printf(\"%%d\", %s);\n", $2.name);
                                                                else if( strcmp($2.type, "float" ) == 0 )
                                                                        sprintf(icg[ic_idx++],"printf(\"%%f\", %s);\n", $2.name);
                                                              }                
        ; 
output_command : OUTPUT_COMMAND { add('K'); }

conditional  :   se '{' condi '}' line fimse            { 
                                                                struct node *sse = mknode($3.nd, $5.nd, $1.name);
                                                                $$.nd = mknode(sse, $6.nd, "se-senao"); 
                                                                
                                                                sprintf(icg[ic_idx++], "goto L%d;\n", label-1);
                                                                sprintf(icg[ic_idx++], "%s:\n", $3.else_body);
                                                        }
             |   se '{' condi '}' line senao  line fimse {
                                                                struct node *sse = mknode($3.nd, $5.nd, $1.name);
                                                                $6.nd->left = $8.nd;
                                                                $6.nd->right = $7.nd;
                                                                $$.nd = mknode(sse, $6.nd, "se-senao");

                                                                sprintf(icg[ic_idx++], "goto L%d;\n", label);
                                                                sprintf(icg[ic_idx++], "L%d:\n",label);

                                                        };


fimse : FIMSE   { add('K'); } { $$.nd = mknode(NULL, NULL, $1.name);}

senao : SENAO   { add('K'); } { $$.nd = mknode(NULL, NULL, $1.name);  sprintf(icg[ic_idx++], "goto L%d;\n", label);
                                                                      sprintf(icg[ic_idx++], "L%d:\n",label-1);}

se    : SE      { add('K'); {is_enq = 0;} } { $$.nd = mknode(NULL, NULL, $1.name); } 

loop: ENQ { add('K'); is_enq = 1;}  '{' condi '}' line fimenq           { 
                                                                                struct node *eqq = mknode($4.nd, $6.nd, $1.name);
                                                                                $$.nd = mknode(eqq, $7.nd, "loop"); 
                                                                        } 

fimenq : FIMENQ { add('K'); } { $$.nd = mknode(NULL, NULL, $1.name); sprintf(icg[ic_idx++], "goto L%d;\n", label-1);
                                                                      sprintf(icg[ic_idx++], "L%d:\n",label);}


exp     : value                 { $$.nd = $1.nd; sprintf($$.type , "%s", $1.type); }
        | exp arithmetic exp    { 
                                        if(!strcmp($1.type, $3.type)) {
		                                sprintf($$.type,"%s", $1.type);
		                                $$.nd = mknode($1.nd, $3.nd, $2.name); 
	                                }
                                        sprintf($$.name, "t%d", temp_var);
	                                temp_var++;
	                                sprintf(icg[ic_idx++], "%s %s = %s %s %s;\n",$$.type,  $$.name, $1.name, $2.name, $3.name);
                                }
        ;

arithmetic : '+' | '-' | '*' | '%' ;

condi   : value relop value     {
                                        if(is_enq) 
                                        {  
                                                sprintf($$.if_body, "L%d", ++label);  
                                                sprintf(icg[ic_idx++], "\n%s:\n", $$.if_body);
                                                sprintf(icg[ic_idx++], "\nif ( !(%s %s %s) )\n\tgoto L%d;\n", $1.name, $2.name, $3.name, label+1);  
                                                sprintf($$.else_body, "L%d:", label++); 
                                        } 
                                        else {
                                                if( strcmp("eq",$2.name) == 0)
                                                          sprintf(icg[ic_idx++], "\nif (%s %s %s) goto L%d; else goto L%d;\n", $1.name, "==", $3.name, label, label+1);
                                                else
                                                        sprintf(icg[ic_idx++], "\nif (%s %s %s) goto L%d; else goto L%d;\n", $1.name, $2.name, $3.name, label, label+1);
                                                sprintf($$.if_body, "L%d", label++);  
                                                sprintf($$.else_body, "L%d", label++);
                                                sprintf(icg[ic_idx++], "L%d:\n", label-2);
                                        }
                                        
                                }
        | TRUE                  { add('K'); $$.nd = NULL; }
        | FALSE                 { add('K'); $$.nd = NULL; }
        ;

relop: LT | GT | EGT | ELT | EQ | NE ;

value   : VARNAME       { $$.nd = mknode(NULL, NULL, $1.name); sprintf($$.name, $1.name); char *id_type = get_type($1.name); sprintf($$.type,"%s",id_type); }
        | FLOAT_VALUE   { strcpy($$.name, $1.name); sprintf($$.type, "float"); add('C'); $$.nd = mknode(NULL, NULL, $1.name); }
        | INT_VALUE     { strcpy($$.name, $1.name); sprintf($$.type, "int"); add('C'); $$.nd = mknode(NULL, NULL, $1.name); }
        ;
%%


void yyerror(const char *s) {
	fprintf(stderr, "Erro: %s\n", s);
}

int main() {
        sprintf(icg[ic_idx++], "#include <stdio.h>\n");
        sprintf(icg[ic_idx++], "#include <stdlib.h>\n");
        sprintf(icg[ic_idx++], "int main(void){\n");
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

        printf("\t\t\t\t\t\t\t   PHASE 3: INTERMEDIATE CODE GENERATION \n\n");
	for(int i=0; i<ic_idx; i++){
		printf("%s", icg[i]);
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

char *get_type(char *var){
	for(int i=0; i<count; i++) {
		if(!strcmp(symbol_table[i].id_name, var)) {
			return symbol_table[i].data_type;
		}
	}

        return NULL;
}