// MatInfoShlExt.h : Declaration of the CMatInfoShlExt

#ifndef __TXTINFOSHLEXT_H_
#define __TXTINFOSHLEXT_H_

#include "resource.h"       // main symbols
#include <comdef.h>
#include <shlobj.h>

/////////////////////////////////////////////////////////////////////////////
// CMatInfoShlExt

class ATL_NO_VTABLE CMatInfoShlExt : 
	public CComObjectRootEx<CComSingleThreadModel>,
	public CComCoClass<CMatInfoShlExt, &CLSID_MatInfoShlExt>,
	public IDispatchImpl<IMatInfoShlExt, &IID_IMatInfoShlExt, &LIBID_TXTINFOLib>,
    public IPersistFile,
    public IQueryInfo
{
public:
	CMatInfoShlExt()
	{
	}

DECLARE_REGISTRY_RESOURCEID(IDR_TXTINFOSHLEXT)

DECLARE_PROTECT_FINAL_CONSTRUCT()

BEGIN_COM_MAP(CMatInfoShlExt)
	COM_INTERFACE_ENTRY(IMatInfoShlExt)
	COM_INTERFACE_ENTRY(IDispatch)
	COM_INTERFACE_ENTRY(IPersistFile)
	COM_INTERFACE_ENTRY(IQueryInfo)
END_COM_MAP()

protected:
    // IMatInfoShlExt
    CString m_sFilename;

public:
    // IPersistFile
    STDMETHOD(GetClassID)(LPCLSID)      { return E_NOTIMPL; }
    STDMETHOD(IsDirty)()                { return E_NOTIMPL; }
    STDMETHOD(Load)(LPCOLESTR, DWORD);
    STDMETHOD(Save)(LPCOLESTR, BOOL)    { return E_NOTIMPL; }
    STDMETHOD(SaveCompleted)(LPCOLESTR) { return E_NOTIMPL; }
    STDMETHOD(GetCurFile)(LPOLESTR*)    { return E_NOTIMPL; }

    // IQueryInfo
    STDMETHOD(GetInfoFlags)(DWORD*)     { return E_NOTIMPL; }
    STDMETHOD(GetInfoTip)(DWORD, LPWSTR*);
};

#endif //__TXTINFOSHLEXT_H_
