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
    //cout<<"文件类型"<<pBMPHead.bfType<<endl;
    cout<<"文件大小:"<<pBMPHead.bfSize<<endl;
    cout<<"保留字_1:"<<pBMPHead.bfReserved1<<endl;
    cout<<"保留字_2:"<<pBMPHead.bfReserved2<<endl;
    cout<<"实际位图数据的偏移字节数:"<<pBMPHead.bfOffBits<<endl<<endl;
}
void showBmpInfoHead(BITMAPINFOHEADER pBMPInfoHead){
    cout<<"BMP INFO HEAD:"<<endl;
    cout<<"结构体的长度:"<<pBMPInfoHead.biSize<<endl;
    cout<<"位图宽:"<<pBMPInfoHead.biWidth<<endl;
    cout<<"位图高:"<<pBMPInfoHead.biHeight<<endl;
    cout<<"biPlanes平面数:"<<pBMPInfoHead.biPlanes<<endl;
    cout<<"biBitCount采用颜色位数:"<<pBMPInfoHead.biBitCount<<endl;
    cout<<"压缩方式:"<<pBMPInfoHead.biCompression<<endl;
    cout<<"biSizeImage实际位图数据占用的字节数:"<<pBMPInfoHead.biSizeImage<<endl;
    cout<<"X方向分辨率:"<<pBMPInfoHead.biXPelsPerMeter<<endl;
    cout<<"Y方向分辨率:"<<pBMPInfoHead.biYPelsPerMeter<<endl;
    cout<<"使用的颜色数:"<<pBMPInfoHead.biClrUsed<<endl;
    cout<<"重要颜色数:"<<pBMPInfoHead.biClrImportant<<endl;
}

BMPDATA* ReadBMPFile(char *strFile){
    FILE *fpi;
    fpi = fopen(strFile,"rb");
    if(!fpi){
        cout<<"Open file error!"<<endl;
        return NULL;
    }
    fread(&bmpdata.bfType,1,sizeof(WORD),fpi);
    if(0x4d42 != bmpdata.bfType){
        cout<<"the file is not a BMP file!"<<endl;
        return NULL;
    }
    //read BMP head
    fread(&bmpdata.strHead,1,sizeof(BITMAPFILEHEADER),fpi);
    showBMPHead(bmpdata.strHead);
    //read BMP info head
    fread(&bmpdata.strInfo,1,sizeof(BITMAPINFOHEADER),fpi);
    showBmpInfoHead(bmpdata.strInfo);
    //read color plane
    for(WORD i = 0;i < bmpdata.strInfo.biClrUsed;i++){
        //delete reserved words
        fread((char *)&(bmpdata.strPla[i].rgbBlue),1,sizeof(BYTE),fpi);
        fread((char *)&(bmpdata.strPla[i].rgbGreen),1,sizeof(BYTE),fpi);
        fread((char *)&(bmpdata.strPla[i].rgbRed),1,sizeof(BYTE),fpi);
        fread((char *)&(bmpdata.strPla[i].rgbReserved),1,sizeof(BYTE),fpi);
    }
    //read Data
    LONG width = bmpdata.strInfo.biWidth%4 == 0? bmpdata.strInfo.biWidth : bmpdata.strInfo.biWidth+4-(bmpdata.strInfo.biWidth%4);
    LONG height = bmpdata.strInfo.biHeight;
    bmpdata.strHead.bfSize = width * height * bmpdata.strInfo.biBitCount /8;

    bmpdata.imagedata = new IMAGEDATA [width * height];

    for(LONG i=0; i<width*height;i++){
        bmpdata.imagedata[i].red=0;
        bmpdata.imagedata[i].green=0;
        bmpdata.imagedata[i].blue=0;
    }
    //IMAGEDATA imagedata[height][width];
    //memset(imagedata,0,sizeof(imagedata));
    //cout<<"read imagedata"<<endl;
    fread(bmpdata.imagedata,sizeof(IMAGEDATA)*width,height,fpi);
    ofstream outfile;
    outfile.open("imagedata1.txt", ios::out | ios::trunc );
    for(LONG i=0;i<bmpdata.strInfo.biWidth * bmpdata.strInfo.biHeight;i++){
        outfile<<WORD(bmpdata.imagedata[i].red)<<"-"<<WORD(bmpdata.imagedata[i].green)<<"-"<<WORD(bmpdata.imagedata[i].blue)<<" ";
        if((i+1)%width == 0 && i!=0){
            outfile<<endl<<endl;
        }
    }outfile.close();
    /*
    cout<<"read success!"<<endl;
    for(LONG i = 0,k=0;k<bmpdata.strInfo.biHeight*bmpdata.strInfo.biWidth && i<bmpdata.strInfo.biHeight;i++){
        for(LONG j=0;k<bmpdata.strInfo.biHeight*bmpdata.strInfo.biWidth && j<bmpdata.strInfo.biWidth;j++,k++){
            imagedata[i][j].blue = bmpdata.imagedata[k].blue;
            imagedata[i][j].green = bmpdata.imagedata[k].green;
            imagedata[i][j].red = bmpdata.imagedata[k].red;
        }
    }
    outfile.open("imagedata2.txt", ios::out | ios::trunc );
    for(LONG i=0;i<height;i++){
        for(LONG j=0;j<width;j++){
             outfile<<WORD(imagedata[i][j].red)<<"-"<<WORD(imagedata[i][j].green)<<"-"<<WORD(imagedata[i][j].blue)<<" ";
        }
        outfile<<endl<<endl;
    }
    outfile.close();
    //cout<<endl;
//    for(LONG i = 0;i<width;i++){
//        for(LONG j = 0; j<height;j++){
//            if(i>=bmpdata.strInfo.biWidth || j>=bmpdata.strInfo.biHeight){
//                cout<<i<<" "<<j<<":"<<WORD(imagedata[i][j].red)<<endl;
//            }
//        }
//    }
    for(LONG i=0; i<width*height;i++){
        bmpdata.imagedata[i].red=0;
        bmpdata.imagedata[i].green=0;
        bmpdata.imagedata[i].blue=0;
    }
    for(LONG i = 0;i<height;i++){
        for(LONG j=0;j<width;j++){
            bmpdata.imagedata[i*width+j].blue = imagedata[i][j].blue;
            bmpdata.imagedata[i*width+j].green = imagedata[i][j].green;
            bmpdata.imagedata[i*width+j].red = imagedata[i][j].red;
        }
    }
    outfile.open("bmpimagedata.txt", ios::out | ios::trunc );
    for(LONG i=0;i<width * height;i++){
        outfile<<WORD(bmpdata.imagedata[i].red)<<"-"<<WORD(bmpdata.imagedata[i].green)<<"-"<<WORD(bmpdata.imagedata[i].blue)<<" ";
        if((i+1)%width == 0 && i!=0){
            outfile<<endl<<endl;
        }
    }outfile.close();*/
//    for(LONG i = 0;i<width;i++){
//        for(LONG j = 0; j<height;j++){
//            if(i>=bmpdata.strInfo.biWidth || j>=bmpdata.strInfo.biHeight){
//                cout<<i<<" "<<j<<":"<<WORD(bmpdata.imagedata[i*width+j].red)<<endl;
//            }
//        }
//    }
//    for(int i=0;i<height;i++){
//        cout<<WORD(bmpdata.imagedata[i].red)<<" "<<WORD(bmpdata.imagedata[i].green)<<" "<<endl;
//    }
//    cout<<"flexed"<<endl;
    //bmpdata.strInfo.biWidth=width;
    fclose(fpi);
    return &bmpdata;
}

void RGB2YUV(char *strFile){
    FILE *fpw;
    BMPDATA *bmpdata = ReadBMPFile(strFile);//read bmp file;
    for(LONG i=0; i<bmpdata->strInfo.biWidth * bmpdata->strInfo.biHeight; i++){
        //cout<<i<<" ";
        BYTE red = bmpdata->imagedata[i].red;
        BYTE green = bmpdata->imagedata[i].green;
        BYTE blue = bmpdata->imagedata[i].blue;
        bmpdata->imagedata[i].red = (BYTE)(0.299 * red + 0.587 * green + 0.114 * blue);
        bmpdata->imagedata[i].green = (BYTE)(-0.148 * red - 0.289 * green + 0.437 * blue);
        bmpdata->imagedata[i].blue = (BYTE)(0.615 * red - 0.515 * green - 0.100 * blue);
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
    fwrite(&bmpdata->bfType,1,sizeof(WORD),fpw);
    fwrite(&bmpdata->strHead,1,sizeof(BITMAPFILEHEADER),fpw);
    fwrite(&bmpdata->strInfo,1,sizeof(BITMAPINFOHEADER),fpw);
    for(DWORD i = 0;i < bmpdata->strInfo.biClrUsed;i++){
        fwrite((char *)&(bmpdata->strPla[i].rgbBlue),1,sizeof(BYTE),fpw);
        fwrite((char *)&(bmpdata->strPla[i].rgbGreen),1,sizeof(BYTE),fpw);
        fwrite((char *)&(bmpdata->strPla[i].rgbRed),1,sizeof(BYTE),fpw);
        //fwrite((char *)&(bmpdata->strPla[i].rgbReserved),1,sizeof(BYTE),fpw);
    }
    LONG width = bmpdata->strInfo.biWidth%4 == 0? bmpdata->strInfo.biWidth : bmpdata->strInfo.biWidth+4-(bmpdata->strInfo.biWidth%4);
    LONG height = bmpdata->strInfo.biHeight;
    fwrite(bmpdata->imagedata,sizeof(IMAGEDATA)*width,height,fpw);
    fclose(fpw);
    return ;
}




