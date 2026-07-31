///////////////////////////////////////////////////////////////////////////////
//  File: XLSWriteMex.cpp
//
//  Description: Main implementation file for XLSWriteMex mex function.
//               Writes a Matlab matrix to an Excel spreadsheet
//
//  Author: Gordon Ray
//  Email : ray@cam.wits.ac.za
//
//  History: 07/03/2004 - GR - Initial Creation
//
//  NOTE: This is provided free, no warranty, ...
//
///////////////////////////////////////////////////////////////////////////////

// XLSWriteMex Usage Instructions: (copied from Scott Hirsch's 'xlswrite.m')
// 
// XLSWriteMex     Easily create an Excel spreadsheet from MATLAB
//
//  XLSWriteMex(m,header,colnames,filename) creates a Microsoft Excel spreadsheet using
//  the MATLAB ActiveX interface.  Microsoft Excel is required.
//
//Inputs:
//    m          Matrix to write to file
// (Optional):
//    header     String of header information.  Use cell array for multiple lines
//                  DO NOT USE multiple row character arrays!!
//    colnames   (Cell array of strings) Column headers.  One cell element per column
//    filename   (string) Name of Excel file.  If not specified, contents will
//                  be opened in Excel.
//
// ex:
//   m = rand(100,4);
//   header = 'my data';
//   %header = {'first line';'second line'};      % This will give 2 header lines
//   colnames = {'Ch1','Ch2','Ch3','Ch4'};
//
//   XLSWriteMex(m,header,colnames,'myfile.xls'); % Will save the spreadsheet as myfile.xls.  
//                                                % The user will never see Excel.
//   XLSWriteMex(m,header,colnames);              % Will open Excel with these contents in a new spreadsheet.
//      

#include "mex.h"

extern "C"
{
	void mexFunction(int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[]);
}

#pragma warning ( disable : 4146 4192 )

#import "c:\\Program files\\Microsoft Office\\Office\\mso9.dll"
#import "c:\\Program files\\Common Files\\Microsoft Shared\\VBA\\VBA6\\vbe6ext.olb"
#import "c:\\Program files\\Microsoft Office\\Office\\excel9.olb" rename("DialogBox", "DialogBoxXL") rename("RGB", "RGB_XL") 
using namespace Excel;


#include <comdef.h>


///////////////////////////////////////////////////////////////////////////////
//  Function: GetStringFromMatrix
//
//  Description: Converts a Matlab string array into a ANSI string
//
//  History: 07/03/2004 - GR - Initial Creation
//
///////////////////////////////////////////////////////////////////////////////
char* GetStringFromMatrix(const mxArray* pMat)
{
	// Get the length of the input string
	int nLen = (mxGetM(pMat) * mxGetN(pMat)) + 1;

	// Allocate memory for the string
	// NOTE: Matlab automatically frees the memory on exiting the mex function
	char* szString = (char*)mxCalloc(nLen, sizeof(char));

	// Copy the string data from the matrix into a C string 
	// If the string array contains several rows, 
	// they are copied, one column at a time, into one long string array. 
	int nStatus = mxGetString(pMat, szString, nLen);
	if(nStatus != 0) 
	{
		mexWarnMsgTxt("Not enough space. String is truncated.");
	}

	return szString;
}


///////////////////////////////////////////////////////////////////////////////
//  Function: VariantFromMatrix
//
//  Description: Converts a Matlab matrix or cell array into a VARIANT
//
//  History: 07/03/2004 - GR - Initial Creation
//
///////////////////////////////////////////////////////////////////////////////
void VariantFromMatrix(const mxArray* pMat, VARIANT* pVar)
{
	if (mxIsEmpty(pMat))
	{
		pVar->vt = VT_EMPTY;
	}
	else if (mxIsNumeric(pMat))
	{
		int nRows = mxGetM(pMat);
		int nCols = mxGetN(pMat);
		int nTotElems = nRows * nCols;
		if (nTotElems == 1)
		{
			pVar->vt = VT_R8;
			double* pdVal = mxGetPr(pMat);
			pVar->dblVal = pdVal[0];
		}
		else
		{
			pVar->vt = VT_ARRAY | VT_R8;

			SAFEARRAYBOUND rgsabound[2];
			rgsabound[0].lLbound = 0;
			rgsabound[0].cElements = nRows;
			rgsabound[1].lLbound = 0;
			rgsabound[1].cElements = nCols;
			SAFEARRAY* psa = SafeArrayCreate(VT_R8, 2, rgsabound);

			double* pdData = NULL;
			SafeArrayAccessData(psa, (void HUGEP **)&pdData);
			memcpy((void*)pdData, mxGetPr(pMat), nTotElems * sizeof(double));
			SafeArrayUnaccessData(psa);

			pVar->parray = psa;
		}
	}
	else if (mxIsCell(pMat))
	{
		int nRows = mxGetM(pMat);
		int nCols = mxGetN(pMat);
		int nTotElems = nRows * nCols;
		if (nTotElems == 1)
		{
			VariantFromMatrix(mxGetCell(pMat, 0), pVar);
		}
		else
		{
			pVar->vt = VT_ARRAY | VT_VARIANT;

			SAFEARRAYBOUND rgsabound[2];
			rgsabound[0].lLbound = 0;
			rgsabound[0].cElements = nRows;
			rgsabound[1].lLbound = 0;
			rgsabound[1].cElements = nCols;
			SAFEARRAY* psa = SafeArrayCreate(VT_VARIANT, 2, rgsabound);

			VARIANT* pvData = NULL;
			SafeArrayAccessData(psa, (void HUGEP **)&pvData);
			for (int i = 0; i < nTotElems; i++)
			{
				VariantFromMatrix(mxGetCell(pMat, i), &pvData[i]);
			}
			SafeArrayUnaccessData(psa);

			pVar->parray = psa;
		}
	}
	else if (mxIsLogical(pMat))
	{
		int nRows = mxGetM(pMat);
		int nCols = mxGetN(pMat);
		int nTotElems = nRows * nCols;
		if (nTotElems == 1)
		{
			pVar->vt = VT_BOOL;
			double* pdVal = mxGetPr(pMat);
			pVar->boolVal = (pdVal[0] == 0.0) ? VARIANT_FALSE : VARIANT_TRUE; 
		}
		else
		{
			pVar->vt = VT_ARRAY | VT_BOOL;

			SAFEARRAYBOUND rgsabound[2];
			rgsabound[0].lLbound = 0;
			rgsabound[0].cElements = nRows;
			rgsabound[1].lLbound = 0;
			rgsabound[1].cElements = nCols;
			SAFEARRAY* psa = SafeArrayCreate(VT_BOOL, 2, rgsabound);

			VARIANT_BOOL* pvbData = NULL;
			SafeArrayAccessData(psa, (void HUGEP **)&pvbData);
			double* pdMat = mxGetPr(pMat);
			for (int i = 0; i < nTotElems; i++)
			{
				if (pdMat[i] != 0.0)
				{
					pvbData[i] = VARIANT_TRUE;
				}
				else
				{
					pvbData[i] = VARIANT_FALSE;
				}
			}
			SafeArrayUnaccessData(psa);

			pVar->parray = psa;
		}
	}
	else if (mxIsChar(pMat))
	{
		pVar->vt = VT_BSTR;
		_bstr_t bstr(GetStringFromMatrix(pMat));
		pVar->bstrVal = bstr.copy();
	}
	else
	{
		pVar->vt = VT_EMPTY;
	}
}

///////////////////////////////////////////////////////////////////////////////
//  Function: GetCellRange
//
//  Description: Calculates the Excel cell range required to store a Matlab matrix
//
//  History: 07/03/2004 - GR - Initial Creation
//
///////////////////////////////////////////////////////////////////////////////
void GetCellRange(const mxArray* pMat, int nFirstRow, int nFirstCol, char* szTopLeft, char* szBotRight)
{
	int nRows = mxGetM(pMat);
	int nCols = mxGetN(pMat);
	if (mxIsChar(pMat))
	{
		nCols = 1;
	}

	char szFirstCol[3];
	memset(szFirstCol, 0, 3);

	if (nFirstCol <= 26)
	{
		szFirstCol[0] = 'A' + nFirstCol - 1;
	}
	else
	{
		int q = (int)(nFirstCol / 26);
		int r = nFirstCol % 26;
		if (r == 0)
		{
			q--;
			r = 26;
		}
		szFirstCol[0] = 'A' + q - 1;
		szFirstCol[1] = 'A' + r - 1;
	}

	sprintf(szTopLeft, "%s%d", szFirstCol, nFirstRow);

	int nLastCol = nFirstCol + nCols - 1;
	char szLastCol[3];
	memset(szLastCol, 0, 3);
	if (nLastCol <= 26)
	{
		szLastCol[0] = 'A' + nLastCol - 1;
	}
	else
	{
		int q = (int)(nLastCol / 26);
		int r = nLastCol % 26;
		if (r == 0)
		{
			q--;
			r = 26;
		}
		szLastCol[0] = 'A' + q - 1;
		szLastCol[1] = 'A' + r - 1;
	}

	int nLastRow = nFirstRow + nRows - 1;
	sprintf(szBotRight, "%s%d", szLastCol, nLastRow);
}


///////////////////////////////////////////////////////////////////////////////
//  Function: mexFunction
//
//  Description: Main mex function to write a Matlab matrix to an Excel spreadsheet
//
//  History: 07/03/2004 - GR - Initial Creation
//
///////////////////////////////////////////////////////////////////////////////
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
	// Check for correct number of args
	if (nrhs < 1)
	{
		mexErrMsgTxt("At least one input required for mex function 'XLSWriteMex'.\n"
					 "USAGE: XLSWriteMex(m,header,colnames,filename)\n"
					 "Required Input:\n"
					 "m:        Matrix to write to file\n"
					 "Optional Inputs:\n"
					 "header:   String of header information.\n"
					 "          Use cell array for multiple lines DO NOT USE multiple row character arrays!!\n"
					 "colnames: (Cell array of strings) Column headers. One cell element per column.\n"
					 "filename: (string) Name of Excel file. If not specified, contents will be opened in Excel.\n");
	}

	const mxArray* m = prhs[0];

	int nr = mxGetM(m);
	int nc = mxGetN(m);

	if (nc > 256)
	{
		mexErrMsgTxt("Matrix is too large. Excel only supports 256 columns");
	}

	CoInitialize(NULL);
	try
	{
		_ApplicationPtr pExcelApp(__uuidof(Application));

		if (nrhs < 4)
		{
			pExcelApp->PutVisible(0,VARIANT_TRUE);
		}

		_WorkbookPtr pWorkBook = pExcelApp->GetWorkbooks()->Add();
		_variant_t vSheetIndx((long)1);
		_WorksheetPtr pSheet = pWorkBook->GetWorksheets()->GetItem(vSheetIndx);

		int nHeadRowOffset = 1;
		char szFromCell[32];
		char szToCell[32];
		if (nrhs >= 2)
		{
			// Write out the header
			const mxArray* header = prhs[1];
			if (!mxIsEmpty(header))
			{
				GetCellRange(header, 1, 1, szFromCell, szToCell);
				RangePtr pRange = pSheet->GetRange(szFromCell, szToCell);
				VARIANT v;
				VariantInit(&v);
				VariantFromMatrix(header, &v);
				pRange->PutValue(v);
				VariantClear(&v);
				nHeadRowOffset += mxGetM(header);
			}
		}

		if (nrhs >= 3)
		{
			// Write out the column names
			const mxArray* colnames = prhs[2];
			if (!mxIsEmpty(colnames))
			{
				GetCellRange(colnames, nHeadRowOffset, 1, szFromCell, szToCell);
				RangePtr pRange = pSheet->GetRange(szFromCell, szToCell);
				VARIANT v;
				VariantInit(&v);
				VariantFromMatrix(colnames, &v);
				pRange->PutValue(v);
				VariantClear(&v);
				nHeadRowOffset += mxGetM(colnames);
			}
		}

		// Write out the data
		GetCellRange(m, nHeadRowOffset, 1, szFromCell, szToCell);
		RangePtr pRange = pSheet->GetRange(szFromCell, szToCell);
		VARIANT v;
		VariantInit(&v);
		VariantFromMatrix(m, &v);
		pRange->PutValue(v);
		VariantClear(&v);

		if (nrhs >= 4)
		{
			// Save the file
			const mxArray* filename = prhs[3];
			char* szFileName = GetStringFromMatrix(filename);
			pWorkBook->SaveAs(szFileName, vtMissing, vtMissing, vtMissing, 
				vtMissing, vtMissing, xlNoChange);
			pExcelApp->Quit();
		}
	}
	catch (_com_error e)
	{
		_bstr_t bstrDesc = e.Description();
		char* szDesc = (char*)bstrDesc;
		if ((szDesc != NULL) && (strlen(szDesc) != 0))
		{
			mexErrMsgTxt(szDesc);
		}
		else
		{
			const char* szMsg = e.ErrorMessage();
			if (szMsg != NULL)
			{
				mexErrMsgTxt(szMsg);
			}
			else
			{
				mexErrMsgTxt("Unknown COM error in XLSWriteMex.dll");
			}
		}
	}
	CoUninitialize();
}