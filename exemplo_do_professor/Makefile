all: comp

comp: y.tab.c lex.yy.c exemplo.h
	gcc y.tab.c lex.yy.c -o comp -Wall 

lex.yy.c: exemplo.l
	flex exemplo.l

y.tab.c: exemplo.y
	yacc -d exemplo.y


clean:
	rm y.tab.h y.tab.c lex.yy.c comp

