#include <stdio.h>
#include "Def.h"

extern void xor_avx(char* data, size_t size, char* key, size_t key_size);

int main() 
{
    size_t payload_size = sizeof(payload);

    // Print payload before encryption
    printf("Payload before encryption:\n");
    for (int i = 0; i < payload_size; i++)
    {   
        printf("%02X ", payload[i]);
        if ((i + 1) % 16 == 0)
            printf("\n");
    }

    xor_avx(payload, payload_size, key, sizeof(key));

    // Print payload after encryption
    printf("\n\nPayload after encryption:\n");
    for (int i = 0; i < payload_size; i++)
    {   
        printf("%02X ", payload[i]);
        if ((i + 1) % 16 == 0)
            printf("\n");
    }

    xor_avx(payload, payload_size, key, sizeof(key));

    // Print payload after decryption
    printf("\n\nPayload after decryption:\n");
    for (int i = 0; i < payload_size; i++)
    {
        printf("%02X ", payload[i]);
        if ((i + 1) % 16 == 0)
            printf("\n");
    }

    return 0;
}