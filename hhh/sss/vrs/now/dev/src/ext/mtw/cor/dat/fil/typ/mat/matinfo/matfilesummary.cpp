
#include "stdafx.h"

#include "mat.h"
#include "mex.h"
#include "matrix.h"
#include "matfilesummary.h"
#include <stdio.h>
#include <string.h>

#ifdef STANDALONE

int main(int argc, char** argv)
{
    char* str;
    int i;

    if (argc<2)
    {
        printf("No file name");
        return 1;
    }

    str = getMatFileSummary(argv[1]);
    printf("MAT-file info: %s\n",str);
    free(str);
    return 0;
}

#endif

#define BUFSIZE 1024

static char* mstrcpy(char* dest, const char* src);
static int has_space(const char* buf, char* bufptr, const char* str);

char* getMatFileSummary(const char* filename)
{
    MATFile* f;
    mxArray* v;
    const char* varname;
    char* buf;
    char* bufptr;
    const char* classname;
    int varcount = 0;

    buf = (char*)malloc(BUFSIZE*sizeof(char));
    bufptr = buf;
    bufptr = mstrcpy(bufptr,"Variables in file:\n");

    f = matOpen(filename,"r");
    while (true)
    {
        int m;
        int n;
        char sizes[20];
        v = matGetNextVariableInfo(f,&varname);
        if (v==NULL)
            break;
        classname = mxGetClassName(v);

        bufptr = mstrcpy(bufptr,"  ");
        if (!has_space(buf,bufptr,varname))
            break;
        bufptr = mstrcpy(bufptr,varname);
        bufptr = mstrcpy(bufptr,"  <");

        m = mxGetM(v);
        n = mxGetN(v);
        sprintf(sizes,"%dx%d ",m,n);

        if (!has_space(buf,bufptr,sizes))
            break;
        bufptr = mstrcpy(bufptr,sizes);

        if (!has_space(buf,bufptr,classname))
            break;
        bufptr = mstrcpy(bufptr,classname);

        bufptr = mstrcpy(bufptr,">\n");
        varcount++;
    }

    if (!varcount)
        strcat(bufptr,"  (none)");

    matClose(f);

    return buf;
}

static char* mstrcpy(char* dest, const char* src)
{
    strcpy(dest,src);
    return dest + strlen(dest);
}

static int has_space(const char* buf, char* bufptr, const char* str)
{
    int space = BUFSIZE - ( bufptr - buf );
    int req = strlen(str) + 10;
    if (req>space)
    {
        //printf("Too short: %d required, %d available\n",req,space);
        strcpy(bufptr,"...");
        return 0;
    }
    else
        return 1;
}


