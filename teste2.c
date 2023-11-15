int main()
{
    int num1 = 15, num2 = 7;
    int resultadoModulo = num1 % num2;

    int numero = 7;
    int quadrado = numero * numero;

    if (quadrado > 25 && resultadoModulo != 0)
    {
        quadrado += resultadoModulo;
    }
    else
    {
        if (quadrado <= 25 || resultadoModulo == 0)
        {
            quadrado -= resultadoModulo;
        }
    }

    int contador = 1;
    int fatorial = 1;

    while (contador <= 5)
    {
        fatorial *= contador;
        contador++;
    }

    int numeroVerificado = 13;
    int resultadoPrimo = (numeroVerificado > 1);

    // Estruturas de controle de fluxo

    // Loop do-while

    return 0;
}