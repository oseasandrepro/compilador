#define MAX_VARIABLES	100
#define MAX_NAME_LENGTH 100

typedef struct {
  char name[MAX_NAME_LENGTH];
  int value;
} variable;

int yylex();