#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/epoll.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#define MAXLINE 1024
#define TRUE 1
int main(int argc, char **argv){
	/*
	* define parameters
	*/
	int sockfd, n, m, epollfd;
	char line[MAXLINE + 1];
	struct sockaddr_in6 servaddr;
	struct epoll_event event, act[3];
	int num;

	time_t t0 = time(NULL);
	printf("time #: %ld\n", t0);
	fputs(ctime(&t0), stdout);
	
	if((sockfd = socket(AF_INET6, SOCK_STREAM, 0)) < 0) //socket()
		perror("socket error");
	bzero(&servaddr, sizeof(servaddr));//init 0

	servaddr.sin6_family = AF_INET6;
	if(argc != 2)
		perror("address error");
	servaddr.sin6_port = htons(atoi(argv[1]));
	//printf("port:%d\n",servaddr.sin6_port);
	servaddr.sin6_addr = in6addr_any;

	//if(inet_pton (AF_INET6, argv[1], &servaddr.sin6_addr) <= 0)
		//perror("inet_pton error");
	if(connect(sockfd, (struct sockaddr*)&servaddr, sizeof(servaddr)) < 0)
		perror("connect error");

	memset(&event, 0, sizeof(event));
	epollfd = epoll_create(1);
	if(epollfd < 0)
		perror("epoll_create error");

	event.data.fd = sockfd;
	event.events = EPOLLIN;
	if((epoll_ctl(epollfd, EPOLL_CTL_ADD, sockfd, &event)) < 0)
		perror("epoll_ctl error 1");
	
	event.data.fd = STDIN_FILENO;
	event.events = EPOLLIN;
	if((epoll_ctl(epollfd, EPOLL_CTL_ADD, STDIN_FILENO, &event)) < 0)
		perror("epoll_ctl error 2");
	

	while(TRUE){
		num = epoll_wait(epollfd, act, sizeof(act),0);
		for(n = 0; n < num; n++){
			if(act[n].data.fd == STDIN_FILENO){
				memset(line,0,sizeof(line));
				read(STDIN_FILENO, line, sizeof(line));
				send(sockfd, line, strlen(line) -1, 0);
			}else if(act[n].data.fd == sockfd){
				memset(line,0,sizeof(line));
				if(recv(sockfd, line, sizeof(line),0) == 0){//link error
					event.data.fd = sockfd;
					if((epoll_ctl(epollfd, EPOLL_CTL_DEL, sockfd, &event)) < 0)
						perror("epoll_ctl error 3");
					close(sockfd);
					exit(0);
				}
				printf("Receive message from server: ");
				puts(line);
				if(strlen(line) == 3 && line[0]=='E' && line[1]=='N' && line[2]=='D'){
					printf("End the connection!");
					close(sockfd);
					exit(0);
				}
				//printf("puts: %s\n",line);
			}
		}
	}
	close(sockfd);
	return 0;
}
