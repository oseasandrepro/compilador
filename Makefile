all: comp

comp: y.tab.c lex.yy.c comp.h
	gcc y.tab.c lex.yy.c -o comp -Wall 

lex.yy.c: comp.l
	flex comp.l

y.tab.c: comp.y
	yacc -d comp.y

clean:
	rm y.tab.h y.tab.c lex.yy.c comp

