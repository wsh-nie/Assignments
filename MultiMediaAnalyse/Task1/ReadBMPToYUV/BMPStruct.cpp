#include "BMPStruct.h"
#include <iostream>
#include <fstream>
#include <cstdio>
#include <string.h>
#include <typeinfo>
using namespace std;

BMPDATA bmpdata;

void showBMPHead(BITMAPFILEHEADER pBMPHead){
    cout<<"BMP HEAD: "<<endl;
    //cout<<"�ļ�����"<<pBMPHead.bfType<<endl;
    cout<<"�ļ���С:"<<pBMPHead.bfSize<<endl;
    cout<<"������_1:"<<pBMPHead.bfReserved1<<endl;
    cout<<"������_2:"<<pBMPHead.bfReserved2<<endl;
    cout<<"ʵ��λͼ���ݵ�ƫ���ֽ���:"<<pBMPHead.bfOffBits<<endl<<endl;
}
void showBmpInfoHead(BITMAPINFOHEADER pBMPInfoHead){
    cout<<"BMP INFO HEAD:"<<endl;
    cout<<"�ṹ��ĳ���:"<<pBMPInfoHead.biSize<<endl;
    cout<<"λͼ��:"<<pBMPInfoHead.biWidth<<endl;
    cout<<"λͼ��:"<<pBMPInfoHead.biHeight<<endl;
    cout<<"biPlanesƽ����:"<<pBMPInfoHead.biPlanes<<endl;
    cout<<"biBitCount������ɫλ��:"<<pBMPInfoHead.biBitCount<<endl;
    cout<<"ѹ����ʽ:"<<pBMPInfoHead.biCompression<<endl;
    cout<<"biSizeImageʵ��λͼ����ռ�õ��ֽ���:"<<pBMPInfoHead.biSizeImage<<endl;
    cout<<"X����ֱ���:"<<pBMPInfoHead.biXPelsPerMeter<<endl;
    cout<<"Y����ֱ���:"<<pBMPInfoHead.biYPelsPerMeter<<endl;
    cout<<"ʹ�õ���ɫ��:"<<pBMPInfoHead.biClrUsed<<endl;
    cout<<"��Ҫ��ɫ��:"<<pBMPInfoHead.biClrImportant<<endl;
}

BMPDATA ReadBMPFileImageData(char *strFile){
    BMPDATA bmpdata;
    bmpdata.height = 0;
    bmpdata.width = 0;
    bmpdata.imagedata = NULL;
    FILE *fpi;
    fpi = fopen(strFile,"rb");
    if(!fpi){
        cout<<"Open file error!"<<endl;
        return bmpdata;
    }
    WORD bfType;
    fread(&bfType,1,sizeof(WORD),fpi);
    if(0x4d42 != bfType){
        cout<<"the file is not a BMP file!"<<endl;
        return bmpdata;
    }
    //read BMP head
    BITMAPFILEHEADER strHead;
    fread(&strHead,1,sizeof(BITMAPFILEHEADER),fpi);
    showBMPHead(strHead);
    //read BMP info head
    BITMAPINFOHEADER strInfo;
    fread(&strInfo,1,sizeof(BITMAPINFOHEADER),fpi);
    showBmpInfoHead(strInfo);
    //read color plane
    RGBQUAD strPla[256];
    for(WORD i = 0;i < strInfo.biClrUsed;i++){
        //delete reserved words
        fread((char *)&(strPla[i].rgbBlue),1,sizeof(BYTE),fpi);
        fread((char *)&(strPla[i].rgbGreen),1,sizeof(BYTE),fpi);
        fread((char *)&(strPla[i].rgbRed),1,sizeof(BYTE),fpi);
        fread((char *)&(strPla[i].rgbReserved),1,sizeof(BYTE),fpi);
    }
    LONG width = (strInfo.biWidth+3)/4*4;
    LONG height = strInfo.biHeight;
    // create return data
    bmpdata.height = height;
    bmpdata.width = width;
    bmpdata.imagedata = new IMAGEDATA*[height];
    for(LONG i = 0;i<height;i++){
        bmpdata.imagedata[i] = new IMAGEDATA[width];
    }
    for(LONG i=0;i<height;i++){
        for(LONG j=0;j<width;j++){
            bmpdata.imagedata[i][j].blue=0;
            bmpdata.imagedata[i][j].green=0;
            bmpdata.imagedata[i][j].red=0;
        }
    }
    //read image data
    IMAGEDATA imagedata[width];
    LONG k=0;
    for(LONG i=height;i>=0;){
        fread(imagedata,sizeof(IMAGEDATA),width,fpi);
        for(LONG j = 0;j<width;j++){
            k++;
            if((k-1)%bmpdata.width == 0){
                i--;
                if(i<0){
                    break;
                }
            }
            bmpdata.imagedata[i][(k-1)%bmpdata.width].blue = imagedata[j].blue;
            bmpdata.imagedata[i][(k-1)%bmpdata.width].green = imagedata[j].green;
            bmpdata.imagedata[i][(k-1)%bmpdata.width].red = imagedata[j].red;
        }
    }
    fclose(fpi);
    return bmpdata;
}

void RGB2YUV(char *strFile){
    FILE *fpw;
    BMPDATA bmpdata = ReadBMPFileImageData(strFile);//read bmp file;
    LONG width = bmpdata.width;
    LONG height = bmpdata.height;
    BYTE y_data[height * width];
    BYTE u_data[height * width /4];
    BYTE v_data[height * width /4];
    memset(y_data,0,sizeof(y_data));
    memset(u_data,0,sizeof(u_data));
    memset(v_data,0,sizeof(v_data));
    LONG yCount=0,uCount=0,vCount=0;

    //RGB2YUV
    for(LONG i=0; i<height; i++){
        for(LONG j=0;j<width; j++){
            BYTE red = bmpdata.imagedata[i][j].red;
            BYTE green = bmpdata.imagedata[i][j].green;
            BYTE blue = bmpdata.imagedata[i][j].blue;
            BYTE Y= (BYTE)(0.299 * red + 0.587 * green + 0.114 * blue);
            BYTE U= (BYTE)(-0.148 * red - 0.289 * green + 0.437 * blue);
            BYTE V= (BYTE)(0.615 * red - 0.515 * green - 0.100 * blue);
            y_data[yCount++] = Y;
            if(i%2==0 && j%2==0){
                u_data[uCount++] = U;
            }else if(j%2==0){
                v_data[vCount++] = V;
            }
        }
    }
    // Save file
    char newfile[40]="new_";
    int len = strlen(newfile);
    for(int i=0;i<strlen(strFile)-3;i++){
        newfile[len+i]=strFile[i];
    }
    len = strlen(newfile);
    newfile[len]='y';
    newfile[len+1]='u';
    newfile[len+2]='v';
    fpw = fopen(newfile,"wb");
    if(!fpw){
        cout<<"Create file error!"<<endl;
        return ;
    }
    fwrite(y_data,sizeof(BYTE),height*width,fpw);
    fwrite(u_data,sizeof(BYTE),height*width/4,fpw);
    fwrite(v_data,sizeof(BYTE),width*height/4,fpw);
    fclose(fpw);
    return ;
}




