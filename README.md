# syntactic-analyzer-using-bison

trabalho de compiladores

### Execução:

```
flex lexer.l
bison -d yacc.y
gcc -c lex.yy.c -o lex.yy.o
gcc -c yacc.tab.c -o yacc.tab.o
gcc -o parser lex.yy.o yacc.tab.o -lfl -lm
./parser [arquivoteste.c]
```


