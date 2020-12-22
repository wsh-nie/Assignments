# 信息协议基础实验四

## 一、实验题目

题目 1：要求编写一个程序，实现两个主机之间的文本聊天通信。通信需要在 IPv6 环境下完成 (即这两个主机均使用 IPv6 地址)。 

人数限制：此题目仅允许 1 个人单独完成。 



基本要求：此程序不需要有图形界面，即图形界面不作为评分依据。两个主 机之间的聊天由一方作为发 起方开始，而后不断进行直到任意一方发送“END” 结束。要求聊天过程中两人都可以随时向对方发送文本消息，即需要实现两个主 机之间的全双工通信。如果提交的代码只能实现两个主机轮流发送文本消息给对 方将会酌情扣分。 



扩展要求：此题目扩展要求自拟，比如可以实现“群聊”、“@”、“文件传输” 功能。选做扩展要求者根据所选择的扩展要求的实现难度以及完成质量酌情加分。 

## 二、实验原理

### 1. 数据结构

* IPv6套接字地址结构体：

```c
struct in6_addr
{ 
    uint8_t s6_addr[16];   //按照网络字节顺序存储128位IPv6地址
};
 
#DEFINE SIN6_LEN
struct sockaddr_in6
{
    uint8_t       	    sin6_len;   //IPv6结构长度，是一个无符号的8为整数，表示128为IPv6地址长度
    sa_family_t         sin6_family; //地址族AF_INET6
    in_port_t		    sin6_port;   //存储端口号，按网络字节顺序
    uint32_t		    sin6_flowinfo;  //低24位是流量标号，然后是4位的优先级标志，剩下四位保留
    struct in6_addr 	sin6_addr;      //IPv6地址，网络字节顺序
    uint32_t		    sin6_scope_id;	//标识地址范围 
};
```

* 通用套接字地址结构体：

```C
struct sockaddr{
    uint8_t       sa_len;
    sa_famliy     sa_famliy; //协议族地址类型
    char          sa_data[14]; //存储具体协议地址
};
```

* epoll结构体

```C

typedef union epoll_data {
    void *ptr;
    int fd;
    __uint32_t u32;
    __uint64_t u64;
} epoll_data_t;
 //感兴趣的事件和被触发的事件
struct epoll_event {
    __uint32_t events; /* Epoll events */
    epoll_data_t data; /* User data variable */
};
```

> *events*可以是以下几个宏的集合：
>
> *EPOLLIN* ：表示对应的文件描述符可以读（包括对端*SOCKET*正常关闭）；
>
> *EPOLLOUT*：表示对应的文件描述符可以写；
>
> *EPOLLPRI*：表示对应的文件描述符有紧急的数据可读（这里应该表示有带外数据到来）；
>
> *EPOLLERR*：表示对应的文件描述符发生错误；
>
> *EPOLLHUP*：表示对应的文件描述符被挂断；
>
> *EPOLLET*： 将*EPOLL*设为边缘触发*(Edge Triggered)*模式，这是相对于水平触发*(Level Triggered)*来说的。
>
> *EPOLLONESHOT*：只监听一次事件，当监听完这次事件之后，如果还需要继续监听这个*socket*的话，需要再次把这个*socket*加入到*EPOLL*队列里



### 2. 函数

* socket()

```c
int socket(int domain,int type, int protocol);
/*
**创建一个套接字：
**返回值：
**    创建成功返回一个文件描述符（0,1,2已被stdin、stdout、stderr占用，所以从3开始）
**    失败返回-1。
**参数：
**    domain为协议家族，TCP属于AF_INET（IPV4）；
**    type为协议类型，TCP属于SOCK_STREAM（流式套接字）；
**    最后一个参数为具体的协议（IPPOOTO_TCP为TCP协议，前两个已经能确定该参数是TCP，所以也可以填0）
*/
```

* bind()

```C
int bind(int sockfd,const struct sockaddr * addr,socklen_t addrlen);
/*
**将创建的套接字与地址端口等绑定
**返回值：成功返回0，失败返回-1.
**参数：
**    sockfd为socket函数返回接受的文件描述符，
**    addr为新建的IPv6套接字结构体
**    注意：定义若是使用struct sockaddr_in6定义，但是该参数需要将struct sockaddr_in *类型地址强转为struct sockaddr *类型（struct sockaddr是通用类型）。
**    最后一个参数为该结构体所占字节数。
*/
```

* listen()

```C
int listen(int sockfd,int backlog);
/*
**对创建的套接字进行监听，监听有无客户请求连接
**返回值：有客户请求连接时，返回从已完成连接的队列中第一个连接（即完成了TCP三次握手的的所有连接组成的队列），否则处于阻塞状态（blocking）。
**参数：
***  sockfd依然为socket函数返回的文件描述符；
***  blocklog为设定的监听队列的长度。可设为5、10等值但是不能大于SOMAXCONN（监听队列最大长度）
*/
```

* connect()

```c
int connect(int sockfd,const struct sockaddr * addr,socklen_t addrlen);
/*
**客户端请求连接
**返回值：成功返回0，失败返回-1
**参数：客户端的socket文件描述符，客户端的socket结构体地址以及结构体变量长度
*/
```

* accept()

```c
int accept(int sockfd,struct sockaddr * addr,socklen_t * addrlen);
/*
**从监听队列中接收已完成连接的第一个连接
**返回值：成功返回0，失败返回-1
**参数：服务器socket未见描述符，服务器的socket结构体地址以及结构体变量长度
*/
```

* send()

```c
ssize_t send(int sockfd,const void * buf,size_t len,int flags);
/*
**发送数据
**返回值：成功返回发送的字符数，失败返回-1
**参数：buf为写缓冲区（send_buf），len为发送缓冲区的大小，flags为一个标志，如MSG_OOB表示有紧急带外数据等
*/
```

* recv()

```C
ssize_t recv(int sockfd,void *buf, size_t len, int flags);
/*
**接收数据
**返回值参数与send函数相似
**不过send是将buf中的数据向外发送，而recv是将接收到的数据写到buf缓冲区中。
*/
```

* close()

```c
int close(int fd);
/*
**关闭套接字，类似于fclose，fd为要关闭的套接字文件描述符
**失败返回-1，成功返回0
*/
```

* 字节序转换函数

```c
/*
**由于我们一般普遍所用的机器（x86）都是小端存储模式或者说叫做小端字节序，
**而网络传输中采用的是大端字节序，所以要进行网络通讯，就必须将进行字节序的转换。
*/
uint32_t htonl(uint32_t hostlong);/*主机字节序转换成网络字节序*/
uint32_t ntohl(uint32_t netlong);/*网络字节序转换成主机字节序*/
```

* 地址转换函数

```c
/*
**由于网络传输是二进制比特流传输，所以必须将我们的常用的点分十进制的IP地址，
**与网络字节序的IP源码（二进制形式）进行互相转换才可以将数据传送到准确的地址
*/
int inet_aton(const char * cp,struct in_addr * inp);//将字符串cp表示的点分十进制转换成网络字节序的二进制形式后存储到inp中
char * inet_ntoa(struct in_addr * in);//将网络字节序的二进制形式转换成点分十进制的字符串形式，返回该字符串的首地址
in_addr_t inet_addr(const char * cp);//与inet_aton的功能相同
```

* epoll_create()

```c
int epoll_create(int size);
/*
**创建epoll，返回一个epoll句柄(即一个文件描述符)
**参数: size告诉内核监听的数目
*/
```

* epoll_ctl()

```c
int epoll_ctl(int epfd, int op, int fd,struct epoll_event *event);
/*
** 控制epoll，成功返回0，失败返回-1
** 参数：
**     epfd: 衃epoll_create所创建的epoll句柄
**     op：对epoll监控描述符控制的动作
**       EPOLL_CTL_ADD(注册新的fd到epfd)
**       EPOLL_CTL_MOD(修改已经注册的fd的监听事件)
**       EPOLL_CTL_DEL(epfd删除一个fd)
**     fd：需要监听的文件描述符
**     event：需要监听的事件
*/
```

* epoll_wait()

```c
int epoll_wait(int epfd, struct epoll_event *event,int maxevents, int timeout);
/*
** 等待epoll，成功：有多少文件描述符就绪，时间到时返回0，失败返回-1
** 参数：
**     epfd: 衃epoll_create所创建的epoll句柄
**     event：需要监听的事件集合
**     maxevent: 告诉内核这个events有多大
**     timeout: 超时时间
**       -1: 永久阻塞
**       0：立即返回，非阻塞
**       >0: 指定微妙
*/
```



### 3. 实验顺序

(1)服务器：由于不知道客户何时会请求建立连接，所以必须绑定端口之后进行监听[socket->bind()->listen()];

(2)客户端：发起连接[connect()];

(3)使用epoll监听端口实现双通道通信



## 三、实验结果

![image-20201222135331739](image/image-20201222135331739.png)

## 四、实验收获

再一次使用socket编程进行tcp连接通信，在上一个实验的基础上加上epoll进行端口的监控，实现全双工通信。

本次实验中出现了很多问题，解决了大部分使得程序能够良好的运行，但仍存在一些bugs尚未解决。比如client发送END结束聊天时，服务器端也会终止；但是server发送END是只能终止客户端的连接。

## 五、实验代码

* Server.c

```c
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
	struct sockaddr_in6 servaddr, cliaddr;
	
	struct epoll_event event,act[3];//epoll_event
	int readynum, clientfd = 0;


	time_t t0 = time(NULL);
	printf("time #: %ld\n", t0);
	fputs(ctime(&t0), stdout);
	if((sockfd = socket(AF_INET6, SOCK_STREAM, 0)) < 0)//set socket 
		perror("socket error");
	bzero(&servaddr, sizeof(servaddr));//init 0
	servaddr.sin6_family = AF_INET6;
	if(argc < 2)
		perror("port error");
	servaddr.sin6_port = htons(atoi(argv[1]));//set port
	servaddr.sin6_addr = in6addr_any;

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

					if(strlen(line) == 3 && line[0]=='E' && line[1]=='N' && line[2]=='D'){
						printf("End the connection!");
						close(clientfd);
						close(sockfd);
						exit(0);
					}
				}
				else{// connected error
					close(clientfd);
				}

			}
		}
	}
	close(clientfd);
	close(sockfd);
	return 0;
}

```

* Client.c

```C
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

```

