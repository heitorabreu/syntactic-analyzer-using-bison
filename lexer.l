NUMERO [0-9]+
ESPACO [ ]
QUEBRA_DE_LINHA [\n]
TAB [\t]
CARRIAGE_RETURN [ \t\r]
OPERADOR_RELACIONAL "=="|"<"|">"|"<="|">="|"!="
OPERADOR_LOGICO "&&"|"||"|"!"

%{
    #include <stdio.h>
    #include "yacc.tab.h"
    int yylval;    
%}

%option yylineno
%x COMMENT

%%

"/*"                   {BEGIN(COMMENT);}
<COMMENT>"*/"          {BEGIN(INITIAL); }
<COMMENT>.|\n
<COMMENT><<EOF>>       {fprintf(yyout, "\t(ERRO - COMENTARIO SEM FIM)\n");return 0;}
"//".*                 { /* Ignorar comentários de linha */ }

"if"                   {return IF; }
"else"                 {return ELSE;}
"while"                {return WHILE;}
"int"                  {return INT; }
"char"                 {return CHAR; }
"void"                 {return VOID; }
";"                    {return SEMICOLON;}
","                    {return COMMA; }
"("                    {return ABRE_PAR;}
")"                    {return FECHA_PAR;}
"{"                    {return ABRE_CHAVE;}
"}"                    {return FECHA_CHAVE;}
"["                    {return ABRE_COL;}
"]"                    {return FECHA_COL;}
"="                    {return ATRIB; }
"+"                    {return ADD;}
"-"                    {return SUB;}
"*"                    {return MUL;}
"/"                    {return DIV;}
"%"                    {return MOD;}
"++"                   {return INC;}
"--"                   {return DEC;}
"+="                   {return MAIS_ATRIB;}
"-="                   {return MENOS_ATRIB;}
[a-zA-Z][a-zA-Z0-9_]*  {return ID;}
[0-9]+                 {return NUMERO;}
{OPERADOR_RELACIONAL}  {return OPERADOR_RELACIONAL;}
{OPERADOR_LOGICO}	   {return OPERADOR_LOGICO;}
{SIMBOLO}	 		   {}
{TAB}			 	   { /* Ignorar tabs */ }
{ESPACO}			   { /* Ignorar espaços */ }
{QUEBRA_DE_LINHA}      { /* Ignorar quebras de linha */ }
{CARRIAGE_RETURN}      { /* Ignorar */ }

"_"{ID}|{NUMERO}{ID}|"_"{NUMERO}{ID}|"_"{ID}|{NUMERO}"_"{ID}       {fprintf(yyout, "\t(linha: %d, ERRO - ID INVALIDO: %s)\n", yylineno, yytext); }

.                      {fprintf(yyout, "\t(linha: %d, ERRO - CARACTER DESCONHECIDO: %s)\n", yylineno, yytext); }

%%

int yywrap() {
    return 1;
}