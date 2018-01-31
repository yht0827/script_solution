#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<arpa/inet.h>
#include<sys/types.h>
#include<sys/socket.h>
#include <sys/ioctl.h>  
#include <sys/stat.h>  
#include<time.h>
#include <netinet/in.h>  
#include <net/if.h>  
#define BUFF_SIZE 1024

int s_getIpAddress (const char * ifr, unsigned char * out) {  
    int sockfd;  
    struct ifreq ifrq;  
    struct sockaddr_in * sin;  
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);  
    strcpy(ifrq.ifr_name, ifr);  
    if (ioctl(sockfd, SIOCGIFADDR, &ifrq) < 0) {  
        perror( "ioctl() SIOCGIFADDR error");  
        return -1;  
    }  
    sin = (struct sockaddr_in *)&ifrq.ifr_addr;  
    memcpy (out, (void*)&sin->sin_addr, sizeof(sin->sin_addr));  
  
    close(sockfd);  
  
    return 4;  
}  

int main(int argc, char **argv){

	int client_socket;
	struct sockaddr_in server_addr;
	char buff_snd[BUFF_SIZE];
	struct tm *t;
	time_t timer;
	timer = time(NULL);
	t= localtime(&timer);
	FILE *fp;
	int i=0;
	unsigned char addr[4] = {0,};
      	char str[50];	
	int ipad;
	client_socket = socket(PF_INET, SOCK_STREAM,0);
	memset( &server_addr,0, sizeof( server_addr));
	server_addr.sin_family = AF_INET;
	server_addr.sin_port = htons(4000);
	server_addr.sin_addr.s_addr=inet_addr("172.20.10.5");
	connect( client_socket,(struct sockaddr*)&server_addr,sizeof(server_addr));


fp=fopen("/root/script/script.txt","r");
if(fp == NULL){printf("FILE ERROR");
exit(1);
}
else{
     if (s_getIpAddress("eth0", addr) > 0){  
	    sprintf(str,"/root/script/%d%02d%02d/%d.%d.%d.txt",t->tm_year+1900,t->tm_mon+1,t->tm_mday,(int)addr[1],(int)addr[2],(int)addr[3]);	
	printf("%s\n",str);
	write(client_socket,str,50);  
    } 
	while(!feof(fp))	
	{
	if(fgets(buff_snd,sizeof(buff_snd),fp)==NULL) break;

	printf("%s",buff_snd);
	write(client_socket,buff_snd,strlen(buff_snd));
	}
}
fclose(fp);
close(client_socket);
return 0;
}
