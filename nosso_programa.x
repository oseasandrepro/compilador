int num1
int num2
int num3
float num4

num1 = 0
num2 = 0


num1 = input{int}
num2 = input{int}
num4 = input{float}

num3 = num1 + num2

imprim "A soma é"
imprim num3

num1 = input{int}

se { num1 > 4 }
	imprim "numero digitado é maior que 4"
fimse

enq { num1 > 4 }
	imprim num1
	num1 = num1 - 1
fimenq

rat
