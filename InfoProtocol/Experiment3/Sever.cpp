#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <time.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#define MAXLINE 1024
#define TRUE 1

int main(int argc, char **argv){

    int sockfd, fd, n, m;
    char line[MAXLINE + 1];
    struct sockaddr_in6 servaddr, cliaddr;

    time_t t0 = time(NULL);
    printf("time #: %ld\n", t0);//输出机器时间
    fputs(ctime(&t0), stdout);//将机器时间转换为格式化时间

    if((sockfd = socket(AF_INET6, SOCK_STREAM, 0)) < 0)
        //判断是否成功创建套接字
        perror("socket error");

    bzero(&servaddr, sizeof(servaddr));//置零操作
    servaddr.sin6_family = AF_INET6;//设置IPaddress类型
    servaddr.sin6_port = htons(20000);//设置端口号
    servaddr.sin6_addr = in6addr_any;//地址使用通配符

    if(bind(sockfd, (struct sockaddr*)&servaddr, sizeof(servaddr)) == -1)
        //为套接字分配地址，并判断绑定函数是否成功
        perror("bind error");

    if(listen(sockfd, 5) == -1)
        /*
        *  判断监听是否成功
        *  int s:描述符，用于表示绑定的未连接的套接字
        *      sockfd，前文中绑定的套接字
        *  int backlog：挂起的连接队列可能增长的最大长度
        *      5，最多同时允许5个客户端同服务器连接
        */
        perror("listen error");

    while(TRUE) {
        //服务器开启
        printf("> Waiting clients ...\r\n");
        socklen_t clilen = sizeof(struct sockaddr);
        fd = accept(sockfd, (struct sockaddr*)&cliaddr, &clilen);
        if(fd == -1){ 
            perror("accept error");
        }

        printf("> Accepted.\r\n");

        while((n = read(fd, line, MAXLINE)) > 0){ //读取客服端发送的文件
            line[n] = 0;
            if(fputs(line, stdout) == EOF)//按行读取文件信息，并输出，并判断文件是否结束
                perror("fputs error");
        }
        close(fd);
    }
    if(n < 0) perror("read error");
    exit(0);
}