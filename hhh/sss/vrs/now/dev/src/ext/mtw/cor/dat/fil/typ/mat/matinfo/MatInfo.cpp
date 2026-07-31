// MatInfo.cpp : Implementation of DLL Exports.


// Note: Proxy/Stub Information
//      To build a separate proxy/stub DLL, 
//      run nmake -f MatInfops.mk in the project directory.

#include "stdafx.h"
#include "resource.h"
#include <initguid.h>
#include "MatInfo.h"

#include "MatInfo_i.c"
#include "MatInfoShlExt.h"


CComModule _Module;

BEGIN_OBJECT_MAP(ObjectMap)
OBJECT_ENTRY(CLSID_MatInfoShlExt, CMatInfoShlExt)
END_OBJECT_MAP()

class CMatInfoApp : public CWinApp
{
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMatInfoApp)
	public:
    virtual BOOL InitInstance();
    virtual int ExitInstance();
	//}}AFX_VIRTUAL

	//{{AFX_MSG(CMatInfoApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

BEGIN_MESSAGE_MAP(CMatInfoApp, CWinApp)
	//{{AFX_MSG_MAP(CMatInfoApp)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

CMatInfoApp theApp;

BOOL CMatInfoApp::InitInstance()
{
    _Module.Init(ObjectMap, m_hInstance, &LIBID_TXTINFOLib);
    return CWinApp::InitInstance();
}

int CMatInfoApp::ExitInstance()
{
    _Module.Term();
    return CWinApp::ExitInstance();
}

/////////////////////////////////////////////////////////////////////////////
// Used to determine whether the DLL can be unloaded by OLE

STDAPI DllCanUnloadNow(void)
{
    AFX_MANAGE_STATE(AfxGetStaticModuleState());
    return (AfxDllCanUnloadNow()==S_OK && _Module.GetLockCount()==0) ? S_OK : S_FALSE;
}

/////////////////////////////////////////////////////////////////////////////
// Returns a class factory to create an object of the requested type

STDAPI DllGetClassObject(REFCLSID rclsid, REFIID riid, LPVOID* ppv)
{
    return _Module.GetClassObject(rclsid, riid, ppv);
}


/////////////////////////////////////////////////////////////////////////////
// DllRegisterServer - Adds entries to the system registry

STDAPI DllRegisterServer(void)
{
    // On NT, add ourself to the list of approved shell extensions.
    if ( 0 == (GetVersion() & 0x80000000) )
        {
        CRegKey reg;
        LONG    lRet;

        lRet = reg.Open ( HKEY_LOCAL_MACHINE, 
                          _T("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Shell Extensions\\Approved"),
                          KEY_SET_VALUE );

        if ( ERROR_SUCCESS != lRet )
            return E_ACCESSDENIED;

        lRet = reg.SetValue ( _T("CMatInfoShlExt extension"),
                              _T("{6161C834-86DE-4cdd-BA3F-8E1E8631EABA}") );

        if ( lRet != ERROR_SUCCESS )
            return E_ACCESSDENIED;
        }


    // registers object, typelib and all interfaces in typelib
    return _Module.RegisterServer(TRUE);
}


/////////////////////////////////////////////////////////////////////////////
// DllUnregisterServer - Removes entries from the system registry

STDAPI DllUnregisterServer(void)
{
    if ( 0 == (GetVersion() & 0x80000000) )
        {
        CRegKey reg;
        LONG    lRet;

        lRet = reg.Open ( HKEY_LOCAL_MACHINE, 
                          _T("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Shell Extensions\\Approved"),
                          KEY_SET_VALUE );

        if ( ERROR_SUCCESS == lRet )
            {
            reg.DeleteValue ( _T("{6161C834-86DE-4cdd-BA3F-8E1E8631EABA}") );
            }
        }

    return _Module.UnregisterServer(TRUE);
}
