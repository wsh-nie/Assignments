#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <stdlib.h>
#include <sys/socker.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#define MAXLINE 1024
#define TRUE 1

int main(int argc, char **argv){

    int sockfd, n, m;
    char line[MAXLINE + 1];
    struct sockaddr_in6 servaddr;

    time_t t0 = time(NULL);
    printf("time #: %ld\n", t0);//输出机器时间
    fputs(ctime(&t0), stdout);//将机器时间转换为格式化时间

    if(argc != 2) //对输入参数的判断，如未输入IPaddress则报错
        perror("usage: a.out <IPaddress>");

    if((sockfd = socket(AF_INET6, SOCK_STREAM, 0)) < 0)
        /**
        *  socket()函数将在通信域中创建一个未绑定的套接字，并返回一个文件描述符，
        *  该文件描述符可在以后对套接字进行操作的函数调用中使用。
        *  domian: 指定要在其中创建套接字的通信域 
        *      AF_INET6,IPv6 和 IPv4的Internet系列
        *  type: 指定要创建的套接字的类型 
        *      SOCK_STREAM类型，提供顺序的，可靠的，双向的连接模式字节流,
        *      并可以提供带外数据流的传输机制 
        *  protocal: 指定要与套接字一起使用的特定协议
        *      指定为0，表示函数使用于请求的套接字类型为默认类型
        */
        perror("socket error");
    
    bzero(&servaddr, sizeof(servaddr));//置零操作
    servaddr.sin6_family = AF_INET6;//通信域设置为IPv6和IPv4
    servaddr.sin6_port = htons(20000);//设置套接字的通信端口

    if(inet_pton (AF_INET6, argv[1], &servaddr.sin6_addr) <= 0)
        //判断输入参数是否是一个ip地址
        perror("inet_pton error");

    if(connect(sockfd, (struct sockaddr*)&servaddr, sizeof(servaddr)) < 0)
        //判断是否连接成功
        perror("connect error");

    while(fgets(line, MAXLINE, stdin) != NULL){ //输入通信信息
        send(sockfd, line, strlen(line), 0);//发送通信信息
    }

    close(sockfd);
    exit(0);
}