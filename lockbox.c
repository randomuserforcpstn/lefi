#include <stdio.h>
#include <string.h>

#define MAX_PASSWORD_LENGTH 100

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <password>\n", argv[0]);
        return 1;
    }

    char correct_password[] = "helloworld";
    char flag[] = "flag{Tithing_Greyhound_Bosoms} -- Username: level_X -- Password: password";
    char *password = argv[1];

    if (strcmp(password, correct_password) == 0) {
        printf("Box unlocked! Here's the flag: %s\n", flag);
    } else {
        printf("Incorrect password. Access denied.\n");
    }

    return 0;
}
