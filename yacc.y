%{
#include <stdio.h>
extern int yylineno;
int yyerror(const char*);
extern FILE* yyin;
%}

%token IF ELSE WHILE
%token INT CHAR VOID
%token SEMICOLON COMMA
%token ABRE_PAR FECHA_PAR ABRE_CHAVE FECHA_CHAVE ABRE_COL FECHA_COL
%token ID
%token NUMERO
%token ATRIB
%token ADD SUB MUL DIV MOD INC DEC MAIS_ATRIB MENOS_ATRIB
%token OPERADOR_RELACIONAL OPERADOR_LOGICO

%%

program: /* Vazio */
       | variable_declaration program
       | function_declaration program
       ;

p2: /* Vazio */
    | variable_declaration p2
    | assignment p2
    | if_statement p2
    | while_loop p2
    ;

function_declaration: INT ID ABRE_PAR var_list FECHA_PAR ABRE_CHAVE p2 FECHA_CHAVE { printf("Função INT %s\n", $2); }
                    | CHAR ID ABRE_PAR var_list FECHA_PAR ABRE_CHAVE p2 FECHA_CHAVE { printf("Função CHAR %s\n", $2); }
                    | VOID ID ABRE_PAR var_list FECHA_PAR ABRE_CHAVE p2 FECHA_CHAVE { printf("Função VOID %s\n", $2); }
                   ;

tipo: INT
    | CHAR
    ;

var_list: tipo ID var_list2
        | tipo ID ABRE_COL FECHA_COL var_list2
        | tipo ID ABRE_COL NUMERO FECHA_COL var_list2
        | /* Vazio */
        ;

var_list2:  COMMA tipo ID var_list2
        |   COMMA tipo ID ABRE_COL FECHA_COL var_list2
        |   COMMA tipo ID ABRE_COL NUMERO FECHA_COL var_list2
        |   /* Vazio */
        ;


variable_declaration: INT id_list SEMICOLON
                   { printf("Declaração de variável INT %s\n", $2); }
                   | CHAR id_list SEMICOLON
                   { printf("Declaração de variável CHAR %s\n", $2); }
                   ;

id_list:  ID id_list2
        | ID ABRE_COL NUMERO FECHA_COL id_list2 
        | ID ATRIB expression id_list2
        | /* Vazio */
        ;

id_list2: COMMA ID id_list2
        | COMMA ID ABRE_COL NUMERO FECHA_COL id_list2
        | COMMA ID ATRIB expression id_list2
        | /* Vazio */
        ;

assignment: ID ATRIB expression SEMICOLON { printf("Atribuição: %s = %d\n", $1, $3); }
          | ID INC SEMICOLON
          | ID DEC SEMICOLON
          | ID MAIS_ATRIB expression SEMICOLON
          | ID MENOS_ATRIB expression SEMICOLON
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
          | expression OPERADOR_LOGICO expression
          | expression OPERADOR_RELACIONAL expression
          | ABRE_PAR expression FECHA_PAR
          | /* Vazio */
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
