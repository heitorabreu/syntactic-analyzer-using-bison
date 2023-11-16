## Authors
<table>
    <td align="center">
      <a href="https://github.com/heitorabreu">
        <img src="https://avatars.githubusercontent.com/u/96392593?v=4" width="100px;" alt="Foto do Penha"/><br>
        <sub>
          <b>Heitor Abreu</b>
        </sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/vesrozeno">
        <img src="https://avatars.githubusercontent.com/u/58575975?v=4" width="100px;" alt="Foto do Vitor"/><br>
        <sub>
          <b>Vitor Rozeno</b>
        </sub>
      </a>
    </td>
</table>

# syntactic-analyzer-using-bison
    


The syntax analyzer is a central component in the interpretation process of programming languages, playing an essential role in the validation and structuring of source code syntax. By automating this process through tools such as Bison, syntax analyzers become fundamental for efficiency in compiler development, contributing to the creation and enhancement of programming languages in an accessible and robust manner.

Throughout this README, we will address the fundamental steps involved in building the syntax analyzer, specifying the decisions made in its construction, providing an overview, and demonstrating how to execute it.

# Execution

   To use the syntax analyzer, the user must have both Bison and Flex installed on their machine. Afterward, the `yacc.y` and `lexer.l` files must be in the same directory. The test file should also be in the same directory.

Following this, the user should generate the files using Bison and Flex and then compile the files through the command terminal by following these steps:

1.  Generate the parser using the following command: `bison -d yacc.y`
    
2.  Generate the scanner using the following command: `flex lexer.l`
    
3.  Compile the files and obtain the executable using the command: `cc -o parser yacc.tab.c lex.yy.c -lfl`
    
4.  Execute the file, including the test file, as follows: `./parser [testfile.c]`
    

Therefore, the script for execution is as follows:
```
flex lexer.l
bison -d yacc.y
cc -o parser yacc.tab.c lex.yy.c -lfl
./parser [testfile.c]
```

# Grammar
The grammar adopted for our work follows the standards of the C language but in a smaller scope. The following structures are accepted:
-   Types: int, char, and void

-   #define for constants
    
-   Declaration of global variables
    
-   Declaration of local variables
    
-   Possibility to assign values during declaration
    
	-   Variables
    
	-   Numbers
    
	-   Expressions
    
-   Function declarations
    
-   Function calls
    
	-   No arrays or pointers
    
-   Expressions
    
	-   Arithmetic operations (+, -, /, *, %)
    
	-   Logical operations (&&, ||, !)
    
	-   Relational operations (==, <, >, <=, >=)
    
	-   Combination of these types of expressions
    
-   Assignments (=, +=, -=, /=, *=, %=, ++, --)
    
	-   Variables
    
	-   Numbers
    
	-   Expressions
    
-   if - else if - else
    
-   while
    
-   return in code blocks

## inside yacc.y
To represent the grammar, we use ***Backus-Naur Form (BNF) notation***.
```
S:  program
;

program:  CERQUILHA  DEFINE  ID  expression  program
       |  variable_declaration  program
       |  function_declaration  program
       |  /*  CADEIA  VAZIA  */
;
```
Here, we define the initial production rules that specify the declaration of constants, variables, and function declarations. The analysis will also accept an empty file.

``` 
p2:  variable_declaration  p2
  |  assignment  p2
  |  function_call  p2
  |  if_statement  p2
  |  while_loop  p2
  |  /*  CADEIA  VAZIA  */
;
```

These are the production rules that will be used within the scope of functions, including:

1.  Variable declaration;
2.  Assignment;
3.  Function calls;
4.  if/else branching structures;
5.  while loop structures.
    
```    
bloco:  ABRE_CHAVE  p2  FECHA_CHAVE
     |  ABRE_CHAVE  p2  RTRN  expression  SEMICOLON  FECHA_CHAVE
     |  ABRE_CHAVE  p2  RTRN  SEMICOLON  FECHA_CHAVE
;

function_declaration:  tipo  ID  ABRE_PAR  var_list  FECHA_PAR  bloco
; 

tipo: INT
    | CHAR
    | VOID
;
```
  
The production rules for functions vary only in the return type the function may have, which can be int, char, or void.
```
var_list:  tipo  ID  var_list2
|  /*  CADEIA  VAZIA  */
;

var_list2:  COMMA  tipo  ID  var_list2
|  /*  CADEIA  VAZIA  */
;
```
These rules define the productions that will be used in the list of arguments for a function.
```
function_call:  ID  ABRE_PAR  expression  exp2  FECHA_PAR
;

exp2:  COMMA  expression  exp2
    |  /*  CADEIA  VAZIA  */
;
```
We also defined the production rule that will be used in function calls. It consists of an ID and expressions inside parentheses.
```
variable_declaration:  tipo  id_list  SEMICOLON
;

id_list:  ID  id_list2
       |  ID  ATRIB  expression  id_list2
;

id_list2:  COMMA  ID  id_list2
        |  COMMA  ID  ATRIB  expression  id_list2
        |  /*  CADEIA  VAZIA  */
;
```
Now, we define the rules for variable declaration, also allowing the assignment of a value to a variable during its declaration.
```
expression:  ID
          |  NUMERO
          |  NOT  expression
          |  function_call
          |  expression  ADD  expression
          |  expression  SUB  expression
          |  expression  MUL  expression
          |  expression  DIV  expression
          |  expression  MOD  expression
          |  expression  OPERADOR_LOGICO  expression
          |  expression  OPERADOR_RELACIONAL  expression
          |  ABRE_PAR  expression  FECHA_PAR
;
```
  
Here, we define the rules for expressions, covering both arithmetic and logical operations. These rules will be used for assignments, if/else branching structures, and while loop structures.

```
assignment:  ID  ATRIB  expression  SEMICOLON
          |  ID  MAIS_ATRIB  expression  SEMICOLON
          |  ID  MENOS_ATRIB  expression  SEMICOLON
          |  ID  MUL_ATRIB  expression  SEMICOLON
          |  ID  DIV_ATRIB  expression  SEMICOLON
          |  ID  MOD_ATRIB  expression  SEMICOLON
          |  ID  INC  SEMICOLON
          |  ID  DEC  SEMICOLON
;
```
This is the rule used for assigning a value to a variable.

```
if_statement:  IF  ABRE_PAR  expression  FECHA_PAR  bloco  if2
            |  IF  ABRE_PAR  expression  FECHA_PAR  bloco  if2  ELSE  bloco
;

if2:  ELIF  ABRE_PAR  expression  FECHA_PAR  bloco  if2
   |  /*  CADEIA  VAZIA  */
;
```
The production rule for the if/else branching structure allows the programmer to use either the if structure alone or the if/else structure. The use of else if is also allowed.
```
while_loop:  WHILE  ABRE_PAR  expression  FECHA_PAR  bloco
;
```
Finally, the while loop structure allows the programmer to use conditions to determine the stopping point and also insert code blocks within the structure's scope.