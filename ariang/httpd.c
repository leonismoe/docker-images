#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <err.h>

#include "index_html_deflate.c"

char http_response_header[] = "HTTP/1.1 200 OK\r\n"
"Content-Encoding: deflate\r\n"
"Content-Type: text/html; charset=UTF-8\r\n"
"Content-Length: ${CONTENT_LENGTH}\r\n"
"Connection: close\r\n\r\n";

int main()
{
  int one = 1, client_fd;
  char recv_buffer[255] = { 0 };
  struct sockaddr_in svr_addr, cli_addr;
  socklen_t sin_len = sizeof(cli_addr);

  int sock = socket(AF_INET, SOCK_STREAM, 0);
  if (sock < 0)
    err(1, "can't open socket");

  setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(int));

  int port = 8080;
  svr_addr.sin_family = AF_INET;
  svr_addr.sin_addr.s_addr = INADDR_ANY;
  svr_addr.sin_port = htons(port);

  if (bind(sock, (struct sockaddr *) &svr_addr, sizeof(svr_addr)) == -1) {
    close(sock);
    err(1, "Can't bind");
  }

  listen(sock, 255);

  while (1) {
    client_fd = accept(sock, (struct sockaddr *) &cli_addr, &sin_len);

    if (client_fd == -1) {
      perror("Can't accept");
      continue;
    }

    send(client_fd, http_response_header, sizeof(http_response_header) - 1, 0); /*-1:'\0'*/
    send(client_fd, index_html_deflate, index_html_deflate_len, 0);
    shutdown(client_fd, SHUT_WR);

    // wait client close
    while (1) {
      int bytes = recv(client_fd, recv_buffer, sizeof(recv_buffer), 0);
      if (bytes < 0) {
        perror("recv err");
        break;
      }
      else if (!bytes)
        break;
    }

    close(client_fd);
  }
}
