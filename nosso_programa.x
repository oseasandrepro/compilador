int num1
int num2
int num3
float num4

mum4 = 0.32
num4 = 32.33
num1 = 0
num2 = 0

input{int,num1}
input{int,num2}
input{float,num4}

num3 = num1 + num2

imprim "A soma é"
imprim num3

input{int,num1}

se { num1 > 4 }
	imprim "numero digitado é maior que 4"
fimse

enq { num1 > 4 }
	imprim num1
	num1 = num1 - 1
fimenq
rat
