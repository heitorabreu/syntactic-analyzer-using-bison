%{
#include <stdio.h>
extern int yylineno;
int yyerror(const char*);
extern FILE* yyin;
%}

%token IF ELSE WHILE
%token INT CHAR 
%token SEMICOLON
%token ABRE_PAR FECHA_PAR ABRE_CHAVE FECHA_CHAVE ABRE_COL FECHA_COL
%token ID
%token NUMERO
%token ATRIB
%token ADD SUB MUL DIV MOD INC DEC
%token OPERADOR_RELACIONAL OPERADOR_LOGICO

%%

program: /* Vazio */
       | function_declaration
       | variable_declaration
       | assignment
       | if_statement
       | while_loop
       ;

p2: /* Vazio */
    | variable_declaration p2
    | assignment p2
    | if_statement p2
    | while_loop p2
    ;

function_declaration: INT ID ABRE_PAR FECHA_PAR ABRE_CHAVE p2 FECHA_CHAVE
                   { printf("Função INT %s\n", $2); }
                   ;

variable_declaration: INT ID SEMICOLON
                   { printf("Declaração de variável INT %s\n", $2); }
                   | CHAR ID SEMICOLON
                   { printf("Declaração de variável CHAR %s\n", $2); }
                   ;

assignment: ID ATRIB expression SEMICOLON
          { printf("Atribuição: %s = %d\n", $1, $3); }
          ;

if_statement: IF ABRE_PAR expression FECHA_PAR ABRE_CHAVE p2 FECHA_CHAVE
            { printf("Estrutura de desvio 'se' completa\n"); }
            | IF ABRE_PAR expression FECHA_PAR ABRE_CHAVE p2 FECHA_CHAVE ELSE ABRE_CHAVE p2 FECHA_CHAVE
            { printf("Estrutura de desvio 'se senão' completa\n"); }
            ;

while_loop: WHILE ABRE_PAR expression FECHA_PAR ABRE_CHAVE p2 FECHA_CHAVE
           { printf("Estrutura de repetição 'enquanto' completa\n"); }
           ;

expression: ID
          | NUMERO
          | expression ADD expression
          | expression SUB expression
          | expression MUL expression
          | expression DIV expression
          | expression MOD expression
          | expression OPERADOR_RELACIONAL expression
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
