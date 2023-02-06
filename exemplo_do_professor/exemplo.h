typedef struct {
	int i;
	enum {INTCONST, VAR, OPER } type;	

} value_t;

value_t *search_symtab(char *s);
value_t *create_const(int i);

value_t *create_add(value_t *a, value_t *b);

int updt_symtable(int reg, char *name);
int yylex();

