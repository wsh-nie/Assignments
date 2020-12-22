#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <time.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/epoll.h>
#define MAXLINE 1024
#define TRUE 1
int main(int argc, char **argv)
{
	/**
	define parameters
	**/
	int sockfd, fd, n, m, epollfd;
	char line[MAXLINE + 1];
	struct sockaddr_in6 servaddr;
	
	struct epoll_event event,act[3];//epoll_event
	int readynum, clientfd = 0;


	time_t t0 = time(NULL);
	printf("time #: %ld\n", t0);
	fputs(ctime(&t0), stdout);
	if((sockfd = socket(AF_INET6, SOCK_STREAM, 0)) < 0)//set socket 
		perror("socket error");
	bzero(&servaddr, sizeof(servaddr));//init 0
	servaddr.sin6_family = AF_INET6;
	if(argc < 3){
		perror("parameters error");
	}else{
		if(inet_pton(AF_INET6, argv[1], &servaddr.sin6_addr) < 0)
			perror("IP Address error");
		servaddr.sin6_port = htons(atoi(argv[2]));//set port
		//servaddr.sin6_addr = in6addr_any;
	}

	if(bind(sockfd, (struct sockaddr*)&servaddr, sizeof(servaddr)) == -1)//bind()
		perror("bind error");
	if(listen(sockfd, 10) == -1)//linten()
		perror("listen error");
	
	// epoll event
	epollfd = epoll_create(1);//epoll_create()
	if(epollfd < 0)
		perror("epoll_create error");
	
	memset(&event,0,sizeof(event));
	event.data.fd = sockfd;
	event.events = EPOLLIN;
	if(epoll_ctl(epollfd, EPOLL_CTL_ADD, sockfd, &event) < 0 )//epoll_ctl()
		perror("epoll_ctl error 1");
	
	event.data.fd = STDIN_FILENO;
	event.events = EPOLLIN;

	if(epoll_ctl(epollfd, EPOLL_CTL_ADD, STDIN_FILENO, &event) < 0 )//epoll_ctl()
		perror("epoll_ctl error 1");

	while(TRUE) {
		readynum = epoll_wait(epollfd, act, sizeof(act), 0);
		for(n = 0; n<readynum; n++){
			if(act[n].data.fd == STDIN_FILENO){//send
				memset(line,0,sizeof(line));
				read(STDIN_FILENO,line,sizeof(line));
				send(clientfd,line,strlen(line)-1,0);
			}else if(act[n].data.fd == sockfd){
				clientfd = accept(sockfd, NULL, NULL);
				event.data.fd = clientfd;
				event.events = EPOLLIN;
				if((epoll_ctl(epollfd, EPOLL_CTL_ADD, clientfd, &event)) <0 )
					perror("epoll_ctl error 2");
			}else if(act[n].data.fd == clientfd){//read
				memset(line,0,sizeof(line));
				if(recv(clientfd,line,sizeof(line),0) != 0 ){//get message
					printf("Receive message from client: %s\n",line);

					if(strcmp(line,"END") ==0){
						printf("End the connection!\n");
						close(clientfd);
						close(sockfd);
						exit(0);
					}
				}
				else{// connected error
					event.data.fd = clientfd;
					if(epoll_ctl(epollfd,EPOLL_CTL_DEL, clientfd, &event) < 0)
						perror("epoll_ctl 3 error");
					close(clientfd);
				}

			}
		}
	}
	close(clientfd);
	close(sockfd);
	return 0;
}
