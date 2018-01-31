#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#define BUFF_SIZE 1024

int main(int argc, char **argv){
    
    FILE *f;
    pid_t pid;
    int server_socket;
    int client_socket;
    int client_addr_size;
    char str[50];
    struct sockaddr_in server_addr;
    struct sockaddr_in client_addr;
    char buff_rcv[BUFF_SIZE];
    char buff_snd[BUFF_SIZE];
    char buff[BUFF_SIZE];
    int i=0;

    server_socket = socket(PF_INET , SOCK_STREAM, 0);
    memset( &server_addr ,0 ,sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(4000);
    server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    if( -1 == bind(server_socket ,(struct sockaddr*)&server_addr ,sizeof(server_addr))){
	printf("bind 에러\n");

    }
    listen(server_socket ,5);

while(1)
{
    client_addr_size = sizeof(client_addr);
    client_socket = accept(server_socket ,(struct sockaddr*)&client_addr , &client_addr_size);
  pid = fork();
  if(pid==0){
	   
	  	memset(str,0x00,sizeof(str));
		read(client_socket,str,50);
		printf("%s\n",str);
		f=fopen(str,"w");
		memset(buff_rcv,0x00,sizeof(buff_rcv));
		read(client_socket,buff_rcv,BUFF_SIZE);
	printf("%s",buff_rcv);
	fprintf(f,"%s",buff_rcv);
	fclose(f);
	    	close(client_socket);
		exit(1);
}
}
   		close(server_socket); 
		return 0;
}
