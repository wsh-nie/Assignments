typedef unsigned char BYTE;//1B
typedef unsigned short WORD;//2B
typedef unsigned int DWORD;//4B
typedef long LONG;//4B


#ifndef BMPSTRUCT_H_INCLUDED
#define BMPSTRUCT_H_INCLUDED

typedef struct tagBITMAPFILEHEADER{
    //WORD bfType;//file type
    DWORD bfSize;//file size
    WORD bfReserved1;// reserved word1
    WORD bfReserved2;// reserver word2
    DWORD bfOffBits;// BMP data offset from the file header
}BITMAPFILEHEADER;// BMP header 14Byte

typedef struct tagBITMAPINFOHEADER{
    DWORD biSize;//Info Header size
    LONG biWidth;//pho width
    LONG biHeight;//pho height
    WORD biPlanes;//planes = 1
    WORD biBitCount;//pixel size
    DWORD biCompression;//compression type
    DWORD biSizeImage;//compression pho size
    LONG biXPelsPerMeter;//horizontal resolution
    LONG biYPelsPerMeter;//vertical resolution
    DWORD biClrUsed;
    DWORD biClrImportant;
}BITMAPINFOHEADER;//BMP INFO HEADER 40Byte

typedef struct tagRGBQUAD{
    BYTE rgbBlue;
    BYTE rgbGreen;
    BYTE rgbRed;
    BYTE rgbReserved;
}RGBQUAD;

typedef struct tagIMAGEDATA{
    BYTE blue;
    BYTE green;
    BYTE red;
}IMAGEDATA;

typedef struct tagBMPData{
    LONG width;
    LONG height;
    IMAGEDATA **imagedata;
}BMPDATA;


void showBMPHead(BITMAPFILEHEADER pBMPHead);
void showBmpInfoHead(BITMAPINFOHEADER pBMPInfoHead);
BMPDATA ReadBMPFileImageData(char *strFile);
void RGB2YUV(char *strFile);

#endif // BMPSTRUCT_H_INCLUDED
