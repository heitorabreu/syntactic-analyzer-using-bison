%{
#include <stdio.h>
extern int yylineno;
extern int yylex();
int yyerror(const char*);
extern FILE* yyin;
%}

%token IF
%token ELSE
%token WHILE
%token INT CHAR 
%token SEMICOLON
%token ABRE_PAR
%token FECHA_PAR
%token ABRE_CHAVE
%token FECHA_CHAVE
%token ABRE_COL
%token FECHA_COL
%token ID
%token NUMERO
%token ATRIB
%token MAIS_ATRIB
%token MENOS_ATRIB
%token ADD
%token SUB
%token MUL
%token DIV
%token MOD
%token INC
%token DEC
%token OPERADOR_RELACIONAL
%token OPERADOR_LOGICO
/* %token CERQUILHA
%token DEFINE */
%token VIRGULA
%token VOID
%token NOT

%%

S: program
;

program:
       | function_declaration
       | variable_declaration
       | assignment
       | commands
;

p2: 
    | variable_declaration p2
    | assignment p2
    | commands p2
;

function_declaration: tipo_retorno ID param bloco
;

param: ABRE_PAR param1
;

param1: FECHA_PAR
      | param2
;

param2: tipo_var param3
;

param3: ID param4
;

param4: ABRE_COL NUMERO FECHA_COL param4
      | ABRE_COL FECHA_CHAVE param4
      | VIRGULA param2
      | FECHA_COL
;

bloco: ABRE_CHAVE p2 FECHA_CHAVE
;

tipo_retorno: INT
    | CHAR
    | VOID                 
;

tipo_var: INT
        | CHAR
;

variable_declaration: tipo_var vb2
;

vb2: ID vb3

vb3: ABRE_COL NUMERO FECHA_COL vb3
   | ABRE_COL FECHA_COL vb3
   | ATRIB expression vb4
   | vb4
;

vb4: VIRGULA vb2
   | SEMICOLON
;

assignment: ID ATRIB expression SEMICOLON
          | ID INC SEMICOLON
          | ID DEC SEMICOLON
          | ID MAIS_ATRIB expression SEMICOLON
          | ID MENOS_ATRIB expression SEMICOLON  
;

commands: command_list com1
;

com1: commands
    |
;

command_list: IF ABRE_PAR expression FECHA_PAR bloco cmdl2
            | WHILE ABRE_PAR expression FECHA_PAR bloco
;

cmdl2: ELSE bloco
     |
;

expression: ID
          | NUMERO
          | NOT expression 
          | expression ADD expression
          | expression SUB expression
          | expression MUL expression
          | expression DIV expression
          | expression MOD expression
          | expression OPERADOR_RELACIONAL expression
          | expression OPERADOR_LOGICO expression
          | ABRE_PAR expression FECHA_PAR expression3
;

expression3: OPERADOR_LOGICO expression
           | OPERADOR_RELACIONAL expression
           | ADD expression
           | SUB expression
           | MUL expression
           | DIV expression
           | MOD expression
           |
;

%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Uso: %s arquivo_de_entrada\n", argv[0]);
        return 1;
    }

    FILE* arquivo_entrada = fopen(argv[1], "r");  // Abra o arquivo de entrada
    if (!arquivo_entrada) {
        fprintf(stderr, "Erro ao abrir o arquivo de entrada.\n");
        return 1;
    }

    yyin = arquivo_entrada;  // Defina yyin para o arquivo de entrada

    int resultado_analise = yyparse();  // Chame a função de análise sintática

    fclose(arquivo_entrada);  // Feche o arquivo de entrada

    if (resultado_analise == 0) {
        printf("Análise sintática concluída com sucesso.\n");
    } else {
        fprintf(stderr, "Erro na análise sintática.\n");
    }

    return resultado_analise;
}

int yyerror(const char *s) {
    fprintf(stderr, "Erro na linha %d: %s\n", yylineno, s);
    return 0;
}
