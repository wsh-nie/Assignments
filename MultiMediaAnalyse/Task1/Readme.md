## 任务内容

第一次作业：C++实现图像读取和颜色空间转换 

（1）读取BMP图像，然后将RGB图像转换到YUV颜色空间并保存。

（2）不能调用现有的图像读取函数、颜色空间转换函数，代码自己编写。
 
请同学们按照要求完成，将代码和文档发送至hzh519@mail.ustc.edu.cn。本次作业提交截止时间：10月30日。

## BMP

位图文件(`Bitmap-File`)可看成由4个部分组成：位图文件头(`bitmap-file header`)、位图信息头(`bitmap-information header`)、彩色表(`color table`)和定义位图的字节【位图数据，即图像数据(`Data Bits`)或(`Data Body`)】阵列，它具有如下所示的形式。

位图文件的组成:
结构名称 | 符 号 | 大小(Byte)
-- |-- | - |
位图文件头 | BITMAPFILEHEADER bmfh | 14
位图信息头 | BITMAPINFOHEADER bmih | 40
彩色表 | RGBQUAD aColors[ ] | 由颜色索引数决定
位图数据 | BYTE aBitmapBits[ ] | 由图像尺寸决定

## RGB2YUV

Y = 0.2990 * red + 0.5870 * green + 0.1140 * blue + 0;
Cb =-0.1687 * red - 0.3313 * green + 0.5000 * blue + 128;
Cr = 0.5000 * red - 0.4187 * green - 0.0813 * blue + 128;

