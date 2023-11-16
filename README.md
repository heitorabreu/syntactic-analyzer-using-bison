# syntactic-analyzer-using-bison

trabalho de compiladores

### Execução:

```
flex lexer.l
bison -d yacc.y
cc -o parser yacc.tab.c lex.yy.c -lfl
./parser [arquivoteste.c]
```


