#include "BMPStruct.h"
#include <iostream>
#include <cstdio>
#include <string.h>
#include <vector>
using namespace std;

#define Wr 0.2627
#define Wg 0.678
#define Wb 0.0593
#define Umax 0.5
#define Vmax 0.5
BITMAPFILEHEADER strHead;
RGBQUAD strPla[256];//256 color planes
BITMAPINFOHEADER strInfo;
vector<vector<IMAGEDATA>> imagedata;
IMAGEDATA** YUVimagedata = NULL;


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
void debug(int a,FILE * file){
    //cout<<a<<": "<<ftell(file)<<endl;
    return;
}
void ReadBMPFile(char *strFile){
    FILE *fpi, *fpw;
    fpi = fopen(strFile,"rb");
    if(!fpi){
        cout<<"Open file error!"<<endl;
        return ;
    }
    WORD bfType;
    fread(&bfType,1,sizeof(WORD),fpi);
    debug(1,fpi);
    if(0x4d42 != bfType){
        cout<<"the file is not a BMP file!"<<endl;
        return ;
    }
    //read BMP head
    fread(&strHead,1,sizeof(BITMAPFILEHEADER),fpi);
    showBMPHead(strHead);
    debug(2,fpi);
    //read BMP info head
    fread(&strInfo,1,sizeof(BITMAPINFOHEADER),fpi);
    showBmpInfoHead(strInfo);
    debug(3,fpi);
    //read color plane
    for(int i = strHead.bfOffBits-54;i>0;i--){
        BYTE s[1];
        fread(s,1,sizeof(BYTE),fpi);
    }
    debug(4,fpi);
    for(WORD i = 0;i < strInfo.biClrUsed;i++){
        //delete reserved words
        fread((char *)&(strPla[i].rgbBlue),1,sizeof(BYTE),fpi);
        fread((char *)&(strPla[i].rgbGreen),1,sizeof(BYTE),fpi);
        fread((char *)&(strPla[i].rgbRed),1,sizeof(BYTE),fpi);
        //fread((char *)&(strPla[i].rgbReserved),1,sizeof(BYTE),fpi);
    }
    debug(5,fpi);
    //read Data
    LONG width = strInfo.biWidth;
    LONG height = strInfo.biHeight;
    IMAGEDATA RGBimagedata[width][height];
    for(LONG i=0; i<width;i++){
        for(LONG j=0;j<height;j++){
            RGBimagedata[i][j].red=0;
            RGBimagedata[i][j].green=0;
            RGBimagedata[i][j].blue=0;
        }
    }
    fread(RGBimagedata,sizeof(IMAGEDATA)*width,height,fpi);
    debug(6,fpi);
    fclose(fpi);
//    for(LONG i=0; i<1;i++){
//        for(LONG j=0;j<height;j++){
//            cout<<WORD(RGBimagedata[i][j].red)<<" ";
//        }
//        cout<<endl;
//    }

    for(LONG i=0; i<width; i++){
        for(LONG j=0;j<height; j++){
            BYTE red = RGBimagedata[i][j].red;
            BYTE green = RGBimagedata[i][j].green;
            BYTE blue = RGBimagedata[i][j].blue;
            RGBimagedata[i][j].red = (BYTE)(0.2990 * red + 0.5870 * green + 0.1140 * blue + 0);
            RGBimagedata[i][j].green = (BYTE)(-0.1687 * red - 0.3313 * green + 0.5000 * blue + 128);
            RGBimagedata[i][j].blue = (BYTE)(0.5000 * red - 0.4187 * green - 0.0813 * blue + 128);
        }
    }
    // Save file
    char newfile[40]="new_";
    int len = strlen(newfile);
    for(int i=0;i<strlen(strFile);i++){
        newfile[len+i]=strFile[i];
    }
    cout<<"file name: "<<newfile<<endl;
    fpw = fopen(newfile,"wb");
    if(!fpw){
        cout<<"Create file error!"<<endl;
        return ;
    }
    fwrite(&bfType,1,sizeof(WORD),fpw);
    debug(11,fpw);
    fwrite(&strHead,1,sizeof(BITMAPFILEHEADER),fpw);
    debug(12,fpw);
    fwrite(&strInfo,1,sizeof(BITMAPINFOHEADER),fpw);
    debug(13,fpw);
    for(DWORD i = 0;i < strInfo.biClrUsed;i++){
        fwrite((char *)&(strPla[i].rgbBlue),1,sizeof(BYTE),fpw);
        fwrite((char *)&(strPla[i].rgbGreen),1,sizeof(BYTE),fpw);
        fwrite((char *)&(strPla[i].rgbRed),1,sizeof(BYTE),fpw);
        //fwrite((char *)&(strPla[i].rgbReserved),1,sizeof(BYTE),fpw);
    }
    debug(14,fpw);
    fwrite(RGBimagedata,sizeof(IMAGEDATA)*width,height,fpw);
    debug(15,fpw);
    fclose(fpw);
    return ;
}




