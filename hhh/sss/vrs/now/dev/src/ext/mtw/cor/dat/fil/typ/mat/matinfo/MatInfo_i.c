/* this file contains the actual definitions of */
/* the IIDs and CLSIDs */

/* link this file in with the server and any clients */


/* File created by MIDL compiler version 5.01.0164 */
/* at Fri Sep 08 09:42:44 2006
 */
/* Compiler settings for D:\prog\win32\MatInfo\MatInfo.idl:
    Oicf (OptLev=i2), W1, Zp8, env=Win32, ms_ext, c_ext
    error checks: allocation ref bounds_check enum stub_data 
*/
//@@MIDL_FILE_HEADING(  )
#ifdef __cplusplus
extern "C"{
#endif 


#ifndef __IID_DEFINED__
#define __IID_DEFINED__

typedef struct _IID
{
    unsigned long x;
    unsigned short s1;
    unsigned short s2;
    unsigned char  c[8];
} IID;

#endif // __IID_DEFINED__

#ifndef CLSID_DEFINED
#define CLSID_DEFINED
typedef IID CLSID;
#endif // CLSID_DEFINED

const IID IID_IMatInfoShlExt = {0x51BBEC40,0x17CA,0x422f,{0xB3,0x44,0x8B,0x2B,0xE6,0x34,0x3F,0x17}};


const IID LIBID_TXTINFOLib = {0x664BD649,0xC887,0x42ca,{0x9F,0xE9,0x48,0xAE,0x60,0x83,0xF1,0x7E}};


const CLSID CLSID_MatInfoShlExt = {0x6161C834,0x86DE,0x4cdd,{0xBA,0x3F,0x8E,0x1E,0x86,0x31,0xEA,0xBA}};


#ifdef __cplusplus
}
#endif

