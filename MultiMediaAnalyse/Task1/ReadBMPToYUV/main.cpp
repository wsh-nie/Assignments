#include <iostream>
#include <cstring>
#include <string.h>
#include "BMPStruct.h"

using namespace std;

int main()
{
    while(1){
        cout<<"Enter file name: "<<endl;
        char strFile[20];
        cin>>strFile;
        RGB2YUV(strFile);
    }
    return 0;
}
