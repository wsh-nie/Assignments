--DSift.exe 为提取DoG SIFT的32位可执行程序，其输入参数有两个，分别为“待处理图象所在文件夹路径”，“图象最长边缩放的尺寸”

--batch_run.bat 中通过设置参数，可以调用DSift.exe。双击batch_run.bat，即可自动提出指定文件夹下的图象的DoG SIFT特征。每幅图象的SIFT特征文件保存在该图像的同一个目录下，命名在图象名称之上加“.dsift”。SIFT特征文件中的数据为binary格式，开头四字节为整数，表示SIFT特征的数量；其后逐个保存各个SIFT特征的结构体数据，每个结构体占144字节，具体格式为
{
unsigned char descriptor[128];
float x;
float y;
float scale;
float orientation;
}

--cv210.dll, cxcore210.dll, highgui210.dll为DSift.exe执行时需要调用的三个动态链接库。