
MatInfops.dll: dlldata.obj MatInfo_p.obj MatInfo_i.obj
	link /dll /out:MatInfops.dll /def:MatInfops.def /entry:DllMain dlldata.obj MatInfo_p.obj MatInfo_i.obj \
		kernel32.lib rpcndr.lib rpcns4.lib rpcrt4.lib oleaut32.lib uuid.lib \

.c.obj:
	cl /c /Ox /DWIN32 /D_WIN32_WINNT=0x0400 /DREGISTER_PROXY_DLL \
		$<

clean:
	@del MatInfops.dll
	@del MatInfops.lib
	@del MatInfops.exp
	@del dlldata.obj
	@del MatInfo_p.obj
	@del MatInfo_i.obj
