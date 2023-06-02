#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main() {
    char input[100]; // Input buffer
    char output[100]; // Output buffer

    while (1) {
        write(STDOUT_FILENO, "This program makes simple arithmetics\n", 36);
        write(STDOUT_FILENO, "Enter an arithmetic statement, e.g., 34 + 132 > ", 47);

        int bytesRead = read(STDIN_FILENO, input, sizeof(input));
        if (bytesRead <= 0)
            break;

        int n1, n2, result;
        char op;

        int matched = sscanf(input, "%d %c %d", &n1, &op, &n2);
        if (matched != 3) {
            write(STDOUT_FILENO, "Wrong statement\n", 16);
            continue;
        }

        switch (op) {
            case '+':
                result = n1 + n2;
                break;
            case '-':
                result = n1 - n2;
                break;
            case '*':
                result = n1 * n2;
                break;
            case '/':
                if (n2 == 0) {
                    write(STDOUT_FILENO, "Division by 0\n", 14);
                    continue;
                }
                result = n1 / n2;
                break;
            default:
                write(STDOUT_FILENO, "Wrong operator\n", 15);
                continue;
        }

        sprintf(output, "%d %c %d = %d\n", n1, op, n2, result);
        write(STDOUT_FILENO, output, strlen(output));
    }

    return 0;
}
