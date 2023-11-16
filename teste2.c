#define a 2
int a = 2;
int b = a + b;
int b = 2;
char a = 0;

// Função para calcular o fatorial de um número
int calcularFatorial(int n)
{
    if (n <= 1)
    {
        return 1;
    }
    else
    {
        return n * calcularFatorial(n - 1);
    }
}

// Função para verificar se um número é primo
int verificarPrimo(int num)
{
    if (num < 2)
    {
        return 0; // Não é primo
    }

    return 1; // É primo
}

int main()
{
    int a = 5, b = 10;
    int soma = a + b;

    int numero = 7;

    if (numero > 5)
    {
        // Código se verdadeiro
        soma += numero;
    }
    else
    {
        // Código se falso
        soma -= numero;
    }

    int contador = 1;
    int fatorial = 1;

    while (contador <= 5)
    {
        // Cálculo do fatorial
        fatorial *= contador;
        contador++;
    }

    int resultadoFatorial = calcularFatorial(fatorial);
    int numeroVerificado = 13;
    int resultadoPrimo = verificarPrimo(numeroVerificado);

    return 0;
}

int calcularQuadrado(int numero)
{
    return numero * numero;
}

int main()
{
    int resultado = calcularQuadrado(5 + calcularFatorial(2, 2 + 2, id, 9));

    funcaoSemParam();

    return 0;
}

int a = 5;