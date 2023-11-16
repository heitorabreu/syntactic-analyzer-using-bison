%option yylineno
%x COMMENT

%{
    #include <stdio.h>
    #include "yacc.tab.h"
    #include <stdlib.h>
%}

ID [a-zA-Z][a-zA-Z0-9_]*
NUMERO [0-9]+
ESPACO [ ]
QUEBRA_DE_LINHA [\n]
TAB [\t]
CARRIAGE_RETURN [ \t\r]
OPERADOR_RELACIONAL "=="|"<"|">"|"<="|">="|"!="
OPERADOR_LOGICO "&&"|"||"

%%


"/*"                   {BEGIN(COMMENT);}
<COMMENT>"*/"          {BEGIN(INITIAL); }
<COMMENT>.|\n
<COMMENT><<EOF>>       {fprintf(yyout, "\t(ERRO - COMENTARIO SEM FIM)\n");return 0;}
"//".*                 { /* Ignorar comentários de linha */ }

"define"               {return DEFINE;}
"#"                    {return CERQUILHA;}
"return"               {return RTRN;}
"!"                    {return NOT;}
","                    {return COMMA;}
"void"                 {return VOID;}
"int"                  {return INT;}
"char"                 {return CHAR;}
"if"                   {return IF;}
"else"                 {return ELSE;}
"else if"              {return ELIF;}
"while"                {return WHILE;}
";"                    {return SEMICOLON;}
"("                    {return ABRE_PAR;}
")"                    {return FECHA_PAR;}
"{"                    {return ABRE_CHAVE;}
"}"                    {return FECHA_CHAVE;}
"="                    {return ATRIB;}
"+="                   {return MAIS_ATRIB;}
"-="                   {return MENOS_ATRIB;}
"*="                   {return MUL_ATRIB;}
"/="                   {return DIV_ATRIB;}
"%="                   {return MOD_ATRIB;}
"+"                    {return ADD;}
"-"                    {return SUB;}
"*"                    {return MUL;}
"/"                    {return DIV;}
"%"                    {return MOD;}
"++"                   {return INC;}
"--"                   {return DEC;}
[a-zA-Z][a-zA-Z0-9_]*  {return ID;}
[0-9]+                 {return NUMERO;}
{OPERADOR_RELACIONAL}  {return OPERADOR_RELACIONAL;}
{OPERADOR_LOGICO}	   {return OPERADOR_LOGICO;}
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