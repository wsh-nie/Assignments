uint_8_t * pSrc=;// this is RGB bit stream

uint_8_t * YUV_Image=new uint_8[320*240*3/2];// YUV420 bit stream

int i=0,j=0;

int width=320; // width of the RGB image

int height=240; // height of the RGB image

int uPos=0, vPos=0;

for( i=0;i< height;i++ ){

    bool isU=false;

    if( i%2==0 ) isU=true; // this is a U line

    for( j=0;j<width;j++){

        int pos = width * i + j; // pixel position

        uint_8_t B = pSrc[pos*3];

        uint_8_t G = pSrc[pos*3+1];

        uint_8_t R = pSrc[pos*3+2];

        uint8_t Y= (uint8_t)(0.3*R + 0.59*G + 0.11*B);

        uint8_t U= (uint8_t)((B-Y) * 0.493);

        uint8_t V= (uint8_t)((R-Y) * 0.877);

        YUV_Image[pos] = Y;

        bool isChr=false;  // is this a chroma point

        if( j%2==0 ) isChr=true;

        if( isChr && isU ){

            YUV_Image[plane+(plane>>2)+uPos]=U;

        }

        if( isChr&& !isU ){

            YUV_Image[plane+vPos]=V;

        }
    }

}