%{
#include <stdio.h>
extern int yylineno;
extern int yylex();
int yyerror(const char*);
extern FILE* yyin;
%}

%token IF
%token ELSE
%token ELIF
%token WHILE
%token INT CHAR 
%token SEMICOLON
%token ABRE_PAR
%token FECHA_PAR
%token ABRE_CHAVE
%token FECHA_CHAVE
%token ID
%token NUMERO
%token ATRIB
%token MAIS_ATRIB
%token MENOS_ATRIB
%token MUL_ATRIB
%token DIV_ATRIB
%token MOD_ATRIB
%token ADD
%token SUB
%token MUL
%token DIV
%token MOD
%token INC
%token DEC
%token OPERADOR_RELACIONAL
%token OPERADOR_LOGICO
%token COMMA
%token VOID
%token NOT
%token RTRN

%%

S: program
;

program: variable_declaration
       | function_declaration
       | /* CADEIA VAZIA */
;

p2: 
    | variable_declaration p2
    | assignment p2
    | if_statement p2
    | while_loop p2
;

bloco: ABRE_CHAVE p2 FECHA_CHAVE
     | ABRE_CHAVE FECHA_CHAVE
     | ABRE_CHAVE p2 RTRN expression SEMICOLON FECHA_CHAVE
     |ABRE_CHAVE RTRN expression SEMICOLON FECHA_CHAVE
     | ABRE_CHAVE p2 RTRN SEMICOLON FECHA_CHAVE 
     | ABRE_CHAVE RTRN SEMICOLON FECHA_CHAVE
;

function_declaration: INT ID ABRE_PAR var_list FECHA_PAR bloco
                    | CHAR ID ABRE_PAR var_list FECHA_PAR bloco
                    | VOID ID ABRE_PAR var_list FECHA_PAR bloco
;

tipo: INT
    | CHAR
;

var_list: tipo ID var_list2
        | /* CADEIA VAZIA */
;

var_list2:  COMMA tipo ID var_list2
        |   /* CADEIA VAZIA */
;

variable_declaration: tipo id_list SEMICOLON
;

id_list:  ID id_list2
        | ID ATRIB expression id_list2
;

id_list2: COMMA ID id_list2
        | COMMA ID ATRIB expression id_list2
        | /* CADEIA VAZIA */
;

assignment: ID ATRIB expression SEMICOLON
          | ID MAIS_ATRIB expression SEMICOLON
          | ID MENOS_ATRIB expression SEMICOLON
          | ID MUL_ATRIB expression SEMICOLON
          | ID DIV_ATRIB expression SEMICOLON
          | ID MOD_ATRIB expression SEMICOLON 
          | ID INC SEMICOLON
          | ID DEC SEMICOLON
;

if_statement: IF ABRE_PAR expression FECHA_PAR bloco if2
            | IF ABRE_PAR expression FECHA_PAR bloco if2 ELSE bloco
;

if2: ELIF ABRE_PAR expression FECHA_PAR bloco if2
   | /* CADEIA VAZIA */
;

while_loop: WHILE ABRE_PAR expression FECHA_PAR bloco
;

expression: ID
          | NUMERO
          | NOT expression 
          | expression ADD expression
          | expression SUB expression
          | expression MUL expression
          | expression DIV expression
          | expression MOD expression
          | expression OPERADOR_LOGICO expression
          | expression OPERADOR_RELACIONAL expression
          | ABRE_PAR expression FECHA_PAR
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
