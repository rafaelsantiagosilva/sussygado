#include <stdio.h>

int main()
{
    float a = 0, b = 0;
    char op = '\0';

    scanf("%f %c %f", &a, &op, &b);

    if (op == '/' && b == 0)
    {
        printf("Não é possível dividir por 0.\n");
        return 0;
    }

    switch (op)
    {
    case '+':
        printf("%.2f+%.2f=%.2f\n", a, b, (a + b));
        break;

    case '-':
        printf("%.2f-%.2f=%.2f\n", a, b, (a - b));
        break;

    case '*':
        printf("%.2f*%.2f=%.2f\n", a, b, (a * b));
        break;

    case '/':
        printf("%.2f/%.2f=%.2f\n", a, b, (a / b));
        break;

    default:
        printf("Operação inválida.\n");
        break;
    }

    return 0;
}